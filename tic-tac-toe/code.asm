; X and O objects are Z=0, Z=1 shows them
; Xwin and Owin are Z=0, Z=1 shows them
; Triggers are Z=1, Z=0 disables
; Triggers:  T_0_0 ... T_2_2
; X objects: X_0_0 ... X_2_2
; O objects: O_0_0 ... O_2_2

; ---------- setup ----------
SET R0 0	; turn counter: 0 = X, 1 = O

LABEL main_loop

	; ---------- input ----------

	; check all triggers
	#FOR i 0 2
		#FOR j 0 2
			; check if trigger is active
			GREATER R2 T_#i_#j.Pos.Z 0.5
			AND R2 R2 T_#i_#j.Act
			IF R2 activated_#i_#j
			GOTO not_activated_#i_#j
			LABEL activated_#i_#j
				; place X or O
				IF R0 dont_place_x_#i_#j
					 SET X_#i_#j.Pos.Z 1
				LABEL dont_place_x_#i_#j

				NOT R1 R0
				IF R1 dont_place_o_#i_#j
					 SET O_#i_#j.Pos.Z 1
				LABEL dont_place_o_#i_#j

				; disable trigger
				SET T_#i_#j.Pos.Z 0

				; swap turn
				NOT R0 R0
				GOTO checked

			LABEL not_activated_#i_#j
		#END
	#END

	LABEL checked

	; ---------- win ----------

	#FOR n 0 2
		; horizontal
		GREATER R1 X_#n_0.Pos.Z 0.5
		GREATER R2 X_#n_1.Pos.Z 0.5
		GREATER R3 X_#n_2.Pos.Z 0.5

		AND R1 R1 R2
		AND R1 R1 R3

		IF R1 winner_x

		; vertical
		GREATER R1 X_0_#n.Pos.Z 0.5
		GREATER R2 X_1_#n.Pos.Z 0.5
		GREATER R3 X_2_#n.Pos.Z 0.5

		AND R1 R1 R2
		AND R1 R1 R3

		IF R1 winner_x

		; horizontal
		GREATER R1 O_#n_0.Pos.Z 0.5
		GREATER R2 O_#n_1.Pos.Z 0.5
		GREATER R3 O_#n_2.Pos.Z 0.5

		AND R1 R1 R2
		AND R1 R1 R3

		IF R1 winner_o

		; vertical
		GREATER R1 O_0_#n.Pos.Z 0.5
		GREATER R2 O_1_#n.Pos.Z 0.5
		GREATER R3 O_2_#n.Pos.Z 0.5

		AND R1 R1 R2
		AND R1 R1 R3

		IF R1 winner_o
	#END

	; diagonal
	GREATER R1 X_0_0.Pos.Z 0.5
	GREATER R2 X_1_1.Pos.Z 0.5
	GREATER R3 X_2_2.Pos.Z 0.5

	AND R1 R1 R2
	AND R1 R1 R3

	IF R1 winner_x

	GREATER R1 X_2_0.Pos.Z 0.5
	GREATER R2 X_1_1.Pos.Z 0.5
	GREATER R3 X_0_2.Pos.Z 0.5

	AND R1 R1 R2
	AND R1 R1 R3

	IF R1 winner_x

	GREATER R1 O_0_0.Pos.Z 0.5
	GREATER R2 O_1_1.Pos.Z 0.5
	GREATER R3 O_2_2.Pos.Z 0.5

	AND R1 R1 R2
	AND R1 R1 R3

	IF R1 winner_o

	GREATER R1 O_2_0.Pos.Z 0.5
	GREATER R2 O_1_1.Pos.Z 0.5
	GREATER R3 O_0_2.Pos.Z 0.5

	AND R1 R1 R2
	AND R1 R1 R3

	IF R1 winner_o

	; check full
	SET R7 1
	#FOR i 0 2
		#FOR j 0 2
			LESS R6 T_#i_#j.Pos.Z 0.5
			AND R7 R7 R6
		#END
	#END

	IF R7 winner ; noone won

	SLEEP 0

GOTO main_loop

; show win color
LABEL winner_x

	SET Xwin.Pos.Z 1

GOTO winner
LABEL winner_o

	SET Owin.Pos.Z 1

LABEL winner

	; wait 3s
	SLEEP 3000

	; reset
	#FOR i 0 2
		#FOR j 0 2
			SET X_#i_#j.Pos.Z 0
			SET O_#i_#j.Pos.Z 0
			SET T_#i_#j.Pos.Z 1
		#END
	#END

	SET Xwin.Pos.Z 0
	SET Owin.Pos.Z 0

	; winner goes first
	NOT R0 R0

GOTO main_loop

