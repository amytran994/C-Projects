.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
	addi sp, sp, -12
    sw s1, 0(sp)
    sw s0, 4(sp)
    sw s2, 8(sp)
	
    # error if length < 1
    bge x0, a2, error_length
    # error if stride < 1
	bge x0, a3, error_stride
    # error if stride < 1
    bge x0, a4, error_stride
    
    # save address of array a0 to s0
    add s0, a0, x0
    # save address of array a1 to s1
    add s1, a1, x0
    # t0 is counter0 k = 0, 1, 2... 
    addi t0, x0, 0
    # reg s2 hold dot product
    addi s2, x0, 0
loop_start:
	# t1 is counter for array1
	mul t1, t0, a3
	# convert to byte    
    slli t1, t1, 2
	# offset the array1 address by the count
   	add s0, a0, t1
    # load value of array1 to t1
    lw t1, 0(s0)
    
    # t2 is counter for array2
	mul t2, t0, a4
    # convert to byte  
    slli t2, t2, 2
    # offset the array2 address by the count
   	add s1, a1, t2
	# load value of array2 to t2
    lw t2, 0(s1)
	
    # product
    mul t1, t1, t2
    
    # add to total dot product
	add s2, s2, t1
    addi t0, t0, 1
    bne t0, a2, loop_start
loop_end:
	add a0, x0, s2	
    # Epilogue
    lw s1, 0(sp)
    lw s0, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12

    ret
    
error_length:
	addi a1, x0, 75
	jal exit2
error_stride:
	addi a1, x0, 76
	jal exit2