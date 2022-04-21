.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    sw s3, 16(sp)

	# save string ad of filename to s0
    add s0, a0, x0
    # save ad of num of rows to s1
    add s1, a1, x0
    # save ad of num of cols to s2
	add s2, a2, x0
    
    ## 1.Start f_open ##
    
    # arg a1 is filename string address
    add a1, a0, x0
    # arg a2 is 0 - read only
    addi a2, x0, 0
    
    addi sp, sp, -16
    sw s0, 0(sp) # name of file
    sw s1, 4(sp) # row ad
    sw s2, 8(sp) # col ad
    sw ra, 12(sp)
    
    jal fopen # return a0: file des
    
    lw s0, 0(sp) # name of file
    lw s1, 4(sp) # row ad
    lw s2, 8(sp) # col ad
    sw ra, 12(sp)
    addi sp, sp, 16
    
    # if a0 = -1, fails, exit 88
    addi s0, x0, -1
    beq a0, s0, error_fopen
    
    # s0: file descriptor
    add s0, a0, x0
    
    ## End f_open ##
       
    ## 3. Start f_read1 ##
    # get num of rows and cols first
    
    # 1. save regs
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    
    # 2. prepare agr
    # a1 : file descriptor
    add a1, s0, x0
    # a2: pointer to rows
    add a2, x0, s1
    # a3: num of bytes to read
    addi a3, x0, 4
    
    # call f_read
    jal fread
    
    # 3. load regs
    lw s0, 0(sp) # file descriptor
    lw s1, 4(sp) # row ad
    lw s2, 8(sp) # col ad
    addi sp, sp, 12
    
    # 4. Check if f_read fails (a0 != 8) exit 91
    addi t1, x0, 4
    bne a0, t1, error_fread
    
    ## 3. Start f_read2 ##
    # get num of rows and cols first
    # 1. save regs
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    
    # 2. prepare agr
    # a1 : file descriptor
    add a1, s0, x0
    # a2: pointer to rows
    add a2, x0, s2
    # a3: num of bytes to read
    addi a3, x0, 4
    
    # call f_read
    jal fread
    
    # 3. load regs
    lw s0, 0(sp) # file descriptor
    lw s1, 4(sp) # row ad
    lw s2, 8(sp) # col ad
    addi sp, sp, 12
    
    # 4. Check if f_read fails (a0 != 4) exit 91
    addi t1, x0, 4
    bne a0, t1, error_fread

	lw t1, 0(s1)
    lw t0, 0(s2)
    mul t0, t0, t1
    slli t0, t0, 2
    
    ## 4. Start malloc ##
    addi sp, sp, -16
   	sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw t0, 12(sp)
    
    # arg a0: num of bytes to allocate
    add a0, t0, x0
    jal malloc # return a0: allocated ma
    
    lw s0, 0(sp) # file descriptor ad
    lw s1, 4(sp) # num of rows
    lw s2, 8(sp) # num of cols
    lw t0, 12(sp) # size of allocated mem
    addi sp, sp, 16
    
	# check if malloc fails: a0 = 0 exit 88
    beq a0, x0, error_malloc
    
    # s3: allocated ma
    add s3, a0, x0
    
    ## End malloc ##
    
    ## 5. Start f_read2 ##
    # read stream from file des to allocated ma
    
    # agr a1: file des
    add a1, x0, s0
    # agr a2: allocated ma
    add a2, x0, s3
    # agr a3: num of bytes to read: rows*cols*4
    add a3, x0, t0

    addi sp, sp, -20
    sw s0, 0(sp) # file des
    sw s1, 4(sp) # num of rows
    sw s2, 8(sp) # num of cols
    sw s3, 12(sp) # allocated ma
    sw t0, 16(sp) # rows*cols
    
    jal fread # return a0: num of bytes read
    
   	lw s0, 0(sp) # file des
    lw s1, 4(sp) # num of rows
    lw s2, 8(sp) # num of cols
    lw s3, 12(sp) # allocated ma
    lw t0, 16(sp) # rows*cols
    addi sp, sp, 20
    
    # f_read fails (a0 != t0) exit 91
    bne a0, t0, error_fread
        
    ## 6. Start f_close: ##
    
    # agr a1: file des
    add a1, s0, x0
    
    addi sp, sp, -20
    sw s0, 0(sp) # file des
    sw s1, 4(sp) # num of rows
    sw s2, 8(sp) # num of cols
    sw s3, 12(sp) # allocated ma
    sw t0, 16(sp) # rows*cols
    
    jal fclose # return a0: 0, success
    
   	lw s0, 0(sp) # file des
    lw s1, 4(sp) # num of rows
    lw s2, 8(sp) # num of cols
    lw s3, 12(sp) # allocated ma
    lw t0, 16(sp) # rows*cols
    addi sp, sp, 20
    
    # check if f_close fails, a0 != 0
   	bne a0, x0, error_fclose
    
    ## End f_close ##
    
    add a0, s3, x0
    add a1, s1, x0
    add a2, s2, x0
    
    # Epilogue
	lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp) 
   	lw ra, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    ret
error_malloc:
	addi a1, x0, 88
    
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw s3, 16(sp)
	addi sp, sp, 20
    
    jal exit2
    
error_fopen:
	addi a1, x0, 90
    
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw s3, 16(sp)
	addi sp, sp, 20

    jal exit2
    
error_fread:
	addi a1, x0, 91
    
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw s3, 16(sp)
	addi sp, sp, 20
    
    jal exit2
    
error_fclose:
	addi a1, x0, 92
    
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp) 
   	lw ra, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    jal exit2