.import ../../src/utils.s
.import ../../src/read_matrix.s

.data
msg0: .asciiz "inputs/test_read_matrix/test_malloc.bin"
m0: .word -1
m1: .word -1

.globl main_test
.text
# main_test function for testing
main_test:

    # load filename inputs/test_read_matrix/test_malloc.bin into a0
    la a0 msg0

    # load address to array m0 into a1
    la a1 m0

    # load address to array m1 into a2
    la a2 m1

    # call read_matrix function
    jal ra read_matrix
    # we expect read_matrix to exit early with code 88

    # exit normally
    jal exit
