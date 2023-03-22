parser : main.c syntax.y lexical.l
	bison -d  syntax.y
	flex lexical.l
	gcc main.c syntax.tab.c semantic.c -lfl inter.c -o parser