%{
  open Ast
  open Lexing
  let l_empty = ({pos_fname = ""; pos_lnum = 0; pos_bol = 0; pos_cnum = 0}, 
                     {pos_fname = ""; pos_lnum = 0; pos_bol = 0; pos_cnum = 0})
  
%}

/* Déclaration des tokens */

%token EOF
%token Tadd Tsub Tmul Tdiv Treste
%token Tdbleg Tdiff Tinf Tinfeg Tsup Tsupeg Tet Tou
%token Tlpar Trpar Tlcr Trcr Tlbr Trbr
%token Tclass Tdef Telse Teq Textends Tif Tmain Tne Tnew Tnull Tobject
%token Toverride Tprint Treturn Tthis Tval Tvar Twhile
%token <int> Tentier
%token <string> Tchaine
%token <bool> Tbool
%token <string> Tident
%token Tpoint Tegal Tneg
%token Tvirg Tpvirg Tdp

/* Priorités et associativités des tokens */

%nonassoc Tif
%nonassoc Telse
%nonassoc Twhile Treturn
%right Tegal
%left Tou
%left Tet
%left Teq Tne Tdbleg Tdiff
%left Tsup Tsupeg Tinf Tinfeg
%left Tadd Tsub
%left Tmul Tdiv Treste
%right moins Tneg
%left Tpoint

/* Point d'entrée de la grammaire */
%start fic


/* Type des valeurs renvoyées par l'analyseur syntaxique */
%type <Ast.fichier> fic

%%

/* Règles de grammaire */

fic:
  l1=cl*; l2=cl_Main; EOF {{f= (l1,l2); lf= ($startpos, $endpos)}}
;
cl:
  | Tclass; i=Tident; Tlbr; ld=separated_list (Tpvirg, dec); Trbr
        {{c= (i,[],[],{t= Typ ("AnyRef",{at= []; lat= l_empty});lt= l_empty},
                                             [],ld); lc= ($startpos, $endpos)}}
  | Tclass; i=Tident; Tlcr; lptc=separated_nonempty_list (Tvirg, par_ty_cl); 
                              Trcr; Tlbr; ld=separated_list (Tpvirg, dec); Trbr
        {{c= (i,lptc,[],{t= Typ ("AnyRef",{at= []; lat= l_empty});lt= l_empty},
                                             [],ld); lc= ($startpos, $endpos)}}
  | Tclass; i=Tident; Tlpar; lp=separated_list (Tvirg, par); Trpar;
                                    Tlbr; ld=separated_list (Tpvirg, dec); Trbr
        {{c= (i,[],lp,{t= Typ ("AnyRef",{at= []; lat= l_empty});lt= l_empty},
                                             [],ld); lc= ($startpos, $endpos)}}
  | Tclass; i=Tident; Tlcr; lptc=separated_nonempty_list (Tvirg, par_ty_cl);
                            Trcr; Tlpar; lp=separated_list (Tvirg, par); Trpar;
                                    Tlbr; ld=separated_list (Tpvirg, dec); Trbr
        {{c= (i,lptc,lp,{t= Typ ("AnyRef",{at= []; lat= l_empty});lt= l_empty},
                                             [],ld); lc= ($startpos, $endpos)}}
                               
  | Tclass; i=Tident; Textends; t=ty; Tlbr; ld=separated_list (Tpvirg, dec);
                                                                           Trbr
        {{c= (i,[],[],t,[],ld); lc= ($startpos, $endpos)}}
  | Tclass; i=Tident; Tlcr; lptc=separated_nonempty_list (Tvirg, par_ty_cl); 
              Trcr; Textends; t=ty; Tlbr; ld=separated_list (Tpvirg, dec); Trbr
        {{c= (i,lptc,[],t,[],ld); lc= ($startpos, $endpos)}}
  | Tclass; i=Tident; Tlpar; lp=separated_list (Tvirg, par); Trpar;
                    Textends; t=ty; Tlbr; ld=separated_list (Tpvirg, dec); Trbr
        {{c= (i,[],lp,t,[],ld); lc= ($startpos, $endpos)}}
  | Tclass; i=Tident; Tlcr; lptc=separated_nonempty_list (Tvirg, par_ty_cl);
                        Trcr; Tlpar; lp=separated_list (Tvirg, par); Trpar;
                    Textends; t=ty; Tlbr; ld=separated_list (Tpvirg, dec); Trbr
        {{c= (i,lptc,lp,t,[],ld); lc= ($startpos, $endpos)}}
                              
  | Tclass; i=Tident; Textends; t=ty; Tlpar; le=separated_list (Tvirg, exp); 
                             Trpar; Tlbr; ld=separated_list (Tpvirg, dec); Trbr
        {{c= (i,[],[],t,le,ld); lc= ($startpos, $endpos)}}
  | Tclass; i=Tident; Tlcr; lptc=separated_nonempty_list (Tvirg, par_ty_cl); 
            Trcr; Textends; t=ty; Tlpar; le=separated_list (Tvirg, exp); Trpar;
                                    Tlbr; ld=separated_list (Tpvirg, dec); Trbr
        {{c= (i,lptc,[],t,le,ld); lc= ($startpos, $endpos)}}
  | Tclass; i=Tident; Tlpar; lp=separated_list (Tvirg, par); Trpar;
                  Textends; t=ty; Tlpar; le=separated_list (Tvirg, exp); Trpar;
                                    Tlbr; ld=separated_list (Tpvirg, dec); Trbr
        {{c= (i,[],lp,t,le,ld); lc= ($startpos, $endpos)}}
  | Tclass; i=Tident; Tlcr; lptc=separated_nonempty_list (Tvirg, par_ty_cl);
                            Trcr; Tlpar; lp=separated_list (Tvirg, par); Trpar;
                  Textends; t=ty; Tlpar; le=separated_list (Tvirg, exp); Trpar;
                                    Tlbr; ld=separated_list (Tpvirg, dec); Trbr
        {{c= (i,lptc,lp,t,le,ld); lc= ($startpos, $endpos)}}
;
dec:
  | v=va {{d= Dvar v; ld= ($startpos, $endpos)}}
  | m=meth {{d= Dmethode m; ld= ($startpos, $endpos)}}
;
va:
  | Tvar; i=Tident; Tegal; e=exp 
        {{v= Vvar (i,{t= Typ ("Any",{at= []; lat= l_empty});lt= l_empty},e);
                                                     lv= ($startpos, $endpos)}}
  | Tvar; i=Tident; Tdp; t=ty; Tegal; e=exp
        {{v= Vvar (i,t,e); lv= ($startpos, $endpos)}}
  | Tval; i=Tident; Tegal; e=exp
        {{v= Vval (i,{t= Typ ("Any",{at= []; lat= l_empty});lt= l_empty},e); 
                                                     lv= ($startpos, $endpos)}}
  | Tval; i=Tident; Tdp; t=ty; Tegal; e=exp
        {{v= Vval (i,t,e); lv= ($startpos, $endpos)}}
;
meth:
  | Tdef; i=Tident; Tlpar; l2=separated_list (Tvirg, par); Trpar; b=bl
        {{m= Mdef (i,[],l2,{t= Typ ("Unit",{at= []; lat= l_empty});lt=
                l_empty},{e= Ebloc b; le= l_empty; te= {t= Typ ("Unit", 
             {at= []; lat= l_empty}); lt=l_empty}}); lm= ($startpos, $endpos)}}
  | Tdef; i=Tident; Tlcr; l1=separated_nonempty_list (Tvirg, par_ty); Trcr;
                             Tlpar; l2=separated_list (Tvirg, par); Trpar; b=bl
        {{m= Mdef (i,l1,l2,{t= Typ ("Unit",{at= []; lat= l_empty});lt=
                l_empty},{e= Ebloc b; le= l_empty; te={t= Typ ("Unit", 
             {at= []; lat= l_empty}); lt=l_empty}}); lm= ($startpos, $endpos)}}
  | Tdef; i=Tident; Tlpar; l2=separated_list (Tvirg, par); Trpar; Tdp; 
                                                             t=ty; Tegal; e=exp
        {{m= Mdef (i,[],l2,t,e); lm= ($startpos, $endpos)}}
  | Tdef; i=Tident; Tlcr; l1=separated_nonempty_list (Tvirg, par_ty); Trcr;
          Tlpar; l2=separated_list (Tvirg, par); Trpar; Tdp; t=ty; Tegal; e=exp
        {{m= Mdef (i,l1,l2,t,e); lm= ($startpos, $endpos)}}
  | Toverride; Tdef; i=Tident; Tlpar; l2=separated_list (Tvirg, par); Trpar; 
                                                                           b=bl
        {{m= Moverride (i,[],l2,{t= Typ ("Unit",{at= []; lat= l_empty});lt=
                l_empty},{e= Ebloc b; le= l_empty; te={t= Typ ("Unit", 
             {at= []; lat= l_empty}); lt=l_empty}}); lm= ($startpos, $endpos)}}
  | Toverride; Tdef; i=Tident; Tlcr; l1=separated_nonempty_list (Tvirg, par_ty)
                     ; Trcr; Tlpar; l2=separated_list (Tvirg, par); Trpar; b=bl
        {{m= Moverride (i,l1,l2,{t= Typ ("Unit",{at= []; lat= l_empty});lt=
                l_empty},{e= Ebloc b; le= l_empty; te={t= Typ ("Unit", 
             {at= []; lat= l_empty}); lt=l_empty}}); lm= ($startpos, $endpos)}}
  | Toverride; Tdef; i=Tident; Tlpar; l2=separated_list (Tvirg, par); Trpar;
                                                        Tdp; t=ty; Tegal; e=exp
        {{m= Moverride (i,[],l2,t,e); lm= ($startpos, $endpos)}}
  | Toverride; Tdef; i=Tident; Tlcr; l1=separated_nonempty_list (Tvirg, par_ty)
                     ; Trcr; Tlpar; l2=separated_list (Tvirg, par); Trpar; Tdp;
                                                             t=ty; Tegal; e=exp
        {{m= Moverride (i,l1,l2,t,e); lm= ($startpos, $endpos)}}
;
par:
  i=Tident; Tdp; t=ty {{p= (i,t); lp= ($startpos, $endpos)}}
;
par_ty:
  | i=Tident
        {{pt= Ptid i; lpt= ($startpos, $endpos)}}
  | i=Tident; Tinf; Tdp; t=ty
       {{pt= Ptidoptyp (i,{o= Inf; lo= l_empty},t); lpt= ($startpos, $endpos)}}
  | i=Tident; Tsup; Tdp; t=ty 
       {{pt= Ptidoptyp (i,{o= Sup; lo= l_empty},t); lpt= ($startpos, $endpos)}}
;
par_ty_cl:
  | pt=par_ty {{ptc= Ptc pt; lptc= ($startpos, $endpos)}}
  | Tadd; pt=par_ty {{ptc= Ptcplus pt; lptc= ($startpos, $endpos)}}
  | Tsub; pt=par_ty {{ptc= Ptcmoins pt; lptc= ($startpos, $endpos)}}
;
ty:
  | i=Tident {{t= Typ (i,{at= []; lat= l_empty}); lt= ($startpos, $endpos)}}
  | i=Tident; ar=arg_ty {{t= Typ (i,ar); lt= ($startpos, $endpos)}}
;
arg_ty:
  Tlcr; liste = separated_nonempty_list (Tvirg,ty); Trcr
        {{at= liste; lat= ($startpos, $endpos)}}
;
cl_Main:
  Tobject; Tmain; Tlbr; liste = separated_list (Tpvirg, dec) ; Trbr
        {{cM= liste; lcM= ($startpos, $endpos)}}
;
exp:
  | n=Tentier
        {{e= Eentier n; le= ($startpos, $endpos); 
                       te={t=Typ ("Int", {at= []; lat= l_empty}); lt=l_empty}}}
  | s=Tchaine
        {{e= Echaine s; le= ($startpos, $endpos); 
                   te= {t=Typ ("String", {at= []; lat= l_empty}); lt=l_empty}}}
  | b=Tbool
        {{e= Ebool b; le= ($startpos, $endpos); 
                  te= {t=Typ ("Boolean", {at= []; lat= l_empty}); lt=l_empty}}}
  | Tlpar; Trpar
        {{e= Eunit; le= ($startpos, $endpos); 
                     te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}}
  | Tnull 
        {{e= Enull; le= ($startpos, $endpos);
                     te= {t=Typ ("Null", {at= []; lat= l_empty}); lt=l_empty}}}
  | Tthis 
        {{e= Ethis; le= ($startpos, $endpos); 
                     te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}}
                       /* cette façon de faire pose peut-être problème */
  | Tlpar; e=exp; Trpar
        {{e= Epar e; le= ($startpos, $endpos); te= e.te}}
  | a=acces 
        {{e= Eacc a; le= ($startpos, $endpos);
                     te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}}
                     /* ici il y a surement un problème */
  | a=acces; Tegal; e=exp
        {{e= Eaccexp (a,e); le= ($startpos, $endpos);
                     te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}}
                           /* ici c'est normal de mettre Unit */
  | a=acces; Tlpar; l=separated_list (Tvirg, exp); Trpar
        {{e= Eaccargexp (a,{at= []; lat= l_empty},l);
           le= ($startpos, $endpos); 
                     te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}}
  | a=acces; ar=arg_ty; Tlpar; l=separated_list (Tvirg, exp); Trpar
        {{e= Eaccargexp (a,ar,l); le= ($startpos, $endpos);
                     te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}}
  | Tnew; id=Tident; Tlpar; l=separated_list (Tvirg, exp); Trpar
        {{e= Enewidargexp (id,{at= []; lat= l_empty},l);
                                                     le= ($startpos, $endpos);
                     te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}}
                         /* faute de solution je mets Unit */
  | Tnew; id=Tident; ar=arg_ty; Tlpar; l=separated_list (Tvirg, exp); Trpar
        {{e= Enewidargexp (id,ar,l); le= ($startpos, $endpos);
                     te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}}
  | Tneg; e=exp 
        {{e= Eneg e; le= ($startpos, $endpos);
                  te= {t=Typ ("Boolean", {at= []; lat= l_empty}); lt=l_empty}}}
  | Tsub; e=exp %prec moins
        {{e= Emoins e; le= ($startpos, $endpos); 
                      te= {t=Typ ("Int", {at= []; lat= l_empty}); lt=l_empty}}}
  | e=exp; o=op; f=exp
        {{e= Eop (e,o,f); le= ($startpos, $endpos); 
                    te= {t=Typ ((if (List.mem o.o [Add; Sub; Mul; Div; Reste])
             then "Int" else "Boolean"), {at= []; lat= l_empty}); lt=l_empty}}}
  | Tif; Tlpar; e=exp; Trpar; f=exp
        {{e= Eif (e,f,{e= Eunit; le= l_empty; te= {t=Typ ("Unit", 
            {at= []; lat= l_empty}); lt=l_empty}}); le= ($startpos, $endpos);
                     te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}}
                                                                      %prec Tif
                                 /* problème possible */
  | Tif; Tlpar; e=exp; Trpar; f=exp; Telse; g=exp
        {{e= Eif (e,f,g); le= ($startpos, $endpos);
                     te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}}
  | Twhile; Tlpar; e=exp; Trpar; f=exp
        {{e= Ewhile (e,f); le= ($startpos, $endpos); 
        te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}} %prec Twhile
  | Treturn; e=exp 
        {{e= Ereturn e; le= ($startpos, $endpos); 
                  te= {t=Typ ("Nothing", {at= []; lat= l_empty}); lt=l_empty}}}
  | Treturn
        {{e= Ereturnvide; le= ($startpos, $endpos); 
                  te= {t=Typ ("Nothing", {at= []; lat= l_empty}); lt=l_empty}}}
  | Tprint; Tlpar; e=exp; Trpar
        {{e= Eprint e; le= ($startpos, $endpos); 
                     te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}}
  | b=bl
        {{e= Ebloc b; le= ($startpos, $endpos); 
                     te= {t=Typ ("Unit", {at= []; lat= l_empty}); lt=l_empty}}}
                   /* aucune logique derrière */
;
bl:
  Tlbr; l=separated_list (Tpvirg, aux_bl); Trbr
                        {{b= l; lb= ($startpos, $endpos)}}
;
aux_bl:
  | v=va {{b1= Bvar v; lb1= ($startpos, $endpos)}}
  | e=exp {{b1= Bexpr e; lb1= ($startpos, $endpos)}}
;
%inline op:
  | Teq       {{o= Eq; lo= ($startpos, $endpos)}}
  | Tne       {{o= Ne; lo= ($startpos, $endpos)}}
  | Tdbleg    {{o= Dbleg; lo= ($startpos, $endpos)}}
  | Tdiff     {{o= Diff; lo= ($startpos, $endpos)}}
  | Tinf      {{o= Inf; lo= ($startpos, $endpos)}}
  | Tinfeg    {{o= Infeg; lo= ($startpos, $endpos)}}
  | Tsup      {{o= Sup; lo= ($startpos, $endpos)}}
  | Tsupeg    {{o= Supeg; lo= ($startpos, $endpos)}}
  | Tadd      {{o= Add; lo= ($startpos, $endpos)}}
  | Tsub      {{o= Sub; lo= ($startpos, $endpos)}}
  | Tmul      {{o= Mul; lo= ($startpos, $endpos)}}
  | Tdiv      {{o= Div; lo= ($startpos, $endpos)}}
  | Treste    {{o= Reste; lo= ($startpos, $endpos)}}
  | Tet       {{o= Et; lo= ($startpos, $endpos)}}
  | Tou       {{o= Ou; lo= ($startpos, $endpos)}}
;
acces:
  | i=Tident                      {{a= Aid i; la= ($startpos, $endpos)}}
  | e=exp; Tpoint; i=Tident       {{a= Aexpid (e,i); la= ($startpos, $endpos)}}
