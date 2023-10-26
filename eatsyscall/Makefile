eatsyscall64: eatsyscall64.o
	ld -o eatsyscall64 eatsyscall64.o

eatsyscall64.o: eatsyscall64.asm
	nasm -f elf64 -g -F dwarf eatsyscall64.asm -o eatsyscall64.o -l eatsyscall64.lst

clean:
	rm -f eatsyscall64
	rm -f eatsyscall64.o
	rm -f eatsyscall64.lst
