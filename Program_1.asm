
# Program 1 of part 2 Check the time of day by inputting a clock time 
.globl main
.data
prompt: .asciiz "Enter hour (0-23): "
morning: .asciiz "It is morning. \n"
noon: .asciiz "It is noon. \n"
afternoon: .asciiz "it is afternoon. \n"
midnight: .asciiz "it is midnight.\n"

.text
main:
li $v0, 4
la $a0, prompt
syscall

li $v0, 5
syscall
move $t1, $v0

beq $t1, $zero, print_midnight

li $t0, 12
beq $t1, $t0, print_noon

slt $t2, $t1, $t0
bne $t2, $zero, print_morning

j print_afternoon

print_midnight:
li $v0, 4
la $a0, midnight
syscall
j exit

print_noon:
li $v0, 4 
la $a0, noon
syscall
j exit

print_morning:
li $v0, 4
la $a0, morning
syscall 
j exit

print_afternoon:
li $v0, 4
la $a0, afternoon 
syscall

exit:
li $v0, 10
syscall
