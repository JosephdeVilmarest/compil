(* Syntaxe abstraite pour Petit Scala *)

type posit = Lexing.position
and loc = posit * posit

(* les types _sl sont les types sans localisation *)

and fichier_sl = (classe list) * classe_Main
and fichier = {f: fichier_sl; lf: loc}

and classe_sl = string * (param_typ_classe list) * (parametre list) * typ *
                                                      (expr list) * (decl list)
and classe = {c: classe_sl; lc: loc}

and decl_sl =
  | Dvar of var
  | Dmethode of methode
and decl = {d: decl_sl; ld:loc}

and var_sl =
  | Vvar of string * typ * expr
  | Vval of string * typ * expr
and var = {v: var_sl; lv:loc}

and methode_sl =
  | Moverride of string * (param_typ list) * (parametre list) * typ * expr
  | Mdef of string * (param_typ list) * (parametre list) * typ * expr
and methode = {m: methode_sl; lm:loc}

and parametre_sl = string * typ
and parametre = {p: parametre_sl; lp:loc}

and param_typ_sl =
  | Ptid of string
  | Ptidoptyp of string * oper * typ
and param_typ = {pt: param_typ_sl; lpt:loc}

and param_typ_classe_sl =
  | Ptc of param_typ
  | Ptcplus of param_typ
  | Ptcmoins of param_typ
and param_typ_classe = {ptc: param_typ_classe_sl; lptc:loc}

and typ_sl = Typ of string * arguments_typ
and typ = {t:typ_sl; lt:loc}

and arguments_typ_sl = typ list
and arguments_typ = {at: arguments_typ_sl; lat:loc}

and classe_Main_sl = decl list
and classe_Main = {cM: classe_Main_sl; lcM:loc}

and expr_sl =
  | Eentier of int
  | Echaine of string
  | Ebool of bool
  | Eunit
  | Ethis
  | Enull
  | Epar of expr
  | Eacc of acces
  | Eaccexp of acces * expr
  | Eaccargexp of acces * arguments_typ * (expr list)
  | Enewidargexp of string * arguments_typ * (expr list)
  | Eneg of expr
  | Emoins of expr
  | Eop of expr * oper * expr
  | Eif of expr * expr * expr
  | Ewhile of expr * expr
  | Ereturnvide
  | Ereturn of expr
  | Eprint of expr
  | Ebloc of bloc
and expr = {e: expr_sl; le:loc; mutable te:typ}
(** on a rendu le truc mutable pour modifier le type **)
and bl_sl =
  | Bvar of var
  | Bexpr of expr
and bl = {b1: bl_sl; lb1:loc}
and bloc_sl = bl list
and bloc = {b: bloc_sl; lb:loc}

and oper_sl = Eq | Ne | Dbleg | Diff | Inf | Infeg | Sup | Supeg | Add | Sub |
                Mul | Div | Reste | Et | Ou
and oper = {o: oper_sl; lo:loc}

and acces_sl =
  | Aid of string
  | Aexpid of expr * string
and acces = {a: acces_sl; la:loc}
