.section .rodata
L_PRINT_INT:
 .string "%d\n" 
	# head
.text
.type main, %function
.global main


	# var i

	# var j

	# var k

	# label main
main:

	# begin
	STP x29, x30, [sp, -48]!
	ADD x29, sp, 48

	# var l

	# var m

	# var n

	# l = 1
	MOV x1,1
	LDR x2,[x29,-8]

	# m = 2
	MOV x2,2
	LDR x3,[x29,-16]

	# n = 3
	MOV x3,3
	LDR x4,[x29,-24]

	# actual l
	STR x1, [x29,-8]
	STR x1, [sp,-8]

	# call PRINTN
	STR x2, [x29,-16]
	STR x3, [x29,-24]
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# actual m
	LDR x1,[x29,-16]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# actual n
	LDR x1,[x29,-24]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# var _t0

	# actual n
	LDR x1,[x29,-24]
	STR x1, [sp,-8]

	# actual m
	LDR x2,[x29,-16]
	STR x2, [sp,-16]

	# actual l
	LDR x3,[x29,-8]
	STR x3, [sp,-24]

	# _t0 = call func
	SUB sp,sp,32
	BL func
	ADD sp,sp,32

	# n = _t0
	MOV x1,x0
	LDR x2,[x29,-24]

	# actual i
	ADR x0,STATIC
	LDR x2,[x0,8]
	STR x2, [sp,-8]

	# call PRINTN
	STR x1, [x29,-24]
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# actual j
	ADR x0,STATIC
	LDR x1,[x0,16]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# actual k
	ADR x0,STATIC
	LDR x1,[x0,24]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# actual n
	LDR x1,[x29,-24]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# end
	LDP x29, x30, [sp], 48
	ret 

	# label func
func:

	# begin
	STP x29, x30, [sp, -16]!
	ADD x29, sp, 16

	# formal o

	# formal p

	# formal q

	# i = o
	LDR x1,[x29,8]
	ADR x0,STATIC
	LDR x2,[x0,8]

	# j = p
	LDR x2,[x29,16]
	ADR x0,STATIC
	LDR x3,[x0,16]

	# k = q
	LDR x3,[x29,24]
	ADR x0,STATIC
	LDR x4,[x0,24]

	# actual i
    adr x0, STATIC
    STR x1, [x0,8]
	STR x1, [sp,-8]

	# call PRINTN
    adr x0, STATIC
    STR x2, [x0,16]
    adr x0, STATIC
    STR x3, [x0,24]
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# actual j
	ADR x0,STATIC
	LDR x1,[x0,16]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# actual k
	ADR x0,STATIC
	LDR x1,[x0,24]
	STR x1, [sp,-8]

	# call PRINTN
	SUB sp,sp,16
	BL PRINTN
	ADD sp,sp,16

	# return 999
	MOV x0,999

	# end
	LDP x29, x30, [sp], 16
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
	.8byte 0,0 ,0 ,0 ,0 
