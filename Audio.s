; Note to self, CLC before all 8-bit adds, SEC before all 8-bit subtracts

PORTB = $4000
PORTA = $4001
DDRB  = $4002
DDRA  = $4003

AUDIOSELECT = $4010 ; Address to write the byte for which audio device will accept the data on the Audio data port
AUDIODATA = $4011 ; Address to write the byte of dat to be taken into the selected audio device
DDRSELECT = $4012 ; Should always be all output
DDRDATA = $4013 ; Should always be all output.

CHANNELLOC = $1000 ; the location where the channel number is stored when calling a sub routine
DATALOC = $1001 ; the location where the extra data is stored when calling a sub routine
BYTELOC = $1002 ; the location where the currently sending byte is stored

SIDMIDILOOKUP = $f000
SNMIDILOOKUP = $f100

; Channel layout:
; SID 1-3 : 0 - 2
; SN1 1-4 : 3 - 6
; SN2 1-4 : 7 - 10
; SN3 1-4 : 11- 14

NONE= %00001111 ; Selecting none
SN1 = %00001110	; WEB for the first SN chip
SN2 = %00001101 ; WEB for the second SN chip
SN3 = %00001011 ; WEB for the third SN chip
SID = %00000111 ; WEB for the SID chip


	;.org $0000

	.org $8000			; org defines a memory location for the next instruction. Note that the binary file will still start at $0000
reset:
	lda #%11111111		; Set all pins to output.
	sta DDRB
	sta PORTB
	sta DDRSELECT	; for WEB
	sta DDRDATA		; and data lines
	sta AUDIOSELECT ; set all WEB to high (false)
	sta AUDIODATA

	lda #3
	sta CHANNELLOC

	lda #%10000111
	sta BYTELOC
	jsr write_byte_SN1

	lda #%00100000
	sta BYTELOC
	jsr write_byte_SN1

	lda #0
	sta DATALOC
	jsr SN_set_vol

loop:
	jmp loop

; The following methods allow the processor to send instructions to the SN chips. For this to occur, the following must be true:
; For note, the channel (3 - 5, 7-9, 11-13) at CHANNELLOC, the midi note number (0 - 127) at DATALOC
; For volume, the channel (3 - 14) at CHANNELLOC, the attenuation value (0 - 15) at DATALOC
; For noise, the channel (6, 10, 14) at CHANNELLOC, the noise control values (NF1,NF0,FB,0,0,0,0,0) at DATALOC
; Note that this data is not guaranteed to be maintained
SN_set_note:
	pha



	pla
	rts
SN_set_vol:
	pha

	lda CHANNELLOC
	sec
	sbc #3 ; turns the channel number into the number on a single SN chip
	jsr mod4
	; Now acc has the 2-bit channel number (D6, D5), and we shift it into the proper position
	; We use asl instead of rol, beacuse then we dont have to worry about the carry being put into bit 0
	asl
	asl
	asl
	asl
	asl
	ora #%10010000 ; Here we add the proper D7 1, and the register type bit (D4) 1 for volume
	and #%11110000 ; and ensure it only takes up the first four bits (maybe not needed but i want to be safe, it costs 2 bytes and 2 cycles)
	sta $0000
	; Now Memlocation $0000 has the first four bits of the command

	lda DATALOC ; loads the volume (attenuation) number
	and #%00001111 ; ensure that our volume only takes up the last four bits.
	ora $0000 ; now we or back in the first four digits.
	sta BYTELOC
	jsr write_byte

	pla
	rts

SN_set_noise:
	pha

	lda #%11100000 ; The register for noise control is always the same (110)
	ora DATALOC ; Then or the control values (already in place) into the a register
	sta BYTELOC
	jsr write_byte

	pla
	rts

; Writes the byte at location BYTELOC to the device corresponding to the channel at CHANNELLOC
write_byte:
	lda CHANNELLOC
	adc #1 ; add one to allign the channels with multiple of 4 boundaries
	jsr div4
sid:
	cmp #0
	bne sn1
	jsr write_byte_SID
	rts
sn1:
	cmp #1
	bne sn2
	jsr write_byte_SN1
	rts
sn2:
	cmp #2
	bne sn3
	jsr write_byte_SN2
	rts
sn3:
	jsr write_byte_SN3
	rts

; TODO
write_byte_SID:
	rts

; Sends the byte at location BYTELOC to SN chip 1
write_byte_SN1:
	lda BYTELOC
	sta AUDIODATA ; setup the data lines

	; Pulse WEB low then back high
	;lda #$00
	lda #SN1
	sta AUDIOSELECT
	;start a loop to wait at least 32 cycles.
	phx ; 3
	ldx #6 ; 2
wait1:
	dex ; 2
	bne wait1 ; 3
	plx ; 3

	lda #NONE
	;lda #$ff
	sta AUDIOSELECT
	; This may not be long enough, so we can add some no-ops.
	rts

; Sends the byte at location BYTELOC to SN chip 2
write_byte_SN2:
	lda BYTELOC
	sta AUDIODATA ; setup the data lines

	; Pulse WEB low then back high
	lda #SN2
	sta AUDIOSELECT
	;start a loop to wait at least 32 cycles.

	phx ; 3
	ldx #6 ; 2
wait2:
	dex ; 2
	bne wait2 ; 3
	plx ; 3

	lda #NONE
	sta AUDIOSELECT
	; This may not be long enough, so we can add some no-ops.
	rts

; Sends the byte at location BYTELOC to SN chip 3
write_byte_SN3:
	lda BYTELOC
	sta AUDIODATA ; setup the data lines

	; Pulse WEB low then back high
	lda #SN3
	sta AUDIOSELECT
	
	;start a loop to wait at least 32 cycles.
	phx ; 3
	ldx #6 ; 2
wait3:
	dex ; 2
	bne wait3 ; 3
	plx ; 3

	lda #NONE
	sta AUDIOSELECT
	; This may not be long enough, so we can add some no-ops.
	rts

; Takes the a register and returns the remander after being divided by 4
mod4:
	sec
	sbc #4
	bpl mod4 ; if a reg is still positive, subtract again
	adc #4 ; add four back to the accumulator, beacuse we must go negative (past zero) to reach here
	rts

; Takes the a register and returns the integer quotient after dividing by 4
div4:
	phx
	ldx #0
div_loop:
	sec
	inx ; increment x
	sbc #4
	bpl div_loop ; if a reg is still positive, subtract again
	dex ; decrement x, because we go one past the correct answer
	txa	; put x value onto the accumulator
	plx ; regain x register from stack

	rts


	.org SIDMIDILOOKUP ; SID midi -> 2 byte frequency divider

	.org SNMIDILOOKUP ; SN midi -> 2 byte frequency divider (in proper order)

	.org $fffc ; $7ffc on the eeprom
	.word reset; puts a literal value in the binary file (or the location of a label)
	.word $0000 ; padding to make bin file right size
