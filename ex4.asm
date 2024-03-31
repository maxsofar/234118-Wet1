.global _start

.section .text
_start:
    movb $3, result     # Assume the list is strictly ascending until proven otherwise
    movq head, %rax     # Load the address of the first node into %rax
    test %rax, %rax     # Test if %rax (head) is null (empty list)
    jz end_program_HW1  # If it is, jump to end_program

    movq (%rax), %rbx   # Load the data of the first node
    addq $8, %rax       # Move to the 'next' field of the first node
    movq (%rax), %rax   # Load the address of the next node

    xor %r9d, %r9d      # This will track if we've encountered a decrease in the sequence

loop_HW1:
    test %rax, %rax     # Check if the current node is NULL
    jz end_program_HW1  # If it is, we've reached the end of the list

    cmpq %rbx, (%rax)   # Compare the data of the current node with the previous node
    jbe check_equal_HW1 # If the current node's data is less than or equal to the previous node's data, check if it's equal

    movq (%rax), %rbx   # Load the data of the current node
    addq $8, %rax       # Move to the 'next' field of the current node
    movq (%rax), %rax   # Load the address of the next node
    jmp loop_HW1        # Jump back to the start of the loop

check_equal_HW1:
    je equal_found_HW1  # If the current node's data is equal to the previous node's data, mark that an equal element was found

    inc %r9d            # Increment the decrease counter
    cmpb $2, %r9b       # Check if we've encountered more than one decrease
    jge none_HW1        # If we have, the list is not ascending

    movb $1, result     # The list is almost ascending
    jmp update_node_HW1 # Update the current node and continue the loop

equal_found_HW1:
    testb $1, %r9b      # Check if we've already encountered a decrease
    jnz update_node_HW1 # If we have, the list is not ascending
    movb $2, result     # The list is ascending but not strictly ascending

update_node_HW1:
    movq (%rax), %rbx   # Load the data of the current node
    addq $8, %rax       # Move to the 'next' field of the current node
    movq (%rax), %rax   # Load the address of the next node
    jmp loop_HW1        # Jump back to the start of the loop

none_HW1:
    movb $0, result     # The list is not ascending

end_program_HW1:
  
