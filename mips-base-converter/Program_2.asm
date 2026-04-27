# Program 2 of part 2 
# Calculate the sum of a sequence


.globl main

.data
prompt_first:  .asciiz "Enter the first number: "
prompt_len:    .asciiz "Enter the length of the sequence: "
msg_sum:       .asciiz "Sum is: "
newline:       .asciiz "\n"

.text
main:
    # Ask for first number
    li   $v0, 4
    la   $a0, prompt_first
    syscall

    li   $v0, 5
    syscall
    move $t1, $v0          

    # Ask for length
    li   $v0, 4
    la   $a0, prompt_len
    syscall

    li   $v0, 5
    syscall
    move $t2, $v0          

    # sum = 0, i = 0, current = first
    li   $t3, 0            
    li   $t4, 0            
    move $t5, $t1         

loop:
    beq  $t4, $t2, done

    add  $t3, $t3, $t5     
    addi $t5, $t5, 1       
    addi $t4, $t4, 1       
    j    loop

done:
    # print "Sum is: "
    li   $v0, 4
    la   $a0, msg_sum
    syscall

    # print sum (int)
    li   $v0, 1
    move $a0, $t3
    syscall

    # print newline
    li   $v0, 4
    la   $a0, newline
    syscall

exit:
    li   $v0, 10
    syscall
