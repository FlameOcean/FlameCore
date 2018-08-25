boot_com = bin/boot.com
boot_asm = src/boot.asm

all: $(boot_com)

$(boot_com):
	nasm $(boot_asm) -o $(boot_com)
	sudo mount -o loop tools/FreeDos/pm.img /mnt/floppy
	sudo cp $(boot_com) /mnt/floppy/
	sudo umount /mnt/floppy

clean:
	rm bin/*

run: $(boot_com)
	bochs -f tools/bochsrc