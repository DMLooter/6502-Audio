
code = bytearray([
  0xa9, 0xff,		# lda $ff
  0x8d, 0x02, 0x60,	# sta $6002, (DDRB), sets all pins to output.

  0xa9, 0x00,		# lda $00
  0x8d, 0x00, 0x60,	# sta #6000, (Port B output register)

  0xa9, 0x01,		# lda $01
  0x8d, 0x00, 0x60,	# sta #6000, (Port B output register)

  0xa9, 0x02,		# lda $02
  0x8d, 0x00, 0x60,	# sta #6000, (Port B output register)

  0xa9, 0x04,		# lda $04
  0x8d, 0x00, 0x60,	# sta #6000, (Port B output register)

  0xa9, 0x08,		# lda $08
  0x8d, 0x00, 0x60,	# sta #6000, (Port B output register)

  0xa9, 0x10,		# lda $10
  0x8d, 0x00, 0x60,	# sta #6000, (Port B output register)

  0xa9, 0x20,		# lda $20
  0x8d, 0x00, 0x60,	# sta #6000, (Port B output register)

  0xa9, 0x40,		# lda $40
  0x8d, 0x00, 0x60,	# sta #6000, (Port B output register)

  0xa9, 0x80,		# lda $80
  0x8d, 0x00, 0x60,	# sta #6000, (Port B output register)

  0x4c, 0x05, 0x80	#jmp $8005

  ])
rom = code + bytearray([0xea] * (32768-len(code)))

rom[0x7ffc] = 0x00 # Low byte program start
rom[0x7ffd] = 0x80 # High byte program start

with open("rom.bin", "wb") as out_file:
  out_file.write(rom);