	AREA	lib, CODE, READWRITE	
	EXPORT lab3
	EXPORT pin_connect_block_setup_for_uart0
	
U0LSR EQU 0x14			; UART0 Line Status Register

lab3
	;write 



is_prime_routine
	stmfd sp!,{r4 - r11, lr}	;store local variables
	; for(int i = 2; i < (num); i++) *register flag 1 true by default*
	;	if (num % i) == 0
	;		return false
	; return *true*
	
	; assuming number for testing is stored by value not ascii 
	
	; r0 = num, move to local
	mov r4, r0
	mov r5, #1		;initiate (i) counter to 2 *offset increment* 	
prime_test_loop
	add r5, r5, #1	;increment counter
	cmp r4, r5
	beq prime_test_return	;loop done when i == num
	;call to signed division
	stmfd sp!, {r0 - r1}
	mov r0, r4		;copy (num) to dividend register
	mov r1, r5		;copy counter to divisor register
	bl signed_division
	
	
	
	
prime_test_return
	
	

read_write_routine
	STMFD SP!,{lr}	; Store register lr on stack
    
; Your code is placed here
loop
	BL read_character
	B loop

	LDMFD sp!, {lr}
	BX lr

read_character 
	STMFD SP!, {R0 - R12, lr}	; Store register lr on stack
rloop	LDR r2, =0xE000C014
		LDR r3, [r2]
		AND r4, r3, #1
		CMP r4, #0
		BEQ rloop
	LDR r2, =0xE000C000
	LDRB r0, [r2]
	;STRB r0, [r2]
	BL write_character
	LDMFD SP!, {R0 - R12, lr}
	BX LR

write_character
	STMFD SP!, {R1 - R12, LR}
	LDR r2, =0xE000C000
	STRB R0 ,[R2]
	LDMFD SP!, {R1 - R12, lr}
	BX LR
 
pin_connect_block_setup_for_uart0
	STMFD sp!, {r0, r1, lr}
	LDR r0, =0xE002C000  ; PINSEL0
	LDR r1, [r0]
	ORR r1, r1, #5
	BIC r1, r1, #0xA
	STR r1, [r0]
	LDMFD sp!, {r0, r1, lr}
	BX lr

	END
