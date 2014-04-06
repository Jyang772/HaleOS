[ORG 0x00]
[BITS 16]

START:
	mov ax, 0x1000				;Set registers to where entry.s is loaded
	mov ds, ax
	mov es, ax


;========= A20 GATE ========
				;Enable A20 using BIOS
	mov ax, 0x2401
	int 0x15

	jc A20GATEERROR		;If fail. Try to enable A20 via System Port A
	jmp A20GATESUCCESS


A20GATEERROR:
	cli
	
	lgdt [GDTR]			;Special CPU instruction to load GDT
		
	mov eax, 0x4000003B		; PG=0, CD=1, NW=0, AM=0, WP=0, NE=1, ET=1, TS=1, EM=0, MP=1, PE=1 
	mov cr0, eax

	jmp dword 0x18:(PROTECTEDMODE - $$ + 0x10000)


[BITS 32]
PROTECTEDMODE:
	mov ax, 0x10			;Set up stack!
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	

	mov ss, ax
	mov esp, 0xffff
	mov ebp, 0xffff
	
	push (MODESWITCHMESSAGE - $$ + 0x10000)
	push 3
	push 0
	call PRINTMESSAGE
	add 	esp, 12	



		


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
