;Justin

[ORG 0x7c00]

[BITS 16]

;SECTION .text

jmp START			 
START:


	
cli
;mov ax, 0x07C0 ;set segment registers
;mov ds, ax
;mov es, ax
;mov fs, ax
;mov gs, ax


						; set DS(segment register) to the address of the bootloader. 

mov ax, 0xb800
mov es, ax						; set ES(segment register) to the address of the video memory starting address. 

; stack initialization
mov ax, 0x0000
mov ss, ax
mov sp, 0xffff
mov bp, 0xffff
sti
; clear the screen
mov si, 0
CLEARSCREEN:
	mov byte[es:si], 0
	mov byte[es:si + 1], 0x03			;Set all color attribute bytes to desired color

	add si, 2
	cmp si, 80 * 25 * 2

	jl CLEARSCREEN

; print welcome message

	push WELCOMEMESSAGE
	push 0
	push 0
	call PRINTMESSAGE
	add sp, 6
	
	; print OS loading message
	push OSIMAGELOADINGMESSAGE
	push 2
	push 0
	call PRINTMESSAGE
	add sp, 6

	; reset disk
	mov ax, 0x00
	mov dl, 0x00

	int 0x13
	jc DISKREADERROR



;================== 998 LEGACY DISK LOADER =======================

	; load OS image
	;mov ch, 0x00
	;mov cl, 0x02
	;mov dh, 0x00
	;mov dl, 0x00

	;mov si, 0x1000
	;mov es, si								; set the start address of OS image to 0x10000
	;mov bx, 0x0000
	
	;mov di, word[TOTALREADIMAGE]				
;LOADOSIMAGE:								;Print to screen without using interrupts
	;mov ah, 0x02							;Direct memory manipulation
	;mov al, 0x01

	;int 0x13
	;jc DISKREADERROR

	;sub di, 1
	;cmp di, 0
	;je FINISHLOADOSIMAGE

	;add si,	0x020 							;(0x02 * 16 = 512 bytes)
	;mov es, si

	;add cl, 0x01
	;cmp cl, 19

	;jl LOADOSIMAGE
	;mov cl, 0x01

	;add dh, 0x01
	;cmp dh, 2

	;jl LOADOSIMAGE 
	;mov dh, 0x00

	;add ch, 0x01
	;cmp ch, 80

	;jl LOADOSIMAGE
	;mov ch, 0x00

	;jmp LOADOSIMAGE
;============================ END 998 LEGACY DISK LOADER ===================================

;======================== NEW 998 DISK LOADER ====================================
	mov si, 0x1000
	mov es, si								; set the start address of OS image to 0x10000
	mov bx, 0x0000
	mov dh, 5
	mov dl, 0
	
	;mov di, word[TOTALREADIMAGE]


	disk_load:
	push dx                       ;Store DX to recall later sectors requested 
	                              ;(DH / DL used for INT 0x13 -0x02)
	mov ah, 0x02 		      ;Function code for reading 
	mov al, dh                    ;Read DH # of sectors
	mov ch, 0x00                  ;Select cylinder 0
	mov dh, 0x00                  ;Select head 0
	mov cl, 0x02                  ;Start from 2nd sector
	
	int 0x13
	jc DISKREADERROR
	
	pop dx
	cmp dh, al		      ;Compare the number of times read (AL contains actual sectors read count)
	jne DISKREADERROR	      ;to make sure all Dh sectors have been read
;===================================================================================




; print OS loading message
FINISHLOADOSIMAGE:
	push PASSMESSAGE
	push 2
	push 40
	call PRINTMESSAGE
	add sp, 6

	jmp $
;jmp 0x1000:0x0000						; jump to OS image	

;;;;;;;;;;;;;;;;;;;;;;
; FUNCTION
;;;;;;;;;;;;;;;;;;;;;;

; disk error handling
DISKREADERROR:
	push FAILMESSAGE
	push 2
	push 20
	call PRINTMESSAGE
	add sp, 6
	jmp $

; show welcome message
PRINTMESSAGE:
	push bp
	mov bp, sp

	push es									;|  pusha |
	push si									;| bp val |
	push di									;| ret. ad|
	push ax									;|    0   |
	push cx									;|    0	  |
	push dx									;|    msg |


	mov ax, word[bp + 4]
	mov bx, word[bp + 6]
	mov cx, word[bp + 8]

	mov si, 0
	add si, cx								; point to message address.

	mov di, 0
	imul bx, 160								;Width is 80 = 160 bytes(80)
	add di, bx
	imul ax, 2								;Multiply by number of bytes per character(2)
	add di, ax								; point to screen memory.

	mov ax, 0xb800
	mov es, ax

	SHOWMESSAGE:
		mov cl, byte[si]				; copy a character from the message to CX register.

		cmp cl, 0
		je SHOWMESSAGEEND					; If all characters of the message are printed, exit the loop.

		mov byte[es:di], cl					; print a character pointed by CX register.
		;mov byte[es:di+1], 01h		

		add si, 1						;http://www.supernovah.com/Tutorials/BootSector4.php
		add di, 2						;Color attribute comes one byte after character

		jmp SHOWMESSAGE

	SHOWMESSAGEEND:

	pop dx
	pop cx
	pop ax
	pop di
	pop si
	pop es

	pop bp
	ret

WELCOMEMESSAGE:
	db 'Welcome to HaleOS!', 0
OSIMAGELOADINGMESSAGE:
	db 'HALE OS Loading........................[    ]', 0
PASSMESSAGE:
	db 'Pass', 0
FAILMESSAGE:
	db 'Fail', 0

TOTALREADIMAGE:
	dw 1024

times 510 - ($ - $$) db 0x00	; fill address 0 to 510 with 0

dw 0xAA55
