.import ../../src/utils.s
.import ../../src/argmax.s

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

    # call argmax function
    jal ra argmax
    # we expect argmax to exit early with code 77

    # exit normally
    jal exit
