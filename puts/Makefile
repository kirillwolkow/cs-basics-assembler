puts: puts.asm
	nasm -f elf64 -g -F dwarf puts.asm
	gcc -no-pie -o puts puts.o

clean:
	rm -f puts
	rm -f puts.o
