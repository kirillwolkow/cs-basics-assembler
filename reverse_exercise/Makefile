reverse: reverse.o
	ld -o reverse reverse.o

reverse.o: reverse.asm
	nasm -f elf64 -g -F dwarf reverse.asm -l reverse.lst
