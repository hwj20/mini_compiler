.section .rodata
L_PRINT_INT:
 .string "%d\n" 
L7:
	.string "wrong 4"
L5:
	.string "pass 3"
L3:
	.string "pass 2"
L1:
	.string "pass "
	# head
.text
.type main, %function
.global main


	# label main
main:

	# begin
	STP x29, x30, [sp, -80]!
	ADD x29, sp, 80

	# var i

	# var j

	# var c

	# i = 1
	MOV x1,1
	LDR x2,[x29,0]

	# j = 2
	MOV x2,2
	LDR x3,[x29,-8]

	# c = 3
	MOV x3,3
	LDR x4,[x29,-16]

	# var _t0

	# _t0 = (i < j)
	STR x1, [x29,0]
	SUB x1,x1,x2
	CMP x1, 0
	MOV x1,0
	BGE CMP_LABEL_0_END
	MOV x1,1 
 CMP_LABEL_0_END:

	# ifz _t0 goto L2
	STR x1, [x29,-24]
	STR x2, [x29,-8]
	STR x3, [x29,-16]
	CMP x1, 0
	BEQ L2

	# actual L1
	ADR x4,L1
	STR x4, [sp,-8]

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

	# label L2
L2:

	# var _t1

	# _t1 = (i <= j)
	LDR x1,[x29,0]
	LDR x2,[x29,-8]
	SUB x1,x1,x2
	CMP x1, 0
	MOV x1,0
	BGT CMP_LABEL_1_END
	MOV x1,1 
 CMP_LABEL_1_END:

	# ifz _t1 goto L4
	STR x1, [x29,-32]
	CMP x1, 0
	BEQ L4

	# actual L3
	ADR x3,L3
	STR x3, [sp,-8]

	# call PRINTS
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# label L4
L4:

	# var _t2

	# _t2 = (c > i)
	LDR x1,[x29,-16]
	LDR x2,[x29,0]
	SUB x1,x1,x2
	CMP x1, 0
	MOV x1,0
	BLE CMP_LABEL_2_END
	MOV x1,1 
 CMP_LABEL_2_END:

	# ifz _t2 goto L6
	STR x1, [x29,-40]
	CMP x1, 0
	BEQ L6

	# actual L5
	ADR x3,L5
	STR x3, [sp,-8]

	# call PRINTS
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# i = 4
	MOV x1,4
	LDR x2,[x29,0]

	# label L6
	STR x1, [x29,0]
L6:

	# var _t3

	# _t3 = (c >= i)
	LDR x1,[x29,-16]
	LDR x2,[x29,0]
	SUB x1,x1,x2
	CMP x1, 0
	MOV x1,0
	BLT CMP_LABEL_3_END
	MOV x1,1 
 CMP_LABEL_3_END:

	# ifz _t3 goto L8
	STR x1, [x29,-48]
	CMP x1, 0
	BEQ L8

	# actual L7
	ADR x3,L7
	STR x3, [sp,-8]

	# call PRINTS
	SUB sp,sp,16
	BL PRINTS
	ADD sp,sp,16

	# label L8
L8:

	# c = 2
	MOV x1,2
	LDR x2,[x29,-16]

	# end
	LDP x29, x30, [sp], 80
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
