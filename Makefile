NASM=nasm -f elf
GCC=gcc -m32
FILE=program

all:	clean compile link

compile:
	$(NASM) -d ELF_TYPE lfsr.asm
	$(NASM) $(FILE).asm

link:
	$(GCC) lfsr.o -o lfsr -nostdlib
	$(GCC) $(FILE).o -o $(FILE)

clean:
	rm -f $(FILE) $(FILE).o
	rm -f lfsr lfsr.o
