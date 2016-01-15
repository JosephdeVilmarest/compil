(* Fichier principal de l'analyseur syntaxique et du typeur de petit-scala *)

open Format
open Lexing


(* Option de compilation, pour s'arrêter à l'issue du parser *)
let parse_only = ref false
let type_only = ref false

(* Noms des fichiers source et cible *)
let ifile = ref ""
let ofile = ref ""

let set_file f s = f := s

(* Les options du compilateur que l'on affiche avec --help *)
let options =
  ["--parse-only", Arg.Set parse_only,
   "  Pour ne faire que l'analyse syntaxique";
  "--type-only", Arg.Set type_only,
   "  Pour ne faire que la phase de typage"]

let usage = "usage: petit-scala [option] file.scala"

(* localise une erreur en indiquant la ligne et la colonne *)
let localisation pos =
  let l = pos.pos_lnum in
  let c = pos.pos_cnum - pos.pos_bol + 1 in
  eprintf "File \"%s\", line %d, characters %d-%d:\n" !ifile l (c-1) c

let localisation2 (debut,fin) =
  let l = debut.pos_lnum and d = debut.pos_cnum - debut.pos_bol
  and f = fin.pos_cnum - debut.pos_bol in
  eprintf "File \"%s\", line %d, characters %d-%d:\n" !ifile l d f

let () =
  (* Parsing de la ligne de commande *)
  Arg.parse options (set_file ifile) usage;

  (* On vérifie que le nom du fichier source a bien été indiqué *)
  if !ifile="" then begin eprintf "Aucun fichier à compiler\n@?"; exit 1 end;

  (* Ce fichier doit avoir l'extension .scala *)
  if not (Filename.check_suffix !ifile ".scala") then begin
    eprintf "Le fichier d'entrée doit avoir l'extension .scala\n@?";
    Arg.usage options usage;
    exit 1
  end;

  (* Par défaut, le fichier cible a le même nom que le fichier source, 
     seule l'extension change *)
  if !ofile="" then ofile := Filename.chop_suffix !ifile ".scala" ^ ".s";

  (* Ouverture du fichier source en lecture *)
  let f = open_in !ifile in

  (* Création d'un tampon d'analyse lexicale *)
  let buf = Lexing.from_channel f in

  try
    (* Parsing: la fonction  Parser.fic transforme le tampon lexical en un
       arbre de syntaxe abstraite si aucune erreur (lexicale ou syntaxique)
       n'est détectée.
       La fonction Lexer.token est utilisée par Parser.fic pour obtenir
       le prochain token. *)
    let fichier = Parser.fic Lexer.token buf in
    close_in f;
    if !parse_only then exit 0
    else
    (Typeur.est_bien_type fichier;

    (* On s'arrête ici si on ne veut faire que le parsing *)
    if !type_only then exit 0

    else
        X86_64.print_in_file !ofile (Comp.comp fichier);
        exit 0)

  with
    | Lexer.Lexing_error c ->
	(* Erreur lexicale. On récupère sa position absolue et
	   on la convertit en numéro de ligne *)
	localisation (Lexing.lexeme_start_p buf);
	eprintf "Erreur lexicale: %s@." c;
	exit 1
    | Parser.Error ->
	(* Erreur syntaxique *)
	localisation (Lexing.lexeme_start_p buf);
	eprintf "Erreur syntaxique@.";
	exit 1
    (* Typeur *)
    | Typeur.Typeur_error (c, l) ->
	(* Erreur de typage*)
	localisation2 l;
	eprintf "Erreur de typage: %s@." c;
	exit 1
(*  | Comp.comp_error c ->
    eprintf "erreur à la compilation: %s@." c;
    exit 1 *)
