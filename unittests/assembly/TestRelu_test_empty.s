.import ../../src/utils.s
.import ../../src/relu.s

.data
m0: .word 

.globl main_test
.text
# main_test function for testing
main_test:

    # load address to array m0 into a0
    la a0 m0

    # load 0 into a1
    li a1 0

    # call relu function
    jal ra relu
    # we expect relu to exit early with code 78

    # exit normally
    jal exit
