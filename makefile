cc = gcc
flex = lex
bison = yacc

lex_source = mini.l
yacc_source = mini.y
src = lex.yy.c tac.c y.tab.c
dep = tac.h tac.c

prom = test

$(prom): $(lex_source) $(yacc_source) $(dep)
	$(flex) $(lex_source)
	$(bison) -d $(yacc_source)
	$(cc) -o $(prom) $(src)

clean:
	rm -rf $(prom)
