	.arch armv6
	.global doRow
	
	.cpu cortex-a53
	.equ 	NUL, 0
	.equ 	FP_OFFSET, 16//TODO: fill in with appropriate value -> (# of saved regs - 1) * 4
		
	.text

// TODO: Write doRow
doRow:
	push {r4-r6, fp, lr}	//using SP to save preserved regs that might be modified
	add fp, sp, #FP_OFFSET	// using SP to update FP to the new stackframe
				// .
	mov r4, #0		// aliveNeighbors = 0
	add r2, r2, #1		// endPtr = endPtr + 1
				// .	
while:	cmp r1, r2		// while (srcPtr != endPtr) {
	beq break		// .
				// .
north:	sub r5, r1, r3		// 	temp = srcPtr-cols
	ldrb r6, [r5]		//	temp = *temp
	cmp r6, #1		//	if (temp == 1) {
	bne south		//	.
	add r4, r4, #1		// 		aliveNeighbors++
				//	}
south:	add r5, r1, r3		//	temp = srcPtr+cols
	ldrb r6, [r5]		//	temp = *temp
	cmp r6, #1		//	if (temp == 1)
	bne east		//	.
	add r4, r4, #1		//		aliveNeighbors++
				// .
east:	add r5, r1, #1		//	temp = srcPtr+1
	ldrb r6, [r5]		//	temp = *temp
	cmp r6, #1		//	if (temp == 1) {
	bne west		// 	.
	add r4, r4, #1		//		aliveNeighbors++
				// 	{
west:	sub r5, r1, #1		//	temp = srcPtr-1
	ldrb r6, [r5]		//	temp = *temp 
	cmp r6, #1		//	if (temp == 1) {
	bne nwest		//	.
	add r4, r4, #1		//		aliveNeighbors++
				//  	}
nwest:	sub r5, r1, r3		//	temp = srcPtr-cols
	sub r5, r5, #1		//	temp = temp-1
	ldrb r6, [r5]		//	temp = *temp
	cmp r6, #1		//	if (temp == 1) {
	bne neast		//	.
	add r4, r4, #1		//		aliveNeighbors++
				// 	}
neast:	sub r5, r1, r3		//	temp = srcPtr-cols
	add r5, r5, #1		//	temp = temp+1
	ldrb r6, [r5]		//	temp = *temp
	cmp r6, #1		//	if (temp == 1) {
	bne swest		//	.
	add r4, r4, #1		//		aliveNeighbors++
				// 	}
swest:	add r5, r1, r3		//	temp = srcPtr+cols
	sub r5, r5, #1		//	temp = temp-1
	ldrb r6, [r5]		// 	temp = *temp
	cmp r6, #1		//	if (temp == 1) {
	bne seast		//	.
	add r4, r4, #1		//		aliveNeighbors++
				// 	}
seast:	add r5, r1, r3		//	temp = srcPtr+cols
	add r5, r5, #1		// 	temp = temp+1
	ldrb r6, [r5]		//	temp = *temp
	cmp r6, #1		// 	if (temp == 1) {
	bne done		//	.
	add r4, r4, #1		//		aliveNeighbors++
done:				//	}
	ldrb r6, [r1]		//	tempStart = srcPtr
	cmp r6, #1		//	if (tempStart == 1) {
	bne dead		//	.
				// .
	cmp r4, #0		// 	if (aliveNeighbors == 0) {
	bne one			// 	. 
	mov r5, #0		//		temp = 0
	strb r5, [r0]		//		*dest = 0
	b end			//		break
				// 	}
one:	cmp r4, #1		// 	if (aliveNeighbors == 1) {
	bne four		// 	.
	mov r5, #0		//		temp = 0
	strb r5, [r0]		//		*dest = 0
	b end			//		break
				// 	}
four:	cmp r4, #4		//	if (aliveNeighbors >= 4) {
	blt two			// 	.
	mov r5, #0		//		temp = 0
	strb r5, [r0]		// 		*dest = 0
	b end			// 		break
				// 	}
two:	cmp r4, #2		//	if (aliveNeighbors == 2) {
	bne three		//	.
	mov r5, #1		//		temp = 1
	strb r5, [r0]		//		*dest = 1
	b end			//		break
				// 	}
three:	cmp r4, #3		// 	if (aliveNeighbors == 3) {
	mov r5, #1		//		temp = 1
	strb r5, [r0]		//		*dest = 0
	b end			//		break
				// 	}
				// }
dead:	cmp r4, #3		//	if (aliveNeighbors = 3) {
	bne else		//	.
	mov r5, #1		//	 	temp = 1
	strb r5, [r0]		//		*dest = 1
	b end			// 		break
				// 	}
else:	mov r5, #0		//	temp = 0
	strb r5, [r0]		//	*dest = 0
	b end			// 	break
				// . 
end:	mov r4, #0		//	aliveNeighbors = 0
	add r0, r0, #1		//	dest++
	add r1, r1, #1		//	srcPtr++
	b while			//	loop again
				// }
break:	sub sp, fp, #FP_OFFSET	// using fp to restore sp to the old stackframe
	pop {r4-r6, fp, lr}	// using sp to restore regssaved in prolog
	bx lr			// using lr to using pc and thereby return
 	
	
		

		

		


