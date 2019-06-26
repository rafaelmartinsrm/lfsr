%include "lfsr.inc"

%macro _output 2		;%1=format, %2=value
	push	%2
	push	%1
	call	printf
	add	esp, 8
%endmacro

segment .text
	global 	main
	extern 	printf
	LFSR_SEED	equ	01h 											;define semente

main:
	xor	eax, eax			;eax = 0
	xor	ebx, ebx			;ebx = 0
	mov	eax, LFSR_SEED		;eax = LFSR_SEED
	mov edx, 0

loop:
	call	shift_lfsr
	mov ebx, eax
	shr ebx, 20
	add dword [counter + ebx*4], 1

	; push	eax			; insere elementos na pilha
	; push edx
	; _output	format_num, eax		; imprime número
	; pop edx
	; pop	eax			; remove elementos da pilha eax


	inc edx
	cmp	edx, 0FFFFFFh		; compara com fim
	jne	loop		; continua loop

	jmp results	;

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

mov eax, 1 ; SYS_exit
mov ebx, 0 ; 0=OK , parametro de SYS_EXIT
int 0x80 ; chamada do kernel

section .data
	format_hex:	db	"0x%08x", 10, 0 ;
	format_num:	db	"%d", 10, 0 ;
	text1:			db	"Frequencia Observada: %d", 10, 0

SECTION .bss
	counter resd 16;
