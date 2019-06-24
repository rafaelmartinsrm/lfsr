NASM=nasm -f elf
GCC=gcc -m32
FILE=lfsr

all:	clean compile link

compile:
	$(NASM) $(FILE).asm

link:
	$(GCC) $(FILE).o -o $(FILE)

clean:
	rm -f $(FILE) $(FILE).o
