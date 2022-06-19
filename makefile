CC := gcc
Source := obj.c myRegAllocation.c tac.c
flex := lex
bison := yacc

all: mini

mini: mini.l mini.y tac.c tac.h obj.c obj.h myRegAllocation.h myRegAllocation.c
	${flex} -o mini.l.c mini.l
	${bison} -d -o mini.y.c mini.y
	$(CC) -g3 mini.l.c mini.y.c $(Source) -o mini
clean:
	rm -fr *.l.* *.y.* mini asm machine

