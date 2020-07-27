PORTB = $6000 ; $ means hex value, no # means address location.
PORTA = $6001
DDRB = $6002
DDRA = $6003

 .org $8000 ; org defines a memory location for the next instruction. Note that the binary file will still start at $0000
reset:
  lda #$ff ; # means load immediate value
  sta DDRB

  lda #$50
  sta PORTB

loop:
  ror
  sta PORTB

  jmp loop ; jump back to the label, not to a literal address.

  .org $fffc ; $7ffc on the eeprom
  .word reset; puts a literal value in the binary file (or the location of a label)
  .word $0000 ; padding to make bin file right size
