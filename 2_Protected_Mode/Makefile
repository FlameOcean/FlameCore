boot_img = bin/boot.img
boot_bin = bin/boot.bin
boot_asm = src/boot.asm

all: $(boot_img)

$(boot_img): $(boot_bin)
	dd if=/dev/zero of=$(boot_img) bs=512 count=2880
	dd if=$(boot_bin)  of=$(boot_img) bs=512 count=1 conv=notrunc
	bash tools/aa55.sh $(boot_img)

$(boot_bin):
	nasm $(boot_asm) -o $(boot_bin)

clean:
	rm bin/*

bochs: $(boot_img)
	bochs -f tools/bochsrc

qemu: $(boot_img)
	qemu-system-i386 -drive format=raw,file=$(boot_img) &

gdb: $(boot_img)
	gdb -q -x tools/gdbrc

