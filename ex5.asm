.global _start

.section .text
_start:
    movq %rsp, %rbp #for correct debugging
    # Load address of the command string into a register
    lea command, %rax
    
    # Set up loop to iterate through each character
find_operand_HW1:
    # Load a character from the string into a register
    movb (%rax), %dl
    
    # Check if end of string
    cmpb $0, %dl
    je end_of_string_HW1
    
    # Check if current character is '$'
    cmpb $'$', %dl
    je found_operand_HW1
    
    # Increment pointer to next character
    inc %rax
    jmp find_operand_HW1

found_operand_HW1:
    # Move to next character after '$'
    inc %rax
    
    # Check the base of the number
    movb (%rax), %dl         # Load the first character after '$'
    cmpb $'0', %dl
    jne decimal_check_HW1    # If it's not '0', it's decimal
    
    # Check for hexadecimal or binary
    movb 1(%rax), %dl        # Load the second character after '$'
    cmpb $'x', %dl
    je hexadecimal_check_HW1 # If it's 'x', it's hexadecimal
    
    cmpb $'b', %dl
    je binary_check_HW1      # If it's 'b', it's binary
    
    cmpb $',', %dl
    je decimal_check_HW1

    # If it's '0' followed by not 'x', 'b' or ',', assume octal
    jmp octal_check_HW1
    
#----------------------------OCTAL----------------------------------------

octal_check_HW1:
    # Pre-calculate powers of 8
    movq $8, %r9               # 8^1
    movq $64, %r10             # 8^2

    movq $0, %r8               # Initialize counter for digit count
    add $1, %rax               # Skip the base indicator '0o'

count_octal_digits_HW1:
    movb (%rax), %dl           # Load the current character
    cmpb $',', %dl
    je start_octal_loop_HW1    # If it's ',', start the loop
    inc %rax                   # Move to the next character
    inc %r8                    # Increase the counter
    jmp count_octal_digits_HW1 # Repeat the loop

start_octal_loop_HW1:
    dec %rax                   # Move back to the last character of the number
    movq $0, %rcx              # Reset counter for power of 8

octal_loop_HW1:
    cmpq $0, %r8               # Check if there are digits left to process
    je end_octal_loop_HW1      # If not, end the loop
    
    xorq %rdx, %rdx            # Zero out %rdx
    movb (%rax), %dl           # Load the current character

    cmpb $'0', %dl             # Check if the character is '0'
    jl invalid_input_HW1       # If it's less, jump to error handling
    cmpb $'7', %dl             # Check if the character is '7'
    jg invalid_input_HW1       # If it's greater, jump to error handling

process_octal_digit_HW1:
    subb $'0', %dl             # Convert from ASCII to integer

multiply_by_power_of_8_HW1:
    cmpq $2, %rcx
    je multiply_by_64_HW1
    cmpq $1, %rcx
    je multiply_by_8_HW1
    jmp add_to_total_octal_HW1

multiply_by_64_HW1:
    imulq %r10, %rdx
    jmp add_to_total_octal_HW1
multiply_by_8_HW1:
    imulq %r9, %rdx

add_to_total_octal_HW1:
    addq %rdx, integer      # Add to the total
    
    dec %rax                # Move to the previous character
    dec %r8                 # Decrease the digit count
    inc %rcx
    jnz octal_loop_HW1      # Repeat the loop if %r8 is not zero

end_octal_loop_HW1:
    movb $1, legal          # Set legal to 1
    jmp end_program_HW1


#-----------------------------DECIMAL------------------------------
decimal_check_HW1:
    # Pre-calculate powers of 10
    movq $10, %r9               # 10^1
    movq $100, %r10             # 10^2

    movq $0, %r8                # Initialize counter for digit count

count_digits_HW1:
    movb (%rax), %dl            # Load the current character
    cmpb $',', %dl
    je check_zero_count_HW1     # If it's ',', check if we haven't counted 0 before
    inc %rax                    # Move to the next character
    inc %r8                     # Increase the counter
    jmp count_digits_HW1        # Repeat the loop

check_zero_count_HW1:
    cmpq $0, %r8                # Check if the count is zero
    jne start_decimal_loop_HW1  # If not, start the decimal loop
    jmp invalid_input_HW1       # If zero, end the program

start_decimal_loop_HW1:
    dec %rax                    # Move back to the last character of the number
    movq $0, %rcx               # Reset counter for power of 10

decimal_loop_HW1:
    cmpq $0, %r8                # Check if there are digits left to process
    je end_decimal_loop_HW1     # If not, end the loop
    
    xorq %rdx, %rdx             # Zero out %rdx
    movb (%rax), %dl            # Load the current character
    cmpb $'0', %dl              # Check if the character is a digit
    jl invalid_input_HW1        # If less than '0', jump to invalid_input
    cmpb $'9', %dl              # Check if the character is a digit
    jg invalid_input_HW1        # If greater than '9', jump to invalid_input
    subb $'0', %dl              # Convert from ASCII to integer

    cmpq $2, %rcx
    je multiply_by_100_HW1
    cmpq $1, %rcx
    je multiply_by_10_HW1
    jmp add_to_total_decimal_HW1

multiply_by_100_HW1:
    imulq %r10, %rdx
    jmp add_to_total_decimal_HW1
multiply_by_10_HW1:
    imulq %r9, %rdx

add_to_total_decimal_HW1:
    addq %rdx, integer      # Add to the total
    
    dec %rax                # Move to the previous character
    dec %r8                 # Decrease the digit count
    inc %rcx
    jnz decimal_loop_HW1    # Repeat the loop if %r8 is not zero

end_decimal_loop_HW1:
    movb $1, legal          # Set legal to 1
    jmp end_program_HW1

#----------------------------BINARY----------------------------------------
binary_check_HW1:
    # Pre-calculate powers of 2
    movq $2, %r9            # 2^1
    movq $4, %r10           # 2^2

    movq $0, %r8            # Reset digit count
    
    add $2, %rax            # Skip the base indicator '0b' or '0x'

count_loop_HW1:
    movb (%rax), %dl        # Load the current character
    cmpb $',', %dl
    je end_count_loop_HW1   # If it's ',', start the loop
    inc %rax                # Move to the next character
    inc %r8                 # Increase the counter
    jmp count_loop_HW1      # Repeat the loop

end_count_loop_HW1:
    dec %rax                # Move back to the last character of the number
    movq $0, %rcx           # Reset counter for power of 2

binary_loop_HW1:
    cmpq $0, %r8            # Check if there are digits left to process
    je end_binary_loop_HW1  # If not, end the loop
    
    xorq %rdx, %rdx         # Zero out %rdx
    movb (%rax), %dl        # Load the current character

    cmpb $'0', %dl          # Check if the character is '0'
    je process_digit_HW1
    cmpb $'1', %dl          # Check if the character is '1'
    jne invalid_input_HW1   # If it's neither, jump to error handling

process_digit_HW1:
    subb $'0', %dl          # Convert from ASCII to integer

    cmpq $2, %rcx
    je multiply_by_4_HW1
    cmpq $1, %rcx
    je multiply_by_2_HW1
    jmp add_to_total_binary_HW1

invalid_input_HW1:
    movb $0, legal
    movl $0, integer
    jmp end_program_HW1

multiply_by_4_HW1:
    imulq %r10, %rdx
    jmp add_to_total_binary_HW1
multiply_by_2_HW1:
    imulq %r9, %rdx

add_to_total_binary_HW1:
    addq %rdx, integer      # Add to the total
    
    dec %rax                # Move to the previous character
    dec %r8                 # Decrease the digit count
    inc %rcx                # Increase the power of 2
    jnz binary_loop_HW1     # Repeat the loop if %r8 is not zero

end_binary_loop_HW1:
    movb $1, legal          # Set legal to 1
    jmp end_program_HW1

#------------------------HEXADECIMAL-------------------------
hexadecimal_check_HW1:
    # Pre-calculate powers of 16
    movq $16, %r9               # 16^1
    movq $256, %r10             # 16^2

    movq $0, %r8                # Initialize counter for digit count
    add $2, %rax                # Skip the base indicator '0b' or '0x'

count_hex_digits_HW1:
    movb (%rax), %dl            # Load the current character
    cmpb $',', %dl
    je start_hex_loop_HW1       # If it's ',', start the loop
    inc %rax                    # Move to the next character
    inc %r8                     # Increase the counter
    jmp count_hex_digits_HW1    # Repeat the loop

start_hex_loop_HW1:
    dec %rax                    # Move back to the last character of the number
    movq $0, %rcx               # Reset counter for power of 16

hex_loop_HW1:
    cmpq $0, %r8                # Check if there are digits left to process
    je end_hex_loop_HW1         # If not, end the loop
    
    xorq %rdx, %rdx             # Zero out %rdx
    movb (%rax), %dl            # Load the current character

    cmpb $'0', %dl              # Check if the character is '0'
    jl invalid_input_HW1        # If it's less, jump to error handling
    cmpb $'9', %dl              # Check if the character is '9'
    jle process_hex_digit_HW1   # If it's less or equal, process the digit
    cmpb $'A', %dl              # Check if the character is 'A'
    jl invalid_input_HW1        # If it's less, jump to error handling
    cmpb $'F', %dl              # Check if the character is 'F'
    jg invalid_input_HW1        # If it's greater, jump to error handling
    jmp process_hex_digit_HW1   # If it's neither, process the digit

process_hex_digit_HW1:
    subb $'0', %dl              # Convert from ASCII to integer
    cmpb $9, %dl
    jle multiply_by_power_of_16_HW1
    subb $7, %dl                # Adjust for hexadecimal A-F
    jmp multiply_by_power_of_16_HW1

multiply_by_power_of_16_HW1:
    cmpq $2, %rcx
    je multiply_by_256_HW1
    cmpq $1, %rcx
    je multiply_by_16_HW1
    jmp add_to_total_hex_HW1

multiply_by_256_HW1:
    imulq %r10, %rdx
    jmp add_to_total_hex_HW1
multiply_by_16_HW1:
    imulq %r9, %rdx

add_to_total_hex_HW1:
    addq %rdx, integer      # Add to the total
    
    dec %rax                # Move to the previous character
    dec %r8                 # Decrease the digit count
    inc %rcx
    jnz hex_loop_HW1        # Repeat the loop if %r8 is not zero

end_hex_loop_HW1:
    movb $1, legal          # Set legal to 1
    jmp end_program_HW1

end_of_string_HW1:
    # '$' not found, handle accordingly
    movb $0, legal          # Set the "legal" label to 0
    
end_program_HW1:

