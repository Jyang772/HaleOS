[ORG 0x00]
[BITS 16]

SECTION	.text

START:
	mov	ax, 0x1000
	mov	ds, ax
	mov	es, ax

	;;;;;;;;;;;;;;;;;;;;;;;;
	; A20 gate activation via BIOS
	;;;;;;;;;;;;;;;;;;;;;;;;
	mov ax, 0x2401
	int 0x15

	jc A20GATEERROR							;If fail, try with System Port A
	jmp A20GATESUCCESS
	
A20GATEERROR:
	in al, 0x92

	or al, 0x02
	and al, 0xFE

	out 0x92, al

A20GATESUCCESS:
	cli							; prevent interrupts

	lgdt	[GDTR]				; load GDTR structure to processor (Special CPU instruction)

	mov	eax, 0x4000003B			; PG=0, CD=1, NW=0, AM=0, WP=0, NE=1, ET=1, TS=1, EM=0, MP=1, PE=1
	mov	cr0, eax				; set CR0 register

	jmp	dword 0x18:(PROTECTEDMODE - $$ + 0x10000)		; set CS to 0x18(Code Segment Descriptor) (Abs. address)

[BITS 32]
PROTECTEDMODE:
	mov	ax, 0x10								; set DS, ES, FS, GS to 0x10(Data Segment Descriptor)
	mov	ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov	ss, ax									; set stack register(SS, ESP, EBP)
	mov	esp, 0xfffe
	mov	ebp, 0xfffe

	push	(MODESWITCHMESSAGE - $$ + 0x10000)
	push	3
	push	0	
	call	PRINTMESSAGE
	add		esp, 12

	push	(PASSMESSAGE - $$ + 0x10000)
	push	3
	push	40
	call	PRINTMESSAGE
	add		esp, 12

	jmp	dword 0x18:0x10200		; set CS to 0x18(Code Segment Descriptor)  (Jump to start of 64bit)

;;;;;;;;;;;;;;;;
; FUNCTION
;;;;;;;;;;;;;;;;

PRINTMESSAGE:
	push ebp
	mov ebp, esp

	push esi
	push edi
	push eax
	push ecx
	push edx

	mov eax, dword[ebp + 8]
	mov ebx, dword[ebp + 12]
	mov ecx, dword[ebp + 16]

	mov esi, 0
	add esi, ecx								; point to message address.

	mov edi, 0									; point to screen memory.
	imul ebx, 160
	add edi, ebx
	imul eax, 2
	add edi, eax								

	SHOWMESSAGE:
		mov cl, byte[esi]						; copy a character from the message to CX register.

		cmp cl, 0
		je SHOWMESSAGEEND						; If all characters of the message are printed, exit the loop.

		mov byte[edi + 0xb8000], cl				; print a character pointed by CX register.
		
		add esi, 1
		add edi, 2	

		jmp SHOWMESSAGE

	SHOWMESSAGEEND:

	pop edx
	pop ecx
	pop eax
	pop edi
	pop esi
	pop ebp
	ret

;;;;;;;;;;;;;;;;
; DATA
;;;;;;;;;;;;;;;;
;align 8, db 0

dw 0x0000

GDTR:
	dw	GDTEND - GDT - 1		; size of GDT
	dd	(GDT - $$ + 0x10000)	; 32-bit base address

GDT:
	NULLDESCRIPTOR:
		dw	0x0000
		dw	0x0000
		db	0x00  
		db	0x00  
		db	0x00
		db	0x00

	IA_32eCODESEGMENTDESCRIPTOR:
		dw	0xffff	; segment size(15:00)
		dw	0x0000	; base address(15:00)
		db	0x00	; base address(23:16)
		db	0x9a	; P=1, DPL=0, S=1, Type=0x0a(Execute/Read)
		db	0xaf	; G=1, D/B=0, L=1, AVL=0, segment size(19:16)
		db	0x00	; base address(31:24)

	IA_32eDATASEGMENTDESCRIPTOR:
		dw	0xffff	; segment size(15:00)
		dw	0x0000	; base address(15:00)
		db	0x00	; base address(23:16)
		db	0x92	; P=1, DPL=0, S=1, Type=0x02(Read/Write)
		db	0xaf	; G=1, D/B=0, L=1, AVL=0, segment size(19:16)
		db	0x00	; base address(31:24)

	CODESEGMENTDESCRIPTOR:
		dw	0xffff	; segment size(15:00)
		dw	0x0000	; base address(15:00)
		db	0x00	; base address(23:16)
		db	0x9a	; P=1, DPL=0, S=1, Type=0x0a(Execute/Read)
		db	0xcf	; G=1, D/B=1, L=0, AVL=0, segment size(19:16)
		db	0x00	; base address(31:24)

	DATASEGMENTDESCRIPTOR:
		dw	0xffff	; segment size(15:00)
		dw	0x0000	; base address(15:00)
		db	0x00	; base address(23:16)
		db	0x92	; P=1, DPL=0, S=1, Type=0x02(Read/Write)
		db	0xcf	; G=1, D/B=1, L=0, AVL=0, segment size(19:16)
		db	0x00	; base address(31:24)
GDTEND:

MODESWITCHMESSAGE:
	db	'Switching to Protected Mode............[    ]', 0
PASSMESSAGE:
	db	'Pass', 0
FAILMESSAGE:
	db	'Fail', 0

times 512 - ($ - $$) db 0x00
