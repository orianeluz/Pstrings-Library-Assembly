# 326367570 Orian Eluz
    .section .text

# ------------------------
.globl pstrlen
.type pstrlen, @function
pstrlen:
    pushq %rbp            # Save base pointer
    movq %rsp, %rbp       # Set up new pointer

    movzb (%rdi), %rax     # Load the length into %al

    movq %rbp, %rsp       # Restore stack pointer
    popq %rbp             # Restore base pointer
    ret                   # Return


# ------------------------
.globl swapCase
.type swapCase, @function
swapCase:
    push %rbp
    mov %rsp, %rbp
    movq %rdi, %rax       # keep struct pointer in rax

    movzb (%rdi), %rcx    # Set iterator to string length
    leaq 1(%rdi), %rsi    # Set source pointer to start of string

.loop:
    # Load current character
    movb (%rsi), %dl

    # Convert lowercase to uppercase
    cmpb $0x61, %dl        # If char < 'a', skip
    jl .not_lower
    cmpb $0x7A, %dl        # If char > 'z', skip
    jg .not_lower
    andb $0xDF, %dl        # Convert to uppercase
    jmp .store

.not_lower:
    # Convert uppercase to lowercase
    cmpb $0x41, %dl        # If char < 'A', skip
    jl .store
    cmpb $0x5A, %dl        # If char > 'Z', skip
    jg .store
    addb $0x20, %dl        # Convert to lowercase

.store:
    # Store updated character
    movb %dl, (%rsi)
    incq %rsi              # Move to next character
    decb %cl               # Decrement length counter
    testb %cl, %cl         # Check if length == 0
    jnz .loop

.done:
    movq %rdi, %rax        # Return Pstring pointer
    movq %rbp, %rsp
    popq %rbp
    ret

# ------------------------
.globl pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
    # Enter
    push %rbp
    mov %rsp, %rbp

    # Save pointer to &str1 so it can be returned later
    movq %rdi, %r8

    # Check if i is valid
    cmpb $0, %dl
    jl .invalid_cpy # i < 0
    cmpb %cl, %dl
    ja .invalid_cpy # i > j

    # Check if j is valid
    movb (%rdi), %al
    cmpb %al, %cl
    jae .invalid_cpy # j > str1 length
    movb (%rsi), %al
    cmpb %al, %cl
    jae .invalid_cpy # j > str2 length

    # Adjust pointers to start copying from the correct positions
    incq %rdi # Skip length byte
    incq %rsi # Skip length byte
    addq %rdx, %rsi # Move src pointer to start at index i
    addq %rdx, %rdi # Move dst pointer to start at index i
    movb %cl, %bl # Save j in %bl
    subb %dl, %bl 
    incb %bl # Increment to include j

    xorb %al, %al # Clear %al for safety

.copy_loop:
    cmpb $0, %bl           # Check if done
    je .done_copy
    movb (%rsi), %al       # Copy character from src
    movb %al, (%rdi)       # Paste character into dst
    incq %rsi              # Move src pointer
    incq %rdi              # Move dst pointer
    decb %bl               # Decrement length counter
    jmp .copy_loop

.done_copy:
    # Update the length byte in dst
    movb (%r8), %al        # Load original length of dst
    movb %al, (%r8)        # Update dst->len with original length
    movq %r8, %rax         # Return pointer to dst

    # Clean up and return
    movq %rbp, %rsp
    popq %rbp
    ret

.invalid_cpy:
    # Print invalid input error message
    movq $invalid_input_msg, %rdi
    xorq %rax, %rax        # Clear rax for printf
    call printf

    # Return dst unchanged 
    movq %r8, %rax         # Load original dst
    movq %rbp, %rsp
    popq %rbp
    ret


# ------------------------
.globl pstrcat
.type pstrcat, @function
pstrcat:
    pushq %rbp
    movq %rsp, %rbp

    # Save pointer to str1 to return later
    movq %rdi, %r8

    # Get the lengths of str1 and str2
    movzbl (%rdi), %edx       # dst->len
    movzbl (%rsi), %ecx       # src->len 

    # Check if concatenation exceeds or equals 255
    addl %edx, %ecx           # Calculate total length
    cmpl $255, %ecx           # Compare to max length
    jae .invalid_cat          # length >= 255

    # Update new length of dst (str1)
    movb %cl, (%rdi)          # Store new length in dst->len
    incq %rdi                 # Move dst pointer to start of string
    addq %rdx, %rdi           # Move dst pointer to end of existing string
    incq %rsi                 # Move src pointer to start of string

.copy_loop_cat:
    cmpb $0, (%rsi)           # Check if null
    je .done_copy_cat         
    movb (%rsi), %al          # Load character from src
    movb %al, (%rdi)          # Write character to dst
    incq %rsi                 # Increment src pointer
    incq %rdi                 # Increment dst pointer
    jmp .copy_loop_cat        # loop

.done_copy_cat:
    movb $0, (%rdi)           # Null-terminate the concatenated string
    movq %r8, %rax            # Return pointer to str1
    movq %rbp, %rsp           # Restore stack pointer
    popq %rbp
    ret

.invalid_cat:
    leaq cannot_concatenate_msg(%rip), %rdi # Load error message
    xorq %rax, %rax           # Clear rax for printf
    call printf
    movq %r8, %rax            # Return pointer to str1
    movq %rbp, %rsp           # Restore stack pointer
    popq %rbp
    ret

# ------------------------
    .section .rodata
invalid_input_msg:
    .string "invalid input!\n"
cannot_concatenate_msg:
    .string "cannot concatenate strings!\n"

