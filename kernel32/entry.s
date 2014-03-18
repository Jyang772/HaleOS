[ORG 0x00]
[BITS 16]

START:
	mov ax, 0x1000				;Set registers to where entry.s is loaded
	mov ds, ax
	mov es, ax


;========= A20 GATE ========

	mov ax, 0x2401
	int 0x15
