[ORG 0x00]
[BITS 16]

START:
	mov ax, 0x1000				;Set registers to where entry.s is loaded
	mov ds, ax
	mov es, ax


;========= A20 GATE ========

;	;mov ax, 0x2401
;	;int 0x15



	mov ah, 2
	mov bh, 0
	mov dh, 3
	mov dl, 0
	mov cx, 1
	int 0x10
	

	mov si, msg
	print:
	lodsb
	or al, al
	jz .done
	mov ah, 0x0e
	mov bl, 0010
	int 0x10
	jmp print

.done:
	jmp $



msg db "In Kernel!", 0
