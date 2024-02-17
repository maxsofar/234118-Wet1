.global _start

.section .text
_start:
  # Process the character
    movb character, %al

    # Check if the character is out of range of keyboard characters
    cmpb $33, %al
    jb out_of_range_HW1
    cmpb $126, %al
    ja out_of_range_HW1

    # check if character is ' and shift it to "
    cmpb $39, %al
    jne next1_HW1
    movb $34, %al
    jmp end_HW1
next1_HW1:
    # check if character is - and shift it to _
    cmpb $45, %al
    jne next2_HW1
    movb $95, %al
    jmp end_HW1
next2_HW1:
    # check if character is , and shift it to <
    cmpb $44, %al
    jne next3_HW1
    movb $60, %al
    jmp end_HW1
next3_HW1:
    # check if character is . and shift it to >
    cmpb $46, %al
    jne next4_HW1
    movb $62, %al
    jmp end_HW1
next4_HW1:
    # check if character is / and shift it to ?
    cmpb $47, %al
    jne next5_HW1
    movb $63, %al
    jmp end_HW1
next5_HW1:
    # check if character is 0 and shift it to )
    cmpb $48, %al
    jne next6_HW1
    movb $41, %al
    jmp end_HW1
next6_HW1:
    # check if character is 1 and shift it to !
    cmpb $49, %al
    jne next7_HW1
    movb $33, %al
    jmp end_HW1
next7_HW1:
    # check if character is 2 and shift it to @
    cmpb $50, %al
    jne next8_HW1
    movb $64, %al
    jmp end_HW1
next8_HW1:
    # check if character is 3 and shift it to #
    cmpb $51, %al
    jne next9_HW1
    movb $35, %al
    jmp end_HW1
next9_HW1:
    # check if character is 4 and shift it to $
    cmpb $52, %al
    jne next10_HW1
    movb $36, %al
    jmp end_HW1
next10_HW1:
    # check if character is 5 and shift it to %
    cmpb $53, %al
    jne next11_HW1
    movb $37, %al
    jmp end_HW1
next11_HW1:
    # check if character is 6 and shift it to ^
    cmpb $54, %al
    jne next12_HW1
    movb $94, %al
    jmp end_HW1
next12_HW1:
    # check if character is 7 and shift it to &
    cmpb $55, %al
    jne next13_HW1
    movb $38, %al
    jmp end_HW1
next13_HW1:
    # check if character is 8 and shift it to *
    cmpb $56, %al
    jne next14_HW1
    movb $42, %al
    jmp end_HW1
next14_HW1:
    # check if character is 9 and shift it to (
    cmpb $57, %al
    jne next15_HW1
    movb $40, %al
    jmp end_HW1
next15_HW1:
    # check if character is = and shift it to +
    cmpb $61, %al
    jne next16_HW1
    movb $43, %al
    jmp end_HW1
next16_HW1:
    # check if character is ; and shift it to :
    cmpb $59, %al
    jne next17_HW1
    movb $58, %al
    jmp end_HW1
next17_HW1:
    # check if character is [ and shift it to {
    cmpb $91, %al
    jne next18_HW1
    movb $123, %al
    jmp end_HW1
next18_HW1:
    # check if character is \ and shift it to |
    cmpb $92, %al
    jne next19_HW1
    movb $124, %al
    jmp end_HW1
next19_HW1:
    # check if character is ] and shift it to }
    cmpb $93, %al
    jne next20_HW1
    movb $125, %al
    jmp end_HW1
next20_HW1:
    # check if character is ` and shift it to ~
    cmpb $96, %al
    jne next21_HW1
    movb $126, %al
    jmp end_HW1
next21_HW1:
    # check if character is a small letter
    cmpb $97, %al
    jb end_HW1
    cmpb $122, %al
    ja end_HW1
    subb $32, %al
    jmp end_HW1

out_of_range_HW1:
    movb $0xff, shifted
    jmp end_program_HW1
    
end_HW1:
    movb %al, shifted

end_program_HW1:

