;
;  30x30 conways game of life with one code block
;  generates 37091 lines of GASM (~4.9s per frame)
;  cells are on (z = 0.2) or off (z = 0)
;  to update they are moved +-0.01 and then mapped back to 0.2 or 0
;

; random starting point

#FOR x 0 29
	#FOR y 0 29
		RAND R0 2 ; 0 or 1
		MUL R0 R0 0.2 ; 0 or 0.2
		SET Cell_#x_#y.Pos.Z R0
	#END
#END

; update loop

LABEL LOOP

#FOR x 0 29
	#FOR y 0 29

		; count neighbors

		SET R0 0 ; count

		#FOR dx x-1 x+1
			#FOR dy y-1 y+1

			; bounds check
			#IF dx < 30
			#IF dx >= 0
			#IF dy < 30
			#IF dy >= 0

				#IF dy != y
					GREATER R3 Cell_#dx_#dy.Pos.Z 0.1
					ADD R0 R0 R3
				#END
				#IF dx != x
					#IF dy == y
						GREATER R3 Cell_#dx_#dy.Pos.Z 0.1
						ADD R0 R0 R3
					#END
				#END

			#END
			#END
			#END
			#END

			#END
		#END

		; determine next state

		; current alive state
		GREATER R3 Cell_#x_#y.Pos.Z 0.1

		; is_alive = n == 3 || (n == 2 && was_alive)
		EQUAL R4 R0 3
		EQUAL R5 R0 2
		AND R5 R5 R3
		OR R5 R5 R4
		IF R5 alive_#x_#y

			; cell dies
			SUB Cell_#x_#y.Pos.Z Cell_#x_#y.Pos.Z 0.01

		GOTO done_#x_#y
		LABEL alive_#x_#y

			; cell lives
			ADD Cell_#x_#y.Pos.Z Cell_#x_#y.Pos.Z 0.01

		LABEL done_#x_#y

	#END
#END

; go to next state

#FOR x 0 29
	#FOR y 0 29

		; cells are within { -0.01, 0.0, 0.01, 0.19, 0.2, 0.21 }
		; map to           {  0.0,  0.0, 0.2,  0.0,  0.2, 0.2  }

		; is_alive = (z > 0.001 && z < 0.011) || (z > 0.191)
		GREATER R4 Cell_#x_#y.Pos.Z 0.001
		LESS R5 Cell_#x_#y.Pos.Z 0.011
		GREATER R6 Cell_#x_#y.Pos.Z 0.191
		AND R4 R4 R5
		OR R4 R4 R6
		IF R4 set_alive_#x_#y

			; cell dies
			SET Cell_#x_#y.Pos.Z 0

		GOTO set_done_#x_#y
		LABEL set_alive_#x_#y

			; cell lives
			SET Cell_#x_#y.Pos.Z 0.2

		LABEL set_done_#x_#y

	#END
#END

SLEEP 0
GOTO LOOP

