# 4-bit-processor
A 4-bit processor made in Logisim Evolution

# PROCESSOR
It’s a 4-bit processor with a 4-bit DATA bus and a 12-bit ADDRESS(up to 4k-nibbles) bus and an
instruction set of 16 instructions.

# INSTRUCTION SET
HEX Op Bin OperationDescription

0 0000 NOP Do nothing

1 0001 LOAD Load DATA from memory using the DS register

2 0010 STORE Save DATA on memory using the DS register

3 0011 SET Set the DATA register to a literal value

4 0100 PUSH Adds an element to the TOP of the STACK

5 0101 POP Removes and returns the TOP element from the STACK

6 0110 GET Returns an element using the DATA register as the STACK pointer
and save it on DATA

7 0111 GETSP Copy the STACK POINTER on the DATA register

8 1000 SWAP Swaps the two TOP elements on the STACK

9 1001 ADD Adds the DATA register and the STACK top and save the result on
DATA. Changes ZERO and CARRY flags

a 1010 SUB Subtract the STACK TOP from DATA, saves the result on DATA.
Changes ZERO and CARRY flags

b 1011 PUSHPC Push the PC value on the STACK

c 1100 SETDS Set the DS register using the DATA register as the index(L, M, H) and
writing the STACK value on it

d 1101 JUMP Copy the value on DS on the PC register

e 1110 SKIPZ Skip one line if ZERO flag is set

f 1111 SKIPC Skip one line if CARRY flag is set


# REGISTERS:
DATA: a 4-bit register

STACK: a register stack, with a 4-bit stack pointer for 16 4-bit memory cells.

STACK POINTER: a 4-bit register that points to the last added element of the stack.

PC: the PROGRAM COUNTER, a 12-bit register that point to the memory cell that contains the
next instruction to execute.

DS: the DESTINATION SELECTOR register, a 12-bit register used as a pointer to LOAD and
STORE, and used as the JUMP address.

ZERO and CARRY flag: 2 1-bit registers that keep information after an arithmetic operation is
executed.

The STACK: is a 4-bit address memory of 4-bit cells that starts at the cell 0(STACK[0]) and ends at
the cell 15(STACK[15]). The STACK[0] cell cant be pushed in or popped out of the STACK but
can be read by the GET instruction and be set by the SWAP instruction when the stack pointer is set
to 1.

# INSTRUCTIONS:
The fetching stage happens once the clock enters falling edge. The control unit will set the address
output to the PC value and send a read signal. The processor will halt until the attention signal is
received, and then save the incoming data as the next instruction to execute.
The word size is 4-bit and every instruction as well. Most of the instructions increment the PC when
they are finished with the exceptions listed next:

SET: increments the PC twice, one at the start to fetch the literal value to set, as they are
another 4-bit word, and one at the end.

JUMP: it doesn’t increments the PC, this will copy instead the DS value on to the PC.

SKIPZ and SKIPC: both increment the PC at the end but will increment it one more if the
corresponding flags are set.

SETDS: this instruction will use the DATA register as the parameter to choose which one of the
three parts DS register should get updated, using the 2 least important bits. The value 0 will point to
nothing, the value 1 will point to DS-L the lower part, the value 2 will point to DS-M the middle
part and the value 3 will point to DS-H the higher part of the register. The value to saber will be the
top value from the STACK.

# MEMORY MAPPING
000-BFF(3k-nibbles) is reserved for the ROM.

C00-DFF(512 nibbles) is reserved for RAM.

E00-EFF(256 nibbles) is reserved for VRAM(writes directly into the display).

F00-F7F(128 nibbles) is reserved for IO(input/output).

F80-FFF(128 nibbles) is reserved for expansions.

# USE CASE
The processor doesn’t need all the circuitry present on the main view of the Logisim file. This is
just a use case showing some kind of very limited console with a 16x16 display, four 7-segment
displays, a joystick(it works just like a four D-PAD) and two buttons(A and B).
You can change the context where you insert the chip and it should still working properly. Though I
recommend to reuse the BUS DRIVER as it contains the memory mapping.
The 16x16 display is composed by 256 4-bit(gray scale) pixels.

# PROGRAMMING

 It's possible to program by directly inserting hex values on the rom.
 But, I recommend you to use [customasm](https://hlorenzi.github.io/customasm/web/) and the ProgramBase.asm file to make thing easier.
 Once copied and the program is finished, select the "logisim 8/16 bit" format and save it on a text file(or .hex file), replace the "v2.0 raw" with "v3.0 hex bytes"
