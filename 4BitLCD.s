PORTB = $6000
PORTA = $6001
DDRB  = $6002
DDRA  = $6003

E  = %00000100
RW = %00000010
RS = %00000001

	.org $8000			; org defines a memory location for the next instruction. Note that the binary file will still start at $0000
reset:
	lda #%11111111		; Set all pins to output.
	sta DDRB


	lda #(%0010 << 4)			; partial initial function set for 4-bit mode
	sta PORTB

	ora #E 						; toggle E bit on then send to port b
	sta PORTB

	and #(~E)						; and !E with A register to turn the enable bit off.
	sta PORTB

	lda #(%0010 << 4)			; function set 1 for 4-bit mode
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #(%1000 << 4)			; function set 2 for 4-bit mode
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #(%0000 << 4)			; Display on 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #(%1110 << 4)			; Display on 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #(%0000 << 4)			; Entry mode 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #(%0110 << 4)			; Entry mode 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #((%0100 << 4) | RS)	; Display H 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #((%1000 << 4) | RS)	; Disply H 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #(("e" & %11110000) | RS)	; Display e 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #((("e" & %00001111) << 4)| RS)	; Disply e 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #(("l" & %11110000) | RS)	; Display l 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #((("l" & %00001111) << 4)| RS)	; Disply l 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #(("l" & %11110000) | RS)		; Display l 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #((("l" & %00001111) << 4)| RS)	; Disply l 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #(("o" & %11110000) | RS)		; Display o 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #((("o" & %00001111) << 4)| RS)	; Disply o 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #(("," & %11110000) | RS)		; Display , 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #((("," & %00001111) << 4)| RS)	; Display , 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #((' ' & %11110000) | RS)		; Display   1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #(((' ' & %00001111) << 4)| RS)	; Display   2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #(("w" & %11110000) | RS)		; Display w 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #((("w" & %00001111) << 4)| RS)	; Display w 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #(("o" & %11110000) | RS)		; Display o 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #((("o" & %00001111) << 4)| RS)	; Display o 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #(("r" & %11110000) | RS)		; Display r 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #((("r" & %00001111) << 4)| RS)	; Display r 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB



	lda #(('l' & %11110000) | RS)		; Display l 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #((('l' & %00001111) << 4)| RS)	; Display l 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #(('d' & %11110000) | RS)		; Display d 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #((('d' & %00001111) << 4)| RS)	; Display d 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB


	lda #(('!' & %11110000) | RS)		; Display ! 1
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

	lda #((('!' & %00001111) << 4)| RS)	; Display ! 2
	sta PORTB

	ora #E
	sta PORTB

	and #(~E)
	sta PORTB

loop:
	jmp loop


	.org $fffc ; $7ffc on the eeprom
	.word reset; puts a literal value in the binary file (or the location of a label)
	.word $0000 ; padding to make bin file right size
