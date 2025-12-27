;
;  10 body gravity simulation
;  generates ~1923 lines of GASM
;  uses Rot to store velocity
;

; ---------- setup ----------

; random starting positions
#FOR n 0 9
	; 0  - 20
	RAND R0 20
	RAND R1 20
	RAND R2 20

	; -10 - 10
	SUB Obj_#n.Pos.X R0 10
	SUB Obj_#n.Pos.Y R1 10
	SUB Obj_#n.Pos.Z R2 10
#END

; zero out rotations to store velocity

#FOR n 0 9
	SET Obj_#n.Rot.X 0
	SET Obj_#n.Rot.Y 0
	SET Obj_#n.Rot.Z 0
#END

; ---------- update ----------

LABEL LOOP

	#FOR i 0 9

		; accumulate gravity

		SET R0 0
		SET R1 0
		SET R2 0

		#FOR j 0 9
			#IF i != j

				; |d| = sqrt(dx^2 + dy^2 + dz^2 + e)

				; dist

				SUB R3 Obj_#j.Pos.X Obj_#i.Pos.X
				SUB R4 Obj_#j.Pos.Y Obj_#i.Pos.Y
				SUB R5 Obj_#j.Pos.Z Obj_#i.Pos.Z
				
				; square
	
				MUL R3 R3 R3
				MUL R4 R4 R4
				MUL R5 R5 R5

				; sum

				ADD R6 R3 R4
				ADD R6 R6 R5
				ADD R6 R6 0.000000001

				; inverse square

				DIV R6 1 R6

				; get dist again

				SUB R3 Obj_#j.Pos.X Obj_#i.Pos.X
				SUB R4 Obj_#j.Pos.Y Obj_#i.Pos.Y
				SUB R5 Obj_#j.Pos.Z Obj_#i.Pos.Z

				; apply

				MUL R3 R3 R6
				MUL R4 R4 R6
				MUL R5 R5 R6

				; accumulate

				ADD R0 R0 R3
				ADD R1 R1 R4
				ADD R2 R2 R5

				#IF j == 0
					; 2x for object 0
					ADD R0 R0 R3
					ADD R1 R1 R4
					ADD R2 R2 R5
				#END

			#END
		#END

		; multiply by speed

		MUL R0 R0 0.013
		MUL R1 R1 0.013
		MUL R2 R2 0.013

		; add gravity to velocity

		ADD Obj_#i.Rot.X Obj_#i.Rot.X R0
		ADD Obj_#i.Rot.Y Obj_#i.Rot.Y R1
		ADD Obj_#i.Rot.Z Obj_#i.Rot.Z R2

	#END

	; move by velocity

	#FOR i 0 9

		ADD Obj_#i.Pos.X Obj_#i.Pos.X Obj_#i.Rot.X
		ADD Obj_#i.Pos.Y Obj_#i.Pos.Y Obj_#i.Rot.Y
		ADD Obj_#i.Pos.Z Obj_#i.Pos.Z Obj_#i.Rot.Z

	#END

SLEEP 0
GOTO LOOP



