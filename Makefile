# Simple makefile for things relating to OpenSCAD
.PHONY: all clean

mainfile=main.scad
base=$(shell basename $(shell pwd) )

partnames=$(shell sed -rn 's|^//\s*_partname_values ||;tp;b;:p p' $(mainfile) )
outputfiles=$(shell echo $(partnames) | tr ' ' '\n' |  sed -r 's|.*|render/$(base)_part_&.stl|g' ) render/display.png $(shell echo $(partnames) | tr ' ' '\n' |  sed -r 's|.*|render/$(base)_part_&.png|g' )

all: $(outputfiles)
clean:
	@rm -f render/*

render:
	mkdir -p render

render/display.png: render $(mainfile)
	openscad -D'partname="display"' --viewall --imgsize 1920,1080 --preview -o $@ main.scad

render/%.png: render $(mainfile)
	openscad $(shell echo "$@" | sed -re "s/.*_part_([^-.]+).*/ -D'partname=\"\1\"'/") --viewall --imgsize 1920,1080 --preview -o $@ main.scad



%.stl: $(mainfile) render
	openscad $(shell echo "$@" | sed -re "s/.*_part_([^-.]+).*/ -D'partname=\"\1\"'/") -o $@ $<
