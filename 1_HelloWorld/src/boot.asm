org	0x7c00					; 告诉编译器程序加载到7c00处
	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	call	DispStr 		; 调用显示字符串例程
	jmp	$					; 无限循环

DispStr:
	mov	ax, BootMessage
	mov	bp, ax				; ES:BP = 串地址
	mov	cx, 16				; CX = 串长度
	mov	ax, 0x01301			; AH = 13,  AL = 01h
	mov	bx, 0x000C			; 页号为0(BH = 0) 黑底红字(BL = 0Ch,高亮)
	mov	dl, 0
	int	0x10 				; 0x10 号中断
	ret

BootMessage:		db	"Hello world!"

times 	510-($-$$)	db	0	; 填充剩下的空间，使生成的二进制代码恰好为512字节
dw 	0xaa55					; 结束标志