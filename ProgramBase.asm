ROM = 0x000
RAM = 0xc00
VRAM = 0xe00
IO = 0xf00


#bankdef bank{
#bits 4
#labelalign 12
#addr_end 0xbff
#outp 0
}
#ruledef base{
	nop =>0x0
	load =>0x1
	store => 0x2
	set {value: i4}=> 0x3 @value
	push => 0x4
	pop => 0x5
	get => 0x6
	getsp => 0x7
	swap => 0x8
	add => 0x9
	sub => 0xa
	pushpc => 0xb
	setds => 0xc
	jump => 0xd
	skipz => 0xe
	skipc => 0xf
}

#ruledef extra{
	prepjmp {addr: i12} => asm{
		set {addr}[11:8]
		push
		set 0x3
		setds
		pop
		set {addr}[7:4]
		push
		set 0x2
		setds
		pop
		set {addr}[3:0]
		push
		set 0x1
		setds
		pop
	}
	addstack {value: i4} => asm{
		set 0x1
		add
		push
		swap
		pop
	}
	adddata {value: i4} => asm{
		incstack {value}
		pop
	}
}
#bank bank
main:
	nop