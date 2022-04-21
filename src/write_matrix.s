.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

  # Prologue
	addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    sw s3, 16(sp)

	# s0: filename ad
    add s0, a0, x0
    # s1: ma of matrix
    add s1, a1, x0
    # s2: num of rows
	add s2, a2, x0
    # s3: num of cols
	add s3, a3, x0
    
    ## 1.Start f_open ##
    
    # arg a1 is filename string address
    add a1, a0, x0
    # arg a2 is 0 - write only
    addi a2, x0, 1
    
    addi sp, sp, -16
    sw s0, 0(sp) # name of file
    sw s1, 4(sp) # matrix ma
    sw s2, 8(sp) # rows
    sw s3, 12(sp) # cols
    
    jal fopen # return a0: file des
    
    lw s0, 0(sp) # name of file
    lw s1, 4(sp) # matrix ma
    lw s2, 8(sp) # rows
    lw s3, 12(sp) # cols
    addi sp, sp, 16
    
    # if a0 = -1, fails, exit 93
    addi t0, x0, -1
    beq a0, t0, error_fopen
    
    # s0: file descriptor
    add s0, a0, x0
    
    ## End f_open ##
        
    ## 2. Write rows & cols ##
    addi sp, sp, -16
    sw s0, 0(sp) # file des
    sw s1, 4(sp) # matrix ma
    sw s2, 8(sp) # rows
    sw s3, 12(sp) # cols
    
    # agr a1: file des
    add a1, x0, s0
    # agr a2: buffer ma
    addi t0, sp, 8
    add a2, x0, t0
    # agr a3: num of elm from buffer
    addi a3, x0, 2
    # agr a4: size of buffer in byte
    addi a4, x0, 4
    
    jal fwrite # return a0 = a3 num of elm
    
    lw s0, 0(sp) # file des
    lw s1, 4(sp) # matrix ma
    lw s2, 8(sp) # rows
    lw s3, 12(sp) # cols
    addi sp, sp, 16
    
    addi t0, x0, 2
    bne a0, t0, error_fwrite # if a0 != a3, fails, exit 94
    
    # Save file des in s0
    # add s0, x0, a1
    
    ## End write rows & cols ##
    
    ## 3. Start f_write ##
    addi sp, sp, -16
    sw s0, 0(sp) # file des
    sw s1, 4(sp) # matrix ma
    sw s2, 8(sp) # rows
    sw s3, 12(sp) # cols
    
    # agr a1: file des
    add a1, x0, s0
    # agr a2: buffer ma
    add a2, x0, s1
    # agr a3: num of elm from buffer
    mul t0, s2, s3
    add a3, x0, t0
    # agr a4: size of buffer in byte
    addi a4, x0, 4
    
    jal fwrite # return a0 = a3 num of elm
    
    lw s0, 0(sp) # file des
    lw s1, 4(sp) # matrix ma
    lw s2, 8(sp) # rows
    lw s3, 12(sp) # cols
    addi sp, sp, 16
    
    mul t0, s2, s3
    bne a0, t0, error_fwrite # if a0 != a3, fails, exit 94
    
    ## End f_write ##
    
    ## 4. Start f_close ##
    addi sp, sp, -16
    sw s0, 0(sp) # file des
    sw s1, 4(sp) # matrix ma
    sw s2, 8(sp) # rows
    sw s3, 12(sp) # cols
    
    # arg a1: file des
    #add a1, x0, s0
    jal fclose # return a0 = a3 num of elm
    
    lw s0, 0(sp) # file des
    lw s1, 4(sp) # matrix ma
    lw s2, 8(sp) # rows
    lw s3, 12(sp) # cols
    addi sp, sp, 16
    
    bne a0, x0, error_fclose
    ## End f_close ##
    
	# Epilogue
	lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp) 
   	lw ra, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    ret
error_fopen:
	addi a1, x0, 93
    # Epilogue
	lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp) 
   	lw ra, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    jal exit2
    
error_fwrite:
	addi a1, x0, 94
    # Epilogue
	lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp) 
   	lw ra, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    jal exit2

error_fclose:
	addi a1, x0, 95
	# Epilogue
	lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp) 
   	lw ra, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    jal exit2
