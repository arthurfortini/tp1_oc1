.data 
	vector1: .word 1, 2, 3, 4, 5
	size1: .word 5
    vector2: .word 5, 4, 3, 2, 1
    size2: .word 5

	message1: .asciiz "Those packs have the same types of seeds!" 
    message2: .asciiz "Those packs doesn't have the same types of seeds :("
    
.text

main:
    la x23, vector1			#saving inputs
    lw x24, size1
    la x25, vector2
    lw x26, size2
    bne x24, x26, out1 		#checks if the two packs have the same amount of seeds
    mv x12, x23				#parameters to sort vector1
    mv x13, x24
    jal x1, bubble
    mv x12, x25				#parameters to sort vector2
    mv x13, x26
    jal x1, bubble
    mv x12, x23				#compare if the two sorted vectors are identical
	mv x13, x25
    jal x1, compare
    beq x17, x0, out1		#test if "compare" returns 1 or 0
    la x11, message1		#if vectors are identical, emits message1
    addi x10, x0, 4
    ecall
    jal zero, end    
	out1: la x11, message2		#if vectors are not identical, emits message2
      	  addi x10, x0, 4		#sets the ecall (it means that i want the console output to exibit a string, whose address is stored in x11)
	      ecall 				#prints the result
	      jal zero, end

bubble:
			addi sp, sp, -20		#make room on stack for registers
			sw x1, 16(sp)    		#save return address
			sw x22, 12(sp)
			sw x21, 8(sp)
    		sw x20, 4(sp)
    		sw x19 0(sp)
    		mv x21, x12
			mv x22, x13
    		li x19, 0			
	for1:	bge x19, x22, endf1		#if i > vector size, go to endf1
			addi x20, x19, -1
	for2:	blt x20, x0, endf2
			slli x5, x20, 2
        	add x5, x21, x5
        	lw x6, 0(x5)			# x6 = vector[j]
        	lw x7, 4(x5)			# x7 = vector[j+1]
        	ble x6, x7, endf2		# if x6 < x7, there's no need to swap the two values, so go to endf2
        	mv x12, x21
        	mv x13, x20
        	jal x1, swap			#swap x6 and x7
        	addi x20, x20, -1
        	j for2
	endf2:	addi x19, x19, 1
			j for1
	endf1:	lw x19, 0(sp)			#restore saved register values
			lw x20, 4(sp)
        	lw x21, 8(sp)
        	lw x22, 12(sp)
        	lw x1, 16(sp)
        	addi sp, sp, 20			#restore stack
        	jalr x0, 0(x1)
        
swap:
	slli x6, x13, 2		#t1 = k*4
    add x6, x12, x6		#t1 = v + k*8
    lw x5, 0(x6)		#t0 = vector[k]  -- temp
    lw x7, 4(x6)		#t1 = vector[k+1]
    sw x7, 0(x6)		#vector[k] = t1
    sw x5, 4(x6)		#vector[k+1] = t0 -- temp
    jalr x0, 0(x1)		#return
    
compare: 
		   li x5, 0 				#i=0
	cfor1: bge x5, x24, cendf1 		#if i >= n end loop
    	   slli x6, x5, 2 			# x6 = i*4 
           add x7, x12, x6 			# x7 = v1 + (i*4)
           add x28, x13, x6 		# x28 = v2 + (i*4)
           lw x29, 0(x7) 			# x29 = v1[i]
    	   lw x30, 0(x28) 			# x30 = v2[i]
           bne x29, x30, notequal 	# x29 != x30 
           addi x5, x5, 1 			# i++
           j cfor1
    cendf1: li x17, 1 				#return 1 if vectors are identical (permutation)
    		jalr x0, 0(x1)
	notequal: li x17, 0 			#return 0 if vectors are not identical (no permutation)
    		jalr x0, 0(x1)

end: