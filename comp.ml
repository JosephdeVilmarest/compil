open X86_64
open Ast
open Lexing
open Typeur

let l_empty = ({pos_fname = ""; pos_lnum = 0; pos_bol = 0; pos_cnum = 0}, 
                     {pos_fname = ""; pos_lnum = 0; pos_bol = 0; pos_cnum = 0})

(* une solution pour les chaines de caractères: maintenir une référence mise 
    à nop au début de la fonction comp dans laquelle on met toutes les chaines 
    rencontrées et ainsi à la fin on les met dans le data, on les associe à des
    entiers. La référence numero sera modifié dès qu'on écrira une chaine 
    ou une étiquette *)

module Omaxmap = Map.Make(String)
let omax_empty = Omaxmap.add "Nothing" (0, 0) (Omaxmap.add "Null" (0, 0) 
        (Omaxmap.add "String" (0, 0) (Omaxmap.add "AnyRef" (0, 0) 
        (Omaxmap.add "Unit" (0, 0) (Omaxmap.add "Int" (0, 0) 
        (Omaxmap.add "Boolean" (0, 0) (Omaxmap.add "AnyVal" (0, 0) 
                                (Omaxmap.add "Any" (0, 0) Omaxmap.empty))))))))

module Key = struct type t = string*string let compare = Pervasives.compare end
module Ocmap = Map.Make(Key) (* donne les offset des champs d'une classe *)
module Ommap = Map.Make(Key) (* donne les offset des méthodes d'une classe *)

module Dmap = Map.Make (String) (* donne le descripteur d'une classe *)
let descr_empty = Dmap.add "Nothing" ["D_Null"] (Dmap.add "Null" ["D_String"] 
        (Dmap.add "String" ["D_AnyRef"] (Dmap.add "AnyRef" ["D_Any"] 
        (Dmap.add "Unit" ["D_AnyVal"] (Dmap.add "Int" ["D_AnyVal"] 
        (Dmap.add "Boolean" ["D_AnyVal"] (Dmap.add "AnyVal" ["D_Any"] 
                                   (Dmap.add "Any" ["D_Any"] Dmap.empty))))))))

let chaines = ref nop and numero = ref 0 and descr = ref descr_empty
and omax = ref omax_empty and oc = ref Ocmap.empty and om = ref Ommap.empty
and thisref = ref ""

module Emap = Map.Make(String)
(* donne l'offset par rapport à rsp des variables locales *)     

        


(** Compilation des expressions et des méthodes (car tout est lié !) **)

(* allocation: au début d'une méthode on alloue l'espace nécessaire et on 
    attribue une adresse à chaque variable locale qui intervient *)
let rec alloc_expr (env, k) e = match e.e with
    | Epar e -> alloc_expr (env, k) e
    | Eaccexp (a,e) -> alloc_expr (env, k) e
    | Eaccargexp (_,_,le) -> List.fold_left alloc_expr (env,k) le
    | Enewidargexp (_,_,le) -> List.fold_left alloc_expr (env,k) le
    | Eneg e -> alloc_expr (env,k) e
    | Emoins e -> alloc_expr (env,k) e
    | Eop (e1,o,e2) -> alloc_expr (alloc_expr ((env,k)) e1) e2
    | Eif (e,e1,e2) -> alloc_expr (alloc_expr (alloc_expr (env,k) e) e1) e2
    | Ewhile (e1,e2) -> alloc_expr (alloc_expr ((env,k)) e1) e2
    | Ereturn e -> alloc_expr (env,k) e
    | Eprint e -> alloc_expr (env,k) e
    | Ebloc b -> alloc_bloc (env, k) b
    | _ -> (env, k) (* pas de variables locales pour les cas restants *)

and alloc_bloc (env, k) b = match b.b with
    | [] -> (env, k)
    | {b1= Bvar v ;lb1=_}::q -> 
            alloc_bloc (Emap.add (id_of_var v) (k-1) env, k-1) {b=q; lb=b.lb}
    | {b1= Bexpr e ;lb1=_}::q ->
            alloc_bloc (alloc_expr (env, k) e) {b=q; lb=b.lb}

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
        (* on doit avoir à ce moment là un objet de classe !thisref dans r15 *)
            pushq (reg r15)
     
    | Enull ->
            pushq (imm 0) ++ 
            call "C_Null" ++ 
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    
    | Epar e -> compile_expr env e
    
    | Eacc {a= Aid id; la=_} -> 
        (try let o = 8*Emap.find id env in
        (* cas où id est une variable locale.
            La variable id est stockée dans rbp + o *) 
            pushq (ind ~ofs:o rbp)
        with Not_found ->  
        (* cas où id est un champ de la classe this.
            A-t-on l'objet en question dans r15 ?
            Si on est en train de compiler une méthode, aucun objet n'a été mis
            dans r15 et cela pose peut être problème.
            On peut essayer de mettre un objet dans r15 juste après avoir
            compilé le constructeur d'une classe *)
            let c = !thisref in
            let o = 8*(Ocmap.find (c, id) !oc) in
            pushq (ind ~ofs:o r15))     
    | Eacc {a= Aexpid (e, id); la=loc} ->
        (* il faut accéder au champ id de l'objet e, 
            donc on regarde la classe de e et on utilise oc *)
        (* si e = Ethis il n'y a pas de problème car on met r15 dans rax, et le
            résultat est le même que pour Eacc {Aid id ...} *)
        let Typ(c,_) = e.te.t in
        let o = 8*(Ocmap.find (c, id) !oc) in
        compile_expr env e ++
            popq (rax) ++
            pushq (ind ~ofs:o rax)
            
    | Eaccexp ({a= Aid id; la=_}, e) -> 
    (* il faut mettre unit sur la pile ? 
        est-ce qu'on construit vraiment un objet unit ??? *)
        compile_expr env e ++
            popq (rax) ++
        (try let o = 8*(Emap.find id env) in
        (* variable locale de la méthode *)
            movq (reg rax) (ind ~ofs:o rbp)
        with Not_found ->
        (* champ de l'objet qui se trouve dans r15 *)
        let c = !thisref in
        let o = 8*(Ocmap.find (c, id) !oc) in            
            movq (reg rax) (ind ~ofs:o r15)) ++
            pushq (imm 0) ++
            call "C_Unit" ++
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    | Eaccexp ({a= Aexpid (e1, id); la=loc}, e2) ->
        let Typ(c,_) = e1.te.t in
        let o = 8*(Ocmap.find (c, id) !oc) in
        compile_expr env e1 ++
        compile_expr env e2 ++
            popq (rbx) ++
            popq (rax) ++
        (* si e1 = Ethis on met r15 dans rax *)
            movq (reg rbx) (ind ~ofs:o rax) ++
            pushq (imm 0) ++
            call "C_Unit" ++
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    
    | Eaccargexp ({a= Aid id; la=_}, _, le) ->
        (* dans ce cas on appelle la méthode de la classe en cours *)
        let c = !thisref in
        let o = 8 * (Ommap.find (c, id) !om) in
        List.fold_left (fun code e -> compile_expr env e ++ code) nop le ++
            movq (ilab ("D_"^c)) (reg rbx) ++
            call_star (ind ~ofs:o rbx) ++
            addq (imm (8*List.length le)) (reg rsp) ++ (* on dépile *)
            pushq (reg rax)
    | Eaccargexp ({a= Aexpid (e,id); la=_}, ar, le) ->
        let Typ(c,_) = e.te.t in
        let o = 8 * (Ommap.find (c, id) !om) in
        List.fold_left (fun code e -> compile_expr env e ++ code) nop le ++
            movq (ilab ("D_"^c)) (reg rbx) ++
            
            movq (reg r15) (reg r9) ++ (** énorme bug **)
        compile_expr env e ++
            popq (r15) ++
            
            call_star (ind ~ofs:o rbx) ++
            movq (reg r9) (reg r15) ++
            
            addq (imm (8*List.length le)) (reg rsp) ++
            pushq (reg rax)
    
    | Enewidargexp (s, ar, le) -> 
    (* on met les expressions sur la pile et on appelle le constructeur *)
        List.fold_left (fun code e -> compile_expr env e ++ code) nop le ++
            call ("C_"^s) ++
            addq (imm (8*(List.length le))) (reg rsp) ++
            pushq (reg rax)
    
    | Eneg e -> (* la négation de b vaut 1-b *)
            compile_expr env e ++
            popq (rax) ++
            pushq (ind ~ofs:8 rax) ++
            call "C_Boolean" ++
            addq (imm 8) (reg rsp) ++
            negq (ind ~ofs:8 rax) ++
            addq (imm 1) (ind ~ofs:8 rax) ++
            pushq (reg rax)
    
    | Emoins e ->
            compile_expr env e ++
            popq (rax) ++
            pushq (ind ~ofs:8 rax) ++
            call "C_Int" ++
            addq (imm 8) (reg rsp) ++
            negq (ind ~ofs:8 rax) ++
            pushq (reg rax)
    
    | Eop (e, o, f) when o.o = Et -> (* il faut évaluer paresseusement *)
        let s = string_of_int !numero in
        numero:= !numero + 1;
            compile_expr env e ++
            popq (rax) ++
            (* on teste si rax = 0 car sinon rax = 1 *)
            cmpq (imm 0) (ind ~ofs:8 rax) ++
            je ("L"^s) ++
            compile_expr env f ++
            popq (rax) ++
        label ("L"^s) ++
            pushq (ind ~ofs:8 rax) ++
            call "C_Boolean" ++
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    | Eop (e, o, f) when o.o = Ou ->
        let s = string_of_int !numero in
        numero:= !numero + 1;
            compile_expr env e ++
            popq (rax) ++
            cmpq (imm 0) (ind ~ofs:8 rax) ++
            jne ("L"^s) ++
            compile_expr env f ++
            popq (rax) ++
        label ("L"^s) ++
            pushq (ind ~ofs:8 rax) ++
            call "C_Boolean" ++
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    | Eop (e,o,f) when o.o = Div ->
        compile_expr env e ++
        compile_expr env f ++
        popq (r14) ++
        popq (r13) ++
        movq (ind ~ofs:8 r13) (reg rax) ++
        movq (ind ~ofs:8 r14) (reg rbx) ++
        cqto ++ idivq (reg rbx) ++
        pushq (reg rax) ++
        call"C_Int" ++
        addq (imm 8) (reg rsp) ++
        pushq (reg rax)
    | Eop (e,o,f) when o.o = Reste ->
        compile_expr env e ++
        compile_expr env f ++
        popq (r14) ++
        popq (r13) ++
        movq (ind ~ofs:8 r13) (reg rax) ++
        movq (ind ~ofs:8 r14) (reg rbx) ++
        cqto ++ idivq (reg rbx) ++
        pushq (reg rdx) ++
        call"C_Int" ++
        addq (imm 8) (reg rsp) ++
        pushq (reg rax)
    | Eop (e, o, f) when List.mem o.o [Add; Sub; Mul] ->
            compile_expr env e ++
            compile_expr env f ++
            popq (rbx) ++
            popq (rax) ++
            movq (ind ~ofs:8 rbx) (reg r13) ++
            movq (ind ~ofs:8 rax) (reg r14) ++
            (match o.o with
                | Add -> addq (reg r13) (reg r14)
                | Sub -> subq (reg r13) (reg r14)
                | Mul -> imulq (reg r13) (reg r14)
                | _ -> failwith "les autres cas sont inutiles") ++
            pushq (reg r14) ++
            call "C_Int" ++
            addq (imm 8) (reg rsp) ++
            pushq (reg rax)
    | Eop (e,o,f) when List.mem o.o [Eq;Ne] ->  
        compile_expr env e ++
        compile_expr env f ++
            popq (rbx) ++
            popq (rax) ++
            (match o.o with
                | Ne -> cmpq (reg rax) (reg rbx)  ++ setne (reg cl) ++
                        movzbq (reg cl) rcx
                | _ ->  cmpq (reg rax) (reg rbx)  ++ sete (reg cl) ++ 
                        movzbq (reg cl) rcx)
            ++
            pushq (reg rcx) ++
            call "C_Boolean" ++
            addq (imm 8) (reg rsp) ++
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
    
    | Ereturnvide -> 
        (* on ne remet rien sur la pile, on se contente de 
            mettre la valeur à retourner dans rax *)
            movq (imm 0) (reg rax) ++
            movq (reg rbp) (reg rsp) ++
            popq (rbp) ++
            ret
    | Ereturn e -> 
        compile_expr env e ++ popq (rax) ++ 
            movq (reg rbp) (reg rsp) ++
            popq (rbp) ++
            ret
    
    | Eprint e when e.te.t = Typ ("Int", {at= []; lat= l_empty}) ->
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
    let s = ident_of_m m and lp = param_of_m m 
                                            and e = exp_of_m m and k = ref 1 in
    (* il y a l'ancienne valeur de rbp et 
        l'adresse de retour en sommet de pile *)
    let env, taille = alloc_methode m in
    label ("M_"^c^"_"^s) ++
        pushq (reg rbp) ++ (* il faut garder en mémoire rbp *)
        movq (reg rsp) (reg rbp) ++
        (* on place rbp au sommet de la pile pour allouer de l'espace aux 
            variables locales et y accéder avec un offset constant 
            par rapport à rbp *)
        addq (imm (8*taille)) (reg rsp) ++ 
        (* on crée le tableau d'activation qui commence en rbp 
            et se finit en rbp-8(-taille-1)  avec taille entier négatif*)
        
        compile_expr (List.fold_left (fun e p -> k:=!k + 1; Emap.add p !k e) 
                    env (List.map (fun p -> let (id,_) = p.p in id) lp)) e ++
        (* le List.fold_left stocke dans env les paramètres de la méthode
            auxquels on veut accéder à partir de rbp. On fait commencer les
            offset à 2 car il y a sur la pile l'ancien rbp et l'adresse de 
            retour *)
        popq (rax) ++
        
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
    | Dmethode {m=Mdef (s,_,_,_,_); lm=_} ->
        (* on sait ici que s n'est pas dans la classe extends *)
        l:= List.append !l ["M_"^c^"_"^s];
        om:= Ommap.add (c, s) !numm !om; numm:= !numm+1
    | Dmethode {m=Moverride (s,_,_,_,_); lm=_} ->
        (* on sait ici que s est dans extends, on ne change pas son offset *)
        l:= aux_modifie ("M_"^c^"_"^s) !l (Ommap.find (c,s) !om)

let comp_classe cl =
    let (c,_,lp,t,_,ld) = cl.c in let Typ (c_extends,_) = t.t in
    thisref:= c;
    let n1, n2 = Omaxmap.find c_extends !omax in
    let numc = ref (n1+1) and numm = ref (n2+1) in
    (* on initialise l avec c_extends *)
    let l = ref (("D_"^c_extends)::(List.tl (Dmap.find c_extends !descr))) in
    Ocmap.iter (fun (s, x) k -> oc:= Ocmap.add (c,x) k !oc) 
                            (Ocmap.filter (fun (s, x) k -> s = c_extends) !oc);
    Ommap.iter (fun (s, x) k -> om:= Ommap.add (c,x) k !om) 
                            (Ommap.filter (fun (s, x) k -> s = c_extends) !om);
    List.iter (fun p -> aux_param p c c_extends numc) lp;
    List.iter (fun d -> aux_decl d c c_extends l numc numm) ld;
    omax:= Omaxmap.add c (!numc, !numm) !omax;
    descr:= Dmap.add c !l !descr

let rec cherche_expr id cl = function
    | [] when (ident_of_class cl = "Any") -> failwith "expression non trouvée"
    | [] ->
        let Typ(c_extends,_) = (extends_of_class cl).t in
        let cl_extends = (Cmap.find c_extends 
                           ((Envmap.find c_extends !envmap).classes)).classe in
            cherche_expr id cl_extends (dec_of_class cl_extends)
    | {d=Dvar v; ld=_}::q when id_of_var v = id -> exp_of_var v
    | x::q -> cherche_expr id cl q

let rec aux_position id = function
    | [] -> failwith "paramètre non trouvé"
    | x::q when x = id -> 0
    | x::q -> 1 + aux_position id q

let constr_of_class cl =
    let c = ident_of_class cl and lp = param_of_class cl
                                                    and ld = dec_of_class cl in
    thisref:= c;
    let l1 = Ocmap.bindings (Ocmap.filter (fun (s, id) k -> s=c) !oc) in
    let lid = List.sort 
          (fun id1 id2 -> Ocmap.find (c,id1) !oc - Ocmap.find (c,id2) !oc)
                                       (List.map (fun ((s,id), k) -> id) l1) in
    let nbc = List.length lid in
    label ("C_"^c) ++
        pushq (reg rbp) ++
	    movq (reg rsp) (reg rbp) ++
    
        movq (imm (8*(nbc+1))) (reg rdi) ++
        call "malloc" ++
        pushq (reg r15) ++ (* on sauvegarde r15 *)
        (* on met l'objet que l'on construit dans r15 *)
        movq (reg rax) (reg r15) ++
        (* on sauvegarde rax qui peut tout à fait être modifié *)
        pushq (reg rax) ++
        (* on met rax dans r12 que l'on augmentera petit à petit *)
        movq (reg rax) (reg r12) ++
        movq (ilab ("D_"^c)) (ind (r12)) ++
        List.fold_left (fun code id -> 
                    code ++
                    addq (imm 8) (reg r12) ++
                    pushq (reg r12) ++
                    (match List.mem id 
                           (List.map (fun p -> let (id,_) = p.p in id) lp) with
                        | true ->
                            (* on ajoute 2 car il y a l'ancien rbp et l'adresse 
                                de retour au dessus de rbp *)
                            let o = 8*(2 + aux_position id (List.map 
                                      (fun p -> let (id,_) = p.p in id) lp)) in
                                pushq (ind ~ofs:o rbp)
                        | false -> 
                            let e = cherche_expr id cl ld in
                            compile_expr Emap.empty e) ++
                                popq (rbx) ++
                                popq (r12) ++
                                movq (reg rbx) (ind (r12))
                                ) nop lid ++
        popq (rax) ++
        popq (r15) ++
        
        movq (reg rbp) (reg rsp) ++
	    popq (rbp) ++
        ret

let compile_methodes_classe cl =
    let c = ident_of_class cl in
    thisref:= c;
    List.fold_left (fun code d -> 
                    code ++
                    (match d.d with
                        | Dvar _ -> nop
                        | Dmethode m -> compile_methode m c))
                                                          nop (dec_of_class cl)

let compile_classes lc cM =
    let cm = {c= ("Main",[],[],{t=Typ("Any",{at= [];lat= l_empty}); lt=l_empty}
                                                     ,[],cM.cM);lc= l_empty} in
    List.iter (fun cl -> comp_classe cl) (cm::lc);
    List.fold_left (fun code cl -> code ++ constr_of_class cl) nop (cm::lc),
    List.fold_left (fun code cl -> code ++ compile_methodes_classe cl)
                                                                   nop (cm::lc)



(** Compilation de la classe Main (inutile) **)

let compile_classe_main cM =
    let cl = {c= ("Main",[],[],{t=Typ("Any",{at= [];lat= l_empty}); lt=l_empty}
                                                     ,[],cM.cM);lc= l_empty} in
    comp_classe cl;
    let constr_Main = constr_of_class cl
    and meth_Main = compile_methodes_classe cl in
    constr_Main, meth_Main



(** Compilation d'un fichier **)

let comp fichier =
    est_bien_type fichier;
    chaines:= nop; numero := 0; descr := descr_empty;
    omax:= omax_empty; oc:= Ocmap.empty; om:= Ommap.empty;
	let (lc, cM) = fichier.f in
	let codeclasses, codemethodes = compile_classes lc cM in
	{text =
	glabel "main" ++
	    call "C_Main" ++ 
	    movq (reg rax) (reg r15) ++ (* on initialise r15 *)
	    call "M_Main_main" ++
	    xorq (reg rax) (reg rax) ++
	    ret ++
        (* le constructeur de Main sert à stocker les variables
            définies dans Main avant Main_main *)
    codeclasses ++ codemethodes ++
    (* on s'occupe des classes prédéfinies *)
    label "C_Nothing" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (ilab ".SNothing") (reg rax) ++ 
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_Null" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (ilab ".SNull") (reg rax) ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_String" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 16) (reg rdi) ++ call "malloc" ++ 
        movq (reg rax) (reg r12) ++ movq (ilab "D_String") (ind (r12)) ++
        movq (ind ~ofs:16 rbp) (reg rbx) ++ movq (reg rbx) (ind ~ofs:8 r12) ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_AnyRef" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ 
        movq (reg rax) (reg r12) ++ movq (ilab "D_AnyRef") (ind (r12)) ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_Any" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ 
        movq (reg rax) (reg r12) ++ movq (ilab "D_Any") (ind (r12)) ++ 
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_Boolean" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 16) (reg rdi) ++ call "malloc" ++ 
        movq (reg rax) (reg r12) ++ movq (ilab "D_Boolean") (ind (r12)) ++
        movq (ind ~ofs:16 rbp) (reg rbx) ++ movq (reg rbx) (ind ~ofs:8 r12) ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_Int" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 16) (reg rdi) ++ call "malloc" ++ 
        movq (reg rax) (reg r12) ++ movq (ilab "D_Int") (ind (r12)) ++
        movq (ind ~ofs:16 rbp) (reg rbx) ++ movq (reg rbx) (ind ~ofs:8 r12) ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_Unit" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 16) (reg rdi) ++ call "malloc" ++ 
        movq (reg rax) (reg r12) ++ movq (ilab "D_Unit") (ind (r12)) ++
        movq (ind ~ofs:16 rbp) (reg rbx) ++ movq (reg rbx) (ind ~ofs:8 r12) ++
        movq (reg rbp) (reg rsp) ++ popq (rbp) ++
        ret ++
    label "C_AnyVal" ++
        pushq (reg rbp) ++ movq (reg rsp) (reg rbp) ++
        movq (imm 8) (reg rdi) ++ call "malloc" ++ 
        movq (reg rax) (reg r12) ++ movq (ilab "D_AnyVal") (ind (r12)) ++ 
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
	    Dmap.fold (fun s l code -> code ++ label ("D_"^s) ++ address l)
	                                                              !descr nop ++
    label ".Sprint_int" ++ string "%d" ++
	label ".Sprint_string" ++ string "%s" ++
    label ".SNothing" ++
        address ["D_Nothing"] ++
    label ".SNull" ++
        address ["D_Null"] ++
	!chaines
	}
