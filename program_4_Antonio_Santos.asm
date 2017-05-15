# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#	Antonio Santos
#	Spring 2017 CSCI 211 - Program 4
#	Due 3/23/2017
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

.text
main:

##READ##
	la $a1, array #a0 holds iniial start of array
	
	li $s0, 0
	loop:
		beq $s0, 10, exit 
		sll $0, $0, 0
		jal vRead
		sll $0, $0, 0
		
		#Another last value check
		beq $v0, -9, takeout
		sll $0,$0,0

		addi $s0, $s0, 1
		j loop #end of loop
   		sll $0, $0, 0
   	j exit
   	sll $0, $0, 0
   	
   	#if we hit a -9 we want to take it out of array
   	takeout: 
   		li $v0, 0
   		sw $v0, -4($a1)
 	exit:
  	#Notice: $s0 contains the size of array now
  	
##FIND SUM##
   	la $a0, array #a0 holds iniial start of array
	
	jal findSum
	sll $0, $0, 0
		move $t0, $v0
		la $a0, sum
		li $v0, 4
		syscall
		addi $a0, $t0, 0
		li $v0, 1
		syscall
	
##FIND AVERAGE##
	la $a0, array #a0 holds iniial start of array
		
	jal findAverage
	sll $0, $0, 0
		move $t0, $v0
		la $a0, avg
		li $v0, 4
		syscall
		addi $a0, $t0, 0
		li $v0, 1
		syscall

##FIND MINIMUM##	
	la $a0, array #a0 holds iniial start of array

	jal findMin
	sll $0, $0, 0
		move $t0, $v0
		la $a0, min
		li $v0, 4
		syscall
		addi $a0, $t0, 0
		li $v0, 1
		syscall

##FIND MAX##
	la $a0, array #a0 holds iniial start of array

	jal findMax
	sll $0, $0, 0
		move $t0, $v0
		la $a0, max
		li $v0, 4
		syscall
		addi $a0, $t0, 0
		li $v0, 1
		syscall

##FIND DISTRIBUTION##
	la $a0, array #a0 holds iniial start of array
	jal findDistro
	sll $0, $0, 0
		move $t0, $v0
		##following prints result for aboce
		la $a0, above
		li $v0, 4
		syscall
		addi $a0, $t0, 0
		li $v0, 1
		syscall
	
		move $t0, $v1
		##following prints result for below
		la $a0, below
		li $v0, 4
		syscall
		addi $a0, $t0, 0
		li $v0, 1
		syscall

	
	##end program
	li $v0, 10
	syscall
	
	
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#FUNCTION 1 - loop that reads in th 10 values into the array
#returns array at an address 4 bits away from last popped
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
vRead:
	#push return address
	sw $ra, 0($sp)
	addi $sp, $sp, -4

	#get user input
	la $a0, prompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	#put inputted value into array
	sw $v0, 0($a1)
	#increment your array by 4 
	la $a1, 4($a1)
	
	#get return address from stack and jump to it
	lw $ra, 4($sp)
	add $sp, $sp, 4
	jr $ra

# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#FUNCTION 2 - loop through the array to sum up all values in the array
#passes array and array counter
#returns sum
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
findSum:
	#push return address
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	
	#push size onto stack
	sw $s0, 0($sp)
	add $sp, $sp,-4
	
	li $v0, 0
	##CALCULATE SUM##
	loop2:
		beqz $s0, done
		sll $0, $0, 0
		lw $t1, 0($a0) #get temporary val
		la $a0, 4($a0)
		add $v0, $v0, $t1 #add temporary val into sum
		addi $s0, $s0, -1
		j loop2 #end of loop 2
		sll $0, $0, 0
	done:	
	
	#restore the size
	lw $s0, 4($sp)
	add $sp, $sp, 4
	
	#get return address from stack 
	lw $ra, 4($sp)
	add $sp, $sp, 4

	jr $ra
	
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#FUNCTION 3 - calculate the average
#takes in counter and array as parameters
#returns average
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
findAverage:
	#push return address
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	
	jal findSum #pass counter and array 
	sll $0, $0, 0 
	
	move $t0, $v0
	
	##CALCULATE AVERAGE##
	div $t0, $s0
	mflo $v0
	
	#get return address from stack 
	lw $ra, 4($sp)
	add $sp, $sp, 4
	
	jr $ra
	
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#FUNCTION 4 - loop through array to find the minimum
#takes in the array size and array as parameters
#returns minimum
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
findMin:
	#push return address
	sw $ra, 0($sp) 
	addi $sp, $sp, -4
	
	#save array starting point
	sw $a0, 0($sp)
	addi $sp, $sp, -4
		
	jal findMax #pass coutner and array
	sll $0, $0, 0
	
	#restore the array start point
	lw $a0, 4($sp)
	addi $sp, $sp, 4
	
	#save size
	sw $s0, 0($sp)
	add $sp, $sp, -4
	
	##CALCUALATE MIN##
	loop3:
		lw $t0, 0($a0)
		bgt $t0, $v0, cont
		sll $0, $0, 0
		addi $v0, $t0, 0

	cont:
		la $a0, 4($a0)
		addi $s0, $s0, -1
		bgtz $s0, loop3 #end of loop 3
		sll $0, $0, 0

	#restore the size
	lw $s0, 4($sp)
	add $sp, $sp, 4
	
	#get return address from stack 
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#FUNCTION 5 - loop through the array to find the maxima
#takes in the array size and array as parameters
#returns maxima
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
findMax:
	#push return address
	sw $ra, 0($sp)
	addi $sp, $sp, -4

	#save size
	sw $s0, 0($sp)
	add $sp, $sp, -4
	
	li $v0, 0
	loop4: #adds next value into array
		lw $t0, 0($a0)
		blt $t0, $v0, cont2
		sll $0, $0, 0
		addi $v0, $t0, 0
	cont2: #conditional to check if we are at end of array
		la $a0, 4($a0)
		addi $s0, $s0, -1
		bgtz $s0, loop4 #end of loop 4
		sll $0, $0, 0

	#restore the size 
	lw $s0, 4($sp)
	addi $sp, $sp, 4	
	
	#get return address from stack 
	lw $ra, 4($sp)
	add $sp, $sp, 4
	
	jr $ra
	

# # # # # # # # # # # # # # # # # # # # # # # # # # # 
#FUNCTION 6 - loop through the array to calculate how many values are above and below the average 
#takes in size and array
#returns the # of values above and below the average
# # # # # # # # # # # # # # # # # # # # # # # # # # # 
findDistro:
	#push return address
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	
	#save size
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	
	#save array starting position
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	
	jal findAverage #pass in counter and array
	sll $0, $0, 0

	move $t0, $v0 #get avg
	
	#restore array starting position
	lw $a0, 4($sp)
	addi $sp, $sp, 4
	
	li $v0, 0
	li $v1, 0
	loop5:
		lw $t1, 0($a0)
		la $a0, 4($a0)
		ble $t1, $t0, abo 
		sll $0, $0, 0
	bel: #if above
		addi $v0, $v0, 1 #adds 1 if value is below avg
		b cont3
		sll $0, $0, 0
	abo: #if below
		addi $v1, $v1, 1 #adds 1 if value is above avg
	cont3:
		addi $s0, $s0, -1
		bgtz $s0, loop5 #end of loop 5
		sll $0, $0, 0
	
	#restore the size 
	lw $s0, 4($sp)
	addi $sp, $sp, 4
	#get return address from stack 
	lw $ra, 4($sp)
	add $sp, $sp, 4
	
	jr $ra
