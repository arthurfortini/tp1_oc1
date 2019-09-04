.data
	input: .word 3
    
.text

main:
	lw x5, input					
	andi x6, x5, 1					#checks if the number is even or odd (a logical AND w/ 1 returns 0 if even, 1 if odd)
	addi x10, x0, 1					#sets the ecall (it means that i want the console output to exibit an integer)
	add x11, x6, x0					#stores the result in a1 (return register)
	ecall
    jal zero, end
    
end: