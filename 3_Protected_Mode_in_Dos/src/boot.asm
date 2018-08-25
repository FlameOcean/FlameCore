%include "src/pm.inc"
org 0x0100
	jmp LABEL_BEGIN

[SECTION .gdt]
; GDT
; 								段基址	,	段界限			,	属性
LABEL_GDT:			Descriptor	0		,	0				,	0			 ; 空描述符
LABEL_DESC_CODE32:	Descriptor	0		,	SegCode32Len - 1,	DA_C + DA_32 ; 非一致代码段
LABEL_DESC_VIDEO:	Descriptor	0x0B8000,	0x0FFFF			,	DA_DRW		 ; 显存首地址

GdtLen	equ	$ - LABEL_GDT	; 获取 GDT 长度，equ 为赋值运算符
GdtPtr	dw	GdtLen - 1		; GDT 界限，dw 为字（2 字节）类型
		dd 	0				; GDT 基地址，dd 为双字类型

; GDT 选择子
SelectorCode32		equ		LABEL_DESC_CODE32 - LABEL_GDT
SelectorVideo		equ		LABEL_DESC_VIDEO  - LABEL_GDT

[SECTION .s16]
[BITS      16]
LABEL_BEGIN:
	mov 	AX, CS
	mov 	DS, AX
	mov 	ES, AX
	mov 	SS, AX
	mov 	SP, 0x0100

	; 初始化 32 位代码段描述符
	xor 	EAX, EAX				; 将 EAX 寄存器内容置 0
	mov 	AX, CS
	shl 	EAX, 4					; 将 EAX 中内容左移 4 位，最高位移入标志位 CF，最低位补 0
	add 	EAX, LABEL_SEG_CODE32	; 将保护模式代码段起始地址赋给 EAX
	mov 	word [LABEL_DESC_CODE32 + 2], AX
	shr 	EAX, 16
	mov 	byte [LABEL_DESC_CODE32 + 4], AL
	mov 	byte [LABEL_DESC_CODE32 + 7], AH

	; 为加载 GDTR 做准备
	xor 	EAX, EAX
	mov 	AX, DS
	shl 	EAX, 4
	add 	EAX, LABEL_GDT
	mov 	dword [GdtPtr + 2], EAX

	lgdt 	[GdtPtr]	; 将 GdtPtr 内容加载到寄存器 GDTR
	cli 				; 关中断

	; 打开地址线 A20
	in 		AL, 0x92
	or 		AL, 00000010b
	out 	0x92, AL

	; 将 CR0 寄存器的 PE 位（最低位）置 1
	mov 	EAX, CR0
	or 		EAX, 1
	mov 	CR0, EAX

	; 真正进入保护模式
	jmp 	dword SelectorCode32:0	; 将 SectorCode32 装入 CS
									; 并跳转到 Code32Sector:0 处

[SECTION .32]
[BITS	  32]
LABEL_SEG_CODE32: ; 32 位代码段的起始地址
	mov 	AX, SelectorVideo
	mov 	GS, AX
	mov 	EDI, (80 * 11 + 79) * 2	; 屏幕第 11 行，第 79 列
	mov 	AH, 0x0C	; 0000: 黑底  1100: 红字
	mov 	AL, 'P'
	mov 	[GS:EDI], AX
	jmp 	$		; 到此停止

SegCode32Len	equ		$ - LABEL_SEG_CODE32