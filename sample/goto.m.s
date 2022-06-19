.section .rodata
L_PRINT_INT:
 .string "%d\n" 
	# head
.text
.type main, %function
.global main


	# label main
main:

	# begin
	STP x29, x30, [sp, -48]!
	ADD x29, sp, 48

	# var x

	# var y

	# x = 1
	MOV x1,1
	LDR x2,[x29,-8]

	# var _t0

	# _t0 = x
	STR x1, [x29,-8]
	LDR x2,[x29,-24]

	# var _t1

	# _t1 = x + 1
	LDR x2,[x29,-8]
	MOV x3,1
	ADD x2,x2,x3

	# x = _t1
	STR x2, [x29,-32]
	LDR x4,[x29,-8]

	# y = _t0
	STR x1, [x29,-24]
	LDR x4,[x29,-16]

	# _t0 = x
	STR x2, [x29,-8]
	LDR x4,[x29,-24]

	# _t1 = x + 1
	LDR x4,[x29,-8]
	MOV x5,1
	ADD x4,x4,x5

	# x = _t1
	STR x4, [x29,-32]
	LDR x6,[x29,-8]

	# y = _t0
	STR x2, [x29,-24]

	# actual y
	STR x2, [x29,-16]
	STR x2, [sp,-8]

	# call PRINTN
	STR x4, [x29,-8]
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# _t0 = x
	LDR x1,[x29,-8]
	LDR x2,[x29,-24]

	# _t1 = x + 1
	LDR x2,[x29,-8]
	MOV x3,1
	ADD x2,x2,x3

	# x = _t1
	STR x2, [x29,-32]
	LDR x4,[x29,-8]

	# actual _t0
	STR x1, [x29,-24]
	STR x1, [sp,-8]

	# call PRINTN
	STR x2, [x29,-8]
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# _t0 = x + 1
	LDR x1,[x29,-8]
	MOV x2,1
	ADD x1,x1,x2

	# x = _t0
	STR x1, [x29,-24]
	LDR x3,[x29,-8]

	# actual x
	STR x1, [x29,-8]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# end
	LDP x29, x30, [sp], 48
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
