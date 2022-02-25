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

.msg_error: .string "invalid input!\n"

.format1: .string "invalid input!\n"


.text

.global run_main
.type run_main, @function
run_main:
    movq    %rsp, %rbp      #for correct debugging
    sub     $520, %rsp
    
    # get n1
    xor     %rax, %rax
    mov     $.msg_d, %rdi   # load format string
    mov     %rsp, %rsi
    call    scanf
    
    # get str1
    xor     %rax, %rax
    mov     $.msg_s, %rdi   # load format string
    leaq    1(%rsp), %rsi
    call    scanf
    movzbq  (%rsp), %rdx    # rdx -> len str1
    movb    $0, 2(%rsp, %rdx)
    
    # get n2
    xor     %rax, %rax
    mov     $.msg_d, %rdi   # load format string
    leaq    256(%rsp), %rsi
    call    scanf
    
    # get str2
    xor     %rax, %rax
    mov     $.msg_s, %rdi   # load format string
    leaq    257(%rsp), %rsi
    call    scanf
    movzbq  256(%rsp), %rcx    # rcx -> len str1
    movb    $0, 258(%rsp, %rcx)
    
    # rsp <- str1
    # rsp + 256 <- str2
    leaq    (%rsp), %rdi
    leaq    256(%rsp), %rsi
    call    run_func
    
    #clean memory
    add     $520, %rsp
    xor     %rax, %rax
    ret

