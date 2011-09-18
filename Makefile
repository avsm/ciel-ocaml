all: _build/src/ciel.cma
	@ :

_build/src/ciel.cma: src/*.ml src/*.mli src/*.mlpack
	ocamlbuild -libs delimcc src/ciel.cma

install: all
	ocamlfind $(OCAMLFIND_FLAGS) -install ciel META _build/src/ciel.cma _build/src/ciel.cmi _build/src/ciel.cmo

uninstall:
	ocamlfind $(OCAMLFIND_FLAGS) -remove ciel

examples/%.bin: examples/%.ml
	ocamlc -o $@ -I +site-lib/ciel ciel.cma unix.cma $<

examples: examples/test.bin
	@ :

clean:
	rm -rf _build
	rm -rf examples/*.cmi examples/*.cmo examples/*.bin
