# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
#  Antonio Santos			#
#  CSCI 211 Project 6, Program 1 		#
#  Spring 2017 Due 4/24/17			#
#  This program is used to teach string manipulation using  #
#  MAL				#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
.data
title: .asciiz "---String Manipulation Program 1---\n"

str1: .asciiz "This is a test "
str2: .asciiz "of our string routines."

label1: .asciiz "\nSTRING 1: "
label2: .asciiz "\nSTRING 2: " 
label3: .asciiz "\nAPPENDED STRING: "
.text
main: 
 
  la $a0, title
  li $v0, 4
  syscall 
  
  la $a0, label1
  li $v0, 4
  syscall 
  
  #get first string dynamically
  la $a0, str1
  jal create
  move $a0, $v0
  move $s0, $v0 #save result 
  jal print 
  
  la $a0, label2
  li $v0, 4
  syscall 
  
  #get second string
  la $a0, str2
  jal create
  move $a0, $v0
  move $s1, $v0 #save result
  jal print
  
  la $a0, label3
  li $v0, 4
  syscall 
  
  #get 3rd string by appending first and second
  move $a0, $s0
  move $a1, $s1
  jal append
  move $a0, $v0
  jal print  
    
#end
li $v0, 10
syscall

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
#  Function: Length			#	
#  Parameters: $v0, $a0			#
#  Returns the length of the referenced string pointed to   #
#  by $a0 in register $v0.			#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
length:
  #push ra on stack
  sw $ra, 0($sp)
  addi $sp, $sp -4
  
  #push $s0 onto stack
  sw $s0, 0($sp)
  addi $sp, $sp, -4
  
  move $s0, $a0 #make a safe copy of string address
  li $t0, 0 #initialize counter
  
  keep_going:
    lb $t1, 0($s0)
    beq $t1, 0x00, stop #null pointer is used as flag 
    nop
    addi $t0, $t0, 1
    la $s0, 1($s0)
    j keep_going
    nop
  stop:
 
  move $v0, $t0 #return counter
   
  #restore $s0 
  lw $s0, 4($sp)
  addi $sp, $sp, 4
  
  #pop ra from stack and return to caller
  lw $ra, 4($sp)
  addi $sp, $sp, 4
  jr $ra
  nop

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
#  Function: Create			#
#  Parameters: $v0, $a0			#
#  Returns a pointer in $v0 to the ASCII string that it 	#
#  dynamically allocates and copies the characters in the 	#
#  string pointed to by the pointer in $a0 into the new	# 
#  string created.			#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
create:
  #push ra on stack
  sw $ra, 0($sp)
  addi $sp, $sp -4
  
  #push $s0 onto stack
  sw $s0, 0($sp)
  addi $sp, $sp, -4
  
  move $s0, $a0 #safe copy address of old address of string
  
  jal length #get length of string
  nop 
  move $t0, $v0 #length is now in $t0
 
  #check and make sure the length is divisable by 4
  li $t1, 4
  div $t0, $t1
  mfhi $t2
  beqz $t2, continue #if we have a remainder (meaning we arent
  	         #divisable by 4)
  nop
    sub $t1, $t1, $t2 #then we add the difference of 4
    add $t0, $t0, $t1 #and our remainder and put it in $t0
  continue:
  
  #now we allocate memory
  move $a0, $t0 
  li $v0, 9
  syscall 
  
  #push $s1 onto stack
  sw $s1, 0($sp)
  addi $sp, $sp, -4
  
  move $s1, $v0 #safe copy address of new string
  
  #copy old string into new string
  get_next:
    lb $t0, 0($s0)
    beq $t0, 0x00, done
    nop
    sb $t0, 0($s1)
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    j get_next 
    nop    
  done:
  
  #restore $s1
  lw $s1, 4($sp)
  addi $sp, $sp, 4
  
  #restore $s0 
  lw $s0, 4($sp)
  addi $sp, $sp, 4
 
  #pop ra from stack and return to caller
  lw $ra, 4($sp)
  addi $sp, $sp, 4
  jr $ra
  nop
  
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
#  Function: Append			#
#  Parameters: $v0, $a0, $a1			#
#  Returns a pointer in $v0 to the dynamic string that 	#
#  results from concatenating the two ASCII strings pointed #
#  to by $a0 and $a1.			#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
append:
  #push ra on stack
  sw $ra, 0($sp)
  addi $sp, $sp -4
  #push $s0 onto stack
  sw $s0, 0($sp)
  addi $sp, $sp, -4
  #push $s1 onto stack
  sw $s1, 0($sp)
  addi $sp, $sp, -4
  
  move $s0, $a0 #safe copy the first string
  move $s1, $a1 #safe copy the second string
  
  jal length #get length of first string
  move $t0, $v0 #and put it into $t0
  move $a0, $a1 
  
  #push $t0 onto stack
  sw $t0, 0($sp)
  addi $sp, $sp, -4
  
  jal length #now get length of 2nd string
  move $t1, $v0 #and put it into $t1
  
  #restore $t0 from stack
  lw $t0, 4($sp)
  addi $sp, $sp, 4
  
  add $t2, $t0, $t1 #get size of master string
  move $t4, $t0 #safe copy first string size
  move $t5, $t1 #safe copy second string size
  
  #check and make sure the length is divisable by 4
  li $t1, 4
  div $t0, $t1
  mfhi $t2
  beqz $t2, continue2 #if we have a remainder (meaning we arent
                      #divisable by 4)
  nop
  sub $t1, $t1, $t2 #then we add the difference of 4
  add $t0, $t0, $t1 #and our remainder and put it in $t0
  continue2:
  
  #now we allocate memory
  move $a0, $t0
  li $v0, 9
  syscall 

  #store $s2 to stack
  sw $s2, 0($sp)
  addi $sp, $sp, -4
  
  move $s2, $v0 #safe copy beginning of master string
  
  #copy first string onto master string
  append_next:
    lb $t3, 0($s0)
    beqz $t4, done2 #counter used as flag to go through first string
    nop
    sb $t3, 0($s2)
    addi $s0, $s0, 1
    addi $s2, $s2, 1
    addi $t4, $t4, -1 
    j append_next 
    nop    
  done2:
  
  #copy second string onto master string
  append_next2:
    lb $t3, 0($s1)
    beqz $t5, done3 #counter used as flag to go through second string
    nop
    sb $t3, 0($s2)
    addi $s1, $s1, 1
    addi $s2, $s2, 1
    addi $t5, $t5, -1
    j append_next2
    nop    
  done3:
    
  #restore $s2 
  lw $s2, 4($sp)
  addi $sp, $sp, 4
  
  #restore $s1
  lw $s1, 4($sp)
  addi $sp, $sp, 4
  
  #restore $s0 
  lw $s0, 4($sp)
  addi $sp, $sp, 4

  #pop ra from stack and return to caller
  lw $ra, 4($sp)
  addi $sp, $sp, 4
  jr $ra
  nop
  
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
#  Function: Print			#
#  Parameters: $a0			#
#  Prints the string pointed to by the pointer in $a0.	#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
print:
  #push ra on stack
  sw $ra, 0($sp)
  addi $sp, $sp -4
  
  li $v0, 4
  syscall   

  #pop ra from stack and return to caller
  lw $ra, 4($sp)
  addi $sp, $sp, 4
  jr $ra
  nop
