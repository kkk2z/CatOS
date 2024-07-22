# Makefile
C_SOURCES = $(wildcard kernel/*.c apps/*.c)
HEADERS = $(wildcard include/*.h)
OBJ = ${C_SOURCES:.c=.o}

CC = gcc
CFLAGS = -m32 -g -ffreestanding -Wall -Wextra

kernel.bin: boot/boot.o ${OBJ}
	ld -m elf_i386 -Ttext 0x1000 $^ -o $@ --oformat binary

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -c $< -o $@

boot/boot.o: boot/boot.s
	nasm -f elf32 $< -o $@

os-image.bin: kernel.bin
	dd if=/dev/zero bs=512 count=2048 of=os-image.bin
	dd if=kernel.bin of=os-image.bin conv=notrunc

clean:
	rm -f boot/*.o kernel/*.o apps/*.o kernel.bin os-image.bin
