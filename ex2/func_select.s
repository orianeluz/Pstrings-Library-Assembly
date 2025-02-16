# 326367570 Orian Eluz

.section .text
.globl run_func
run_func:
    # start func
    push %rbp
    mov %rsp, %rbp

    # save pointers for the strings on stack
    subq $32, %rsp 
    movq %rsi, -8(%rbp)   # str1
    movq %rdx, -16(%rbp)  # str2

    # option num (rdi is the choice)
    leaq -31(%rdi), %rsi  # adjust option value
    cmpq $6, %rsi         # max valid value is 6
    ja .c_def             # invalid option, go handle
    jmp *jmp_table(,%rsi,8) # jump to case

.c_31:
    # call strlen on both strings and save the results
    movq -8(%rbp), %rdi    # pass str1
    xorq %rax, %rax
    call pstrlen
    pushq %rax   # save len1

    movq -16(%rbp), %rdi   # pass str2
    xorq %rax, %rax
    call pstrlen
    pushq %rax   # save len2

    # print lengths
    movq $pstrlen_msg, %rdi
    popq %rdx   # move len1 
    popq %rsi   # move len2  
    xorq %rax, %rax        # clear rax for printf
    call printf
    jmp .c_end


.c_33:
    # swapcase first string and print it
    movq -8(%rbp), %rdi
    call swapCase
    lea (%rax), %rdi
    call print_pstring

    # do the same for second string
    movq -16(%rbp), %rdi
    call swapCase
    lea (%rax), %rdi
    call print_pstring

    jmp .c_end

.c_34:
    # read i, j indexes
    movq $scanf_indices, %rdi
    lea -28(%rbp), %rsi    # for i
    lea -24(%rbp), %rdx    # for j
    xorq %rax, %rax
    call scanf

    # get i, j into regs
    movb -28(%rbp), %dl    # i
    movb -24(%rbp), %cl    # j

    # copy substring
    movq -8(%rbp), %rdi    # dest = str1
    movq -16(%rbp), %rsi   # src = str2
    call pstrijcpy

    # print both strings
    movq -8(%rbp), %rdi
    call print_pstring
    movq -16(%rbp), %rdi
    call print_pstring

    jmp .c_end

.c_37:
    # concat strings (str2 into str1)
    movq -8(%rbp), %rdi    # str1 (dest)
    movq -16(%rbp), %rsi   # str2 (src)
    xorq %rax, %rax
    call pstrcat

    # print both strings
    movq -8(%rbp), %rdi
    xorq %rax, %rax
    call print_pstring
    movq -16(%rbp), %rdi
    xorq %rax, %rax
    call print_pstring

    jmp .c_end

.c_def:
    # for invalid options, print error
    movq $invalid_option_msg, %rdi
    xorq %rax, %rax
    call printf

.c_end:
    # cleanup and return
    addq $32, %rsp
    popq %rbp
    ret

.type print_pstring, @function
print_pstring:    # print a pstring (len + content)
    pushq %rbp
    movq %rsp, %rbp

    # get length and string addr
    movzbq (%rdi), %rsi        # length
    lea 1(%rdi), %rdx          # addr of string

    # call printf
    lea pstring_msg(%rip), %rdi
    xor %eax, %eax
    call printf

    # done
    movq %rbp, %rsp
    popq %rbp
    ret

.section .rodata
jmp_table:
    .quad .c_31, .c_def, .c_33, .c_34, .c_def, .c_def, .c_37


invalid_option_msg:
    .string "invalid option!\n"
pstrlen_msg:
    .string "first pstring length: %d, second pstring length: %d\n"
pstring_msg:
    .string "length: %d, string: %s\n"
scanf_indices:
    .string "%d %d"
