org 0x07C00 				; 指出程序要被加载到绝对内存地址 0x7c00 处
	mov ax, cs
	mov ds, ax
	mov es, ax
	call DispStr 			; 调用子程序 DispStr
	jmp $					; 让程序无限循环下去而不退出

DispStr:
	mov ax, BootMessage 	; 将字符串变量 BootMessage 的首地址放入 ax 寄存器
	mov bp, ax
	mov cx, 16
	mov ax, 0x01301
	mov bx, 0x000C
	mov dl, 0
	int 0x10
	ret

BootMessage: db "Hello world!"

times 510-($-$$) db 0		; ($-$$) 表示当前行编译后的地址距离程序首地址的字节数，
							; 该句的含义为重复0直到510字节

dw 0xAA55 					; 在程序结尾添加上0xAA55。
							; BIOS 检测软盘 0 面 0 磁道 1 扇区，
							; 只有当该扇区最后两字节为 0xAA55 才认为是正确的引导扇区