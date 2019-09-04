.data 
	input: .word 5

.text

main:
	lw x11, input
	call factorial
	addi x10, x0, 1					#sets the ecall
	ecall							#prints the result
	jal zero, end

factorial:
		addi sp,sp,-8					#make room on stack for recursive iteration
		sw x1,4(sp)
		sw x11,0(sp)
		addi x5,x11,-1					
		bge x5,x0, loop					# tests if x5 = 0 -- when it does, it means that the recursive iteration is over
		addi x11,x0,1					
		addi sp,sp,8
		jalr x0,0(x1)
	loop: addi x11,x11,-1			    # input-1
		jal x1, factorial			    # factorial calls itself
		addi x7,x11,0
		lw x11,0(sp)
		lw x1,4(sp)
		addi sp,sp,8
		mul x11,x11,x7				    #multiplicate the current value with the past one
		jalr x0,0(x1)
        
end: