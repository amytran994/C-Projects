.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
	# error if m0 rows < 1
    bge x0, a1, error_dim_m0
	# error if m0 cols < 1
    bge x0, a2, error_dim_m0

	# error if m1 rows < 1
    bge x0, a4, error_dim_m1
	# error if m1 cols < 1
    bge x0, a5, error_dim_m1

    # error if cols of m0 != rows of m1
    bne a2, a4, error_dim

    # Prologue
	addi sp, sp, -14
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)


	# save address of m0 to s0
    add s0, a0, x0
    # save address of m1 to s1
    add s1, a3, x0
    # save address result matrix to s2
    add s2, a6, x0

    # counter t0 for m0
    addi t0, x0, 0
    # slider t1 for m0
    addi t1, x0, 0
    # counter t5 for matrix result
    addi t5, x0, 0

outer_loop_start:
	mul t1, t0, a2
	# convert to byte
    slli t1, t1, 2
	# offset m0 by the count
   	add s0, a0, t1
    # inner loop counter
	addi t3, x0, 0

inner_loop_start:

    # inc pointer next result matrix before calling dot
    slli t6, t5, 2
    add s2, a6, t6

    # save address of m0, m1
	addi sp, sp, -48
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw t2, 28(sp)
    sw t6, 32(sp)
    sw t3, 36(sp)
    sw t5, 40(sp)
    sw t0, 44(sp)

    # convert to byte
    slli t2, t3, 2
	  # offset m1 by the count
   	add s1, a3, t2
 	  # put s0 pointer in arg a0
    add a0, x0, s0
    # put s1 pointer in arg a1
 	  add a1, x0, s1

    add a4, a5, x0

	addi a3, x0, 1
    jal dot

    # Save dot product in result matrix
    sw a0, 0(s2)

    # get the address of m0, m1 back
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    lw t2, 28(sp)
    lw t6, 32(sp)
    lw t3, 36(sp)
    lw t5, 40(sp)
	lw t0, 44(sp)
    addi sp, sp, 48

    # inc counter of result matrix
    addi t5, t5, 1
    # incr counter of inner loop
    addi t3, t3, 1

    # loop until t3 = cols m1 -1
    bne t3, a5, inner_loop_start
inner_loop_end:

	addi t0, t0, 1
	bne t0, a1, outer_loop_start

outer_loop_end:

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
   	lw ra, 12(sp)
    addi sp, sp, 14
    ret
error_dim_m0:
	addi a1, x0, 72
	jal exit2
error_dim_m1:
	addi a1, x0, 73
    jal exit2
error_dim:
	addi a1, x0, 74
    jal exit2
