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
and thisref = ref ""

module Emap = Map.Make(String) (* donne l'offset par rapport à rsp de l'objet associé a la string (variable locale) *)     

        


(** Compilation des expressions et des méthodes (car tout est lié !) **)

(* allocation: au début d'une méthode on alloue l'espace nécessaire et on attribue une adresse à chaque variable locale qui intervient *)
let rec alloc_expr (env, k) e = match e.e with
    | Epar e -> alloc_expr (env, k) e
    | Ebloc b -> alloc_bloc (env, k) b
    | _ -> (env, k)

and alloc_bloc (env, k) b = match b.b with
    | [] -> (env, k)
    | {b1= Bvar v ;lb1=_}::q -> alloc_bloc (Emap.add (id_of_var v) (k) env, k-1) {b=q; lb=b.lb}
    | {b1= Bexpr e ;lb1=_}::q -> alloc_bloc (alloc_expr (env, k) e) {b=q; lb=b.lb}

let alloc_methode m =
    let e = exp_of_m m in alloc_expr (Emap.empty, 0) e


let rec compile_expr env e = match e.e with
    | Eentier i ->
            pushq (imm i) ++
            call "C_Int" ++ 
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    
    | Echaine c ->
        let s = string_of_int !numero in
        numero:= !numero + 1;
        chaines:= !chaines ++ label (".S"^s) ++ string c;
            pushq (ilab (".S"^s)) ++
            call "C_String" ++
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)       
    
    | Ebool b ->
        (if b then pushq (imm 1) else pushq (imm 0)) ++ 
            call "C_Boolean" ++ 
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    
    | Eunit ->
            pushq (imm 0) ++
            call "C_Int" ++ 
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    
    | Ethis ->
            nop
     
    | Enull ->
            pushq (imm 0) ++ 
            call "C_Null" ++ 
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    
    | Epar e -> compile_expr env e
    
    | Eacc {a= Aid id; la=_} ->
        (try let o = 8*Emap.find id env in
            pushq (ind ~ofs:o rbp) (* c'est le cas où id est une variable locale, cas le plus simple *)
        with Not_found -> (* dans ce cas id est le champ de la classe this *)
            let c = !thisref in
            let o = 8*(Ocmap.find (c, id) !oc) in
            pushq (ind ~ofs:o r15)) (* on mettra dans r15 l'adresse d'un objet avant d'appeler une de ses méthodes *)
            
    | Eacc {a= Aexpid (e, id); la=_} ->
        (* il faut accéder au champ id de l'objet e, donc on regarde la classe de e et on utilise oc *)
        let Typ(c,_) = e.te.t in
        let o = 8*(Ocmap.find (c, id) !oc) in
        compile_expr env e ++
            popq (rax) ++
            pushq (ind ~ofs:o rax)
            
    | Eaccexp ({a= Aid id; la=_}, e) -> (* il faut mettre unit sur la pile, est-ce qu'on construit vraiment un objet unit ??? *)
        compile_expr env e ++
            popq (rax) ++
        (try let o = 8*Emap.find id env in
            movq (reg rax) (ind ~ofs:o rbp)
        with Not_found ->
            let c = !thisref in
            let o = 8*(Ocmap.find (c, id) !oc) in
            movq (reg rax) (ind ~ofs:o r15)) ++
            pushq (imm 0) ++
            call "C_Unit" ++
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    | Eaccexp ({a= Aexpid (e1, id); la=_}, e2) ->
        let Typ(c,_) = e1.te.t in
        let o = 8*(Ocmap.find (c, id) !oc) in
        compile_expr env e1 ++
        compile_expr env e2 ++
            popq (rbx) ++
            popq (rax) ++
            movq (reg rbx) (ind ~ofs:o rax) ++
            pushq (imm 0) ++
            call "C_Unit" ++
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    
    | Eaccargexp ({a= Aid id; la=_}, ar, le) -> (* que mettre dans r15 ? *)
        let c = !thisref in
        let o = 8 * (Ommap.find (c, id) !om) in
        List.fold_right (fun e code -> code ++ compile_expr env e) le nop ++
            movq (ilab ("D_"^c)) (reg rbx) ++  (* avant je faisais juste un call ("M_"^c^"_"^id) *)
            call_star (ind ~ofs:o rbx) ++
            addq (imm (8*List.length le)) (reg rsp) ++
            pushq (reg rax)
    | Eaccargexp ({a= Aexpid (e,id); la=_}, ar, le) ->
        let Typ(c,_) = e.te.t in
        let o = 8 * (Ommap.find (c, id) !om) in
        List.fold_right (fun e code -> code ++ compile_expr env e) le nop ++
            movq (ilab ("D_"^c)) (reg rbx) ++
        compile_expr env e ++
            pushq (reg r15) ++
            call_star (ind ~ofs:o rbx) ++
            addq (imm (8*List.length le)) (reg rsp) ++
            pushq (reg rax)
    
    | Enewidargexp (s, ar, le) -> (* on met les expressions sur la pile et on appelle le constructeur *)
        List.fold_right (fun e code -> compile_expr env e ++ code) le nop ++
            call ("C_"^s) ++
            pushq (reg rax)
    
    | Eneg e -> (* la négation de b vaut 1-b *)
            compile_expr env e ++
            popq (rax) ++
            negq (ind ~ofs:8 rax) ++
            addq (imm 1) (ind ~ofs:8 rax) ++
            pushq (reg rax)
    
    | Emoins e ->
            compile_expr env e ++
            popq (rax) ++
            negq (ind ~ofs:8 rax) ++
            pushq (reg rax)
    
    | Eop (e, o, f) when o.o = Et -> (* il faut évaluer paresseusement *)
        let s = string_of_int !numero in
        numero:= !numero + 1;
            compile_expr env e ++
            popq (rax) ++
            cmpq (imm 0) (ind ~ofs:8 rax) ++ (* on teste si rax = 0 car sinon rax = 1 *)
            je ("L"^s) ++
            compile_expr env f ++
            popq (rax) ++
        label ("L"^s) ++
            pushq (reg rax)
    | Eop (e, o, f) when o.o = Ou -> (* il faut évaluer paresseusement encore *)
        let s = string_of_int !numero in
        numero:= !numero + 1;
            compile_expr env e ++
            popq (rax) ++
            cmpq (imm 0) (ind ~ofs:8 rax) ++
            jne ("L"^s) ++
            compile_expr env f ++
            popq (rax) ++
        label ("L"^s) ++
            pushq (reg rax)
    | Eop (e,o,f) when o.o = Div ->
        compile_expr env e ++
        compile_expr env f ++
        popq (r14) ++
        popq (r13) ++
        movq (ind ~ofs:8 r13) (reg rax) ++
        movq (ind ~ofs:8 r14) (reg rbx) ++
        cqto ++ idivq (reg rbx) ++
        movq (reg rax) (ind ~ofs:8 r13) ++
        pushq (reg r13)
    | Eop (e,o,f) when o.o = Reste ->
        compile_expr env e ++
        compile_expr env f ++
        popq (r14) ++
        popq (r13) ++
        movq (ind ~ofs:8 r13) (reg rax) ++
        movq (ind ~ofs:8 r14) (reg rbx) ++
        cqto ++ idivq (reg rbx) ++
        movq (reg rdx) (ind ~ofs:8 r13) ++
        pushq (reg r13)
    | Eop (e, o, f) when List.mem o.o [Add; Sub; Mul] ->
            compile_expr env e ++
            compile_expr env f ++
            popq (rbx) ++
            popq (rax) ++
            movq (ind ~ofs:8 rbx) (reg r13) ++
            (match o.o with
                | Add -> addq (reg r13) (ind ~ofs:8 rax)
                | Sub -> subq (reg r13) (ind ~ofs:8 rax)
                | Mul -> imulq (ind ~ofs:8 rax) (reg r13) ++ movq (reg r13) (ind ~ofs:8 rax)
                | _ -> failwith "les autres cas sont inutiles") ++
            pushq (reg rax)
    | Eop (e, o, f) ->
        compile_expr env e ++
        compile_expr env f ++
            popq (rbx) ++
            popq (rax) ++
            movq (ind ~ofs:8 rbx) (reg r13) ++
            (match o.o with
                (* il y a peut être un problème sur l'égalité structurelle :
                    Je la teste pareil que l'autre égalité alors qu'il faut 
                    peut être l'utiliser avec les adresses des paramètres ? *)
                | Eq -> 
                        cmpq (ind ~ofs:8 rax) (reg r13) ++ 
                        sete (reg cl) ++ movzbq (reg cl) rcx
                | Ne -> 
                        cmpq (ind ~ofs:8 rax) (reg r13) ++ 
                        setne (reg cl) ++ movzbq (reg cl) rcx
                | Dbleg ->
                        cmpq (ind ~ofs:8 rax) (reg r13) ++
                        sete (reg cl) ++ movzbq (reg cl) rcx
                | Diff -> 
                        cmpq (ind ~ofs:8 rax) (reg r13) ++ 
                        setne (reg cl) ++ movzbq (reg cl) rcx
                | Inf -> 
                        cmpq (reg r13) (ind ~ofs:8 rax) ++ 
                        sets (reg cl) ++ movzbq (reg cl) rcx
                | Infeg -> 
                        cmpq (ind ~ofs:8 rax) (reg r13) ++ 
                        setns (reg cl) ++ movzbq (reg cl) rcx
                | Sup -> 
                        cmpq (ind ~ofs:8 rax) (reg r13) ++ 
                        sets (reg cl) ++ movzbq (reg cl) rcx
                | Supeg -> 
                        cmpq (reg r13) (ind ~ofs:8 rax) ++ 
                        setns (reg cl) ++ movzbq (reg cl) rcx
                | _ -> failwith "on n'est pas dans un autre cas") ++
            pushq (reg rcx) ++
            call "C_Boolean" ++
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    
    | Eif (e, e1, e2) -> 
        let s1 = string_of_int !numero and s2 = string_of_int (!numero+1) in
        numero:= !numero + 2;
            compile_expr env e ++
            popq (rax) ++
            cmpq (imm 0) (ind ~ofs:8 rax) ++
            je ("L"^s1) ++
            compile_expr env e1 ++
            jmp ("L"^s2) ++
        label ("L"^s1) ++
            compile_expr env e2 ++
        label ("L"^s2)
    
    | Ewhile (e1, e2) ->
        let s1 = string_of_int !numero and s2 = string_of_int (!numero+1) in
        numero:= !numero +2;
        label ("L"^s1) ++
            compile_expr env e1 ++
            popq (rax) ++
            movq (ind ~ofs:8 rax) (reg rbx) ++
            cmpq (imm 0) (reg rbx) ++
            je ("L"^s2) ++
            compile_expr env e2 ++
            jmp ("L"^s1) ++
        label ("L"^s2)
    
    | Ereturnvide -> (* on ne remet rien sur la pile, on se contente de mettre la valeur à retourner dans rax *)
            movq (imm 0) (reg rax) ++
            movq (reg rbp) (reg rsp) ++
            popq (rbp) ++
            ret (* doit-on mettre le ret et les modif re rsp et rbp ? Je pense que oui *)
    | Ereturn e -> 
        compile_expr env e ++ popq (rax) ++ 
            movq (reg rbp) (reg rsp) ++
            popq (rbp) ++
            ret
    
    | Eprint e when e.te.t = Typ ("Int", {at= []; lat= l_empty}) -> (* on ne remet rien sur la pile après avoir affiché *)
        compile_expr env e ++
            call "print_int" ++ (* ici e est un entier *)
            addq (imm 8) (reg rsp) ++
            pushq (imm 0) ++
            call "C_Unit" ++
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    
    | Eprint e -> (* c'est forcément une string si on a survécu au typage *)
        compile_expr env e ++
            call "print_string" ++ (* ici e est une string *)
            addq (imm 8) (reg rsp) ++
            pushq (imm 0) ++
            call "C_Unit" ++
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    
    | Ebloc b ->
        List.fold_left (fun code bl -> code ++ (compile_bl env bl)) nop b.b


and compile_bl env bl = match bl.b1 with
    | Bvar v ->
        let id = id_of_var v and e = exp_of_var v in
        compile_expr env e ++
            popq (rax) ++
            movq (reg rax) (ind ~ofs:(8*(Emap.find id env)) rbp)
        
    | Bexpr e ->
        compile_expr env e

and compile_methode m c =
    let s = ident_of_m m and lp = param_of_m m and e = exp_of_m m and k = ref 1 in
    (* il y a l'ancienne valeur de rbp et l'adresse de retour en sommet de pile *)
    let env, taille = alloc_methode m in
    label ("M_"^c^"_"^s) ++
        pushq (reg rbp) ++ (* il faut garder en mémoire rbp pour le restaurer *)
        movq (reg rsp) (reg rbp) ++
        subq (imm (-8*taille)) (reg rsp) ++ (* on crée le tableau d'activation qui commence en rsp et se finit en rsp-8(taille-1) *)
        
        compile_expr (List.fold_left (fun e p -> k:=!k + 1; Emap.add p !k e) env (List.map (fun p -> let (id,_) = p.p in id) lp)) e ++
        
        movq (reg rbp) (reg rsp) ++ (* on supprime les variables allouées *)
        popq (rbp) ++ (* on restaure rbp *)
        ret
    
    



(** Compilation des classes **)

let aux_param p c c_extends numc =
    let (s, _) = p.p in
    if Ocmap.exists (fun (c, x) k -> x = s) !oc then ()
    else (oc:= Ocmap.add (c, s) !numc !oc; numc:= !numc+1)

let rec aux_modifie y l k = match l, k with
    | [], _ -> failwith "override pas définie dans la classe héritée"
    | t::q, k when k = 0 -> y::q
    | t::q, k -> t::(aux_modifie y q (k-1))

let aux_decl d c c_extends l numc numm = match d.d with
    | Dvar v ->
        let id = id_of_var v in
        (* il faut regarder si id est dans la classe extends *)
        if Ocmap.exists (fun (c, x) k -> x = c) !oc then ()
        else (oc:= Ocmap.add (c, id) !numc !oc; numc:= !numc+1)
    | Dmethode {m=Mdef (s,_,_,_,_); lm=_} -> (* on sait ici que s n'est pas dans la classe extends *)
        l:= List.append !l ["M_"^c^"_"^s];
        om:= Ommap.add (c, s) !numm !om; numm:= !numm+1
    | Dmethode {m=Moverride (s,_,_,_,_); lm=_} -> (* on sait ici que s est dans extends, on ne change pas son offset *)
        l:= aux_modifie ("M_"^c^"_"^s) !l (Ommap.find (c,s) !om)

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
                                        compile_expr Emap.empty e) ++
                                popq (rbx) ++
                                movq (reg rbx) (ind (r12))
                                ) nop lid ++
        ret

let compile_methodes_classe cl =
    let c = ident_of_class cl in
    thisref:= c;
    List.fold_left (fun code d -> code ++ (match d.d with
                                                | Dvar _ -> nop
                                                | Dmethode m -> compile_methode m c)) nop (dec_of_class cl)

let compile_classes lc cM =
    let cm = {c= ("Main",[],[],{t=Typ("Any",{at= [];lat= l_empty}); lt=l_empty},[],cM.cM);lc= l_empty} in
    List.iter (fun cl -> comp_classe cl) (cm::lc);
    List.fold_left (fun code cl -> code ++ constr_of_class cl) nop (cm::lc),
    List.fold_left (fun code cl -> code ++ compile_methodes_classe cl) nop (cm::lc)



(** Compilation de la classe Main **)

let compile_classe_main cM =
    let cl = {c= ("Main",[],[],{t=Typ("Any",{at= [];lat= l_empty}); lt=l_empty},[],cM.cM);lc= l_empty} in
    comp_classe cl;
    let constr_Main = constr_of_class cl
    and meth_Main = compile_methodes_classe cl in
    constr_Main, meth_Main



(** Compilation d'un fichier **)

let comp fichier =
    chaines:= nop; numero := 0; descr := descr_empty;
    omax:= omax_empty; oc:= Ocmap.empty; om:= Ommap.empty;
	let (lc, cM) = fichier.f in
	let codeclasses, codemethodes = compile_classes lc cM in
	{text =
	glabel "main" ++
	    call "C_Main" ++ 
	    (* dans rax on a l'adresse de l'objet, on peut le mettre dans la pile et le dépiler dans 
	        M_Main_main si c'est plus facile lors de l'écriture de la compilation des méthodes *)
	    pushq (reg rax) ++
	    call "M_Main_main" ++
	    addq (imm 8) (reg rsp) ++
	    xorq (reg rax) (reg rax) ++
	    ret ++
        (* le constructeur de Main sert à stocker les variables définies dans Main avant Main_main *)
        codeclasses ++ codemethodes ++
    (* on s'occupe des classes prédéfinies *)
    label "C_Nothing" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_Nothing") (ind (r12)) ++ 
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_Null" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_Null") (ind (r12)) ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_String" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 16) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_String") (ind (r12)) ++
        movq (ind ~ofs:16 rbp) (reg rbx) ++ movq (reg rbx) (ind ~ofs:8 r12) ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_AnyRef" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_AnyRef") (ind (r12)) ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_Any" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_Any") (ind (r12)) ++ 
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_Boolean" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 16) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_Boolean") (ind (r12)) ++
        movq (ind ~ofs:16 rbp) (reg rbx) ++ movq (reg rbx) (ind ~ofs:8 r12) ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_Int" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 16) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_Int") (ind (r12)) ++
        movq (ind ~ofs:16 rbp) (reg rbx) ++ movq (reg rbx) (ind ~ofs:8 r12) ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_Unit" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 16) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_Unit") (ind (r12)) ++
        movq (ind ~ofs:16 rbp) (reg rbx) ++ movq (reg rbx) (ind ~ofs:8 r12) ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_AnyVal" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ movq (reg rax) (reg r12) ++ movq (ilab "D_AnyVal") (ind (r12)) ++ 
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "print_int" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (ind ~ofs:16 rbp) (reg rdi) ++
        movq (ind ~ofs:8 rdi) (reg rsi) ++
        movq (ilab ".Sprint_int") (reg rdi) ++
        movq (imm 0) (reg rax) ++
        call "printf" ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "print_string" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (ind ~ofs:16 rbp) (reg rdi) ++
        movq (ind ~ofs:8 rdi) (reg rsi) ++
        movq (ilab ".Sprint_string") (reg rdi) ++
        movq (imm 0) (reg rax) ++
        call "printf" ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret; 
	data =
	    Dmap.fold (fun s l code -> code ++ label ("D_"^s) ++ address l) !descr nop ++
    label ".Sprint_int" ++ string "%d" ++
	label ".Sprint_string" ++ string "%s" ++
	    !chaines
	}
