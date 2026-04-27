.data   
    prompt:     .asciiz "Please enter an integer: "
    continue_loop: .asciiz "Would you like to convert another integer? (0 or 1) "
    bmessage:   .asciiz "The binary is: "
    hex_message: .asciiz "The hexadecimal is: 0x"    
    hex_char: .asciiz "0123456789ABCDEF" 
    newline:    .asciiz "\n"
    zeroText:   .asciiz "0"
    buffer:     .space 32 #reserve 32 bytes of memory 
    
.text
.globl main

main:
    loop:
        # ask user for number
        li $v0, 4
        la $a0, prompt
        syscall

        # read integer
        li $v0, 5
        syscall
        move $a0, $v0
        addu $s1, $a0, $zero                #save the integer for hexadecimal conversion  
        jal binary_conversion               # jump to binary conversion and save return address of next line in $ra 
        move $a0, $s1
        jal hex_conversion                  #jumpt to hexadecimal conversion and save return address of the next line in $ra
        
        la $a0, continue_loop
        li $v0, 4
        syscall                     # ask user if they would like to continue the program

        li $v0, 5
        syscall                 # read 0 or 1            

        bne $v0, 1, Exit           #if $v0 not equal to one, then exit
        j loop                      # if $v0 equal to one, loop around

    Exit:
        li $v0, 10
        syscall
            
# ------------------- Functions ----------------------
    binary_conversion: 
            move $t0, $a0
            # print message
            li $v0, 4
            la $a0, bmessage
            syscall

            # if number is 0, go to printZero
            beq $t0, $zero, printZero

            # set up buffer
            la $t1, buffer         # points to buffer
            li $t2, 0              # counter

        saveBits:
            # stop when number becomes 0
            beq $t0, $zero, printBits

            # divide number by 2
            li $t3, 2
            divu $t0, $t3
            mfhi $t4 # remainder
            mflo $t0 # quotient
            # store remainder at address 0($t1)
            sb $t4, 0($t1) 
            addi $t1, $t1, 1
            #increase counter by 1
            addi $t2, $t2, 1

            j saveBits

        printBits:
            # go back to last saved digit
            addi $t1, $t1, -1

        printLoop:
            # if counter=0, exit
            beq $t2, $zero, end_binaryC

            # load one number from buffer
            lb $a0, 0($t1)
            # print one character
            li $v0, 1
            syscall

            addi $t1, $t1, -1
            # counter-1
            addi $t2, $t2, -1

            j printLoop
        
        end_binaryC:
            li $v0, 4
            la $a0, newline
            syscall
            jr $ra                           #finish binary conversion, 1st way
        
        printZero:
            li $v0, 4
            la $a0, zeroText
            syscall
            jr $ra                           #finish binary conversion, 2nd way

    hex_conversion:
        li $t2, 28                  # the first 4 bits are from 31 till 28
        move $t0, $a0

        li $v0, 4
        la $a0, hex_message
        syscall                     #print hexadecimal prompt

        li $t4, 0                   # Indication: if 0, skip zeros. If 1, start printing
        hex_loop:
            blt $t2, $zero end_hexC         #when $t2 becomes negative, exit loop

            srlv $t1, $t0, $t2          #shift bits to the right till the desirable 4 bits are at the end
            andi $t1, $t1, 0xF          #will isolate the last 4 bits

            #check if leading zeros or start printing
            bne $t4, $zero, print_hex               #if $t4 is equal to 1, it can start printing
            bne $t1, $zero, start_printing          # checks if the bits isolated are equal to zero, if not, then it can start printing

            addi $t2, $t2, -4                       #goes to the end position of the next set of bits
            j hex_loop

            start_printing:
                li $t4, 1               # can start printing digits, no leading zeros
            print_hex:
                la $t3, hex_char            #load memory address of hex_char in $t3
                add $t3, $t3, $t1           # offset of $t3 pointer till the hexadecimal conversion is reached
                
                lb $a0, 0($t3)
                li $v0, 11
                syscall                     #print hexadecimal conversion

                addi $t2, $t2, -4           #this is repeated to allow flow and no overuse $ra
                j hex_loop
            end_hexC:
                bne $t4, $zero, done_hex            #if nothing was printed, then the number was 0
                li $v0, 4
                la $a0, zeroText
                syscall
            done_hex:
                li $v0, 4
                la $a0, newline
                syscall
                jr $ra               #finish hexadecimal conversion