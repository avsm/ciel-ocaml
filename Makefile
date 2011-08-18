all: _build/src/ciel.cma
	@ :

_build/src/ciel.cma: src/*.ml src/*.mli src/*.mllib
	ocamlbuild -libs delimcc src/ciel.cma

clean:
	rm -rf _build
