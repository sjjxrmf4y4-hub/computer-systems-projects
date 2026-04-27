# Program 3 Part 2
# Function 3: decimal (0-15) to hex using lookup table

.globl main

.data
prompt:    .asciiz "Enter an integer (0-15): "
label:     .asciiz "Hex is: "
nl:        .asciiz "\n"

# lookup table (0-15)
hexTable:  .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

.text
main:
    # ask for number
    li   $v0, 4
    la   $a0, prompt
    syscall

    # read int
    li   $v0, 5
    syscall
    move $t0, $v0          

    # print label
    li   $v0, 4
    la   $a0, label
    syscall

    # get base address of table
    la   $t1, hexTable

    # add offset (input) to base
    add  $t2, $t1, $t0

    # load the character from table
    lb   $t3, 0($t2)

    # print the hex char
    li   $v0, 11
    move $a0, $t3
    syscall

    # newline
    li   $v0, 4
    la   $a0, nl
    syscall

    # end
    li   $v0, 10
    syscall