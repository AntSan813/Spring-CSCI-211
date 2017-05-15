# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
#  Antonio Santos
#  CSCI 211 - Spring 2017
#  Program 5 - Due 4/10/17
#  Note: the counter is not including macros. With that being said, 
#  lw = 4 instructions, sw = 4 instructions, and so on. 
#
#  Another note: the code works the same without clearing the data 
#  addresses, but i figured it will be better to include it.
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

.data
c1: .asciiz "\n1st character entered: "
c2: .asciiz "\n2nd character entered: "
count: .asciiz "\nNumber of instructions between inputs: "

.text
main:

# * POLLING * #
li $t1, 0xffff0000 #get reciever control address
again:
  lw $t2, 0($t1) #get reciever control value
  andi $t2, $t2, 1 #get rightmost bit
  beqz $t2, again #if nothing happened, cha
  nop
  
# * get and store char * #
lw $t3, 4($t1) 
sw $t3, 12($t1) 

# * clear data addresses * #
sw $zero, 4($t1)
sw $zero, 12($t1)


# * POLLING AGAIN WITH COUNTER * #
li $t0, 8 #counter starting with # of instructions executed
          #after first char input
again2:
  lw $t2, 0($t1) 
  addi $t0, $t0, 6 #increment counter by however many instructions 
                   #there are in this loop 
  andi $t2, $t2, 1 
  beqz $t2, again2 
  nop
  
# * get and store char * #
lw $t4, 4($t1) 
sw $t4, 12($t1) 

# * clear data addresses * #
sw $zero, 4($t1)
sw $zero, 12($t1)


# * Ouput char 1 * #
la $a0, c1
li $v0, 4
syscall
move $a0, $t3
li $v0, 11
syscall

# * Ouput char 2 * #
la $a0, c2
li $v0, 4
syscall
move $a0, $t4
li $v0, 11
syscall

# * Ouput # of instructions * #
la $a0, count
li $v0, 4
syscall
move $a0, $t0
li $v0, 1
syscall

#end
li $v0, 10
syscall
