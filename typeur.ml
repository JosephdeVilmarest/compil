(** Toutes les fonctions prendront en argument des types contenant une loc **)

(** Modules et types **)

open Ast
module Cmap = Map.Make (String)
module Smap = Map.Make (String)

open Lexing
let l_empty = ({pos_fname = ""; pos_lnum = 0; pos_bol = 0; pos_cnum = 0}, 
                     {pos_fname = ""; pos_lnum = 0; pos_bol = 0; pos_cnum = 0})

exception Typeur_error of string * loc

type classaug = {mutable classe : classe; borneinf : typ}

(* de meme que dans l'ast, pour d�clarer un nouveau type on le d�clare
   sans localisation (_sl) puis avec localisation *)
type dec_var_sl = 
    | Var of string * typ
    | Val of string * typ
type dec_var = {dv: dec_var_sl; ldv: loc}

type environnement = {mutable classes: classaug Cmap.t; 
                                mutable dec: dec_var list}

(* typ_ret correspond au type de retour d'une m�thode *)
(* ici la localisation est dans le typ *)
type typ_ret = None | Some of typ

(* module envmap qui a un nom de classe associe l environnment de la classe*)

module Envmap = Map.Make(String)

let envmap = ref Envmap.empty

(* va stoquer les environnements des methodes : nom de classe -> nom de methode -> environnement*)

module MEnvmap = Map.Make(String)
 
let menvmap = ref MEnvmap.empty


(**Fonctions Utiles**)

(* fonctions qui donnent les 6 diff�rents attributs d'une classe cl
   don�e sous le type classe et non classaug *)
let ident_of_class cl = let (n,_,_,_,_,_) = cl.c in n
let ptc_of_class cl = let (_,l,_,_,_,_) = cl.c in l
let param_of_class cl = let (_,_,p,_,_,_) = cl.c in p
let extends_of_class cl = let  (_,_,_,t,_,_) = cl.c in t
let exp_of_class cl = let (_,_,_,_,e,_) = cl.c in e
let dec_of_class cl = let (_,_,_,_,_,d) = cl.c in d

(* s est renvoy� sous la forme ident *)
let pere_of_class cl gamma = let (_,_,_,{t= Typ (s,at); lt= _},_,_) = cl.c in (s,at)

(* on donne ici la classe sous la forme ident *)
(* string -> environnement -> ptc list *)
let trouve_ptc c gamma = ptc_of_class (Cmap.find c gamma.classes).classe

(* fonctions qui donnent les attributs d'une m�thode *)
let ident_of_m m = match m.m with
	| Moverride(n,_,_,_,_) -> n
	| Mdef(n,_,_,_,_) -> n

let pt_of_m m = match m.m with
	| Moverride(_,l,_,_,_) -> l
	| Mdef(_,l,_,_,_) -> l

let param_of_m m = match m.m with
	| Moverride(_,_,l,_,_) -> l
	| Mdef(_,_,l,_,_) -> l

let t_of_m m = match m.m with
	| Moverride(_,_,_,t,_) -> t
	| Mdef(_,_,_,t,_) -> t

let exp_of_m m = match m.m with
	| Moverride(_,_,_,_,e) -> e
	| Mdef(_,_,_,_,e) -> e

(* renvoie ce qui nous int�resse d'une m�thode pour le typage *)
let cherche_param_meth m cl =
    let dec = dec_of_class cl in
    let met = ref {m= Mdef ("",[],[],{t= Typ ("Nothing",{at= [];lat= l_empty});
                                    lt= l_empty},{e= Eunit; le= l_empty; 
    te= {t=Typ ("Nothing",{at= [];lat= l_empty}); lt=l_empty}}); lm= l_empty} in
    let f = function
        | Dmethode m0 -> (match m0.m with
                | Moverride (x,lpt,lp,t,e) when x=m -> met := m0
                | Mdef (x,lpt,lp,t,e) when x=m -> met := m0
                | _ -> ())
        | _ -> ()
    in List.iter f (List.map (fun decl -> decl.d) dec);
    match !met.m with
    
        | Moverride (x,lpt,lp,t,e) -> 
            if x = "" then raise (Typeur_error("la methode n'est pas dans la classe",!met.lm))
             else  (x,lpt,lp,t,e)
        | Mdef (x,lpt,lp,t,e) -> 
         if x = "" then raise (Typeur_error("la methode n'est pas dans la classe",!met.lm))
        else  (x,lpt,lp,t,e)

(* Prend en  argument un ptc et renvoie le pt associe *)
let pt_of_ptc ptc = match ptc.ptc with 
    | Ptc(pt) -> pt
    | Ptcplus(pt) -> pt
    | Ptcmoins(pt) -> pt

(* prend en argument ptc et renvoie son id *)
let id_of_ptc ptc = match (pt_of_ptc ptc).pt with
	| Ptid s -> s
	| Ptidoptyp (s,_,_) -> s

(* prend en argument pt et renvoie son id *)
let id_of_pt pt = match pt.pt with 
	| Ptid s -> s
	| Ptidoptyp (s,_,_) -> s

(* transforme un ptc en typ *)
let t_of_ptc ptc = 
    let i = id_of_ptc ptc in
    {t= Typ(i,{at= []; lat= l_empty}); lt= ptc.lptc}

(* fonctions qui donnent les attributs d'une variable *)
let id_of_var v = match v.v with
    | Vvar (x,_,_) -> x
    | Vval (x,_,_) -> x
let typ_of_var v = match v.v with
    | Vvar (_,t,_) -> t
    | Vval (_,t,_) -> t
let exp_of_var v = match v.v with
    | Vvar (_,_,e) -> e
    | Vval (_,_,e) -> e

(* fonctions qui donnent les attributs d'une d�claration de variable *)
let id_of_dec_var dv = match dv.dv with
    | Var (x,_) -> x
    | Val (x,_) -> x
let typ_of_dec_var dv = match dv.dv with
    | Var (_,t) -> t
    | Val (_,t) -> t



let rec cherche_dec id = function 
    |[] -> raise Not_found
    |dv::q when (match dv.dv with Var(s,t) -> s |Val(s,t) -> s) = id -> 
                         (match dv.dv with Var(s,t) -> t |Val(s,t) -> t)
    |d::q -> cherche_dec id q

(* ici il faut que la variable soit mutable, 
   c'est pour l'affectation dans typ_expr *)
exception Variable_immuable
let rec cherche_dec_mutable id = function
    | [] -> raise Not_found
    | (Dvar {v= (Vvar (x,t,_)); lv= _})::q when x = id -> t
    | (Dvar {v= (Vval (x,t,_)); lv= _})::q when x = id -> 
                                                        raise Variable_immuable
    | d::q -> cherche_dec_mutable id q

(* on fait de m�me dans une dec_var list *)
let rec cherche_dec_var id = function
    | [] -> raise Not_found
    | d::q when id_of_dec_var d = id -> typ_of_dec_var d
    | d::q -> cherche_dec_var id q
let rec cherche_dec_var_mutable id = function
    | [] -> raise Not_found
    | ({dv= Var (x,t); ldv= _})::q when x = id -> t
    | ({dv= Val (x,_); ldv= _})::q when x = id -> raise Variable_immuable
    | d::q -> cherche_dec_var_mutable id q

(* on cherche ici le p�re de c donn�e sous la forme ident *)
let pere_of_ident c gamma = 
    let {t= Typ (s,_); lt= l_empty} =
                       extends_of_class (Cmap.find c gamma.classes).classe in s

(* cette fonction donne le typ � l'int�rieur d'un 
   typ_ret qu'on suppose diff�rent de None *)
let typ_of_typ_ret = function
    | None -> raise (Typeur_error ("Le type de retour n'a pas �t� d�fini", l_empty))
    | Some t -> t

let rec tl_of_ptcl = function
	| []-> []
	| ptc::q -> (t_of_ptc ptc)::(tl_of_ptcl q)



(** Sous-typage **)

let sigma_of_listes lptc lt =
    (* ptc list -> typ list -> typ Smap *)
	let rec aux sigma lptc lt = match lptc, lt with
		| [], [] -> sigma
		| ptc::p, t::q -> aux (Smap.add (id_of_ptc ptc) t sigma) p q
		| _ -> raise 
		   (Typeur_error ("listes de tailles diff�rentes dans sigma", l_empty))
		   (* est-ce qu'on remplace l_empty par quelque chose ? *)
	in aux Smap.empty lptc lt

let rec substitue sigma t =
    (* typ -> typ *)
	let Typ (c, larg) = t.t in
	if Smap.mem c sigma then Smap.find c sigma
	else {t= Typ (c, {at= List.map (substitue sigma) larg.at; lat= larg.lat});
	                                                              lt= larg.lat}

let rec est_sous_classe c1 c2 gamma =
    (* string -> string -> environnement -> bool *)
	if c1 = "Nothing" then true
	else if c1 = "Null" then not(List.mem c1 
	                           ["Nothing"; "Unit"; "Int"; "Boolean"; "AnyVal"])
	     else if c1 = c2 then true
              else if c1 = "Any" then false
                   else let c = pere_of_ident c1 gamma in 
                        est_sous_classe c c2 gamma

let rec est_sous_type t1 t2 gamma = match t1.t, t2.t with
    (* typ -> typ -> environnement -> bool *)
    | _, Typ ("Any", _) -> true
	| Typ ("Nothing", _), _ -> true
	| Typ ("Null", _), Typ (s,sigma) -> not (List.mem s ["Nothing"; "Unit";
	                                               "Int"; "Boolean"; "AnyVal"])
	| Typ(c1,at1), Typ(c2,at2) when c1 = c2 -> 
	        let l = trouve_ptc c1 gamma in
	        aux_verif1 (List.map (fun ptc -> ptc.ptc) l) at1 at2 gamma
	| x, y when aux_verif2 t1 t2 gamma -> true
	| x, y when aux_verif3 t1 t2 gamma -> true
	| _ -> false

and aux_verif1 l at1 at2 gamma = match l, at1.at, at2.at with
    (* ptc_sl list -> arguments_typ -> arguments_typ -> environnement -> bool *)
	| [], [], [] -> true
    | (Ptc _)::q, t1::l1, t2::l2 -> (t1.t = t2.t)&&
             (aux_verif1 q {at= l1; lat= at1.lat} {at= l2; lat= at2.lat} gamma)
	| (Ptcplus _)::q, t1::l1, t2::l2 -> (est_sous_type t1 t2 gamma)&&
	         (aux_verif1 q {at= l1; lat= at1.lat} {at= l2; lat= at2.lat} gamma)
	| (Ptcmoins _)::q, t1::l1, t2::l2 -> (est_sous_type t2 t1 gamma)&&
	         (aux_verif1 q {at= l1; lat= at1.lat} {at= l2; lat= at2.lat} gamma)
	| _ -> raise 
	            (Typeur_error ("probl�me de taille d'une liste larg", l_empty))

and aux_verif2 t1 t2 gamma =
    let Typ (c1,at1) = t1.t and Typ (c2,at2) = t2.t in
    let t = extends_of_class (Cmap.find c1 gamma.classes).classe in
    let Typ (c,at) = t.t
	and sigma1 = sigma_of_listes (trouve_ptc c1 gamma) at1.at in
	let l = List.map (substitue sigma1) at.at in
	(est_sous_classe c c2 gamma)&&
	       (est_sous_type {t= Typ (c,{at= l; lat= at.lat}); lt= t.lt} t2 gamma)

and aux_verif3 t1 t2 gamma =
    let Typ (c1,larg1) = t1.t and Typ (c2,larg2) = t2.t in
    let tex = extends_of_class (Cmap.find c1 gamma.classes).classe in
    let Typ (s, _) = tex.t in
    if s = "Nothing" then true
    else if c2 = "Nothing" then false
         else let t = (Cmap.find c2 gamma.classes).borneinf in
	     not(est_sous_classe c1 c2 gamma)&&(est_sous_type t1 t gamma)





(** Bonne formation d'un type **)

let subst_bf lptc at gamma =
    (* ptc list -> arguments_typ -> environnement -> bool *)
	let sigma = sigma_of_listes lptc at.at in
	let rec aux lpt lt = match lpt, lt with
		| [], [] -> true
		| (Ptid _)::p, t::q -> aux p q
		| (Ptidoptyp (_, {o= Inf; lo= _}, t2))::p, t::q -> 
		                (est_sous_type t (substitue sigma t2) gamma)&&(aux p q)
		| (Ptidoptyp (_, {o= Sup; lo= _}, t2))::p, t::q -> 
		                (est_sous_type (substitue sigma t2) t gamma)&&(aux p q)
		| _ -> raise (Typeur_error ("ce cas n'arrive jamais", l_empty))
	in aux (List.map (fun pt -> pt.pt) (List.map pt_of_ptc lptc)) at.at

let rec est_bf t gamma =
    (* typ -> environnement -> bool *)
    let Typ (c,at) = t.t in
	try let lptc = trouve_ptc c gamma in
	        (* de type ptc list *)
		if List.length lptc <> List.length at.at then false
		else let flag = ref true in 
		    List.iter (fun t -> flag:= !flag && (est_bf t gamma)) at.at;
		    !flag && (subst_bf lptc at gamma)
	with Not_found -> false



(** Typage d'une expression **)

(** choses pour verifier l unicite des blocs et autres **)

let pas_de_doublons l loc = 
	let rec aux x = function
		| [] -> true
		| t::q -> if t = x then false else aux x q 
	in let rec aux2 = function
		| [] -> true
		| t1::q1 -> if not(aux t1 q1) then false else aux2 q1
	in let b = aux2 l in if b = false 
	    then raise (Typeur_error 
    ("Il y a des doublons : deux parametres, types, variables ou classes ont le meme nom",
                                                                          loc))
    else ()




let rec verif_unicite_bloc bloc = 
    let l1 = bloc.b in
    let l2 = List.fold_left (fun l bl -> List.append l (verif_unicite_bl bl)) [] l1 in
    pas_de_doublons l2 bloc.lb;l2
    
and verif_unicite_bl bl = match bl.b1 with
    |Bvar(v) ->  [id_of_var v]
    |Bexpr(e) -> []


(*********************************************************************************************************)

let ltparam cl =
    (* classe -> string list *)
    let l = param_of_class cl in 
	let rec aux = function
		| [] -> []
		| (a,b)::q -> b :: aux q
	in aux (List.map (fun p -> p.p) l)

let rec type_expr exp gamma tr = if (match exp.e with |Ebloc(b) -> true |_ -> false) then 
    (match exp.e with Ebloc(b) -> let _ = verif_unicite_bloc b  in () |_ -> failwith "impossible");
    let ttyp = match exp.e with
    | Eentier _ -> {t= Typ ("Int", {at= []; lat= l_empty}); lt= exp.le}
    | Echaine _ -> {t= Typ ("String", {at= []; lat= l_empty}); lt= exp.le}    
    | Ebool _ -> {t= Typ ("Boolean", {at= []; lat= l_empty}); lt= exp.le}    
    | Eunit -> {t= Typ ("Unit", {at= []; lat= l_empty}); lt= exp.le}
    
    | Enull -> {t= Typ ("Null", {at= []; lat= l_empty}); lt= exp.le}
    
    | Ethis -> cherche_dec_var "this" gamma.dec
    
    | Epar e -> type_expr e gamma tr
    
    | Eacc {a= Aid id; la= _} -> let t =
           (try cherche_dec_var id gamma.dec
            with Not_found -> 
                    cherche_dec id (gamma.dec)) in t  
    | Eacc {a= Aexpid (e,id); la= loc} -> 
            let Typ (c,at) = (type_expr e gamma tr).t in 
            let (_,lptc,_,_,_,ld) = ((Cmap.find c gamma.classes).classe).c in
            let sigma = sigma_of_listes lptc at.at in
            let ldd = (Envmap.find c (!envmap)).dec in 
           (try let t = cherche_dec id ldd in 
                substitue sigma t
            with Not_found -> raise
                                   (Typeur_error ("variable non d�finie",loc)))
    
    | Eaccexp ({a= Aid id; la= loca},e) -> 
           (try let t1 = cherche_dec_var_mutable id gamma.dec in
                let t2 = type_expr e gamma tr in
                if est_sous_type t2 t1 gamma 
                    then {t= Typ ("Unit", {at= []; lat= l_empty}); lt= exp.le}
                else raise (Typeur_error ("expression pas du bon type", e.le))
            with Variable_immuable ->
                        raise (Typeur_error ("variable immuable",loca))
                | Not_found -> 
                        let Typ (c,_) = (cherche_dec_var "this" gamma.dec).t in
                        let ld = dec_of_class 
                                          (Cmap.find c gamma.classes).classe in
                       (try let t1 = cherche_dec_mutable id 
                                                (List.map (fun d -> d.d) ld) in
                            let t2 = type_expr e gamma tr in
                            if est_sous_type t2 t1 gamma 
                                then {t= Typ ("Unit", {at= []; lat= l_empty});
                                                                    lt= exp.le}
                            else raise 
                            (Typeur_error ("expression pas du bon type", e.le))
                        with Variable_immuable -> raise
                                     (Typeur_error ("variable immuable", loca))
                            | Not_found -> raise 
                                (Typeur_error ("variable non d�finie", loca))))
    
    | Eaccexp ({a= Aexpid (e,id); la= loca},e2) -> 
            let Typ (c,at) = (type_expr e gamma tr).t in 
            let (_,lptc,_,_,_,ld) = ((Cmap.find c gamma.classes).classe).c in
           (try let t1 = cherche_dec_mutable id (List.map (fun d -> d.d) ld) in
                let t2 = type_expr e2 gamma tr in
                let sigma = sigma_of_listes lptc at.at in
                if est_sous_type t2 (substitue sigma t1) gamma
                    then {t= Typ ("Unit", {at= []; lat= l_empty}); lt= exp.le}
                else raise 
                     (Typeur_error ("l'expression n'est pas du bon type",e.le))
            with Variable_immuable -> raise 
                                     (Typeur_error ("variable immuable", loca))
                | Not_found -> raise 
                        (Typeur_error ("la variable n'est pas d�finie", loca)))
    
    | Eaccargexp ({a= Aid m; la= loca},at,le) -> 
            type_expr {e=(Eaccargexp ({a= Aexpid ({e= Ethis; le= l_empty; 
                                       te=cherche_dec_var "this" gamma.dec},m);
                                la= loca},at,le)); le= exp.le; 
             te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}} gamma tr
    
    | Eaccargexp ({a= Aexpid (e,m); la= loca},at1,le) -> 
            let Typ (c,at) = (type_expr e gamma tr).t in  
            let cl = ((Cmap.find c gamma.classes).classe) in
            let (_,lpt,lp,t,e) = cherche_param_meth m cl in 
            let lptc = ptc_of_class cl in
            let sigma = sigma_of_listes lptc at.at in
            let lptc2 = (List.map (fun pt -> {ptc= Ptc pt; lptc= pt.lpt}) lpt)
            in let
            sigma_prime = sigma_of_listes lptc2 at1.at in
            let image_composition = {at = List.map (fun ptc -> 
                        substitue sigma (substitue sigma_prime (t_of_ptc ptc)))
                                                       lptc2;lat = l_empty} in 
            let application_sigma_ptc sigm ptc = match ptc.ptc with
                |Ptc({pt = Ptidoptyp(s,o,t) ;lpt = loc}) -> 
                   {ptc = Ptc({pt = Ptidoptyp(s,o,substitue sigma t);lpt=loc});
                                                                lptc = ptc.lptc}
                |Ptc(_) -> ptc 
                |_ -> failwith "cas impossible"
            in
            let antecedent = 
                    List.map ( fun x -> application_sigma_ptc sigma x) lptc2 in 
            let flag = ref (subst_bf antecedent image_composition gamma) in
            flag:= !flag && (subst_bf lptc {at=(List.map 
                (fun t -> substitue sigma_prime t) at.at); lat= at.lat} gamma);
            List.iter (fun t -> flag:= !flag && (est_bf t gamma)) at1.at;
            let rec aux le lt = match le, lt with
                | [], [] -> ()
                | e::p, t::q -> 
                    flag:= !flag && 
                    (est_sous_type (type_expr e gamma tr) 
                           (substitue sigma (substitue sigma_prime t))  gamma); 
                                aux p q
                | _ -> raise 
                 (Typeur_error ("pas le bon nombre d'expressions", exp.le))
            in aux le (List.map (fun (s,t) -> t) (List.map (fun p -> p.p) lp));
            if !flag then substitue sigma (substitue sigma_prime t)
            else raise (Typeur_error ("un des types est mal form�", exp.le))
     
    | Enewidargexp (c,at,le) when (est_bf {t= Typ (c,at); lt= exp.le} gamma) ->
	        let cl = (Cmap.find c gamma.classes).classe in
		    let ltp = ltparam cl in  
            let lptc = ptc_of_class cl in 
            let sigma = sigma_of_listes lptc (at.at) in
            let rec aux ss lar l = match lar, l with
                | [], [] -> true
                | t::p, e::q -> (est_sous_type (type_expr e gamma tr) 
                                (substitue ss t) gamma)&&(aux ss p q)
                | _ -> raise 
                     (Typeur_error ("pas le bon nombre d'expressions", exp.le))
            in
            if aux sigma ltp le then {t= Typ (c,at); lt= exp.le}
            else raise (Typeur_error 
                   ("le type de l'expr ne correspond pas � la classe", exp.le))
    | Enewidargexp _ -> raise (Typeur_error ("le type est mal form�", exp.le)) 
    
    | Eneg e 
       when (type_expr e gamma tr).t = Typ("Boolean",{at= []; lat= l_empty}) ->
                {t= Typ("Boolean",{at= []; lat= l_empty}); lt= exp.le}
    | Eneg e -> raise 
            (Typeur_error ("Eneg attend une expression de type Boolean", e.le))
    
    | Emoins e 
          when (type_expr e gamma tr).t = Typ ("Int",{at= []; lat= l_empty}) ->
                {t= Typ("Int",{at= []; lat= l_empty}); lt= exp.le}
    | Emoins e -> raise 
              (Typeur_error ("Emoins attend une expression de type Int", e.le))
    
    | Eop (e1,o,e2) when List.mem o.o [Eq; Ne] -> 
            let t1 = type_expr e1 gamma tr and t2 = type_expr e2 gamma tr in
            if (est_sous_type t1 
                {t= Typ("AnyRef",{at= []; lat= l_empty}); lt= l_empty} gamma)&&
                 (est_sous_type t2 
                  {t= Typ("AnyRef",{at= []; lat= l_empty}); lt= l_empty} gamma)
                then {t= Typ("Boolean",{at= []; lat= l_empty}); lt= exp.le}
            else raise (Typeur_error 
                   ("le type de l'expr doit etre sous-type de AnyRef", exp.le))
    | Eop (e1,o,e2) when List.mem o.o [Dbleg; Diff; Inf; Infeg; Sup; Supeg] -> 
            let Typ (s1, _) = (type_expr e1 gamma tr).t 
            and Typ (s2, _) = (type_expr e2 gamma tr).t in
            if (s1 = "Int")&&(s2 = "Int")
                then {t= Typ("Boolean",{at= []; lat= l_empty}); lt= exp.le}
            else raise 
               (Typeur_error ("le type de l'expression doit etre Int", exp.le))
    | Eop (e1,o,e2) when List.mem o.o [Add; Sub; Mul; Div; Reste] -> 
            let Typ (s1, _) = (type_expr e1 gamma tr).t 
            and Typ (s2, _) = (type_expr e2 gamma tr).t in
            if (s1 = "Int")&&(s2 = "Int")
                then {t= Typ("Int",{at= []; lat= l_empty}); lt= exp.le}
            else raise 
               (Typeur_error ("le type de l'expression doit etre Int", exp.le))
    | Eop (e1,o,e2) -> 
            let Typ (s1, _) = (type_expr e1 gamma tr).t 
            and Typ (s2, _) = (type_expr e2 gamma tr).t in
            if (s1 = "Boolean")&&(s2 = "Boolean")
                then {t= Typ("Boolean",{at= []; lat= l_empty}); lt= exp.le}
            else raise (Typeur_error 
                         ("le type de l'expression doit etre Boolean", exp.le))
                       
    | Eif (e1,e2,e3) when (type_expr e1 gamma tr).t = 
                        Typ("Boolean",{at= []; lat= l_empty}) ->
            let t2 = type_expr e2 gamma tr and t3 = type_expr e3 gamma tr in
            if est_sous_type t2 t3 gamma then t3
            else if est_sous_type t3 t2 gamma then t2
                 else raise 
             (Typeur_error ("les types des expr ne correspondent pas", exp.le))
    | Eif (e1,_,_) -> raise (Typeur_error
                 ("Eif attend une premi�re expression de type Boolean", e1.le))
    
    | Ewhile (e1,e2) when (type_expr e1 gamma tr).t = 
                        Typ("Boolean",{at= []; lat= l_empty}) -> 
            if est_bf (type_expr e2 gamma tr) gamma 
                then {t= Typ("Unit",{at= []; lat= l_empty}); lt= exp.le}
            else raise (Typeur_error 
                    ("la deuxi�me expr de Ewhile n'est pas de type bf", e2.le))
    | Ewhile (e1,_) -> raise (Typeur_error 
                    ("Ewhile attend une premi�re expr de type Boolean", e1.le))
    
    | Ereturnvide ->
            if (tr<> None)&&(est_sous_type 
               {t= Typ("Unit",{at= []; lat= l_empty}); lt= l_empty} 
                                                     (typ_of_typ_ret tr) gamma)
                then {t= Typ("Nothing",{at= []; lat= l_empty}); lt= exp.le}
            else raise (Typeur_error 
               ("l'expression n'est pas de type un sous-type de unit", exp.le))
    | Ereturn e ->
            if (tr<>None)&&
               (est_sous_type (type_expr e gamma tr) (typ_of_typ_ret tr) gamma)
                then {t= Typ("Nothing",{at= []; lat= l_empty}); lt= exp.le}
            else raise (Typeur_error 
                       ("l'expr n'est pas de type un sous-type de tr", exp.le))
    
    | Eprint e when (match (type_expr e gamma tr).t with 
                        Typ ("String",{at= []; lat=_}) -> true |_ -> false) ->
                {t= Typ("Unit",{at= []; lat= l_empty}); lt= exp.le}
    | Eprint e when (match (type_expr e gamma tr).t with 
                        Typ ("Int",{at= []; lat=_}) -> true |_ -> false) -> 
                {t= Typ("Unit",{at= []; lat= l_empty}); lt= exp.le}
    | Eprint e -> raise (Typeur_error 
                  ("Eprint attend une expression de type Int ou String", e.le)) 
    
    | Ebloc {b=[]; lb=lb} -> 
            {t= Typ("Unit",{at= []; lat= l_empty}); lt= exp.le}
    | Ebloc {b=[{b1=Bvar v; lb1=lb1}]; lb=lb} ->
            let t = typ_of_var v in 
            let t2 = type_expr (exp_of_var v) gamma tr in
            if (est_bf t gamma)&&(est_sous_type t2 t gamma)
                then {t= Typ("Unit",{at= []; lat= l_empty}); lt= exp.le}
            else raise 
                    (Typeur_error ("pas un sous-type ou type mal form�", t.lt))
    | Ebloc {b=[{b1=Bexpr e; lb1=lb1}]; lb=lb} -> type_expr e gamma tr
    | Ebloc {b=({b1=(Bvar {v= (Vvar (x,t,e)); lv=lv}); lb1=lb1}::l); lb=lb} -> 
            if not(est_bf t gamma) 
                then raise (Typeur_error ("type mal form�", t.lt))
            else let tee = type_expr e gamma tr in
                 if not(est_sous_type tee t gamma) 
                    then raise 
                             (Typeur_error ("l'expr n'a pas le bon type",e.le))
                 else if (match t.t with 
                        Typ(ss,tt) when ss = "Any" -> true | _ -> false) then
                      type_expr ({e=Ebloc {b=l; lb=lb}; le=lb; 
                      te={t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}) 
                      {classes=gamma.classes; 
                      dec={dv=(Var (x,tee)); ldv=lv}::gamma.dec} tr
                    else 
                      type_expr ({e=Ebloc {b=l; lb=lb}; le=lb; 
                      te={t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}) 
                         {classes=gamma.classes; 
                                    dec={dv=(Var (x,t)); ldv=lv}::gamma.dec} tr
    
     | Ebloc {b=({b1=(Bvar {v= (Vval (x,t,e)); lv=lv}); lb1=lb1}::l); lb=lb} -> 
            if not(est_bf t gamma) 
                then raise (Typeur_error ("type mal form�", t.lt))
            else let tee = type_expr e gamma tr in
                 if not(est_sous_type tee t gamma) 
                    then raise 
                             (Typeur_error ("l'expr n'a pas le bon type",e.le))
                 else if (match t.t with 
                        Typ(ss,tt) when ss = "Any" -> true | _ -> false) then
                      type_expr ({e=Ebloc {b=l; lb=lb}; le=lb; 
                      te={t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}) 
                      {classes=gamma.classes; 
                      dec={dv=(Val (x,tee)); ldv=lv}::gamma.dec} tr
                    else 
                      type_expr ({e=Ebloc {b=l; lb=lb}; le=lb; 
                      te={t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}) 
                         {classes=gamma.classes; 
                                    dec={dv=(Val (x,t)); ldv=lv}::gamma.dec} tr
    | Ebloc {b=({b1=Bexpr e; lb1=lb1}::l); lb=lb} 
            when est_bf (type_expr e gamma tr) gamma ->
                type_expr {e= Ebloc {b=l; lb=lb}; le=lb; 
              te={t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}} gamma tr
    | Ebloc b  -> raise (Typeur_error ("probl�me dans Ebloc", b.lb))
in exp.te <- ttyp ;ttyp;;


(** Typage d'une classe **)

(** 1 **)

(* prend en argument un environnement gamma et un parametre de type pt. 
    cree la classe associee a pt ainsi que le type de la borne inf *)

let rec cree_classe_pt pt =
  match pt.pt with
        | Ptid(ident) -> ({c= (ident, [], [], 
                         {t= Typ("AnyRef",{at= []; lat= l_empty}); lt= pt.lpt},
    [], []); lc= pt.lpt},{t= Typ ("Null", {at= []; lat= l_empty}); lt= l_empty})
	    | Ptidoptyp(ident,o,t) when o.o = Inf -> ({c=(ident, [], [], t, [], []);
             lc=pt.lpt},{t= Typ ("Null", {at= []; lat= l_empty}); lt= l_empty})
	    | Ptidoptyp(ident,o,t) -> 
	               ({c=(ident, [], [], {t= Typ("AnyRef",{at= []; 
	                         lat= l_empty}); lt= pt.lpt}, [], []); lc=pt.lpt},t)

(* prend en argument un environnement gamma et un parametre de type de classe
    ptc, verifie si la borne est bien formee dans gamma et le cas echeant
    renvoie un environnement ou on a rajoute la classe du parametre de type *)
and ajout_classe_param_type gamma ptc =
    let pt = pt_of_ptc ptc in    
    let (cl,borne_inf) = cree_classe_pt pt in
    match pt.pt with
 	    | Ptid(_) -> ajoute_cl_env cl borne_inf gamma 
		| Ptidoptyp(_,_,t) -> 
		            if not(est_bf t gamma) 
		                then raise (Typeur_error ("type non bien forme", t.lt))
		            else ajoute_cl_env cl borne_inf gamma

(* creation de gamma prime a partir de gamma et d'une classe *)
and creation_gamma_prime gamma cl = 
    let gamma_prime = {classes = gamma.classes;dec = gamma.dec} in
	let l = ptc_of_class cl in 
	let rec aux g = function 
		| [] -> g 
		| ptc::q -> let g1,g2 = (ajout_classe_param_type g ptc) in aux g1 q
	in aux gamma_prime l;


(** 2 **)

(* il faut lorsque l'on rajoute les declarations de la classe pere *)
(* s assurer du changement de parametres de type dans les methodes *)

and substitue_dec_t sigma dec = let loc = dec.ld in match dec.d with 
  | Dvar(var) -> {d = Dvar(substitue_var_t sigma var); ld = loc}
  | Dmethode(methode) -> {d = Dmethode(substitue_methode_t sigma methode);
                                                                 ld = loc}
and substitue_var_t sigma var = let loc = var.lv in match var.v with
  | Vvar(str,t,e) -> {v = Vvar(str,substitue_typ_t sigma t,
                                       substitue_expr_t sigma e);lv = loc}
  | Vval(str,t,e) -> {v = Vval(str,substitue_typ_t sigma t,
                                       substitue_expr_t sigma e);lv = loc}
and substitue_methode_t sigma methode = let loc = methode.lm in 
    match methode.m with
  | Moverride(str,pt_li,p_li,t,exp) -> { m = Moverride(str,List.map 
                                (fun pt -> substitue_pt_t sigma pt) pt_li,
                           List.map (fun p -> substitue_p_t sigma p) p_li,
             substitue_typ_t sigma t,substitue_expr_t sigma exp);lm = loc}
  | Mdef(str,pt_li,p_li,t,exp) -> { m = Mdef(str,List.map 
                                (fun pt -> substitue_pt_t sigma pt) pt_li,
                           List.map (fun p -> substitue_p_t sigma p) p_li,
             substitue_typ_t sigma t,substitue_expr_t sigma exp);lm = loc}
and  substitue_p_t sigma p = let loc = p.lp in match p.p with   
    |(str,t) -> { p = (str,substitue_typ_t sigma t);lp = loc} 

and  substitue_pt_t sigma pt = let loc = pt.lpt in match pt.pt with
  | Ptid(str) -> pt
  | Ptidoptyp(str,o,t) -> 
                 {pt = Ptidoptyp(str,o,substitue_typ_t sigma t);lpt = loc}
and  substitue_typ_t sigma t = match t.t with  
    Typ(a,b) -> if Smap.mem a sigma then Smap.find a sigma 
                else t
and  substitue_at_t sigma at = let loc = at.lat in match at.at with  
     l -> { at = List.map (fun t -> substitue_typ_t sigma t) l; lat = loc}
and  substitue_expr_t sigma e = let loc = e.le and
                       ttt = substitue_typ_t sigma e.te in match e.e with  
  | Epar(exp) -> {e = Epar(substitue_expr_t sigma exp); le = loc; te = ttt}
  | Eacc(acc) -> {e = Eacc(substitue_acc_t sigma acc); le = loc;te = ttt}
  | Eaccexp(acc,exp) -> {e = Eaccexp(substitue_acc_t sigma acc,
                            substitue_expr_t sigma exp); le =loc;te = ttt}
  | Eaccargexp(acc,at,lle) -> {e = Eaccargexp(substitue_acc_t sigma acc,
                                                  substitue_at_t sigma at,
       List.map (fun ex -> substitue_expr_t sigma ex) lle);le = loc; te = ttt}
  | Enewidargexp(str,at,lle) -> {e = Enewidargexp(str,substitue_at_t sigma at,
       List.map (fun ex -> substitue_expr_t sigma ex) lle);le = loc; te = ttt}
  | Eneg(exp) -> {e = Eneg(substitue_expr_t sigma exp); le = loc; te = ttt}
  | Emoins(exp) -> {e = Emoins(substitue_expr_t sigma exp); le = loc; te = ttt}
  | Eop(exp1,o,exp2) -> {e = Eop(substitue_expr_t sigma exp1,o,substitue_expr_t
                                               sigma exp2); le = loc; te = ttt}
  | Eif(exp1,exp2,exp3) -> {e = Eif(substitue_expr_t sigma exp1,substitue_expr_t
                     sigma exp1,substitue_expr_t sigma exp3); le = loc; te = ttt}
  | Ewhile(exp1,exp2) -> {e = Ewhile(substitue_expr_t sigma exp1,substitue_expr_t
                                                 sigma exp2); le = loc; te = ttt}
  | Ereturn(exp) -> {e = Ereturn(substitue_expr_t sigma exp); le = loc; te = ttt} 
  | Eprint(exp) -> {e = Eprint(substitue_expr_t sigma exp); le = loc; te= ttt}
  | Ebloc(bll) -> {e = Ebloc(substitue_bloc_t sigma bll); le = loc; te = ttt}
  | _ -> e 
and  substitue_bl_t sigma bll = let loc = bll.lb1 in match bll.b1 with 
  |Bvar(v) -> {b1 = Bvar(substitue_var_t  sigma v); lb1 = loc}
  |Bexpr(exp) -> {b1 = Bexpr(substitue_expr_t sigma exp); lb1 = loc}
and substitue_bloc_t sigma b = let loc = b.lb and l = b.b in  
    {b = List.map (fun bl -> substitue_bl_t sigma bl) l;lb = loc}
and  substitue_acc_t sigma a = let loc = a.la in match a.a with 
  |Aexpid(exp,str) -> {a=Aexpid(substitue_expr_t sigma exp,str ) ;la = loc}
  |_ -> a

and substitue_declarations sigma l = 
    List.map (fun d -> substitue_dec_t sigma d) l



(* prend en argument une classe et un environnement et renvoie une classe 
    augmentee ou les methodes et champs sont ceux herites *)
and cree_classe_aug gamma gamma_prime cl borne_inf = 
	let nom_cl_pere,at_nouveau = pere_of_class cl gamma in
	let ca_pere = Cmap.find nom_cl_pere gamma.classes in 
    let lptc_ancien = ptc_of_class  (ca_pere.classe) in
    let sigma = sigma_of_listes lptc_ancien at_nouveau.at in
	let dec_of_father = substitue_declarations sigma (dec_of_class (ca_pere.classe)) in
    let dec_classe_aug_father = List.map 
(fun decvar -> (match decvar.dv with Val(s,t) -> {dv = Val(s,substitue_typ_t sigma t);ldv = decvar.ldv}
                                 |Var(s,t) ->{dv = Var(s,substitue_typ_t sigma t);ldv = decvar.ldv} )) 
(Envmap.find nom_cl_pere (!envmap)).dec
 in gamma_prime.dec <- dec_classe_aug_father; parcours_liste_dec_methode cl nom_cl_pere dec_of_father; 
	{classe = {c=(ident_of_class cl, ptc_of_class cl,param_of_class cl,
	        extends_of_class cl,exp_of_class cl,dec_of_father); lc=cl.lc};borneinf = borne_inf}
(* fonction qui parcourt une liste de declarations et qui met les methodes dans le menvmap*)
and parcours_liste_dec_methode cl nom_cl_pere = function
    |[] -> ()
    |l::q -> (match l.d with
    |Dvar(v) -> parcours_liste_dec_methode cl nom_cl_pere q
    |Dmethode(m) -> 
        let eee =  Smap.find (ident_of_m m) (MEnvmap.find nom_cl_pere (!menvmap)) in  
        menvmap := MEnvmap.add (ident_of_class cl) 
        (Smap.add (ident_of_m m) eee (MEnvmap.find (ident_of_class cl) (!menvmap))) 
                                                                        (!menvmap); 
        parcours_liste_dec_methode cl nom_cl_pere q)

(* rajoute la classe � gamma et a gamma prime*)
and rajoute_classe_env gamma gamma_prime cl borne_inf = 
    let t = extends_of_class cl in
	if not(est_bf t gamma_prime)
	    then raise (Typeur_error (" le type d'extends n'est pas bien forme ", cl.lc))
	else gamma.classes <- Cmap.add (ident_of_class cl) 
	                      (cree_classe_aug gamma gamma_prime cl borne_inf) gamma.classes;
        gamma_prime.classes <- Cmap.add (ident_of_class cl) 
	                       (cree_classe_aug gamma gamma_prime cl borne_inf) gamma_prime.classes


(** 3 **)

(* rajoute les differentes declarations de variable dans gamma prime *)
and ajout_decl_variables gamma_prime cl = 
	let name_cl = ident_of_class cl in
	let param_list = param_of_class cl in
	let dec_env = gamma_prime.dec in
	let rec verifie_bf_et_rajoute l = function
		| []-> l
		| (s,t)::q -> 
		        if not(est_bf t gamma_prime) 
		            then raise (Typeur_error ("type non bien forme",t.lt))
				else verifie_bf_et_rajoute ((Val(s,t))::l) q
    in 
    let l = verifie_bf_et_rajoute (List.map (fun d -> d.dv) dec_env) 
                                        (List.map (fun p -> p.p) param_list) in
    gamma_prime.dec <- 
        {dv=(Val("this",{t=Typ(name_cl,{at=List.map t_of_ptc (ptc_of_class cl);
                        lat=l_empty}); lt= l_empty})); ldv= l_empty}::
                                  (List.map (fun d -> {dv= d; ldv= l_empty}) l)


(** 4 **)

(** fonction pour debugger **)


(* On verifie que l'appel est legal *)
and verification_constructeur gamma_prime cl =
	let t = extends_of_class cl and l = exp_of_class cl in 
	let Typ(i,at) = t.t in  
	if not((type_expr {e=Enewidargexp (i,at,l); le= l_empty; 
	                   te={t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}} 
	                                                 gamma_prime None).t = t.t)
	    then raise (Typeur_error ("mauvaise formation du constructeur", t.lt))
	else ()


(** 5 **)

(* On prend une var, on trouve le type de l expression, on verifie 
    s il est donne que c est le meme et si ce type est bien form� 
    dans gamma_prime et on renvoie un type dec_var *)
(* var -> environnement -> dec_var *)
and verifications_dec_champ_1 v gamma_prime = 
	match v.v with 
	| Vvar(i,t,e) -> ( 
		(** changement on compare juste les types **)
		let t2 = type_expr e gamma_prime None in
		let Typ (id,_) = t.t in match id with
		| x when x = "Any" ->
		       (if est_bf t2 gamma_prime then {dv=Var(i,t2); ldv=v.lv}
				else raise (Typeur_error ("type non bien form�",v.lv)))
		| _ -> 
		       (if est_sous_type t2 t gamma_prime 
			        then (if est_bf t gamma_prime then {dv=Var(i,t); ldv=v.lv}
				          else raise 
				                   (Typeur_error ("type non bien forme",t.lt)))
                else raise 
                     (Typeur_error ("erreur de typage de l expression",e.le))))
	| Vval(i,t,e) -> (
		let t2 = type_expr e gamma_prime None in
		let Typ (id,_) = t.t in match id with
		| x when x = "Any" ->
		       (if est_bf t2 gamma_prime then {dv=Val(i,t2); ldv=v.lv}
				else raise (Typeur_error ("type non bien form�",v.lv)))
		| _ -> 
		       (if est_sous_type t2 t gamma_prime 
			        then (if est_bf t gamma_prime then {dv=Val(i,t); ldv=v.lv}
				          else raise 
				                   (Typeur_error ("type non bien forme",t.lt)))
			    else raise 
			         (Typeur_error ("erreur de typage de l expression",e.le))))

(* on rajoute la declaration a gamma prime et on rajoute la 
    declaration a la classe augmentee associee a la classe *)
and verification_dec_champ v cl gamma gamma_prime = 
	let dec_v = verifications_dec_champ_1 v gamma_prime in
	let nom_classe = ident_of_class cl in 
	begin
	gamma_prime.dec <- dec_v::gamma_prime.dec;
	let ca = Cmap.find nom_classe gamma_prime.classes in
    let (n,ptc,p,t,e,d) = ca.classe.c in 
    ca.classe <- 
               {c= (n,ptc,p,t,e,{d=Dvar(v); ld= l_empty}::d); lc= ca.classe.lc};
    let ca = Cmap.find nom_classe gamma.classes in
    let (n,ptc,p,t,e,d) = ca.classe.c in 
    ca.classe <- 
               {c= (n,ptc,p,t,e,{d=Dvar(v); ld= l_empty}::d); lc= ca.classe.lc}
	end


(** gestion des methodes **)

(* cree gamma seconde a partir de gamma prime et de methode *)
(* environnement -> methode -> environnement *)
and cree_gamma_prime2 cll gamma_prime m = 
    let c = ident_of_class cll in
    let mi = ident_of_m m in
	let ptliste = pt_of_m m in 
    let gamma_prime2 = {classes = gamma_prime.classes; dec = gamma_prime.dec} in
    menvmap := MEnvmap.add c (Smap.add mi gamma_prime2 (MEnvmap.find c (!menvmap))) (!menvmap);
	let rec aux g = function
		| [] -> g 
		| pt :: q -> let cl,binf = cree_classe_pt pt in  
    let g1,g2 = (ajoute_cl_env cl binf g ) in aux g1 q
	in aux gamma_prime2 ptliste

(* on verifie si les types de param et du type de retour sont biens formes*)
(* environnement -> methode -> unit *)
and param_type_retour_bf gamma_prime2 m = 
	let l = param_of_m m in 
	let rec aux = function 
		| [] -> ()
		| (s,t)::q ->
		        if not(est_bf t gamma_prime2) 
		            then raise
		                  (Typeur_error ("le type n est pas bien forme", t.lt))
		        else aux q
	in aux (List.map (fun p-> p.p) l);
	let t = t_of_m m in 
	if not(est_bf t gamma_prime2)
	    then raise (Typeur_error (" le type n est pas bien forme", t.lt))
	else ()

(* on rajoute la methode a C *)
(* classe -> methode -> environnement -> unit *)
and rajoute_methode cl m gamma gamma_prime = 
	let c = ident_of_class cl in
	let ca = Cmap.find c gamma_prime.classes in	match ca.classe.c with
	    | (n,ptc,p,t,e,d) -> (ca.classe <- 
	            {c=(n,ptc,p,t,e,{d=Dmethode(m); ld=m.lm}::d); lc=ca.classe.lc});
    let ca = Cmap.find c gamma.classes in	match ca.classe.c with
	    | (n,ptc,p,t,e,d) -> (ca.classe <- 
	            {c=(n,ptc,p,t,e,{d=Dmethode(m); ld=m.lm}::d); lc=ca.classe.lc})

(* On rajoute les declarations de type dans gamma prime prime�*)
(* methode -> environnement -> unit *)
and rajoute_declaration_type m gamma_prime2 =  
	let l = param_of_m m  in 
	let rec aux = function
		| [] -> ()
		| (s,t) :: q -> 
		            ((gamma_prime2.dec <- 
		                   ({dv=Val(s,t); ldv=t.lt}::gamma_prime2.dec)); aux q)
	in aux (List.map (fun p -> p.p) l)

(* methode -> environnement -> unit *)
(* methode -> environnement -> unit *)
and verification_expression m gamma_prime2 = (** probleme **)
	let e = exp_of_m m and t = t_of_m m in
	let t2 = type_expr e gamma_prime2 (Some t) in
	if not(est_sous_type t2 t gamma_prime2)
	    then raise 
	             (Typeur_error ("l expression n est pas un sous-type...",e.le))
	else ()

(* verifications effectuees jusqu'a maintenant sur les methodes,
   on renvoie l objet gamma_prime2 *)
(* classe -> methode -> environnement -> environnement *)
and verif_methode_intermediaire cl m gamma gamma_prime = 
	let gamma_prime2 = cree_gamma_prime2 cl gamma_prime m in
	begin
	param_type_retour_bf gamma_prime2 m;
	rajoute_methode cl m gamma gamma_prime;
	rajoute_declaration_type m gamma_prime2;
	verification_expression m gamma_prime2;
	end; gamma_prime2


(** verification du override **)

(* fonction qui prend en argument une methode et qui regarde si 
   elle a deja ete definie dans une superclasse. Si oui la renvoie. 
   On suppose que l'on a ajoute la methode a la classe *)
(* methode -> classe -> environnement -> methode *)
and methode_definie_precedemment m cl gamma_prime = 
	let nom_classe = ident_of_class cl in 
	let nom_methode = ident_of_m m in 
	let ca = Cmap.find nom_classe gamma_prime.classes in
	let l = List.tl (dec_of_class ca.classe) in 
	let rec aux = function
		| [] -> raise
		            (Typeur_error ("pas de telle methode definie avant", m.lm))
		| (Dmethode m2)::q -> let nom_m2 = ident_of_m m2 in 
		                             if nom_methode = nom_m2 then m2 else aux q
		| t::q -> aux q
	in aux (List.map (fun d-> d.d) l)

(*fonction qui verifie que la methode n a pas ete definie avant*)
(* methode -> classe -> environnement -> () *)
and methode_non_definie_precedemment m cl gamma_prime = 
	let nom_classe = ident_of_class cl in 
	let nom_methode = ident_of_m m in 
	let ca = Cmap.find nom_classe gamma_prime.classes in
	let l = List.tl (dec_of_class ca.classe) in 
	let rec aux = function
		| [] -> ()
		| (Dmethode m2)::q -> 
		        let nom_m2 = ident_of_m m2 in 
		        if nom_methode = nom_m2 
		            then raise 
		                   (Typeur_error ("cette methode a ete definie", m.lm))
		        else aux q
		| t::q -> aux q
	in aux (List.map (fun d -> d.d) l)

(* on suppose que la methode m est un override de la methode m0 
   on veut creer la substitution des parametres de type de m par ceux de m0
   puis l appliquer pour verifier que tout le monde est bien defini *)
and sigma_meth m m0 = 
	let l = pt_of_m m  and l0 = pt_of_m m0 in 
	sigma_of_listes (List.map (fun pt -> {ptc= Ptc pt; lptc= pt.lpt}) l) 
	                    (List.map (fun pt -> {t= Typ(id_of_pt pt, {at= []; 
	                                            lat= l_empty}); lt=pt.lpt}) l0)

(* verification du fait que les parametres de la methode m sont de meme type
   que ceux de m0 a redefinition des parametres pres et que le type de sortie
   de l'override est un sous-type de la methode initiale *)
(* methode -> methode -> environnement -> unit *)
and comparaison_parametres_methodes m m0 gamma_prime2 = 
	let l = param_of_m m and l0 = param_of_m m0 in 
	let sigma = sigma_meth m0 m in  
	let t = t_of_m m and t0 = t_of_m m0 in 
    if not(est_sous_type t (substitue sigma t0) gamma_prime2) 
	    then raise 
	      (Typeur_error 
("override: le type de sortie ne correspond pas � celui de la super-m�thode", 
                                                                         m.lm))
	      (* ie ce n'est pas un sous-type de celui de m0 *)
	else 
	let rec aux = function
		| [],[] -> ()
		| (s,ty)::q, (s0,ty0)::q0 -> 
		        if  not((substitue sigma ty0).t = ty.t)
					then raise (Typeur_error
("override: les parametres n'ont pas le meme type que dans la super-m�thode", 
                                                                         m.lm))
			    else ()
		| _ -> raise(Typeur_error ("override: pas le meme nombre de parametres", 
		                                                                 m.lm))
	in aux (List.map (fun p -> p.p) l, List.map (fun p -> p.p) l0)

(* methode -> methode -> unit *)
and comparaison_bornes_methodes m m0 = 
	let l = pt_of_m m and l0 = pt_of_m m0 in 
	let rec aux = function
		| [], [] -> ()
		| Ptid(i)::q, Ptid(i0)::q0 -> aux (q,q0)
		| Ptidoptyp(i,o,t)::q, Ptidoptyp(i0,o0,t0)::q0 ->
		        if not(o.o = o0.o) || not(t.t = t0.t)
		            then raise 
		                (Typeur_error 
		                  ("override: les bornes ne sont pas les memes", m.lm))
		        else aux (q,q0)
		| aaa::q,ccc::q0 -> aux (q,q0) 
        | _ -> raise (Typeur_error("Il n'y a pas le m�me nommbre de
                                         parametres de types",m.lm)) 
	in aux (List.map (fun pt -> pt.pt) l, List.map (fun pt -> pt.pt) l0) 

(* verifie que l override est correctement utilise *)
(* environnement -> environnement -> classe -> methode -> unit *)
and verif_override gamma_prime gamma_prime2 cl m = 
	match m.m with 
	| Moverride(_) ->
	        let m0 = methode_definie_precedemment m cl gamma_prime in 
			comparaison_parametres_methodes m m0 gamma_prime2; 
			comparaison_bornes_methodes m m0
	| Mdef(_) -> methode_non_definie_precedemment m cl gamma_prime


(** verification que la methode est bien definie **)

(* classe -> methode -> environnement -> unit*)
and verif_methode cl m gamma gamma_prime =
    let gamma_prime2 = verif_methode_intermediaire cl m gamma gamma_prime in 
    verif_override gamma_prime gamma_prime2 cl m;


(** verification des d�clarations dans gamma_prime **)

(* classe -> environnement -> unit *)
and verif_dec cl gamma gamma_prime = 
	let l = dec_of_class cl in
	let rec aux = function
		| [] -> ()
		| d::q -> (
			match d.d with 
			| Dvar(v) -> verification_dec_champ v cl gamma gamma_prime; aux q
			| Dmethode(m) -> let envmapprec = (!envmap) in 
                             verif_methode cl m gamma gamma_prime;
                            (* on fait cela pour eviter aue l introduction de parametres de type
                            de la methode change une autre classe de meme nom *)
                             envmap:= Envmap.add (ident_of_class cl) 
                            (Envmap.find (ident_of_class cl) (!envmap)) envmapprec;   
                             aux q
			)
	in aux l


(** Ajout d'une nouvelle classe dans l environnement gamma **)

and ajoute_cl_env cl borne_inf gamma = 
	let gamma_prime = creation_gamma_prime gamma cl in 
    begin
    let c = ident_of_class cl in menvmap := MEnvmap.add c (Smap.empty) (!menvmap);
    envmap := Envmap.add (ident_of_class cl) gamma_prime (!envmap);
	rajoute_classe_env gamma gamma_prime cl borne_inf; 
	ajout_decl_variables gamma_prime cl; 
	verification_constructeur gamma_prime cl; 
	verif_dec cl gamma gamma_prime; 
	end; (gamma,gamma_prime)


(** typage de la classe main  **)

(* on cree la classe array *)
(* unit -> classe *)
let cree_array () = {c= ("Array" , [{ptc= Ptc({pt= Ptid("X"); lpt= l_empty}); 
            lptc= l_empty}] , [] , {t= Typ("AnyRef",{at= []; lat= l_empty}); 
                                          lt= l_empty} , [] , []); lc= l_empty}

let cree_main classe_main = {c= ("Main", [],[],{t= Typ("AnyRef",{at= []; 
                     lat= l_empty}); lt= l_empty},[],classe_main); lc= l_empty}


let est_present_param_important = function
    |[] -> false
    |p::q -> let (s,t) = p.p in (match t with 
           |{t= Typ("Array",{at= [{t= Typ("String",_); lt= _}]; lat= _}); lt= _}
                                                                         -> true
           |_  -> false)
  
let vm classe_main = 
	let rec aux = function
		| [] -> false 
		| Dmethode({m= Mdef("main", [],lp, 
		        {t= Typ("Unit",_); lt= _}, _);lm= _})::q
            -> est_present_param_important lp
		| t::q -> aux q 
	in aux (List.map (fun d -> d.d) classe_main.cM)


(** verification de la variance A DEBUGGER **)

(* fonction qui verifie si T n est pas dans le type tau
   (renvoie true si pas dans le type tau) *)
(* string -> typ -> bool *)
let verifie_absence t tau = 
	let Typ(i,at) = tau.t in 
	let rec aux = function
		| [] -> true
		| {t= Typ(i0,at0);  lt= _}::q -> if i0 = t then false else (aux at0.at) && (aux q)
	in (aux at.at)&& (not(t=i))

(* methode -> typ list, donne la liste des types des parametres *)
let ltparam2 m =
    let l = param_of_m m in 
	let rec aux = function
		| [] -> []
		| (a,b)::q -> b::aux q
	in aux (List.map (fun p -> p.p) l)

(* derniere_pos : -1 si negative, 1 si positive *)
(* string -> int -> int -> typ -> environnement -> unit *)
let rec verifie_pos_typ t derniere_pos pos_voulue tau gamma = 
	let Typ(i,at) = tau.t in 
	begin 
	if (t = i)&&(derniere_pos * pos_voulue = -1) 
	    then raise (Typeur_error ("position_foireuse", tau.lt))
	else (); 
	let cl = (Cmap.find i gamma.classes).classe in 
	let lptc = ptc_of_class cl in
	let rec aux = function
		| [], []-> ()
		| t0::q, {ptc= Ptc(_); lptc= _}::p ->
		        if not(verifie_absence t t0) 
					    then raise 
					    (Typeur_error ("type signe en position neutre", t0.lt))
				else aux (q,p)
		| t0::q, {ptc= Ptcplus(_); lptc= _}::p -> 
		        verifie_pos_typ t derniere_pos pos_voulue t0 gamma;
		        aux (q,p)
		| t0::q, {ptc= Ptcmoins(_); lptc= _}::p -> 
		       verifie_pos_typ t (-derniere_pos) pos_voulue t0 gamma;
		       aux (q,p)
		| _ -> raise 
		        (Typeur_error ("erreur: pas le meme nombre de pt que de types",
		                                                                cl.lc))
	in aux (at.at,lptc) 
	end

let verifie_variance_classe_un t pos_voulue cl gamma_prime =
	let lptc = ptc_of_class cl and ldec = dec_of_class cl in
	let rec traite_bornes = function
		| [] -> ()
		| ptc:: q -> 
		        let pt = pt_of_ptc ptc in (match pt.pt with 
				    | Ptid(_) -> traite_bornes q
				    | Ptidoptyp (_,{o= Sup; lo= _},tau) ->
				            verifie_pos_typ t (-1) pos_voulue tau gamma_prime;
				            traite_bornes q
				    | Ptidoptyp (_,{o= Inf; lo= _},tau) ->
				            verifie_pos_typ t 1 pos_voulue tau gamma_prime;
				            traite_bornes q
				    | _ -> raise (Typeur_error 
				               ("cas inutile dans verifie_variance", l_empty)))
	in let rec traite_dec = function
		| [] -> ()
		| Dvar({v= Vvar(_,tau,_); lv= _})::q -> 
		        if not (verifie_absence t tau)
			        then raise (Typeur_error
			                         ("type signe en position neutre", tau.lt))
			    else traite_dec q 
		| Dvar({v= Vval(_,tau,_); lv= _})::q -> 
		        verifie_pos_typ t 1 pos_voulue tau gamma_prime;
		        traite_dec q
		| Dmethode(m)::q -> let gamma_prime_2 = (Smap.find (ident_of_m m) (MEnvmap.find (ident_of_class cl) (!menvmap))) in
		       (let tau = t_of_m m in 
		        verifie_pos_typ t 1 pos_voulue tau gamma_prime_2; 
				(let l = ltparam2 m in
				let rec aux = function
				    | [] -> ()
					| tau2::q2 -> 
					        verifie_pos_typ t (-1) pos_voulue tau2 gamma_prime_2;
					        aux q2
				in aux l; traite_dec q);
                let l2 = pt_of_m m in 
                (let rec auxxx = function
                    |[] -> ()
                    |pt :: q -> (match pt.pt with 
				    | Ptid(_) -> auxxx q
				    | Ptidoptyp (_,{o= Sup; lo= _},tau) ->
				            verifie_pos_typ t (1) pos_voulue tau gamma_prime;
				            auxxx q
				    | Ptidoptyp (_,{o= Inf; lo= _},tau) ->
				            verifie_pos_typ t (-1) pos_voulue tau gamma_prime;
				            auxxx q
				    | _ -> raise (Typeur_error 
				               ("cas inutile dans verifie_variance", l_empty)))
            
	                in auxxx l2)) in 
	traite_bornes lptc; 
	traite_dec (List.map (fun d -> d.d) ldec);
	verifie_pos_typ t 1 pos_voulue (extends_of_class cl) gamma_prime

(* classe -> environnement -> ()*)
let verifie_variance_classe cl gamma_prime = 
	let lptc = ptc_of_class cl in
	let rec aux = function 
	| [] -> ()
	| Ptc(_)::q -> aux q 
	| Ptcplus(pt)::q -> 
	            verifie_variance_classe_un (id_of_pt pt) 1 cl gamma_prime;
	            aux q
	| Ptcmoins(pt)::q ->
	            verifie_variance_classe_un (id_of_pt pt) (-1) cl gamma_prime;
	            aux q
	in aux (List.map (fun ptc -> ptc.ptc) lptc)



(** Verification de l unicite **)
	



 

(* classe list -> unit *)
let verif_unicite_classe classe_list = 
	let rec aux = function
		| [] -> []
		| cl :: q -> (ident_of_class cl)::aux q
	in let ln = aux classe_list in pas_de_doublons ln l_empty

(* classe -> unit *)
let verif_unicite_param_type classe = 
	let rec conversion_param_type_classe_ident = function
		| [] -> [] 
		| ptc :: q -> id_of_ptc ptc :: conversion_param_type_classe_ident q 
	in let rec conversion_param_type_ident = function
		| [] -> [] 
		| pt :: q0 -> id_of_pt pt :: conversion_param_type_ident q0
	in let l = ptc_of_class classe in 
	pas_de_doublons (conversion_param_type_classe_ident l) classe.lc; 
	let rec partie_methode = function
		| [] -> ()
		| {d= Dmethode(m); ld= _}::q1 -> 
		        let l1 = pt_of_m m in 
                pas_de_doublons (conversion_param_type_ident l1) classe.lc;
                partie_methode q1
		| t1::q1 -> partie_methode q1
	in partie_methode (dec_of_class classe)

let rec param_ident = function
	(* parametre list -> string list *)	
	| [] -> []
	| {p= (a,b); lp= _}::q -> a:: param_ident q

let verifie_unicite_param classe = 
	(* classe -> unit *)
	let l = param_of_class classe in 
	pas_de_doublons (param_ident l) classe.lc;
	let rec partie_methode = function
		| [] -> ()
		| {d= Dmethode(m); ld= _}::q1 -> let l1 = param_of_m m in
                            pas_de_doublons (param_ident l1) classe.lc;
                            partie_methode q1
		| t1::q1 -> partie_methode q1
	in partie_methode (dec_of_class classe)

let verifie_unicite_champs classe = 
	let l = param_ident (param_of_class classe) in 
	let rec creation_liste_ident_champ = function
		| [] -> [] 
		| {d= Dvar(v); ld= _}::q -> id_of_var v :: creation_liste_ident_champ q
		| t::q -> creation_liste_ident_champ q
	in let l2 = creation_liste_ident_champ (dec_of_class classe) in 
	pas_de_doublons (List.append l l2) classe.lc

let verifie_unicite_nom_methodes classe = 
	let rec creation_liste_ident_methode = function
		| [] -> [] 
		| {d= Dmethode(m); ld= _}::q ->
		                         ident_of_m m :: creation_liste_ident_methode q
		| t::q -> creation_liste_ident_methode q
	in pas_de_doublons (creation_liste_ident_methode 
	                                           (dec_of_class classe)) classe.lc


let verif_heritage classe classe_liste = 
(* classe -> classe_list -> unit verifie 
    que les heritages sont dans classe list*)
	let tau = extends_of_class classe in
	let Typ(i,at) = tau.t in 
	if  List.mem i ["Any";"AnyVal"; "Unit"; "Int"; "Boolean" ; "String"; 
	                                                         "Null"; "Nothing"]
	then raise (Typeur_error ("herite d'un type interdit", classe.lc))
	else let rec trouve = function
            | [] -> raise (Typeur_error 
           ("le type dont herite la classe n'est pas defini avant", classe.lc))
            | cl::q -> if ident_of_class cl = i then () else trouve q
    in trouve classe_liste



(** Typage du fichier **)
    
let new_gamma () =
    let g = {classes = Cmap.empty; dec = []} in
    g.classes <- Cmap.add "Nothing" {classe= {c= ("Nothing",[],[],
    {t= Typ ("Null",{at= []; lat= l_empty}); lt= l_empty},[],[]); lc= l_empty};
            borneinf= {t=Typ ("Nothing",{at= []; lat= l_empty}); lt= l_empty}} 
                                                                     g.classes;
    g.classes <- Cmap.add "Null" {classe= {c= ("Null",[],[], {t= Typ ("String",
                    {at= []; lat= l_empty}); lt= l_empty},[],[]); lc= l_empty};
             borneinf= {t=Typ ("Nothing",{at= []; lat= l_empty}); lt= l_empty}}
                                                                     g.classes;
    g.classes <- Cmap.add "String" {classe= {c= ("String",[],[],
    {t= Typ ("AnyRef",{at= []; lat= l_empty}); lt= l_empty},[],[]); 
            lc= l_empty}; borneinf= {t=Typ ("Nothing",{at= []; lat= l_empty});
                                                       lt= l_empty}} g.classes;
    g.classes <- Cmap.add "AnyRef" {classe= {c= ("AnyRef",[],[],
    {t= Typ ("Any",{at= []; lat= l_empty}); lt= l_empty},[],[]); lc= l_empty}; 
            borneinf= {t=Typ ("Nothing",{at= []; lat= l_empty}); lt= l_empty}} 
                                                                     g.classes;
    g.classes <- Cmap.add "Unit" {classe= {c= ("Unit",[],[],
               {t= Typ ("AnyVal",{at= []; lat= l_empty}); lt= l_empty},[],[]); 
                            lc= l_empty}; borneinf= {t=Typ ("Nothing",{at= [];
                                       lat= l_empty}); lt= l_empty}} g.classes;
    g.classes <- Cmap.add "Int" {classe= {c= ("Int",[],[],
               {t= Typ ("AnyVal",{at= []; lat= l_empty}); lt= l_empty},[],[]);
                            lc= l_empty}; borneinf= {t=Typ ("Nothing",{at= [];
                                      lat= l_empty}); lt= l_empty}} g.classes;
    g.classes <- Cmap.add "Boolean" {classe= {c= ("Boolean",[],[],
               {t= Typ ("AnyVal",{at= []; lat= l_empty}); lt= l_empty},[],[]);
                             lc= l_empty}; borneinf= {t=Typ ("Nothing",{at= [];
                                       lat= l_empty}); lt= l_empty}} g.classes;
    g.classes <- Cmap.add "AnyVal" {classe= {c= ("AnyVal",[],[],
               {t= Typ ("Any",{at= []; lat= l_empty}); lt= l_empty},[],[]);
                             lc= l_empty}; borneinf= {t=Typ ("Nothing",{at= [];
                                       lat= l_empty}); lt= l_empty}} g.classes;
    g.classes <- Cmap.add "Any" {classe= {c= ("Any",[],[],
               {t= Typ ("Any",{at= []; lat= l_empty}); lt= l_empty},[],[]);
                             lc= l_empty}; borneinf= {t=Typ ("Nothing",{at= [];
                                       lat= l_empty}); lt= l_empty}} g.classes;
    g


(* ajoute les classes a envmap ainsi que les methodes a menvmap*)

let ajout_total () =  
    envmap := Envmap.add "Nothing"
    {classes = (Cmap.add "Nothing" {classe= {c= ("Nothing",[],[],
    {t= Typ ("Null",{at= []; lat= l_empty}); lt= l_empty},[],[]); lc= l_empty};
            borneinf= {t=Typ ("Nothing",{at= []; lat= l_empty}); lt= l_empty}} Cmap.empty);
    dec = []} (!envmap);
    menvmap := MEnvmap.add "Nothing" (Smap.empty) (!menvmap); 
    envmap := Envmap.add "Null" 
    {classes = (Cmap.add "Null" {classe= {c= ("Null",[],[], {t= Typ ("String",
                    {at= []; lat= l_empty}); lt= l_empty},[],[]); lc= l_empty};
             borneinf= {t=Typ ("Nothing",{at= []; lat= l_empty}); lt= l_empty}} Cmap.empty);
    dec = []} (!envmap);
    menvmap := MEnvmap.add "Null" (Smap.empty) (!menvmap);
    envmap := Envmap.add "String"
    {classes = (Cmap.add "String" {classe= {c= ("String",[],[],
    {t= Typ ("AnyRef",{at= []; lat= l_empty}); lt= l_empty},[],[]); 
            lc= l_empty}; borneinf= {t=Typ ("Nothing",{at= []; lat= l_empty});
                                                       lt= l_empty}} Cmap.empty);
    dec = []} (!envmap);
    menvmap := MEnvmap.add "String" (Smap.empty) (!menvmap);
        envmap := Envmap.add "AnyRef"
    {classes = (Cmap.add "AnyRef" {classe= {c= ("AnyRef",[],[],
    {t= Typ ("Any",{at= []; lat= l_empty}); lt= l_empty},[],[]); lc= l_empty}; 
            borneinf= {t=Typ ("Nothing",{at= []; lat= l_empty}); lt= l_empty}}  Cmap.empty);
    dec = []} (!envmap);
    menvmap := MEnvmap.add "AnyRef" (Smap.empty) (!menvmap) ;
        envmap := Envmap.add "Unit"
    {classes = (Cmap.add "Unit" {classe= {c= ("Unit",[],[],
               {t= Typ ("AnyVal",{at= []; lat= l_empty}); lt= l_empty},[],[]); 
                            lc= l_empty}; borneinf= {t=Typ ("Nothing",{at= [];
                                       lat= l_empty}); lt= l_empty}} Cmap.empty);
    dec = []} (!envmap);
    menvmap := MEnvmap.add "Unit" (Smap.empty) (!menvmap) ;
        envmap := Envmap.add "Int"
    {classes = (Cmap.add "Int" {classe= {c= ("Int",[],[],
               {t= Typ ("AnyVal",{at= []; lat= l_empty}); lt= l_empty},[],[]);
                            lc= l_empty}; borneinf= {t=Typ ("Nothing",{at= [];
                                      lat= l_empty}); lt= l_empty}} Cmap.empty);
    dec = []} (!envmap);
    menvmap := MEnvmap.add "Int" (Smap.empty) (!menvmap) ;
        envmap := Envmap.add "Boolean"
    {classes = ( Cmap.add "Boolean" {classe= {c= ("Boolean",[],[],
               {t= Typ ("AnyVal",{at= []; lat= l_empty}); lt= l_empty},[],[]);
                             lc= l_empty}; borneinf= {t=Typ ("Nothing",{at= [];
                                       lat= l_empty}); lt= l_empty}} Cmap.empty);
    dec = []} (!envmap);
    menvmap := MEnvmap.add "Boolean" (Smap.empty) (!menvmap) ;
        envmap := Envmap.add "AnyVal"
    {classes = ( Cmap.add "AnyVal" {classe= {c= ("AnyVal",[],[],
               {t= Typ ("Any",{at= []; lat= l_empty}); lt= l_empty},[],[]);
                             lc= l_empty}; borneinf= {t=Typ ("Nothing",{at= [];
                                       lat= l_empty}); lt= l_empty}} Cmap.empty);
    dec = []} (!envmap);
    menvmap := MEnvmap.add "AnyVal" (Smap.empty) (!menvmap) ;    
        envmap := Envmap.add "Any"
    {classes = (Cmap.add "Any" {classe= {c= ("Any",[],[],
               {t= Typ ("Any",{at= []; lat= l_empty}); lt= l_empty},[],[]);
                             lc= l_empty}; borneinf= {t=Typ ("Nothing",{at= [];
                                       lat= l_empty}); lt= l_empty}} Cmap.empty);
    dec = []} (!envmap);
    menvmap := MEnvmap.add "Any" (Smap.empty) (!menvmap)




let liste_initiale_classe () = 
    [{c= ("Nothing",[],[], {t= Typ ("Null",{at= []; lat= l_empty}); 
                lt= l_empty},[],[]); lc= l_empty};
    {c= ("Null",[],[], {t= Typ ("String",{at= []; lat= l_empty}); 
                lt= l_empty},[],[]); lc= l_empty};
    {c= ("String",[],[], {t= Typ ("AnyRef",{at= []; lat= l_empty}); 
                lt= l_empty},[],[]); lc= l_empty};
    {c= ("AnyRef",[],[], {t= Typ ("Any",{at= []; lat= l_empty}); 
                lt= l_empty},[],[]); lc= l_empty};
    {c= ("Unit",[],[], {t= Typ ("AnyVal",{at= []; lat= l_empty});
                lt= l_empty},[],[]); lc= l_empty};
    {c= ("Int",[],[], {t= Typ ("AnyVal",{at= []; lat= l_empty}); 
                lt= l_empty},[],[]); lc= l_empty};
    {c= ("Boolean",[],[], {t= Typ ("AnyVal",{at= []; lat= l_empty}); 
                lt= l_empty},[],[]); lc= l_empty};
    {c= ("AnyVal",[],[], {t= Typ ("Any",{at= []; lat= l_empty});
                lt= l_empty},[],[]); lc= l_empty};
    {c= ("Any",[],[], {t= Typ ("Any",{at= []; lat= l_empty}); 
                lt= l_empty},[],[]); lc= l_empty}]


let verif_heritage_class_list class_list = 
    let l = liste_initiale_classe () in
    let rec aux l0 = function  
        | [] -> ()
        | cl::q ->  verif_heritage cl l0; aux (cl::l0) q
    in aux l class_list



let est_bien_type fichier = 
    try (** solution provisoire **)
	let gamma = new_gamma () in
    ajout_total ();
	let (l, m) = fichier.f in 
	verif_unicite_classe l;
	verif_heritage_class_list l;
	let rec aux g = function
			| [] -> g
			| cl::q -> 
                     let envmapprec = (!envmap) in
                    let menvmapprec = (!menvmap) in
			         let g2,gp = (ajoute_cl_env cl{t= Typ ("Null", {at= []; lat= l_empty}); lt= l_empty} g) in 
                    envmap := Envmap.add (ident_of_class cl) gp envmapprec;
                    (* ajout des methodes : on fait cela pour que ce qui se passe au s
                      ein des classes (pt) n influence pas le truc globalement *)
                    menvmap := MEnvmap.add (ident_of_class cl) 
                    (MEnvmap.find (ident_of_class cl) (!menvmap)) menvmapprec;
			    verifie_variance_classe cl (Envmap.find (ident_of_class cl) (!envmap));  
				verif_unicite_param_type cl;
				verifie_unicite_param cl;
				verifie_unicite_champs cl;
				verifie_unicite_nom_methodes cl;
				aux g2 q
	in let gamma_2 = aux gamma l in
    let envmapprec2 = (!envmap) in
    let menvmapprec2 = (!menvmap) in
	let gamma_3,gp3 = ajoute_cl_env (cree_array ()) {t= Typ ("Null", {at= []; lat= l_empty}); lt= l_empty}  gamma_2 in
    envmap := Envmap.add (ident_of_class (cree_array ())) gp3 envmapprec2;
    menvmap := MEnvmap.add (ident_of_class (cree_array ())) 
    (MEnvmap.find (ident_of_class (cree_array ())) (!menvmap)) menvmapprec2;
	let cl2 = cree_main m.cM in 
	verif_unicite_param_type cl2;
	verifie_unicite_param cl2;
	verifie_unicite_champs cl2 ;
	verifie_unicite_nom_methodes cl2;
    let envmapprec3 = (!envmap) in
    let menvmapprec3 = (!menvmap) in
	let _,gp4 = ajoute_cl_env cl2 {t= Typ ("Null", {at= []; lat= l_empty}); lt= l_empty} gamma_3 in 
    envmap := Envmap.add (ident_of_class cl2) gp4 envmapprec3;
    menvmap := MEnvmap.add (ident_of_class cl2) 
    (MEnvmap.find (ident_of_class cl2) (!menvmap)) menvmapprec3;
    let t = vm m in if t then () 
		else raise
		       (Typeur_error ("la methode main n'est pas bien definie", m.lcM))
    with Not_found -> raise (Typeur_error(" il a eu un appel a quelque chose de non defini",l_empty))
