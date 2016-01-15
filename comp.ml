open X86_64
open Ast
open Lexing
open Typeur

let l_empty = ({pos_fname = ""; pos_lnum = 0; pos_bol = 0; pos_cnum = 0}, 
                     {pos_fname = ""; pos_lnum = 0; pos_bol = 0; pos_cnum = 0})

(* une solution pour les chaines de caractères: maintenir une référence mise à nop au début de la fonction comp dans laquelle on met toutes les chaines rencontrées et ainsi à la fin on les met dans le data, on les associe à des entiers. La référence numero sera modifié dès qu'on écrira une chaine ou une étiquette *)

module Omaxmap = Map.Make(String)
let omax_empty = Omaxmap.add "Nothing" (0, 0) (Omaxmap.add "Null" (0, 0) (Omaxmap.add "String" (0, 0) (Omaxmap.add "AnyRef" (0, 0) (Omaxmap.add "Unit" (0, 0) (Omaxmap.add "Int" (0, 0) (Omaxmap.add "Boolean" (0, 0) (Omaxmap.add "AnyVal" (0, 0) (Omaxmap.add "Any" (0, 0) Omaxmap.empty))))))))

module Key = struct type t = string * string let compare = Pervasives.compare end
module Ocmap = Map.Make(Key) (* donne les offset des champs d'une classe *)
module Ommap = Map.Make(Key) (* donne les offset des méthodes d'une classe *)

module Dmap = Map.Make (String) (* donne le descripteur d'une classe *)
let descr_empty = Dmap.add "Nothing" ["D_Null"] (Dmap.add "Null" ["D_String"] (Dmap.add "String" ["D_AnyRef"] (Dmap.add "AnyRef" ["D_Any"] (Dmap.add "Unit" ["D_AnyVal"] (Dmap.add "Int" ["D_AnyVal"] (Dmap.add "Boolean" ["D_AnyVal"] (Dmap.add "AnyVal" ["D_Any"] (Dmap.add "Any" ["D_Any"] Dmap.empty))))))))

let chaines = ref nop and numero = ref 0 and descr = ref descr_empty
and omax = ref omax_empty and oc = ref Ocmap.empty and om = ref Ommap.empty
        
        


(** Compilation des expressions et des méthodes (car tout est lié !) **)

let rec compile_expr e = match e.e with
    | Eentier i ->
        pushq (imm i) ++ call "C_Int" ++ pushq (reg rax)
    
    | Echaine c -> 
        let s = string_of_int !numero in
        numero:= !numero + 1;
        chaines:= !chaines ++ label (".S"^s) ++ string c;
        pushq (ilab (".S"^s)) ++ call "C_String" ++ pushq (reg rax)       
    
    | Ebool b -> 
        if b then pushq (imm 1) else pushq (imm 0) ++ call "C_Boolean" ++ pushq (reg rax)
    
    | Eunit ->
        pushq (imm 0) ++ call "C_Int" ++ pushq (reg rax)
    
    | Ethis -> failwith "à faire"
    
    | Enull ->
        pushq (imm 0) ++ call "C_Int" ++ pushq (reg rax)
    
    | Epar e -> compile_expr e
    
    | Eacc a -> failwith "à faire"
    | Eaccexp (a, e) -> failwith "à faire"
    | Eaccargexp (a, ar, e) -> failwith "à faire"
    
    | Enewidargexp (s, ar, le) -> (* on met les expressions sur la pile et on appelle le constructeur *)
            List.fold_right (fun e code -> compile_expr e ++ code) le nop ++
            call ("C_"^s) ++
            pushq (reg rax)
    
    | Eneg e -> (* la négation de b vaut 1-b *)
            compile_expr e ++
            popq (rax) ++
            addq (imm 8) (reg rax) ++
            negq (ind (rax)) ++
            addq (imm 1) (ind rax) ++
            pushq (reg rax)
    
    | Emoins e ->
            compile_expr e ++
            popq (rax) ++
            negq (reg 8(rax)) ++
            pushq (reg rax)
    
    | Eop (e, o, f) when o.o = Et -> (* il faut évaluer paresseusement *)
        let s = string_of_int !numero in
        numero:= !numero + 1;
            compile_expr e ++
            popq (rax) ++
            cmpq (imm 0) (ind 8(rax)) ++ (* on teste si rax = 0 car sinon rax = 1 *)
            je ("L"^s) ++
            compile_expr f ++
            popq (rax) ++
        label ("L"^s) ++
            pushq (reg rax)
    | Eop (e, o, f) when o.o = Ou -> (* il faut évaluer paresseusement encore *)
        let s = string_of_int !numero in
        numero:= !numero + 1;
            compile_expr e ++
            popq (rax) ++
            cmpq (imm 0) (ind 8(rax)) ++
            jne ("L"^s) ++
            compile_expr f ++
            popq (rax) ++
        label ("L"^s) ++
            pushq (reg rax)
    | Eop (e, o, f) ->
            compile_expr e ++
            compile_expr f ++
            popq (rbx) ++
            popq (rax) ++
            (match o.o with
                (* il y a peut être un problème sur l'égalité structurelle :
                    Je la teste pareil que l'autre égalité alors qu'il faut 
                    peut être l'utiliser avec les adresses des paramètres ? *)
                | Eq -> cmpq (ind 8(rax)) (ind 8(rbx)) ++ sete (ind 8(al)) ++ movzbq (ind 8(al)) rax
                | Ne -> cmpq (ind rax) (reg rbx) ++ setne (reg al) ++ movzbq (reg al) rax
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
            compile_expr e ++
            popq (rax) ++
            cmpq (imm 0) (reg rax) ++
            je ("L"^s1) ++
            compile_expr e1 ++
            jmp ("L"^s2) ++
        label ("L"^s1) ++
            compile_expr e2 ++
        label ("L"^s2)
    
    | Ewhile (e1, e2) ->
        let s1 = string_of_int !numero and s2 = string_of_int (!numero+1) in
        numero:= !numero +2;
        label ("L"^s1) ++
            compile_expr e1 ++
            popq (rax) ++
            cmpq (imm 0) (reg rax) ++
            je ("L"^s2) ++
            compile_expr e2 ++
            jmp ("L"^s1) ++
        label ("L"^s2)
    
    | Ereturnvide -> movq (imm 0) (reg rax)
    | Ereturn e -> compile_expr e ++ popq (rax)
    
    | Eprint e when e.te.t = Typ ("Int", {at= []; lat= l_empty}) ->
            compile_expr e ++
            popq (rdi) ++
            call "print_int" (* ici e est un entier *)
    
    | Eprint e -> (* c'est forcément une string si on a survécu au typage *)
            compile_expr e ++
            popq (rdi) ++
            call "print_string" (* ici e est une string *)
    
    | Ebloc b -> let code = ref nop in List.iter (fun bl -> code:= !code ++ (compile_bl bl)) b.b; !code


and compile_bl bl = match bl.b1 with
    | Bvar _ -> failwith ""
    | Bexpr e -> compile_expr e

and compile_methode m = match m.m with
	| Moverride _ -> failwith ""
	| Mdef (s, pt, p, t, e) when s = "main" -> compile_expr e ++ ret
	| Mdef _ -> failwith ""

and compile_decl d = match d.d with
	| Dvar v -> failwith ""
	| Dmethode m -> compile_methode m




(** Compilation des classes **)

let aux_param p c c_extends numc =
    let (s, _) = p.p in
    if Ocmap.exists (fun (c, x) k -> x = s) !oc then ()
    else (oc:= Ocmap.add (c, s) !numc !oc; numc:= !numc+1)

let rec aux_modifie x y = function
    | [] -> failwith "override pas définie dans la classe héritée"
    | t::q when t = x -> y::q
    | t::q -> t::(aux_modifie x y q)

let aux_decl d c c_extends l numc numm = match d.d with
    | Dvar v ->
        let id = id_of_var v in
        (* il faut regarder si id est dans la classe extends *)
        if Ocmap.exists (fun (c, x) k -> x = c) !oc then ()
        else (oc:= Ocmap.add (c, id) !numc !oc; numc:= !numc+1)
    | Dmethode {m=Mdef (s,_,_,_,_); lm=_} -> (* on sait ici que s n'est pas dans la classe extends *)
        l:= List.append !l [c^"_"^s];
        om:= Ommap.add (c, s) !numm !om; numm:= !numm+1
    | Dmethode {m=Moverride (s,_,_,_,_); lm=_} -> (* on sait ici que s est dans extends, on ne change pas son offset *)
        l:= aux_modifie (c_extends^"_"^s) (c^"_"^s) !l

let comp_classe cl =
    let (c,_,lp,t,_,ld) = cl.c in let Typ (c_extends,_) = t.t in
    let n1, n2 = Omaxmap.find c_extends !omax in
    let numc = ref (n1+1) and numm = ref (n2+1) in 
    let l = ref (List.append ["D_"^c_extends] (List.tl (Dmap.find c_extends !descr))) in (* on initialise l avec c_extends *)
    Ocmap.iter (fun (s, x) k -> oc:= Ocmap.add (c,x) k !oc) (Ocmap.filter (fun (s, x) k -> s = c_extends) !oc);
    Ommap.iter (fun (s, x) k -> om:= Ommap.add (c,x) k !om) (Ommap.filter (fun (s, x) k -> s = c_extends) !om);
    List.iter (fun p -> aux_param p c c_extends numc) lp;
    List.iter (fun d -> aux_decl d c c_extends l numc numm) ld;
    omax:= Omaxmap.add c (!numc, !numm) !omax;
    descr:= Dmap.add c !l !descr

let rec cherche_expr id = function
    | [] -> failwith "expression non trouvée"
    | {d=Dvar v; ld=_}::q when id_of_var v = id -> exp_of_var v
    | x::q -> cherche_expr id q

let constr_of_class cl =
(* on a un certains nombre de champs de cl avec leur offset dans !oc.
il y a des paramètres et des variables *)
    let c = ident_of_class cl and lp = param_of_class cl and ld = dec_of_class cl in
    let l1 = Ocmap.bindings (Ocmap.filter (fun (s, id) k -> s=c) !oc) in
    let lid = List.sort (fun id1 id2 -> Ocmap.find (c,id1) !oc - Ocmap.find (c,id2) !oc) (List.map (fun ((s,id), k) -> id) l1) in
    let nbc = List.length lid in
    label ("C_"^c) ++
        movq (imm (8*(nbc+1))) (reg rdi) ++
        call "malloc" ++
        movq (reg rax) (reg r12) ++ (* on met rax dans r12 car la valeur de retour est à mettre dans rax *)
        movq (ilab ("D_"^c)) (ind (r12)) ++
        List.fold_left (fun code id -> 
                                code ++
                                addq (imm 8) (reg r12) ++
                                (match List.mem id (List.map (fun p -> let (id,_) = p.p in id) lp) with
                                    | true -> nop
                                    | false -> let e = cherche_expr id ld in
                                        compile_expr e) ++
                                popq (rbx) ++
                                movq (reg rbx) (ind (r12))
                                ) nop lid ++
        ret

let compile_classes lc =
    List.iter (fun cl -> comp_classe cl) lc;
    List.fold_left (fun code cl -> code ++ constr_of_class cl) nop lc



(** Compilation de la classe Main **)

let compile_classe_main cM = (* pour l'instant je ne prends en compte qu'une déclaration qui est la méthode main *)
	match cM.cM with
	    | [d] -> compile_decl d
	    | _ -> failwith ""



(** Compilation d'un fichier **)

let comp fichier =
    chaines:= nop; numero := 0; descr := descr_empty;
    omax:= omax_empty; oc:= Ocmap.empty; om:= Ommap.empty;
	let (lc, cM) = fichier.f in
	let codemain = compile_classe_main cM in
	let codeclasses = compile_classes lc in
	{text =
	glabel "main" ++
	    call "C_Main" ++ 
	    (* dans rax on a l'adresse de l'objet, on peut le mettre dans la pile et le dépiler dans 
	        M_Main_main si c'est plus facile lors de l'écriture de la compilation des méthodes *)
	    call "M_Main_main" ++
	    xorq (reg rax) (reg rax) ++
	    ret ++
    label "C_Main" ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ movq (ilab "D_Main") (ind (rax)) ++ ret ++
        codeclasses ++
    (* faut-il faire des constructeurs pour les classes déjà définies, comme par exemple *)
    label "C_Nothing" ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_Nothing") (ind (r12)) ++ ret ++
    label "C_Null" ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_Null") (ind (r12)) ++ ret ++
    label "C_String" ++
        movq (imm 16) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_String") (ind (r12)) ++
        addq (imm 8) (reg r12) ++ popq (rbx) ++ movq (reg rbx) (ind (r12)) ++ ret ++
    label "C_AnyRef" ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_AnyRef") (ind (r12)) ++ ret ++
    label "C_Any" ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_Any") (ind (r12)) ++ ret ++
    label "C_Boolean" ++
        movq (imm 16) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_Boolean") (ind (r12)) ++
        addq (imm 8) (reg r12) ++ popq (rbx) ++ movq (reg rbx) (ind (r12)) ++ ret ++
    label "C_Int" ++
        movq (imm 16) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_Int") (ind (r12)) ++
        addq (imm 8) (reg r12) ++ popq (rbx) ++ movq (reg rbx) (ind (r12)) ++ ret ++
    label "C_Unit" ++
        movq (imm 16) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_Unit") (ind (r12)) ++
        addq (imm 8) (reg r12) ++ popq (rbx) ++ movq (reg rbx) (ind (r12)) ++ ret ++
    label "C_AnyVal" ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_AnyVal") (ind (r12)) ++ ret ++
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
