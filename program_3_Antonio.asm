# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#	Antonio Santos
#	Spring 2017 CSCI 211 - Program 3
#	Due 3/1/2017
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
.data
array: .space 40 #array size 10 for ints

prompt: .asciiz "\nEnter an interger: "
sum: .asciiz "\nSum: "
avg: .asciiz "\nAverage: "
min: .asciiz "\nMinimum: "
max: .asciiz "\nMaximum: "
above: .asciiz "\nIntegers above average: "
below: .asciiz "\nIntegers below average: "
median: .asciiz "\nMedian: "
mode: .asciiz "\nMode: "

.text
main:

# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#PART 1 - loop that reads in th 10 values into the array
#$t0 is the array positioner  - DO NOT CHANGE
#$t2 counts how many values are in array  - DO NOT CHANGE
#$t3 holds the value of whats read in 
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
	la $t0, array #t0 holds iniial start of array
	li $t2, 0 #t2 is loop counter

	loop:
	la $a0, prompt
	li $v0, 4
	syscall

	li $v0, 5
	syscall

	#last value check
	beq $v0, -9, next
	sll $0,$0,0
	beq $t2, 10, next 
	sll $0, $0, 0

	#following takes value read in and puts it in array
	addi $t3, $v0, 0
	sw $t3, 0($t0) 
	la $t0, 4($t0) 
	addi $t2, $t2, 1
	j loop #end of loop
	sll $0, $0, 0

	next:

# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#PART 2 - loop through the array to sum up all values in the array
#$t2 contains # of elements in array
#$t0 is the array position 
#$t4 holds the sum of all elements in the array
#$t3 takes out the value from the array
#$t1 is the loop counter
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
	addi $t1, $t2, 0
	loop2:
	la $t0, -4($t0)
	lw $t3, ($t0)
	add $t4, $t4, $t3
	addi $t1, $t1, -1
	bgtz $t1, loop2 #end of loop 2
	sll $0, $0, 0

	##following prints result
	la $a0, sum
	li $v0, 4
	syscall
	addi $a0, $t4, 0
	li $v0, 1
	syscall

# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#PART 3 - calculate the average
#$t4 holds sum of all values in the array
#$t2 contains # of elements in array
#$t6 contains the average  - DO NOT CHANGE
#$t5 is used as a
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
	div $t4, $t2
	mflo $t5
	mfhi $t6
	add $t6, $t6, $t5
	
	la $a0, avg
	li $v0, 4
	syscall
	addi $a0, $t6, 0
	li $v0, 1
	syscall

# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#PART 4 - loop through array to find the minimum
#$t1 is used as loop counter
#$t0 contains array address 
#$t3 contains the min
#t4 contains temporary value
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
	addi $t1, $t2, 0
	
	loop3:
	lw $t4, 0($t0)
	bgt $t4, $t3, cont
	sll $0, $0, 0
	addi $t3, $t4, 0

	cont:
	la $t0, 4($t0)
	addi $t1, $t1, -1
	bgtz $t1, loop3 #end of loop 3
	sll $0, $0, 0

	##following prints result
	la $a0, min
	li $v0, 4
	syscall
	addi $a0, $t3, 0
	li $v0, 1
	syscall	


# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#PART 5 - loop through the array to find the maxima
#$t1 is used as loop counter
#$t0 contains array address 
#$t3 contains the max
#t4 contains temporary value
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
	addi $t1, $t2, 0
	li $t3, 0
	
	loop4:
	la $t0, -4($t0)
	lw $t4, 0($t0)
	blt $t4, $t3, cont2
	sll $0, $0, 0
	addi $t3, $t4, 0

	cont2:
	addi $t1, $t1, -1
	bgtz $t1, loop4 #end of loop 4
	sll $0, $0, 0

	##following prints result
	la $a0, max
	li $v0, 4
	syscall
	addi $a0, $t3, 0
	li $v0, 1
	syscall

# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#PART 6 - loop through the array to calculate how many values are above and below the average 
#$t1 is used as loop counter
#$t0 contains array address 
#$t3 contains # of elements above average
#$t5 contains # of elements below average
#$t4 contains temporary value
#$t6 contains the average of all values in array
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
	addi $t1, $t2, 0
	li $t3, 0
	li $t5, 0
	
	loop5:
	la $t0, 4($t0)
	lw $t4, 0($t0)
	ble $t6, $t4, abo 
	sll $0, $0, 0

	bel:
	addi $t5, $t5, 1
	b cont3
	sll $0, $0, 0

	abo:
	addi $t3, $t3, 1

	cont3:
	addi $t1, $t1, -1
	bgtz $t1, loop5 #end of loop 5
	sll $0, $0, 0

	##following prints result for aboce
	la $a0, above
	li $v0, 4
	syscall
	addi $a0, $t3, 0
	li $v0, 1
	syscall

	##following prints result for below
	la $a0, below
	li $v0, 4
	syscall
	addi $a0, $t5, 0
	li $v0, 1
	syscall

# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#EXTRA CREDIT - sorts data
#$t1 contains end of array address
#$t0 contains array address 
#$t3 contains current value
#$t5 contains next value (used to compare)
#$t9 contains boolean value to see if a swap occured
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
	la $t1, array
	addi $t9, $t2, 0	
	
	#inPos is used to get the end of the array
	inPos:
	addi $t9, $t9, -1
	beqz $t9, sort
	sll $0, $0, 0
	la $t1,4($t1)
	j inPos
	sll $0, $0, 0
	
	#following sorts the array 
	sort:
	la $t0, array
	li $t9, 1
	beq $t1, $t0, end3
	sll $0, $0, 0
	
	swap:
	lw $t3, 0($t0)
	lw $t5, 4($t0)
	slt $t9, $t5, $t3 
	beqz $t9, end
	sll $0, $0, 0
	sw $t5, 0($t0)
	sw $t3, 4($t0)
	
	end:
	la $t0, 4($t0)
	bgtz $t9, sort	
	sll $0, $0, 0
	bne $t0, $t1, swap
	sll $0, $0, 0
	#end of swap algorithm
	#results can be viewed at the array adress (in my case the array started at address 0x10010000)
	end3:
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#EXTRA CREDIT PART 2 - find median
#$t9 contains the constant 2
#$t1 contains end of array address 
#$t3 contains the median value
#$t5 contains a temporary value
#$t4 contains boolean value to see if the array has an odd or even amount
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
	#following calculates the position of the midpoiny 
	la $t0, array
	li $t9, 2
	div $t2, $t9
	mfhi $t3
	mflo $t5
	add $t5, $t5, $t3
	seq $t4, $t3, $0 #if $t4 is 1, then values are even, else its odd

	li $t3, 1	
	#loop6 goes yo midpoint
	loop6:
	beq $t3, $t5, go
	la $t0, 4($t0)
	addi $t3, $t3, 1
	j loop6
	sll $0, $0, 0

	go:	
	beq $t4, 1, even
	sll $0, $0, 0
	
	#if odd
	lw $t3, 0($t0)
	j end2
	sll $0, $0, 0
	
	#if even
	even:
	#following adds midpoint pluss next value 
	lw $t3, 0($t0)
	lw $t5, 4($t0)
	add $t3, $t3, $t5 #median stored into $t3
	div $t3, $t9
	mflo $t3
	mfhi $t5
	add $t3, $t3, $t5

	end2:
	#outputs the median
	la $a0, median
	li $v0, 4
	syscall
	addi $a0, $t3, 0
	li $v0, 1
	syscall
	
	
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#EXTRA EXTRA CREDIT - Finds mode
#$t0 contains array address
#$t1 contains array counter
#$t3 contains most frequently used value
#$t4 contains temporary value
#$t5 contains frequency counter
#$t6 contains boolean value 
#$t7 contains previous value
#$t8 contains previous value counter
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
	la $t0, array
	li $t5, 0
	addi $t1, $t2, 0

	loop7:
	li $t8, 0
		
	inner:
	lw $t4, 0($t0)
	addi $t8, $t8, 1
	sne $t6, $t4, $t7 #if the temp value != the previous value, set $t6 to 1
			  #....That means we are at a new value  
	bnez $t6, continue
	sll $0, $0, 0
	blt $t8, $t5, continue #if we arent at a new value and this value isnt as
			       #frequent as the previous most frequent value, then jump to continue 
	sll $0, $0, 0
	addi $t5, $t8, 0
	lw $t3, 0($t0)	
	
	continue:
	lw $t7, 0($t0)
	la $t0, 4($t0)
	addi $t1, $t1, -1
	beqz $t1, finish #if at end of array
	sll $0, $0, 0
	beqz $t6, inner #if previous and current are
	sll $0, $0, 0
	bnez $t1, loop7 #else case
	sll $0, $0, 0

	finish:
	##following prints result
	la $a0, mode
	li $v0, 4
	syscall
	addi $a0, $t3, 0
	li $v0, 1
	syscall

##end program
	li $v0, 10
	syscall
