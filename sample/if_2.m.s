	# head
	LOD R2,STACK
	STO (R2),0
	LOD R4,EXIT
	STO (R2+4),R4

	# label main
main:

	# begin

	# var i

	# var j

	# var c

	# i = 1
	LOD R5,1

	# j = 1
	LOD R6,1

	# c = 1
	LOD R7,1

	# var t0

	# t0 = (i == j)
	STO (R2+8),R5
	SUB R5,R6
	TST R5
	LOD R3,R1+40				// r1-- pc
	JEZ R3
	LOD R5,0
	LOD R3,R1+24
	JMP R3
	LOD R5,1

	# ifz t0 goto L1
	STO (R2+20),R5
	STO (R2+12),R6
	STO (R2+16),R7
	TST R5
	JEZ L1

	# j = 2
	LOD R8,2

	# i = 1
	LOD R6,1

	# goto L2
	STO (R2+8),R6
	STO (R2+12),R8
	JMP L2

	# label L1
L1:

	# actual i
	LOD R5,(R2+8)
	STO (R2+24),R5		// i -- parameter

	# call PRINTN
	STO (R2+28),R2
	LOD R4,R1+32
	STO (R2+32),R4
	LOD R2,R2+28
	JMP PRINTN

	# label L2
L2:

	# c = 2
	LOD R5,2

	# end
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

PRINTN:
	LOD R7,(R2-4) # 789
	LOD R15,R7 # 789  		// r15--show reg
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
	OUT					// about r15

	# ret
	LOD R3,(R2+4)
	LOD R2,(R2)			// restore r2
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

STATIC:
	DBN 0,0
STACK:
