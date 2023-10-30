puts: printf.asm
	nasm -f elf64 -g -F dwarf printf.asm
	gcc -no-pie -o printf printf.o

clean:
	rm -f printf
	rm -f printf.o