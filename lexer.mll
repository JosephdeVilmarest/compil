{
  open Lexing
  open Parser

  let s = ref "Bonjour"
  (* exception à lever pour signaler une erreur lexicale *)
  exception Lexing_error of string

  (* fonction à appeler à chaque retour chariot *)
  let newline lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
      { pos with pos_lnum = pos.pos_lnum + 1; pos_bol = pos.pos_cnum }

}

rule token = parse
  | [' ' '\t']+ {token lexbuf}
  | '\n' {newline lexbuf; token lexbuf}
  | "/*" {comment1 lexbuf}
  | "//" {comment2 lexbuf}
  | '0' {Tentier 0}
  | ['1'-'9']['0'-'9']* as s 
               {let i = int_of_string s in
                if i>2147483647 
                    then raise (Lexing_error "depassement de capacité")
                else Tentier i}
  | '+' {Tadd}
  | '-' {Tsub}
  | '*' {Tmul}
  | '/' {Tdiv}
  | '%' {Treste}
  | "class" {Tclass}
  | "def" {Tdef}
  | "else" {Telse}
  | "eq" {Teq}
  | "extends" {Textends}
  | "if" {Tif}
  | "Main" {Tmain}
  | "ne" {Tne}
  | "new" {Tnew}
  | "null" {Tnull}
  | "object" {Tobject}
  | "override" {Toverride}
  | "print" {Tprint}
  | "return" {Treturn}
  | "this" {Tthis}
  | "val" {Tval}
  | "var" {Tvar}
  | "while" {Twhile}
  | "true" {Tbool true}
  | "false" {Tbool false}
  | '(' {Tlpar}
  | ')' {Trpar}
  | '[' {Tlcr}
  | ']' {Trcr}
  | '{' {Tlbr}
  | '}' {Trbr}
  | '.' {Tpoint}
  | '!' {Tneg}
  | '=' {Tegal}
  | "==" {Tdbleg}
  | "!=" {Tdiff}
  | '<' {Tinf}
  | "<=" {Tinfeg}
  | '>' {Tsup}
  | ">=" {Tsupeg}
  | "&&" {Tet}
  | "||" {Tou}
  | ',' {Tvirg}
  | ';' {Tpvirg}
  | ':' {Tdp}
  | ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as id {Tident id}
  | '"' {s:= ""; chaine lexbuf}
  | eof {EOF}
  | _ {raise (Lexing_error "caractere illegal dans token")}

and comment1 = parse
  | "*/" {token lexbuf}
  | '\n' {newline lexbuf; comment1 lexbuf}
  | eof  {raise (Lexing_error "commentaire non termine")}
  | _    {comment1 lexbuf}

and comment2 = parse
  | '\n' {newline lexbuf; token lexbuf}
  | eof  {EOF}
  | _    {comment2 lexbuf}
  
and chaine = parse
  | '"' {Tchaine !s}
  | "\\\\" {s:= !s^"\\\\"; chaine lexbuf}
  | "\\\"" {s:= !s^"\\\""; chaine lexbuf}
  | '\n' {raise (Lexing_error "passage à la ligne illégal")}
  | "\\n" {s:= !s^"\n"; chaine lexbuf}
  | "\\t" {s:= !s^"\t"; chaine lexbuf}
  | "\\" {raise (Lexing_error "caractere illegal dans la chaine")}
  | [' '-'~'] as c {s:= !s^(String.make 1 c); chaine lexbuf}
  | _ {raise (Lexing_error "caractere illegal dans la chaine")}
  | eof {raise (Lexing_error "chaine non terminee")}
