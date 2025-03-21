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
		set {value}
		add
		push
		swap
		pop
	}
}
#bank bank

cell0 = 0xc00
cell1 = 0xc01
cell2 = 0xc02
cell3 = 0xc03
cell4 = 0xc04
cell5 = 0xc05
cell6 = 0xc06
cell7 = 0xc07
cell8 = 0xc08
cell9 = 0xc09
turn = 0xc0a
jx = 0xc0b
jy = 0xc0c
abutton = 0xc0d
bbutton = 0xc0e
cursorcell = 0xc0f

jxupdated = 0xc1b
jyupdated = 0xc1c
abtupdated = 0xc1d
bbtupdated = 0xc1e

main:
	nop
	prepjmp background
	jump
	.background_end:
	
	prepjmp grid
	jump
	.grid_end:
	
	.frame:
		prepjmp getinput
		jump
		..getinput_end:
	prepjmp .frame
	jump

getinput:
	set 0xb
	push
	.nextinput:
		prepjmp IO
		set 0x1
		setds
		load
		push
		prepjmp RAM
		set 0x1
		swap
		setds
		swap
		load
		push
		prepjmp 0xc10
		set 0x1
		get
		push
		set 0x1
		setds
		pop
		pop
		sub
		set 0x1
		push
		set 0x0
		skipz
		add
		store
		pop
		set 0x0
		push
		set 0x2
		setds
		pop
		pop
		store
		prepjmp .nextinput
		addstack 0x1
		set 0x1
		add
		skipc
		jump
		
	
	pop
	prepjmp main.frame.getinput_end
	jump

grid:
	set 0x0
	push
	.verticals:
		set 0x2
		setds
		set 0xe
		push
		set 0x3
		setds
		pop
		set 0x5
		push
		set 0x1
		setds
		set 0x0
		store
		pop
		set 0xa
		push
		set 0x1
		setds
		set 0x0
		store
		pop
		prepjmp .verticals
		addstack 0x1
		skipc
		jump

	.horizontals:
		set 0x1
		setds
		set 0xe
		push
		set 0x3
		setds
		pop
		set 0x5
		push
		set 0x2
		setds
		set 0x0
		store
		pop
		set 0xa
		push
		set 0x2
		setds
		set 0x0
		store
		pop
		prepjmp .horizontals
		addstack 0x1
		skipc
		jump
	pop
	prepjmp main.grid_end
	jump

background:
	set 0x0
	push
	.newline:
		push
	.newpixel:
		set 0xe
		push
		set 0x3
		setds
		pop
		set 0x1
		setds
		swap
		set 0x2
		setds
		swap
		set 0x7
		store
		prepjmp .newpixel
		addstack 0x1
		skipc
		jump
	pop
	prepjmp .newline
	addstack 0x1
	set 0x0
	skipc
	jump
	pop
	prepjmp main.background_end
	jump
