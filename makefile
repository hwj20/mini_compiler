CC := gcc
Source := obj.c myRegAllocation.c tac.c
flex := lex
bison := yacc

all: mini asm machine other

mini: mini.l mini.y tac.c tac.h obj.c obj.h myRegAllocation.h myRegAllocation.c
	${flex} -o mini.l.c mini.l
	${bison} -d -o mini.y.c mini.y
	$(CC) -g3 mini.l.c mini.y.c $(Source) -o mini

asm: asm.l asm.y opcode.h
	${flex} -o asm.l.c asm.l
	${bison} -d -o asm.y.c asm.y
	$(CC) -g3 asm.l.c asm.y.c -o asm

machine: machine.c opcode.h
	$(CC) -g3 machine.c -o machine

clean:
	rm -fr *.l.* *.y.* mini asm machine

