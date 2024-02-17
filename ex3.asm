.global _start

.section .text
_start:
    movq %rsp, %rbp #for correct debugging
    movb $0, bool            # Suppose can't be splitted until proven otherwise
    movl $0x80000000, %eax   # inc = -Inf
    movl $0x7FFFFFFF, %ebx   # dec = Inf


    movl $0, %esi            # esi is index for up_array
    movl $0, %edi            # edi is index for down_array
    movl $0, %ecx            # i = 0
    movl size, %edx          # Load array length


loop:
    cmpl %edx, %ecx          # Compare i with len(array)
    jge  end            # If i >= len(array), jump to end

    movl source_array(,%ecx,4), %r8d  # Load arr[i] into r8d
    cmpl %eax, %r8d                   # Compare inc with arr[i]
    jle elif1                         # If inc >= arr[i], jump to elif1
    cmpl %r8d, %ebx                   # Compare arr[i] with dec
    jle elif1                         # If arr[i] >= dec, jump to elif1
    jmp if                            # If inc < arr[i] < dec, jump to if

    
jmp  end_loop                     # FAIL


if:
    incl %ecx                         # i++
        cmpl %edx, %ecx                   # Compare i+1 with len(array)
    jge pre_else                          # If i >= len(array), jump to else
    movl source_array(,%ecx,4), %r8d  # Load arr[i] into r8d
    decl %ecx                         # i--
    cmpl %r8d, source_array(,%ecx,4)  # Compare arr[i] with arr[i+1]
    jge else                          # If arr[i] >= arr[i+1], jump to else

    movl source_array(,%ecx,4), %eax
    movl %eax, up_array(,%esi,4)
    incl %esi
    incl %ecx                # i++
    jmp  loop                # Jump back to start of loop

pre_else:
     decl %ecx                         # i--

else:   
    movl source_array(,%ecx,4), %ebx    
    movl %ebx, down_array(,%edi,4)
    incl %edi
    incl %ecx                # i++
    jmp  loop                # Jump back to start of loop

elif1:     
    cmpl source_array(,%ecx,4), %eax
    jge elif2
    movl source_array(,%ecx,4), %eax
    movl %eax, up_array(,%esi,4)
    incl %esi
    incl %ecx                # i++
    jmp  loop                # Jump back to start of loop

elif2:
    cmpl %ebx, source_array(,%ecx,4)
    jge end_loop
    movl source_array(,%ecx,4), %ebx
    movl %ebx, down_array(,%edi,4)
    incl %edi
    incl %ecx                # i++
    jmp  loop                # Jump back to start of loop

jmp end_loop

end:
    movb $1, bool

end_loop:
    cmpb $0, bool
    jne end_programm

    # Clear up_array
    movl $0, %esi
clear_up_array:
    cmpl size, %esi
    jge clear_down_array
    movl $0, up_array(,%esi,4)
    incl %esi
    jmp clear_up_array

    # Clear down_array
clear_down_array:
    movl $0, %edi
clear_down_array_loop:
    cmpl size, %edi
    jge end_programm
    movl $0, down_array(,%edi,4)
    incl %edi
    jmp clear_down_array_loop

end_programm:

