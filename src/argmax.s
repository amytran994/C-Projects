.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
	# error if length < 1
    bge x0, a1, error
    
    # return 1 if array length = 1
    addi t0, x0, 1
    beq t0, a1, one_elm
    
    # Prologue	
	addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    
    # save address of the array to s0
    add s0, a0, x0
    
    # t0 is counter
    addi t0, x0, 0
    
	# offset the array address by the count
    add s0, a0, t0
    # let t1 = arr[0], temp max value
    lw t1, 0(s0)
    # init max index = 0
    addi s2, x0, 0
loop_start:
	slli s1, t0, 2
	# offset the array address by the count
   	add s0, a0, s1
    # load the value at that address to s1
    lw s1, 0(s0)
    
	# if s1 > t1, update t1 and max index
    blt t1, s1, loop_continue
	# increment the count
    addi t0, t0, 1
    # return to loop_start to run a new loop
    bne t0, a1, loop_start
    j loop_end
loop_continue:
	# s1 > t1, update max value t1 
	mv t1, s1
    # save index of this max value
    addi s2, t0, 0
    # increment the count
    addi t0, t0, 1
    # return to loop_start to run a new loop
    bne t0, a1, loop_start
loop_end:
	# save the max index to a0
	add a0, s2, x0
    # Epilogue
	lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    ret
error:
	addi a1, x0, 77
	jal exit2
    
one_elm:
	addi a0, x0, 0
    
    ret