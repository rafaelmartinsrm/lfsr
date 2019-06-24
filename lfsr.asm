%macro _output 2		;%1=format, %2=value
	push	%2
	push	%1
	call	printf
	add	esp, 8
%endmacro

section .text
	global 	main
	extern 	printf
	LFSR_SEED	equ	01h 											;define SEED

main:
	xor	eax, eax			;eax=0
	xor	ebx, ebx			;ebx=0
	mov	eax, LFSR_SEED		;eax=LFSR_SEED
	mov edx, 0

print_loop:
	call	shift_lfsr		;call to shif_lfsr procedure
	mov ebx, eax
	shr ebx, 20
	add dword [counter + ebx*4], 1

	; push	eax			;save eax on stack
	; push edx
	; _output	format_num, eax		;print number
	; pop edx
	; pop	eax			;get eax

	inc edx
	cmp	edx, 0FFFFFFh		;compare with seed
	jne	print_loop		;continue loop

	jmp results	;

	mov	al, 1			;al=1
	xor	ebx, ebx			;ebx=0
	int	80h			;int 80h

shift_lfsr:
	mov	ecx, eax 															; ecx = eax
	mov	ebx, ecx 															; ebx = ecx
	shr ebx, 1																; (ebx = lfsr >> 2) # 22
	xor eax, ebx 															; (0 ^ 1)

	mov	ebx, ecx 															; ebx = lfsr
	shr ebx, 2																; (ebx = lfsr >> 2) # 21
	xor eax, ebx 															; (0 ^ 1 ^ 2)

	mov	ebx, ecx 															; ebx = lfsr
	shr ebx, 7																; (ebx = lfsr >> 7) # 17
	xor eax, ebx 															; (0 ^ 1 ^ 2 ^ 7)

	and eax, 1																; eax = bit
	shl eax, 23																; bit << 23
	shr ecx, 1																; lfsr >> 1
	or ecx, eax																; bit | lfsr
	mov eax, ecx															; ret = eax = ecx

	and eax, 0x00FFFFFF												; 24-bit

end:
	ret

results:
	mov eax, 0

print_results:
	mov ebx, [counter + eax*4]

	push eax
	_output	text1, ebx
	pop eax

	inc eax
	cmp eax, 16
	jne print_results

section .data
	format_hex:	db	"0x%08x", 10, 0 ;
	format_num:	db	"%d", 10, 0 ;
	text1:			db	"Frequencia Observada: %d", 10, 0

SECTION .bss
	counter resd 16;
