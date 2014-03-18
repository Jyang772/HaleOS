[ORG 0x00]
[BITS 16]

START:
	mov ax, 0x1000				;Set registers to where entry.s is loaded
	mov ds, ax
	mov es, ax


;========= A20 GATE ========

;	mov ax, 0x2401
;	int 0x15

	
	call Print



Print:
	lodsb
	or al, al
	jz .done
	mov ah, 0x0E
	int 0x10
	jmp Print
	
	.done:
	jmp $




msg db "In Kernel!", 0
