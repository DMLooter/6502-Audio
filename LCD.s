PORTB = $6000
PORTA = $6001
DDRB  = $6002
DDRA  = $6003

E  = %10000000
RW = %01000000
RS = %00100000

	.org $8000		; org defines a memory location for the next instruction. Note that the binary file will still start at $0000
reset:
	lda #%11111111	; # means load immediate value, % means binary value
	sta DDRB		;

	lda #%11100000	; only the top three pins of Port A are needed for output
	sta DDRA


	lda #%00111000	; Function set(001), 8-bit(1), 2-line(1), 5x8(1), **(00).
	sta PORTB

	lda #0 			; clear RS/RW/E bits
	sta PORTA

	lda #E 			; toggle E bit on, then off to send instruction
	sta PORTA

	lda #0 			; clear RS/RW/E bits
	sta PORTA


	lda #%00001110	; Display on/off(00001), Display on(1), Cursor on(1), Blinking off(0)
	sta PORTB

	lda #0 			; clear RS/RW/E bits
	sta PORTA

	lda #E 			; toggle E bit on, then off to send instruction
	sta PORTA

	lda #0 			; clear RS/RW/E bits
	sta PORTA


	lda #%00000110	; Entry Mode Set(000001), Increment Cursor on write(1), Don't shift display(0)
	sta PORTB

	lda #0 			; clear RS/RW/E bits
	sta PORTA

	lda #E 			; toggle E bit on, then off to send instruction
	sta PORTA

	lda #0 			; clear RS/RW/E bits
	sta PORTA


	lda #"H"		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA

	lda #"e"		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA


	lda #"l"		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA


	lda #"l"		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA


	lda #"o"		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA


	lda #","		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA


	lda #' '		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA


	lda #"w"		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA


	lda #"o"		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA


	lda #"r"		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA


	lda #"l"		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA


	lda #"d"		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA


	lda #"!"		; ASCII String literal
	sta PORTB

	lda #RS			; set RS to data
	sta PORTA

	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA

	lda #RS			; set RS to data and E off
	sta PORTA

loop:
	jmp loop


	.org $fffc ; $7ffc on the eeprom
	.word reset; puts a literal value in the binary file (or the location of a label)
	.word $0000 ; padding to make bin file right size
