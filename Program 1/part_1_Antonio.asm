# # # # # # # # # # # # # # # # # #
# Antonio Santos		  #
# Part 1 for Program 1		  #	
# CSCI 211 - Spring 2017	  #
# # # # # # # # # # # # # # # # # # 
.text
        .globl  main   
main:
	lw $8, a
	lw $9, b
	lw $10, c
	sub $8, $8, $10
	add $8, $8, $9
	li $v0, 1
	lw $a0, a
	syscall
	li $v0, 10
	syscall
	
	.data
	a: .word 5
	b: .word 7
	c: .word 3
