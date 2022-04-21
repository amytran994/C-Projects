.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
	addi sp, sp, -8
    sw s1, 0(sp)
    sw s0, 4(sp)
	
    # error if length < 1
    bge x0, a1, error
    # save address of the array to s0
    add s0, a0, x0
    # t0 is counter
    addi t0, x0, 0
    
loop_start:
	slli s1, t0, 2
	# offset the array address by the count
   	add s0, a0, s1
    
    # load the value at that address to t1
    lw t1, 0(s0)
    
    # compare t1 with 0, if t1 <= 0, go to loop_continue
    blt t1, x0, loop_continue

    # add t1 back to the array
    sw t1, 0(s0)
    
    # increment the count
    addi t0, t0, 1
    
    # repeat
    bne t0, a1, loop_start
    j loop_end
loop_continue:
	# t1 <0, change t1 to 0
	mv t1, x0
    # add t1 back to the array
    sw t1, 0(s0)
    # increment the count
    addi t0, t0, 1
    # return to loop_start to run a new loop
    bne t0, a1, loop_start
loop_end:
	add a0, x0, s0
    # Epilogue
	lw s1, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
	ret
error:
	addi a1, x0, 78
	jal exit2