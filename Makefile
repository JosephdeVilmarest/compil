CMO= lexer.cmo parser.cmo typeur.cmo x86_64.cmo comp.cmo main.cmo
GENERATED = lexer.ml parser.ml parser.mli
BIN=pscala
FLAGS=

all: $(BIN)

.PHONY: tests

tests: $(BIN)
	./testC.sh -3 ./pscala

$(BIN): $(CMO)
	ocamlc $(FLAGS) -o $(BIN) $(CMO)

.SUFFIXES: .mli .ml .cmi .cmo .mll .mly

.mli.cmi:
	ocamlc $(FLAGS) -c  $<

.ml.cmo:
	ocamlc $(FLAGS) -c  $<

.mll.ml:
	ocamllex $<

.mly.ml:
	menhir --infer -v $<

clean:
	rm -f *.cm[io] *.o *~ $(BIN) $(GENERATED) parser2.automaton

parser.ml: ast.cmi

.depend depend: $(GENERATED)
	rm -f .depend
	ocamldep *.ml *.mli > .depend

include .depend



