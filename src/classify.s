.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

	# Prologue
	addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    
	# Check num of arg=5
	addi s0, x0, 5
   	#bne a0, s0, error_argc
	lw s0, 4(a1) # ma of m0
    lw s1, 8(a1) # ma of m1
    lw s2, 12(a1) # ma of input path
    lw s3, 16(a1) # ma of output path
	add s5, a2, x0 # save print
    
	# =====================================
    # LOAD MATRICES
    # =====================================
    ## Read matrix ##
    addi sp, sp, -32
    sw s0, 0(sp) # m0 path
    sw s1, 4(sp) # m1 path
    sw s2, 8(sp) # input path
    sw s3, 12(sp) # output path
	sw t0, 16(sp)
    sw t1, 20(sp)
    sw s5, 24(sp)
    sw ra, 28(sp)
    
    # Load pretrained m0
    # arg a0: ma of m0
	add a0, x0, s0
    # arg a1: rows
    add a1, sp, x0
    addi a1, a1, 16
	# arg a2: cols
	addi a2, a1, 4
    
    jal read_matrix

    lw s0, 0(sp) # ma of m0
    lw s1, 4(sp) # m1 path
    lw s2, 8(sp) # input path
    lw s3, 12(sp) # output path
    lw t0, 16(sp)
    lw t1, 20(sp)
    lw s5, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    
    # save ma of m0 into a0
	add s0, a0, x0
	#lw t0, 0(t0) # save rows of m0 in t0
    #lw t1, 0(t1) # save cols of m0 in t1

    # Load pretrained m1
	addi sp, sp, -40
    sw s0, 0(sp) # m0
    sw s1, 4(sp) # ma of m1
    sw s2, 8(sp) # ma of input path
    sw s3, 12(sp) # ma of output path
	sw t0, 16(sp) # rows of m0
    sw t1, 20(sp) # cols of m0
    sw t2, 24(sp) # ma for rows of m1 
    sw t3, 28(sp) # ma for cols of m1
	sw s5, 32(sp)
    sw ra, 36(sp)

	# arg a0: ma of m1
	add a0, x0, s1
    # arg a1: rows
    add a1, x0, sp
    addi a1, a1, 24
	# arg a2: cols
	addi a2, a1, 4
    
    jal read_matrix

    lw s0, 0(sp) # m0
    lw s1, 4(sp) # ma of m1
    lw s2, 8(sp) # ma of input path
    lw s3, 12(sp) # ma of output path
    lw t0, 16(sp) # rows of m0
    lw t1, 20(sp) # cols of m0
    lw t2, 24(sp) # ma for rows of m1 
    lw t3, 28(sp) 
    lw s5, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40
	
    # save ma of m1 into s1
	add s1, a0, x0
	#lw t2, 0(t2) # save rows of m1 in t2
    #lw t3, 0(t3) # save cols of m1 in t3

    # Load input matrix

	addi sp, sp, -48
    sw s0, 0(sp) # m0
    sw s1, 4(sp) # m1
    sw s2, 8(sp) # ma of input path
    sw s3, 12(sp) # ma of output path
	sw t0, 16(sp) # rows of m0
    sw t1, 20(sp) # cols of m0
    sw t2, 24(sp) # rows of m1 
    sw t3, 28(sp) # cols of m1
    sw t4, 32(sp) # ma for rows of input
    sw t5, 36(sp) # ma for cols of input
	sw s5, 40(sp)
    sw ra, 44(sp)

	# arg a0: ma of input
	add a0, x0, s2
    # arg a1: rows
    add a1, x0, sp
    addi a1, a1, 32
	# arg a2: cols
	addi a2, a1, 4
    
    jal read_matrix

    lw s0, 0(sp) # m0
    lw s1, 4(sp) # m1
    lw s2, 8(sp) # input
    lw s3, 12(sp) # ma of output path
    lw t0, 16(sp) # rows of m0
    lw t1, 20(sp) # cols of m0
    lw t2, 24(sp) # rows of m1 
    lw t3, 28(sp) # cols of m1
    lw t4, 32(sp) # rows of input
    lw t5, 36(sp) # cols of input
    lw s5, 40(sp)
    lw ra, 44(sp)

    addi sp, sp, 48
	
    # save ma of input into s2
	add s2, a0, x0
    
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    
    mul s4, t0, t5 # rows m0 * cols input = size of hidden_layer
    
    addi sp, sp, -52
    sw s0, 0(sp) # m0
    sw s1, 4(sp) # m1
    sw s2, 8(sp) # input
    sw s3, 12(sp) # ma of output path
	sw t0, 16(sp) # rows of m0
    sw t1, 20(sp) # cols of m0
    sw t2, 24(sp) # rows of m1 
    sw t3, 28(sp) # cols of m1
    sw t4, 32(sp) # rows of input
    sw t5, 36(sp) # cols of input
    sw s4, 40(sp) # ma of hidden layer
    sw s5, 44(sp)
    sw ra, 48(sp)

    # num of bytes need to allocate = size*4
    slli s4, s4, 2
    # arg a0 = num of bytes
    add a0, s4, x0
    # call malloc
    jal malloc
    
    lw s0, 0(sp) # m0
    lw s1, 4(sp) # m1
    lw s2, 8(sp) # input
    lw s3, 12(sp) # ma of output path
	lw t0, 16(sp) # rows of m0
    lw t1, 20(sp) # cols of m0
    lw t2, 24(sp) # rows of m1 
    lw t3, 28(sp) # cols of m1
    lw t4, 32(sp) # rows of input
    lw t5, 36(sp) # cols of input
    lw s4, 40(sp) # ma of hidden layer
    lw s5, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52

    # save ma of allocated space in s4
    add s4, a0, x0
    
    addi sp, sp, -52
    sw s0, 0(sp) # m0
    sw s1, 4(sp) # m1
    sw s2, 8(sp) # input
    sw s3, 12(sp) # ma of output path
	sw t0, 16(sp) # rows of m0
    sw t1, 20(sp) # cols of m0
    sw t2, 24(sp) # rows of m1 
    sw t3, 28(sp) # cols of m1
    sw t4, 32(sp) # rows of input
    sw t5, 36(sp) # cols of input
    sw s4, 40(sp) # ma of hidden_layer
    sw s5, 44(sp)
    sw ra, 48(sp)
    
    # prepare calling matmul(m0, input)
    # arg a0: m0
    add a0, s0, x0
    # arg a1: rows m0
    add a1, t0, x0
    # arg a2: cols m0
    add a2, t1, x0
    # arg a3: input
    add a3, s2, x0
    # arg a4: rows input
    add a4, t4, x0
    # arg a5: cols input
    add a5, t5, x0
    # arg a6: ma of result
    add a6, s4, x0
    
    jal matmul
    
    ### Free m0, input ###
    add a0, s0, x0
    jal free
    add a0, s2, x0
    jal free
    
    lw s0, 0(sp) # m0
    lw s1, 4(sp) # m1
    lw s2, 8(sp) # input
    lw s3, 12(sp) # ma of output path
	lw t0, 16(sp) # rows of m0
    lw t1, 20(sp) # cols of m0
    lw t2, 24(sp) # rows of m1 
    lw t3, 28(sp) # cols of m1
    lw t4, 32(sp) # rows of input
    lw t5, 36(sp) # cols of input
    lw s4, 40(sp) # hidden layer
    lw s5, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52
    
    # remove freed address
    add s0, x0, x0
    add s2, x0, x0
    
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    
    # Prepare to call relu(hidden layer)
    # arg a0: hidden layer
    add a0, s4, x0
    # arg a1: num of elms
    mul a1, t0, t5
    
   	addi sp, sp, -52
    sw s0, 0(sp) # m0
    sw s1, 4(sp) # m1
    sw s2, 8(sp) # input
    sw s3, 12(sp) # ma of output path
	sw t0, 16(sp) # rows of m0
    sw t1, 20(sp) # cols of m0
    sw t2, 24(sp) # rows of m1 
    sw t3, 28(sp) # cols of m1
    sw t4, 32(sp) # rows of input
    sw t5, 36(sp) # cols of input
    sw s4, 40(sp) # hidden_layer
    sw s5, 44(sp)
    sw ra, 48(sp)
    
    jal relu
    
    lw s0, 0(sp) # m0
    lw s1, 4(sp) # m1
    lw s2, 8(sp) # input
    lw s3, 12(sp) # ma of output path
	lw t0, 16(sp) # rows of m0
    lw t1, 20(sp) # cols of m0
    lw t2, 24(sp) # rows of m1 
    lw t3, 28(sp) # cols of m1
    lw t4, 32(sp) # rows of input
    lw t5, 36(sp) # cols of input
    lw s4, 40(sp) # hidden layer
    lw s5, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52
    
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

	### malloc ###
    addi sp, sp, -52
    sw s0, 0(sp) #
    sw s1, 4(sp) # m1 
    sw s2, 8(sp) # input (freed)
    sw s3, 12(sp) # ma of output path
	sw t0, 16(sp) # rows of m0
    sw t1, 20(sp) # cols of m0
    sw t2, 24(sp) # rows of m1 
    sw t3, 28(sp) # cols of m1
    sw t4, 32(sp) # rows of input
    sw t5, 36(sp) # cols of input
    sw s4, 40(sp) # hidden layer
    sw s5, 44(sp)
    sw ra, 48(sp)
    
    # arg a0 = num of bytes
    # rows m1 * cols input = size of score
    # num of bytes need to allocate = size*4
    mul a0, t2, t5
    slli a0, a0, 2
    # call malloc
    jal ra, malloc
    
    lw s0, 0(sp) # m0
    lw s1, 4(sp) # m1
    lw s2, 8(sp) # input
    lw s3, 12(sp) # ma of output path
	lw t0, 16(sp) # rows of m0
    lw t1, 20(sp) # cols of m0
    lw t2, 24(sp) # rows of m1 
    lw t3, 28(sp) # cols of m1
    lw t4, 32(sp) # rows of input
    lw t5, 36(sp) # cols of input
    lw s4, 40(sp) # ma of hidden layer
    lw s5, 44(sp) # ma of score
    lw ra, 48(sp)
    addi sp, sp, 52
    
    # save ma of score in s2
    add s2, a0, x0
	
    ### Malloc done ###
    
    ### score = matlu(m1, hidden layer) ###
	addi sp, sp, -52
    sw s0, 0(sp) # ma of score
    sw s1, 4(sp) # m1 
    sw s2, 8(sp) # input (freed)
    sw s3, 12(sp) # ma of output path
	sw t0, 16(sp) # rows of m0
    sw t1, 20(sp) # cols of m0
    sw t2, 24(sp) # rows of m1 
    sw t3, 28(sp) # cols of m1
    sw t4, 32(sp) # rows of input
    sw t5, 36(sp) # cols of input
    sw s4, 40(sp) # hidden layer
    sw s5, 44(sp) # print
    sw ra, 48(sp)

    # prepare calling matmul(m1, hidden layer)
    # arg a0: m1
    add a0, s1, x0
    # arg a1: rows m1
    add a1, t2, x0
    # arg a2: cols m1
    add a2, t3, x0
    # arg a3: hidden layer
    add a3, s4, x0
    # arg a4: rows hidden layer = rows of m0
    add a4, t0, x0
    # arg a5: cols hidden layer = cols of input
    add a5, t5, x0
    # arg a6: ma of result
    add a6, s2, x0
    
    jal matmul

    lw s0, 0(sp)
    lw s1, 4(sp) # m1 (freed)
    lw s2, 8(sp) # input (freed)
    lw s3, 12(sp) # ma of output path
	lw t0, 16(sp) # rows of m0
    lw t1, 20(sp) # cols of m0
    lw t2, 24(sp) # rows of m1 
    lw t3, 28(sp) # cols of m1
    lw t4, 32(sp) # rows of input
    lw t5, 36(sp) # cols of input
    lw s4, 40(sp) # hidden layer (freed)
    lw s5, 44(sp) # print
    lw ra, 48(sp)
    addi sp, sp, 52
    
    # add score into s0   
   	add s0, s2, x0
	### Score done ###
	
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    
	addi sp, sp, -52
    sw s0, 0(sp) # score
    sw s1, 4(sp) # m1
    sw s2, 8(sp) # input (freed)
    sw s3, 12(sp) # ma of output path
	sw t0, 16(sp) # rows of m0
    sw t1, 20(sp) # cols of m0
    sw t2, 24(sp) # rows of m1 
    sw t3, 28(sp) # cols of m1
    sw t4, 32(sp) # rows of input
    sw t5, 36(sp) # cols of input
    sw s4, 40(sp) # hidden layer
    sw s5, 44(sp) # print
    sw ra, 48(sp)

    # Prepare calling write matrix
    # arg a0: filename
    add a0, s3, x0
    # arg a1: ma of matrix
    add a1, s0, x0
    # arg a2: rows
    add a2, t2, x0
    # arg a3: cols
    add a3, t5, x0
    
	jal write_matrix	
    
	lw s0, 0(sp) # score
    lw s1, 4(sp) # m1
    lw s2, 8(sp) # input
    lw s3, 12(sp) # ma of output path
	lw t0, 16(sp) # rows of m0
    lw t1, 20(sp) # cols of m0
    lw t2, 24(sp) # rows of m1 
    lw t3, 28(sp) # cols of m1
    lw t4, 32(sp) # rows of input
    lw t5, 36(sp) # cols of input
    lw s4, 40(sp) # hidden layer
    lw s5, 44(sp) # print
    lw ra, 48(sp)
    addi sp, sp, 52

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

	addi sp, sp, -52
    sw s0, 0(sp) # score (rows of m1, cols of input)
    sw s1, 4(sp) # m1 (freed)
    sw s2, 8(sp) # input (freed)
    sw s3, 12(sp) # ma of output path
	sw t0, 16(sp) # rows of m0
    sw t1, 20(sp) # cols of m0
    sw t2, 24(sp) # rows of m1 
    sw t3, 28(sp) # cols of m1
    sw t4, 32(sp) # rows of input
    sw t5, 36(sp) # cols of input
    sw s4, 40(sp) # hidden_layer (freed)
    sw s5, 44(sp) # print
    sw ra, 48(sp)
    
	# Prepare to call argmax
    # arg a0: ma of array
    add a0, s0, x0
    # arg a1: num of elems
    mul a1, t2, t5    
 
    jal argmax
    
	lw s0, 0(sp) # score
    lw s1, 4(sp) # m1 (freed)
    lw s2, 8(sp) # input  (freed)
    lw s3, 12(sp) # ma of output path
	lw t0, 16(sp) # rows of m0
    lw t1, 20(sp) # cols of m0
    lw t2, 24(sp) # rows of m1 
    lw t3, 28(sp) # cols of m1
    lw t4, 32(sp) # rows of input
    lw t5, 36(sp) # cols of input
    lw s4, 40(sp) # hidden layer (freed)
    lw s5, 44(sp) # print
    lw ra, 48(sp)
    addi sp, sp 52
    
    # Save argmax result in s0
    add a1, a0, x0
    # Print classification
    bne s5, x0, not_print
    jal print_int
    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char
    
not_print:
  	### Free m1, hidden layer ###
	add a0, s1, x0
    jal free
    add a0, s4, x0
    jal free
    add a0, s0, x0
    jal free
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
	addi sp, sp, 28
    ret
error_malloc:
	addi a1, x0, 88
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
	addi sp, sp, 28

    jal exit2
error_argc:
	addi a1, x0, 89
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
	addi sp, sp, 28
	jal exit2