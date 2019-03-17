# Who:  Jay Chen
# What: fibonacci.asm
# Why:  Implementation of CS 2640 Project 2
# When: Due 3/17/19
# How:  List the uses of registers
# $t0 - stores user input integer n
# $t1 - validates input, a value in fib
# $t2 - validates input, b value in fib
# $t3 - array ref var in fib
# $t4 - temp var in fib
# $t5 - counter var for fib loops, allows the code to preserve user input by copying its value

.data
    prompt:          .asciiz     "\nenter unsigned int (0-47):\nn --> "
    error:           .asciiz     "error: int OOB, input 32-bit unsigned int (0-47)\n"
    curr_output:     .asciiz     "fibonacci: "
    list_output:     .asciiz     "\nfibonacci sequence: " 
    MAX_INT:         .word       47
    array:           .space      192     # 4*48, n=47th fibonacci number is the last one that can be held by unsigned int (<2^32-1)
    .align 2

.text
.globl main


main:	# program entry
    
input_loop:
    la $a0, prompt         # print prompt
    li $v0, 4
    syscall

    li $v0, 5              # read integer from user
    syscall

    move $t0, $v0          # t0 <-- user int 

    chk_input:
    la $t2, MAX_INT
    lw $t2, 0($t2)
    slt $t1, $t2, $t0      # check input greater than max int for fibonacci range (0-47)  
    slt $t2, $t0, $0       # check input less than 0
    or $t1, $t1, $t2       # if t1||t2 == 1, t1 <-- 1
    beq $t1, $0, fibonacci # t1 && t2==0, means valid int entered

    print_error:
    la $a0, error 
    li $v0, 4
    syscall
    j input_loop

fibonacci:
    la $t3, array          # t3 references start of array

    li $t1, 0              # load init fib value into position 0 of array (no calculation for n=0)
    sw $t1, 0($t3)         # set array[0] = 0
    beq $t0, $zero, result # if n = 0, skip straight to output print 

    li $t2, 1              
   
    addi $t3, $t3, 4       # increment array position by 4 so starting at fib 1 not 0
    addi $t1, $t1, 1       # increment a value by 1, because a = 0 was already stored above and n>=1
    move $t5, $t0          # duplicate user input into t5 for counter var

    fib_loop:
    sw $t1, 0($t3)               # a --> t3
    move $t4, $t2                # temp <-- b
    addu $t2, $t2, $t1           # b <-- t2(b) + t1(a)
    move $t1, $t4                # a <-- temp 
    addi $t5, $t5, -1            # for n>=2 decrement counter
    beq  $t5, $zero, result      # end loop if array has reached size n
    addi $t3, $t3, 4             # increment array pointer
    j fib_loop                   # else keep looping

result:
    la $a0, curr_output          # print label for output
    li $v0, 4
    syscall

    lw $a0, 0($t3)               # print fibonacci # for user input n
    li $v0, 36                   # 36 is unsigned int print
    syscall

    la $a0, list_output          # print label for output
    li $v0, 4
    syscall

    la $t3, array                # reset t3 to start of array
    move $t5, $t0                # reset counter var t5 to user input n

    output_loop:
    lw $a0, 0($t3)               # print every fib number in array up to n 
    li $v0, 36                   # 36 is unsigned int print
    syscall

    #print space after int
    li $a0, 32                  #ascii 32 for whitespace
    li $v0, 11                  #syscall code for printing character
    syscall
    
    addi $t3, $t3,  4           #increment array pointer
    beq $t5, $zero, end         #check if counter has reached 0
    addi $t5, $t5, -1           #decrement counter
    j output_loop
end:

exit:
li $v0, 10		# terminate the program
syscall

# fib(n):
#   a = 0
#   b = 1
#   for i from 0 to n - 1:
#   array [i] = a
#   temp = b
#   b += a //(array[i])
#   a = temp

# Your program will read from input the value of n. Be sure to validate user input and report errors when
# necessary. n must be a positive number that can not be too large that the value of f(n) cannot be expressed
# with a 32-bit unsigned integer and can be output to the console. Note: You may need to use a different
# syscall code to print an unsigned integer value to the console.
# While iterating through this loop, store the value of f(k) (for k = 0, 1, 1, 2, 3,…, N) in an array. This array
# should be large enough to contain N values (where N is the largest permissible value of n). In other words,
# store each number of the fibonacci sequence up to, and including, the nth number in the array.
# Your program should then output the nth Fibonacci number, then, on a separate line, output the entire portion
# of the sequence stored in the array with each value separated by a space. Use appropriate prompts to
# describe the output.
# Execute the program for n = 10 and n = 20. Save a copy of the output.

