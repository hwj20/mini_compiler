	# head
	LOD R2,STACK
	STO (R2),0
	LOD R4,EXIT
	STO (R2+4),R4

	# label main
main:

	# begin

	# var l

	# var m

	# var n

	# l = 1
	LOD R7,1
	LOD R13,(R2+8)

	# m = 2
	LOD R6,2
	LOD R13,(R2+12)

	# n = 3
	LOD R11,3
	LOD R13,(R2+16)

	# actual l
	STO (R2+8),R7
	STO (R2+20),R7

	# call PRINTN
	STO (R2+12),R6
	STO (R2+16),R11
	STO (R2+24),R2
	LOD R4,R1+32
	STO (R2+28),R4
	LOD R2,R2+24
	JMP PRINTN

	# actual m
	LOD R7,(R2+12)
	STO (R2+20),R7

	# call PRINTN
	STO (R2+24),R2
	LOD R4,R1+32
	STO (R2+28),R4
	LOD R2,R2+24
	JMP PRINTN

	# actual n
	LOD R9,(R2+16)
	STO (R2+20),R9

	# call PRINTN
	STO (R2+24),R2
	LOD R4,R1+32
	STO (R2+28),R4
	LOD R2,R2+24
	JMP PRINTN

	# actual L1
	LOD R12,L1
	STO (R2+20),R12

	# call PRINTS
	STO (R2+24),R2
	LOD R4,R1+32
	STO (R2+28),R4
	LOD R2,R2+24
	JMP PRINTS

	# var t0

	# actual n
	LOD R7,(R2+16)
	STO (R2+24),R7

	# actual_addr m
	LOD R5,R2+12
	STO (R2+28),R5

	# actual l
	LOD R11,(R2+8)
	STO (R2+32),R11

	# t0 = call func
	STO (R2+36),R2
	LOD R4,R1+32
	STO (R2+40),R4
	LOD R2,R2+36
	JMP func

	# n = t0
	LOD R10,R4
	LOD R11,(R2+16)

	# actual l
	LOD R13,(R2+8)
	STO (R2+24),R13

	# call PRINTN
	STO (R2+16),R10
	STO (R2+28),R2
	LOD R4,R1+32
	STO (R2+32),R4
	LOD R2,R2+28
	JMP PRINTN

	# actual m
	LOD R11,(R2+12)
	STO (R2+24),R11

	# call PRINTN
	STO (R2+28),R2
	LOD R4,R1+32
	STO (R2+32),R4
	LOD R2,R2+28
	JMP PRINTN

	# actual n
	LOD R10,(R2+16)
	STO (R2+24),R10

	# call PRINTN
	STO (R2+28),R2
	LOD R4,R1+32
	STO (R2+32),R4
	LOD R2,R2+28
	JMP PRINTN

	# actual L1
	LOD R12,L1
	STO (R2+24),R12

	# call PRINTS
	STO (R2+28),R2
	LOD R4,R1+32
	STO (R2+32),R4
	LOD R2,R2+28
	JMP PRINTS

	# actual n
	LOD R6,(R2+16)
	STO (R2+24),R6

	# call PRINTN
	STO (R2+28),R2
	LOD R4,R1+32
	STO (R2+32),R4
	LOD R2,R2+28
	JMP PRINTN

	# actual L1
	LOD R13,L1
	STO (R2+24),R13

	# call PRINTS
	STO (R2+28),R2
	LOD R4,R1+32
	STO (R2+32),R4
	LOD R2,R2+28
	JMP PRINTS

	# end
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

	# label func
func:

	# begin

	# formal o

	# formal_addr p

	# formal q

	# var t1

	# t1 = o + q
	LOD R7,(R2-4)
	LOD R14,(R2-12)
	ADD R7,R14

	# p = t1
	STO (R2+8),R7
	LOD R14,(R2-8)
	LOD R5, R14
	STO (R5), R7

	# o = p
	LOD R14, (R14)
	LOD R12,(R2-4)

	# actual o
	STO (R2-4),R14
	STO (R2+12),R14

	# call PRINTN
	STO (R2+16),R2
	LOD R4,R1+32
	STO (R2+20),R4
	LOD R2,R2+16
	JMP PRINTN

	# actual p
	LOD R12,(R2-8)
	LOD R12, (R12)
	STO (R2+12),R12

	# call PRINTN
	STO (R2+16),R2
	LOD R4,R1+32
	STO (R2+20),R4
	LOD R2,R2+16
	JMP PRINTN

	# actual q
	LOD R14,(R2-12)
	STO (R2+12),R14

	# call PRINTN
	STO (R2+16),R2
	LOD R4,R1+32
	STO (R2+20),R4
	LOD R2,R2+16
	JMP PRINTN

	# actual L1
	LOD R14,L1
	STO (R2+12),R14

	# call PRINTS
	STO (R2+16),R2
	LOD R4,R1+32
	STO (R2+20),R4
	LOD R2,R2+16
	JMP PRINTS

	# return 999
	LOD R4,999
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

	# end
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

PRINTN:
	LOD R7,(R2-4) # 789
	LOD R15,R7 # 789 
	DIV R7,10 # 78
	TST R7
	JEZ PRINTDIGIT
	LOD R8,R7 # 78
	MUL R8,10 # 780
	SUB R15,R8 # 9
	STO (R2+8),R15 # local 9 store

	# out 78
	STO (R2+12),R7 # actual 78 push

	# call PRINTN
	STO (R2+16),R2
	LOD R4,R1+32
	STO (R2+20),R4
	LOD R2,R2+16
	JMP PRINTN

	# out 9
	LOD R15,(R2+8) # local 9 

PRINTDIGIT:
	ADD  R15,48
	OUT

	# ret
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

PRINTS:
	LOD R7,(R2-4)

PRINTC:
	LOD R15,(R7)
	DIV R15,16777216
	TST R15
	JEZ PRINTSEND
	OUT
	ADD R7,1
	JMP PRINTC

PRINTSEND:
	# ret
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

EXIT:
	END

L1:
	DBS 10,0
STATIC:
	DBN 0,0
STACK:
