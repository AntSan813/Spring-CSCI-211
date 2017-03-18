# # # # # # # # # # # # # # # # # #
# Antonio Santos		  #
# Part 2 for Program 2		  #
# CSCI 211 - Spring 2017	  #
# # # # # # # # # # # # # # # # # # 
.data
pr_line: .asciiz "Enter Pay Rate: "
hrs_line: .asciiz "\nEnter your hours: "
.text
main:
##gets the pay rate##
la $a0, pr_line
li $v0, 4
syscall
li $v0, 5
syscall 
add $t0, $zero, $v0

#Doubles the pay rate
li $t2, 2
mult $t0, $t2
mfhi $t2
mflo $t7
add $t2, $t2, $t7 #t2 contains overtime pay amount

##gets the hours worked##
loop:
la $a0, hrs_line
li $v0, 4
syscall
li $v0, 5
syscall
add $t3, $zero, $v0 #t3 contains hours worked
bge $t3, 40, overtime
bltz $t3, end
b nonover

nonover:
#performs calculation
mult $t3, $t0
mfhi $t1
mflo $t4
add $t1, $t1, $t4 #t1 contains final value
b print

overtime:
#gets first 40 hours of pay rate
li $t4,  40 
mult $t4, $t0
mfhi $t5
mflo $t6
add $t4, $t5, $t6 #t4 contains 40 hour pay amount
#gets over 40 hour pay
addi $t1, $t3, -40 
mult $t1, $t2
mfhi $t1
mflo $t5
add $t1, $t5, $t1 #t1 contains over 40 hour pay amount
#adds double pay and regular pay
add $t1, $t1, $t4 #t1 contains final value
b print

print:
li $v0, 1
addi $a0, $t1, 0 #no matter the case, $t1 will have final result
syscall  

bgtz $t3, loop #condition statement 
b end

end:
##ending statement
li $v0, 10
syscall
