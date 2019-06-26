
segment  .text
	global 	shift_lfsr

; eax = lsfr
; retorna = eax = lsfr
	shift_lfsr:
		enter 4,0
		pusha
		pushf

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
		mov [ebp-4], eax

		popf
		popa
		mov eax, [ebp-4]
		leave
		ret
