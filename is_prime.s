	AREA	is_prime, CODE, READWRITE	
	ENTRY 
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
	mov r6, #1		; initialize is_prime flag to 1
prime_test_loop
	add r5, r5, #1	;increment counter
	cmp r4, r5
	beq prime_test_return	;loop done when i == num
	;call to signed division
	stmfd sp!, {r0 - r3}
	mov r0, r4		;copy (num) to dividend register
	mov r1, r5		;copy counter to divisor register
	bl signed_division
	;r0 and r1 overwritten with quotient and remainder
	cmp r1, #0	
	moveq r6, #0
	ldmfd sp!, {r0 - r3, lr}
	beq prime_test_return
	
	
	
prime_test_return
	mov r0, r6	; return bool is_prime value in r0
	ldmfd sp!, {r4 - r11, lr}
	;bx lr
	end
	
	
	;;;;;;;;;;;;;;;;;;;;;;
	
	
	
signed_division
	stmfd !sp, {r2 - r7}
main
	mov r0, #-5		;initialize dividend
	mov r1, #-2		;initialize divisor
	bl handle_sign
	mov r2, #0		;initialize quotient to 0
	mov r3, r0		;initialize remainder to dividend
	mov r4, #16		;initialize counter to 16
	lsl r1, #16		;logical shift left divisor 16 places
	add r4, r4, #1	;offset addition for loop subtraction
	
main_loop
	sub r4, r4, #1	
	sub r3, r3, r1	;remainder = remainder - divisor
	cmp r3, #0		; is remainder < 0?
	blt remainder_less_than_zero
	lsl r2, #1 		;left shift quotient
	add r2, r2, #1	;lsb should be 1
	b remainder_less_than_zero_branch_merged
	
remainder_less_than_zero
	add r3, r3, r1	;remainder = remainder + divisor
	lsl r2, #1		;left shift quotient, lsb = 0
	
remainder_less_than_zero_branch_merged
	lsr r1, #1		;shift right divisor
	cmp r4, #0		;is counter > 0?
	bgt main_loop
					
					;quotient and remainder are now known, 
					;time to check the sign flag
	cmp r7, #0
	beq flag_not_set
	neg r2, r2		;negate quotient
	neg r3, r3		;negate remainder
flag_not_set
	b end_program
		
handle_sign		
	mov r7, #0		;initialize sign flag to 0
	cmp r0, #0		;check dividend sign
	bgt check_divisor
	mov r7, #1		;increment sign flag if negative
	neg r0, r0		;negate dividend to positive
check_divisor
	cmp r1, #0		;check divisor sign
	bgt handle_sign_finished
	neg r1, r1		;negate divisor to positive
	cmp r7, #0		;check if sign flag already set
	bgt sign_reset
	mov r7, #1		;sign set
	b handle_sign_finished
sign_reset
	mov r7, #0		;sign reset
handle_sign_finished
	bx lr	
	
end_program
	bx lr