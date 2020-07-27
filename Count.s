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

	lda #253
	jsr print_number
	lda #253
	jsr print_number
	lda #252
	jsr print_number
	lda #251
	jsr print_number

	;ldy #0			; Initialize y offest register
;print:
	;tya
	;jsr print_number
	;iny
	;jmp print

loop:
	jmp loop

NUM = $1000			; Initially the number to be divided, then turns into the quotient
print_number:		; takes the number stored in the a register and outputs its decimal representation to the lcd.
	sta NUM			; put the number in RAM
	lda #%10000000
	jsr lcd_instruction			; Set cursor to beginning of display

	LDA #0			; zero out the remainder
	LDX #8			; set the bit number to 8
	ASL NUM			; Shift the top bit of NUM into carry bit
L100: ROL				; shift carry bit into low bit of A reg, effectively moving multiplier one digit lower.
	CMP #100		; compare A to 100
	BCC L200		; If A < 100, skip to L2
	SBC #100		; else, A = A-100
L200: ROL NUM		; Shift the top bit of NUM into carry bit
	DEX				; decrement bit number
	BNE L100		; If x != 0, jump to L1 and loop again, otherwise continue

	ldx NUM			; load the quotient into x register (hundreds digit)
	sta NUM			; put the remainder into the num to divide later
	lda ascii_decimal,x ; use quotient to pick asci digit for hundreds place
	jsr print_char

	LDA #0			; zero out the remainder
	LDX #8			; set the bit number to 8
	ASL NUM			; Shift the top bit of NUM into carry bit
L10: ROL			; shift carry bit into low bit of A reg, effectively moving multiplier one digit lower.
	CMP #10			; compare A to 10
	BCC L20			; If A < 10, skip to L2
	SBC #10			; else, A = A-10
L20: ROL NUM		; Shift the top bit of NUM into carry bit
	DEX				; decrement bit number
	BNE L10			; If x != 0, jump to L1 and loop again, otherwise continue

	ldx NUM			; load the quotient into x register (tens digit)
	sta NUM			; put the remainder (ones place) in memory
	lda ascii_decimal,x ; use quotient to pick asci digit for tens place
	jsr print_char

	ldx NUM			; load the ones place digit into offset register
	lda ascii_decimal,x ; use quotient to pick asci digit for once place
	jsr print_char




lcd_wait:
	pha				; store A reg on stack
	phx				; store x reg on stack
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
	plx				; pull x register back from stack
	pla				; pull A register back from stack
	rts

lcd_instruction:				; This assumes the full 8-bit instruction is stored in the a register
	jsr lcd_wait
	phx							; store x reg on stack
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
	plx							; pull x register back from stack
	rts							; return from subroutine

print_char:						; This assumes the 8-bit ASCII Character to print is in the a register
	jsr lcd_wait
	phx							; store x reg on stack
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
	plx							; pull x register back from stack
	rts							; return from subroutine


	.org $ff00	;asci representations of all characters, going up
ascii_decimal:
	.asciiz "0123456789"

	.org $fffc ; $7ffc on the eeprom
	.word reset; puts a literal value in the binary file (or the location of a label)
	.word $0000 ; padding to make bin file right size
