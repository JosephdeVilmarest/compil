open X86_64
open Ast
open Lexing
open Typeur

let l_empty = ({pos_fname = ""; pos_lnum = 0; pos_bol = 0; pos_cnum = 0}, 
                     {pos_fname = ""; pos_lnum = 0; pos_bol = 0; pos_cnum = 0})

(* une solution pour les chaines de caractères: maintenir une référence mise à nop au début de la fonction comp dans laquelle on met toutes les chaines rencontrées et ainsi à la fin on les met dans le data, on les associe à des entiers. La référence numero sera modifié dès qu'on écrira une chaine ou une étiquette *)

module Dmap = Map.Make (String)
let descr_empty = Dmap.add "Nothing" ["D_Null"] (Dmap.add "Null" ["D_String"] (Dmap.add "String" ["D_AnyRef"] (Dmap.add "AnyRef" ["D_Any"] (Dmap.add "Unit" ["D_AnyVal"] (Dmap.add "Int" ["D_AnyVal"] (Dmap.add "Boolean" ["D_AnyVal"] (Dmap.add "AnyVal" ["D_Any"] (Dmap.add "Any" ["D_Any"] Dmap.empty))))))))

let chaines = ref nop and numero = ref 0 and descr = ref descr_empty



(** Descripteurs de classes **)

let rec aux_modifie x y = function
    | [] -> failwith "override pas définie dans la classe héritée"
    | t::q when t = x -> y::q
    | t::q -> t::(aux_modifie x y q)

let aux_descr d c c_extends l = match d.d with
    | Dvar _ -> l
    | Dmethode {m=Mdef (s,_,_,_,_); lm=_} -> List.append l [c^"_"^s]
    | Dmethode {m=Moverride (s,_,_,_,_); lm=_} -> aux_modifie (c_extends^"_"^s) (c^"_"^s) l

let ajout_descripteur cl =
    let (c,_,_,t,_,ld) = cl.c in let Typ (c_extends,_) = t.t in
    let l = ref (List.append ["D_"^c_extends] (List.tl (Dmap.find c_extends !descr))) in
    List.iter (fun d -> l:= aux_descr d c c_extends !l) ld;
    descr:= Dmap.add c !l !descr

let descripteurs_de_classes lc =
    List.iter (fun cl -> ajout_descripteur cl) lc




let rec code_of_expr e = match e.e with
    | Eentier i -> pushq (imm i)
    
    | Echaine c -> 
        let s = string_of_int !numero in
        numero:= !numero + 1;
        chaines:= !chaines ++ label (".S"^s) ++ string c;
            pushq (ilab (".S"^s))
    
    | Ebool b -> if b then pushq (imm 1) else pushq (imm 0)
    
    | Eunit -> nop (* ou est-ce pushq (imm 0) ? *)
    
    | Ethis -> failwith "à faire"
    
    | Enull -> pushq (imm 0)
    
    | Epar e -> code_of_expr e
    
    | Eacc a -> failwith "à faire"
    | Eaccexp (a, e) -> failwith "à faire"
    | Eaccargexp (a, ar, e) -> failwith "à faire"
    
    | Enewidargexp (s, ar, e) -> failwith "à faire"
    
    | Eneg e -> (* la négation de b vaut 1-b *)
            code_of_expr e ++
            popq (rax) ++
            negq (reg rax) ++
            addq (imm 1) (reg rax) ++
            pushq (reg rax)
    
    | Emoins e ->
            code_of_expr e ++
            popq (rax) ++
            negq (reg rax) ++
            pushq (reg rax)
    
    | Eop (e, o, f) when o.o = Et -> (* il faut évaluer paresseusement *)
        let s = string_of_int !numero in
        numero:= !numero + 1;
            code_of_expr e ++
            popq (rax) ++
            cmpq (imm 0) (reg rax) ++ (* on teste si rax = 0 car sinon rax = 1 *)
            je ("L"^s) ++
            code_of_expr f ++
            popq (rax) ++
        label ("L"^s) ++
            pushq (reg rax)
    | Eop (e, o, f) when o.o = Ou -> (* il faut évaluer paresseusement encore *)
        let s = string_of_int !numero in
        numero:= !numero + 1;
            code_of_expr e ++
            popq (rax) ++
            cmpq (imm 0) (reg rax) ++
            jne ("L"^s) ++
            code_of_expr f ++
            popq (rax) ++
        label ("L"^s) ++
            pushq (reg rax)
    | Eop (e, o, f) ->
            code_of_expr e ++
            code_of_expr f ++
            popq (rbx) ++
            popq (rax) ++
            (match o.o with
                (* il y a peut être un problème sur l'égalité structurelle: je la teste pareil que l'autre égalité 
                    alors qu'il faut peut être l'utiliser avec les adresses des paramètres *)
                | Eq -> cmpq (reg rax) (reg rbx) ++ sete (reg al) ++ movzbq (reg al) rax
                | Ne -> cmpq (reg rax) (reg rbx) ++ setne (reg al) ++ movzbq (reg al) rax
                | Dbleg -> cmpq (reg rax) (reg rbx) ++ sete (reg al) ++ movzbq (reg al) rax (* on teste si rbx - rax est nul *)
                | Diff -> cmpq (reg rax) (reg rbx) ++ setne (reg al) ++ movzbq (reg al) rax
                | Inf -> cmpq (reg rbx) (reg rax) ++ sets (reg al) ++ movzbq (reg al) rax
                | Infeg -> cmpq (reg rax) (reg rbx) ++ setns (reg al) ++ movzbq (reg al) rax
                | Sup -> cmpq (reg rax) (reg rbx) ++ sets (reg al) ++ movzbq (reg al) rax
                | Supeg -> cmpq (reg rbx) (reg rax) ++ setns (reg al) ++ movzbq (reg al) rax
                | Add -> addq (reg rbx) (reg rax)
                | Sub -> subq (reg rbx) (reg rax)
                | Mul -> imulq (reg rbx) (reg rax)
                | Div -> cqto ++ idivq (reg rbx)
                | Reste -> cqto ++ idivq (reg rbx) ++ movq (reg rdx) (reg rax)
                | _ -> failwith "cas non traité dans op") ++
            pushq (reg rax)
    
    | Eif (e, e1, e2) -> 
        let s1 = string_of_int !numero and s2 = string_of_int (!numero+1) in
        numero:= !numero + 2;
            code_of_expr e ++
            popq (rax) ++
            cmpq (imm 0) (reg rax) ++
            je ("L"^s1) ++
            code_of_expr e1 ++
            jmp ("L"^s2) ++
        label ("L"^s1) ++
            code_of_expr e2 ++
        label ("L"^s2)
    
    | Ewhile (e1, e2) ->
        let s1 = string_of_int !numero and s2 = string_of_int (!numero+1) in
        numero:= !numero +2;
        label ("L"^s1) ++
            code_of_expr e1 ++
            popq (rax) ++
            cmpq (imm 0) (reg rax) ++
            je ("L"^s2) ++
            code_of_expr e2 ++
            jmp ("L"^s1) ++
        label ("L"^s2)
    
    | Ereturnvide -> failwith "à faire"
    | Ereturn e -> failwith "à faire"
    
    | Eprint e when e.te.t = Typ ("Int", {at= []; lat= l_empty}) ->
            code_of_expr e ++
            popq (rdi) ++
            call "print_int" (* ici e est un entier *)
    
    | Eprint e -> (* c'est forcément une string si on a survécu au typage *)
            code_of_expr e ++
            popq (rdi) ++
            call "print_string" (* ici e est une string *)
    
    | Ebloc b -> let code = ref nop in List.iter (fun bl -> code:= !code ++ (code_of_bl bl)) b.b; !code


and code_of_bl bl = match bl.b1 with
    | Bvar _ -> failwith ""
    | Bexpr e -> code_of_expr e

let code_of_methode m = match m.m with
	| Moverride _ -> failwith ""
	| Mdef (s, pt, p, t, e) when s = "main" -> code_of_expr e ++ ret
	| Mdef _ -> failwith ""

let code_of_decl d = match d.d with
	| Dvar v -> failwith ""
	| Dmethode m -> code_of_methode m

let code_of_classe_main cM =
	match cM.cM with
	    | [d] -> code_of_decl d
	    | _ -> failwith ""

let comp fichier =
    chaines:= nop; numero := 0; descr := descr_empty;
	let (lc, cM) = fichier.f in
	let codemain = code_of_classe_main cM in
	descripteurs_de_classes lc;
	{text =
	    glabel "main" ++
	    (* allocation *)
	    call "M_Main_main" ++
	    xorq (reg rax) (reg rax) ++
	    ret ++
    label "C_Main" ++
        (* constructeur de Main ? *)
    label "M_Main_main" ++
        codemain ++
    label "print_int" ++
        movq (reg rdi) (reg rsi) ++
        movq (ilab ".Sprint_int") (reg rdi) ++
        movq (imm 0) (reg rax) ++
        call "printf" ++
        ret ++
    label "print_string" ++
        movq (reg rdi) (reg rsi) ++
        movq (ilab ".Sprint_string") (reg rdi) ++
        movq (imm 0) (reg rax) ++
        call "printf" ++
        ret;        
	data =
	label "D_Main" ++
        address ["D_Any"; "M_Main_main"] ++
        Dmap.fold (fun s l code -> code ++ label ("D_"^s) ++ address l) !descr nop ++
    label ".Sprint_int" ++ string "%d" ++
	label ".Sprint_string" ++ string "%s" ++
	    !chaines
	}