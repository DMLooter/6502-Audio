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


	lda #(%0010 << 4)			; partial initial function set for 4-bit mode, cant use subroutine
	sta PORTB
	ora #E 						; toggle E bit on then send to port b
	sta PORTB
	and #(~E)					; and !E with A register to turn the enable bit off.
	sta PORTB

	lda #%00101000				; function set for 4-bit Mode
	jsr lcd_instruction

	lda #%00001110				; display on, cursor on
	jsr lcd_instruction

	lda #%00000110				; Entry mode increment cursor, dont shift display
	jsr lcd_instruction


	lda #'H'					; Load H into the a register
	jsr print_char				; print

	lda #'e'					; Load e into the a register
	jsr print_char				; print

	lda #'l'					; Load l into the a register
	jsr print_char				; print

	lda #'l'					; Load l into the a register
	jsr print_char				; print

	lda #'o'					; Load o into the a register
	jsr print_char				; print

	lda #','					; Load , into the a register
	jsr print_char				; print

	lda #' '					; Load space into the a register
	jsr print_char				; print

	lda #'w'					; Load w into the a register
	jsr print_char				; print

	lda #'o'					; Load o into the a register
	jsr print_char				; print

	lda #'r'					; Load r into the a register
	jsr print_char				; print

	lda #'l'					; Load l into the a register
	jsr print_char				; print

	lda #'d'					; Load d into the a register
	jsr print_char				; print

	lda #'!'					; Load ! into the a register
	jsr print_char				; print

loop:
	jmp loop

lcd_wait:
	pha				; store A reg on stack
	lda #%00001111	; Set high four of port B to input
	sta DDRB
lcd_busy:			; start loop
	lda #RW			; Set read bit
	sta PORTB
	lda #(RW | E)	; Toggle enable bit on.
	sta PORTB
	ldx PORTB		; Read bits	into x register
	lda #RW			; Toggle enable off
	sta PORTB

	lda #(RW | E)	; Do second "read"
	sta PORTB

	txa				; put the read data back to the a register.
	and #%10000000	; zero out all but the busy flag. Will set processor zero flag if the busy flag is zero.
	bne lcd_busy	; If processor zero flag is not set, busy flag IS set, and we loop back

	lda #RW			; reset enable low
	sta PORTB
	lda #%11111111	; Set port B back to output
	sta DDRB
	pla				; pull A register back from stack
	rts

lcd_instruction:				; This assumes the full 8-bit instruction is stored in the a register
	jsr lcd_wait
	tax							; Copy the instruction into the x register.
	and #$f0					; select top four bits of command
	sta PORTB					; put command on output, RS = 0, R/w = 0
	ora #E						; toggle Enable.
	sta PORTB
	and #(~E)
	sta PORTB

	txa							; transfer the full command back into the a register
	and #$0f					; select low four bits
	asl							; Shift those four bits to the high four.
	asl
	asl
	asl
	sta PORTB					; set the datalines to the lcd
	ora #E						; toggle Enable bit to write
	sta PORTB
	and #(~E)
	sta PORTB
	rts							; return from subroutine

print_char:						; This assumes the 8-bit ASCII Character to print is in the a register
	jsr lcd_wait
	tax
	and #$f0					; Select the top four bits of the cahracter
	ora #RS						; Or RS to the a register
	sta PORTB
	ora #E						; Toggle enable bit.
	sta PORTB
	and #(~E)
	sta PORTB

	txa							; transfer the full command back into the a register
	and #$0f					; select low four bits
	asl							; Shift those four bits to the high four.
	asl
	asl
	asl
	ora #RS						; Or RS to the a register
	sta PORTB					; set the datalines to the lcd
	ora #E						; toggle Enable bit to write
	sta PORTB
	and #(~E)
	sta PORTB
	rts							; return from subroutine


	.org $fffc ; $7ffc on the eeprom
	.word reset; puts a literal value in the binary file (or the location of a label)
	.word $0000 ; padding to make bin file right size
