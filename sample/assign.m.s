.section .rodata
L_PRINT_INT:
 .string "%d\n" 
L6:
	.string "m="
L5:
	.string "l="
L4:
	.string "k="
L3:
	.string "j="
L2:
	.string "
,"
L1:
	.string "i="
	# head
.text
.type main, %function
.global main


	# label main
main:

	# begin
	STP x29, x30, [sp, -96]!
	ADD x29, sp, 96

	# var i

	# var j

	# var k

	# var l

	# var m

	# i = 8
	MOV x1,8
	LDR x2,[x29,0]

	# var _t0

	# _t0 = i + 2
	STR x1, [x29,0]
	MOV x2,2
	ADD x1,x1,x2

	# j = _t0
	STR x1, [x29,-40]
	LDR x3,[x29,-8]

	# var _t1

	# _t1 = i - 3
	LDR x3,[x29,0]
	MOV x4,3
	SUB x3,x3,x4

	# k = _t1
	STR x3, [x29,-48]
	LDR x5,[x29,-16]

	# var _t2

	# _t2 = i * 2
	LDR x5,[x29,0]
	MOV x6,2
	MUL x5,x5,x6

	# l = _t2
	STR x5, [x29,-56]
	LDR x7,[x29,-24]

	# var _t3

	# _t3 = i / 2
	LDR x7,[x29,0]
	MOV x8,2
	DIV x7,x7,x8

	# m = _t3
	STR x7, [x29,-64]
	LDR x9,[x29,-32]

	# actual L1
	ADR x9,L1
	STR x9, [sp,-8]

	# call PRINTS
	STR x1, [x29,-8]
	STR x3, [x29,-16]
	STR x5, [x29,-24]
	STR x7, [x29,-32]
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# actual i
	LDR x1,[x29,0]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# actual L2
	ADR x1,L2
	STR x1, [sp,-8]

	# call PRINTS
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# actual L3
	ADR x1,L3
	STR x1, [sp,-8]

	# call PRINTS
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# actual j
	LDR x1,[x29,-8]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# actual L2
	ADR x1,L2
	STR x1, [sp,-8]

	# call PRINTS
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# actual L4
	ADR x1,L4
	STR x1, [sp,-8]

	# call PRINTS
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# actual k
	LDR x1,[x29,-16]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# actual L2
	ADR x1,L2
	STR x1, [sp,-8]

	# call PRINTS
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# actual L5
	ADR x1,L5
	STR x1, [sp,-8]

	# call PRINTS
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# actual l
	LDR x1,[x29,-24]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# actual L2
	ADR x1,L2
	STR x1, [sp,-8]

	# call PRINTS
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# actual L6
	ADR x1,L6
	STR x1, [sp,-8]

	# call PRINTS
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# actual m
	LDR x1,[x29,-32]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# actual L2
	ADR x1,L2
	STR x1, [sp,-8]

	# call PRINTS
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# end
	LDP x29, x30, [sp], 96
	ret 

PRINTN:
	STP x29,x30, [sp,-16]!
	ADD x29,sp,16
	LDR w1, [x29,8]
	ADR x0, L_PRINT_INT
	bl printf
	LDP x29,x30, [sp], 16
	ret

PRINTS:
	STP x29,x30, [sp,-16]!
	ADD x29,sp,16
	LDR x0,[x29,8]
	bl printf
	LDP x29,x30, [sp], 16
	ret

EXIT:
	ret

.section .data
STATIC:
	.8byte 0,0 
