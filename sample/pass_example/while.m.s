.section .rodata
L_PRINT_INT:
 .string "%d\n" 
L1:
	.string "----line----"
	# head
.text
.type main, %function
.global main


	# label main
main:

	# begin
	STP x29, x30, [sp, -48]!
	ADD x29, sp, 48

	# var i

	# i = 1
	MOV x1,1
	LDR x2,[x29,0]

	# label L2
	STR x1, [x29,0]
L2:

	# var _t0

	# _t0 = (i < 10)
	LDR x1,[x29,0]
	MOV x2,10
	SUB x1,x1,x2
	CMP x1, 0
	MOV x1,0
	BGE CMP_LABEL_0_END
	MOV x1,1 
 CMP_LABEL_0_END:

	# ifz _t0 goto L3
	STR x1, [x29,-8]
	CMP x1, 0
	BEQ L3

	# actual L1
	ADR x3,L1
	STR x3, [sp,-8]

	# call PRINTS
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

	# var _t1

	# _t1 = i + 1
	LDR x1,[x29,0]
	MOV x2,1
	ADD x1,x1,x2

	# i = _t1
	STR x1, [x29,-16]
	LDR x3,[x29,0]

	# goto L2
	STR x1, [x29,0]
	B L2

	# label L3
L3:

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
