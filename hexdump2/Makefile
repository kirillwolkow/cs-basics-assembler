hexdump2: hexdump2.o library.o
	ld -o hexdump2 hexdump2.o library.o

hexdump2.o: hexdump2.asm
	nasm -f elf64 -g -F dwarf hexdump2.asm -l hexdump2.lst

library.o: library.asm
	nasm -f elf64 -g -F dwarf library.asm -l library.lst