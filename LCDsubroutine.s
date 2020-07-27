PORTB = $6000
PORTA = $6001
DDRB  = $6002
DDRA  = $6003

E  = %10000000
RW = %01000000
RS = %00100000

	.org $8000		; org defines a memory location for the next instruction. Note that the binary file will still start at $0000
reset:
	lda #%11111111	; set all Port b pins to output.
	sta DDRB		;

	lda #%11100000	; only the top three pins of Port A are needed for output
	sta DDRA

	lda #%00111000	; Function set(001), 8-bit(1), 2-line(1), 5x8(1), **(00).
	jsr lcd_instruction

	lda #%00001110	; Display on/off(00001), Display on(1), Cursor on(1), Blinking off(0)
	jsr lcd_instruction

	lda #%00000110	; Entry Mode Set(000001), Increment Cursor on write(1), Don't shift display(0)
	jsr lcd_instruction
	lda #%00000001	; Clear Display
	jsr lcd_instruction


	lda #"H"		; ASCII String literal
	jsr print_char

	lda #"e"		; ASCII String literal
	jsr print_char

	lda #"l"		; ASCII String literal
	jsr print_char

	lda #"l"		; ASCII String literal
	jsr print_char

	lda #"o"		; ASCII String literal
	jsr print_char

	lda #","		; ASCII String literal
	jsr print_char

	lda #' '		; ASCII String literal
	jsr print_char

	lda #"w"		; ASCII String literal
	jsr print_char

	lda #"o"		; ASCII String literal
	jsr print_char

	lda #"r"		; ASCII String literal
	jsr print_char

	lda #"l"		; ASCII String literal
	jsr print_char

	lda #"d"		; ASCII String literal
	jsr print_char

	lda #"!"		; ASCII String literal
	jsr print_char

loop:
	jmp loop

lcd_wait:
	pha				; store A reg on stack
	lda #%00000000	; Set port B to input
	sta DDRB
lcd_busy:			; start loop
	lda #RW
	sta PORTA
	lda #(RW | E)	; pulse Enable high
	sta PORTA
	lda PORTB
	and #%10000000	; zero out all but busy flag. Will set zero flag if the busy flag is zero.
	bne lcd_busy	; If zero flag is not set, busy flag IS set, and we loop back

	lda #RW			; reset enable low
	sta PORTA
	lda #%11111111	; Set port B back to output
	sta DDRB
	pla				; pull A register back from stack
	rts

lcd_instruction:
	jsr lcd_wait
	sta PORTB
	lda #0 			; clear RS/RW/E bits
	sta PORTA
	lda #E 			; toggle E bit on, then off to send instruction
	sta PORTA
	lda #0 			; clear RS/RW/E bits
	sta PORTA
	rts				; return from subroutine


print_char:
	jsr lcd_wait
	sta PORTB
	lda #RS			; set RS to data
	sta PORTA
	lda #(RS | E)	; toggle E bit on, then off to send instruction
	sta PORTA
	lda #RS			; set RS to data and E off
	sta PORTA
	rts				;return

	.org $fffc ; $7ffc on the eeprom
	.word reset; puts a literal value in the binary file (or the location of a label)
	.word $0000 ; padding to make bin file right size
