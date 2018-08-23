boot_img = bin/boot.img
boot_bin = bin/boot.bin
boot_asm = src/boot.asm
zeros_img = bin/zeros.img

all: $(boot_img)

$(boot_img): $(boot_bin) $(zeros_img)
	dd if=$(boot_bin)  of=$(boot_img) bs=512 count=1
	dd if=$(zeros_img) of=$(boot_img) skip=1 seek=1 bs=512 count=2879

$(zeros_img):
	dd if=/dev/zero of=$(zeros_img) bs=512 count=2880

$(boot_bin):
	nasm $(boot_asm) -o $(boot_bin)

clean:
	rm bin/*