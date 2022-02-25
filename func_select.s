	#211497037 noam cohen

.section .rodata
.align 8

.msg_d: .string " %d"
.msg_c: .string " %c"
.msg_s: .string " %s"

.msg1: .string "first pstring length: %d, second pstring length: %d\n"
.msg2: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
.msg3: .string "length: %d, string: %s\n"
.msg4: .string "length: %d, string: %s\n "
.msg5: .string "compare result: %d\n"

.msg_error: .string "invalid option!\n"

.format1: .string "invalid input!\n"

.L0:
    .quad .L1               # 50: pstrlen
    .quad .L6               # 51: error
    .quad .L2               # 52: replaceChar
    .quad .L3               # 53: pstrijcpy
    .quad .L4               # 54: swapCase
    .quad .L5               # 55: pstrijcmp
    .quad .L6               # 56: error
    .quad .L6               # 57: error
    .quad .L6               # 58: error
    .quad .L6               # 59: error
    .quad .L1               # 60: pstrlen


.text

.global run_func
.type even, @function
run_func:
    # saving arguments
    mov     %rdi, %r14      # r14-> pstr1
    mov     %rsi, %r15      # r15-> pstr2
    
    # get n
    sub     $8, %rsp
    mov     %rsp, %rsi
    xor     %rax, %rax
    mov     $.msg_d, %rdi   # load format string
    call    scanf
    movq    (%rsp), %rsi
    add     $8, %rsp
    
    
    sub     $50, %rsi
    # if negetive
    cmp     $0, %rsi
    jl      .L6
    cmp     $10, %rsi
    jg      .L6
    jmp     *.L0(,%rsi,8)

.L1:
    # getting first len
    movq    %r14, %rdi
    call    pstrlen
    movq    %rax, %r10      # r10 -> first len
    
    # getting second len
    movq    %r15, %rdi
    call    pstrlen
    movq    %rax, %r11      # r11 -> second len
    
    # printing
    movq    %r10, %rsi      # second
    movq    %r11, %rdx      # first
    movq    $.msg1, %rdi
    xor     %rax, %rax
    call    printf@PLT
    ret

.L2:
    sub     $8, %rsp
    # get old
    mov     %rsp, %rsi
    xor     %rax, %rax
    mov     $.msg_c, %rdi   # load format string
    call    scanf
    movzbq    (%rsp), %r12    # r12 -> old
    
    # get new
    xor     %rax, %rax
    mov     %rsp, %rsi
    mov     $.msg_c, %rdi   # load format string
    call    scanf
    movzbq    (%rsp), %r13  # r11 -> new
    
    # calling replace for str1
    mov     %r13, %rdx      # new
    mov     %r12, %rsi      # old
    mov     %r14, %rdi      # first
    call    replaceChar
    
    # calling replace for str2
    mov     %r13, %rdx      # new
    mov     %r12, %rsi      # old
    mov     %r15, %rdi      # second
    call    replaceChar
    
    # printing
    leaq    1(%r15), %r8    # second
    leaq    1(%r14), %rcx   # first
    movq    %r13, %rdx      # new
    movq    %r12, %rsi      # old
    movq    $.msg2, %rdi
    xor     %rax, %rax
    call    printf@PLT
    add     $8, %rsp
    ret
    
.L3:
    sub     $8, %rsp
    # get i
    mov     %rsp, %rsi
    xor     %rax, %rax
    mov     $.msg_d, %rdi   # load format string
    call    scanf
    movq    (%rsp), %r12    # r12 -> i
    
    # get j
    xor     %rax, %rax
    mov     %rsp, %rsi
    mov     $.msg_d, %rdi   # load format string
    call    scanf
    movq    (%rsp), %r13    # r13 -> j
    
    # calling pstrijcpy
    mov     %r13, %rcx      # j
    mov     %r12, %rdx      # i
    mov     %r15, %rsi      # src
    mov     %r14, %rdi      # dest
    call    pstrijcpy
    
    # printing
    leaq    1(%r14), %rdx   # string
    movzbq  (%r14), %rsi    # len
    movq    $.msg3, %rdi
    xor     %rax, %rax
    call    printf@PLT
    
    # printing
    leaq    1(%r15), %rdx   # string
    movzbq  (%r15), %rsi    # len
    movq    $.msg3, %rdi
    xor     %rax, %rax
    call    printf@PLT
    
    add     $8, %rsp
    ret

.L4:
    # calling swapCase for str1
    mov     %r14, %rdi      # first
    call    swapCase
    
    # printing
    leaq    1(%r14), %rdx   # string
    movzbq  (%r14), %rsi    # len
    movq    $.msg3, %rdi
    xor     %rax, %rax
    call    printf@PLT
    
    # calling swapCase for str2
    mov     %r15, %rdi      # second
    call    swapCase
    
    # printing
    leaq    1(%r15), %rdx   # string
    movzbq  (%r15), %rsi    # len
    movq    $.msg3, %rdi
    xor     %rax, %rax
    call    printf@PLT
    ret
    
.L5:
    sub     $8, %rsp
    # get i
    mov     %rsp, %rsi
    xor     %rax, %rax
    mov     $.msg_d, %rdi   # load format string
    call    scanf
    movq    (%rsp), %r12    # r12 -> i
    
    # get j
    xor     %rax, %rax
    mov     %rsp, %rsi
    mov     $.msg_d, %rdi   # load format string
    call    scanf
    movq    (%rsp), %r13    # r13 -> j
    
    # calling replace for str2
    mov     %r13, %rcx      # j
    mov     %r12, %rdx      # i
    mov     %r15, %rsi      # src
    mov     %r14, %rdi      # dest
    call    pstrijcmp
    
    # printing
    movq    %rax, %rsi      # result
    movq    $.msg5, %rdi
    xor     %rax, %rax
    call    printf@PLT
    add     $8, %rsp
    ret

.L6:
    movq    $.msg_error, %rdi
    xor     %rax, %rax
    call    printf@PLT
    ret
