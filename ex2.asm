# This is freaking DFS in assembly you guys

/*
 *  Registers:
 *  r8-r15    are used to keep track of visited vertices (manual stack)
 *  rsi       is used as a counter for the number of visited neighbors on each level
 *  rax       is used to point to the current vertex in the vertices array
 *  rcx       is used to point to the current vertex on rest of adjacency lists
 *  rbx       is used to store the value of the current vertex
 */ 

.global _start

.section .text
_start:
    # Initialize registers r8-r15 to null (vertex flags)
    xorq %r8, %r8
    xorq %r9, %r9
    xorq %r10, %r10
    xorq %r11, %r11
    xorq %r12, %r12
    xorq %r13, %r13
    xorq %r14, %r14
    xorq %r15, %r15
    xorq %rsi, %rsi

    movq $-1, circle     # Suppose cycle not found until proven differently

    lea vertices, %rax   # Load the address of vertices into rax
    movq %rax, %rcx      # Copy top level pointer to rcx
    mov (%rax), %rbx     # Load the first element of the array into rbx
    
    cmpq $0, %rbx        # Check if we have any vertices
    je end_program_HW1       # If not, end the program
    
main_loop_HW1:     
    cmpq $0, %rbx        # Check if we reached the end (0 in the array)
    je backtrack_HW1
    
    # Check if vertex is already visited by looping over r8-r15
    cmpq %rbx, %r8
    je cycle_found_HW1
    cmpq %rbx, %r9
    je cycle_found_HW1
    cmpq %rbx, %r10
    je cycle_found_HW1
    cmpq %rbx, %r11
    je cycle_found_HW1
    cmpq %rbx, %r12
    je cycle_found_HW1
    cmpq %rbx, %r13
    je cycle_found_HW1
    cmpq %rbx, %r14
    je cycle_found_HW1
    cmpq %rbx, %r15
    je cycle_found_HW1

    # Mark vertex as visited by copying it to the first empty register
    cmpq $0, %r8
    je mark_r8_HW1
    cmpq $0, %r9
    je mark_r9_HW1
    cmpq $0, %r10
    je mark_r10_HW1
    cmpq $0, %r11
    je mark_r11_HW1
    cmpq $0, %r12
    je mark_r12_HW1
    cmpq $0, %r13
    je mark_r13_HW1
    cmpq $0, %r14
    je mark_r14_HW1
    cmpq $0, %r15
    je mark_r15_HW1

mark_r8_HW1:
    movq %rbx, %r8
    jmp visit_neighbor_HW1
mark_r9_HW1:
    movq %rbx, %r9
    jmp visit_neighbor_HW1
mark_r10_HW1:
    movq %rbx, %r10
    jmp visit_neighbor_HW1
mark_r11_HW1:
    movq %rbx, %r11
    jmp visit_neighbor_HW1
mark_r12_HW1:
    movq %rbx, %r12
    jmp visit_neighbor_HW1
mark_r13_HW1:
    movq %rbx, %r13
    jmp visit_neighbor_HW1
mark_r14_HW1:
    movq %rbx, %r14
    jmp visit_neighbor_HW1
mark_r15_HW1:
    movq %rbx, %r15
    jmp visit_neighbor_HW1

next_neighbor_HW1:
    inc %sil          # Increment the current counter
    addq $8, %rcx     # Move to the next pointer in the array
    movq (%rcx), %rbx # Move the value at the new address to rbx
    jmp main_loop_HW1 # Jump to main_loop


visit_neighbor_HW1:
    movq %rbx, %rdx   # Save old rbx value into a temporary register (rdx)
    movq (%rbx), %rbx # Load the neighbor into rbx
    shlq $8, %rsi     # Shift counter register to the left by 8 bits
    test %rbx, %rbx   # Compare new rbx with 0
    jz main_loop_HW1  # If new rbx is 0 (sink node), jump to main_loop without updating rsi and rcx
    
    movq %rdx, %rcx   # Update rcx with the old value of rbx
    jmp main_loop_HW1 # Jump to main_loop

backtrack_HW1:
    # Find the last occupied cell in our "stack"
    cmpq $0, %r9
    je unmark_r8_HW1
    
    cmpq $0, %r10
    je unmark_r9_HW1
    
    cmpq $0, %r11
    je unmark_r10_HW1
    
    cmpq $0, %r12 
    je unmark_r11_HW1
    
    cmpq $0, %r13
    je unmark_r12_HW1
    
    cmpq $0, %r14
    je unmark_r13_HW1
    
    cmpq $0, %r15
    je unmark_r14_HW1
    
    jmp unmark_r15_HW1

unmark_r8_HW1:
    xorq %r8, %r8
    addq $8, %rax      # Move to the next vertex at top level
    cmpq $0, (%rax)    # Compare value pointed by to level pointer to 0
    je end_program_HW1 # If we reached the vertices array end, we finished
    movq (%rax), %rbx  # Otherwise put current top level vertex to rbx
    jmp main_loop_HW1

unmark_r9_HW1:
    xorq %r9, %r9
    shr $8, %rsi      # Shift rsi by 8 bits to the right
    movzx %sil, %edx  # Move LSB of rsi to edx
    shl $3, %edx      # Multiply by 8 to get the offset
    addq %r8, %rdx    # Add the offset to the previous ri-1
    movq %rdx, %rcx   # Move the value at the new address to rcx
    jmp next_neighbor_HW1

unmark_r10_HW1:
    xorq %r10, %r10
    shr $8, %rsi      # Shift rsi by 8 bits to the right
    movzx %sil, %edx  # Move LSB of rsi to edx
    shl $3, %edx      # Multiply by 8 to get the offset
    addq %r9, %rdx    # Add the offset to the previous ri-1
    movq %rdx, %rcx   # Move the value at the new address to rcx
    jmp next_neighbor_HW1

unmark_r11_HW1:
    xorq %r11, %r11
    shr $8, %rsi      # Shift rsi by 8 bits to the right
    movzx %sil, %edx  # Move LSB of rsi to edx
    shl $3, %edx      # Multiply by 8 to get the offset
    addq %r10, %rdx   # Add the offset to the previous ri-1
    movq %rdx, %rcx   # Move the value at the new address to rcx
    jmp next_neighbor_HW1

unmark_r12_HW1:
    xorq %r12, %r12
    shr $8, %rsi      # Shift rsi by 8 bits to the right
    movzx %sil, %edx  # Move LSB of rsi to edx
    shl $3, %edx      # Multiply by 8 to get the offset
    addq %r11, %rdx   # Add the offset to the previous ri-1
    movq %rdx, %rcx   # Move the value at the new address to rcx
    jmp next_neighbor_HW1

unmark_r13_HW1:
    xorq %r13, %r13
    shr $8, %rsi      # Shift rsi by 8 bits to the right
    movzx %sil, %edx  # Move LSB of rsi to edx
    shl $3, %edx      # Multiply by 8 to get the offset
    addq %r12, %rdx   # Add the offset to the previous ri-1
    movq %rdx, %rcx   # Move the value at the new address to rcx
    jmp next_neighbor_HW1

unmark_r14_HW1:
    xorq %r14, %r14
    shr $8, %rsi      # Shift rsi by 8 bits to the right
    movzx %sil, %edx  # Move LSB of rsi to edx
    shl $3, %edx      # Multiply by 8 to get the offset
    addq %r13, %rdx   # Add the offset to the previous ri-1
    movq %rdx, %rcx   # Move the value at the new address to rcx
    jmp next_neighbor_HW1

unmark_r15_HW1:
    xorq %r15, %r15
    shr $8, %rsi      # Shift rsi by 8 bits to the right
    movzx %sil, %edx  # Move LSB of rsi to edx
    shl $3, %edx      # Multiply by 8 to get the offset
    addq %r14, %rdx   # Add the offset to the previous ri-1
    movq %rdx, %rcx   # Move the value at the new address to rcx
    jmp next_neighbor_HW1

cycle_found_HW1:
    movq $1, circle

end_program_HW1:

