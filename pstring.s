	#211497037 noam cohen

.file	"pstring.h"

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

.global pstrlen
.type pstrlen, @function
pstrlen:
    movb    (%rdi), %al
    ret

.global replaceChar
.type replaceChar, @function
replaceChar: 
                            # str -> rdi, old-> rsi, new -> rdx
    movq    %rdi, %rax      # rax -> str (save)
    movb    (%rdi), %r10b   # lentgh-> r10b
    cmpb     $0,%r10b       # edge case - string is lentgh 0
    je      .RCdone
.RCloop:
    inc     %rdi            # moving to next char
    cmpb    %sil,(%rdi)     # compare cur to old
    jne     .RCnotReplace
    movb    %dl, (%rdi)     # replace cur to new
.RCnotReplace:
    dec     %r10b           # length--
    cmpb     $0, %r10b      # if in last char
    jne     .RCloop
.RCdone:
    ret


.global pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
                            # dst->rdi, src->rsi, i->dl, j->cl
    movq    %rdi, %rax      # dst -> rax (save)
    
    # edge case - indexes out of bound
    # cmp for i vs dst len:
    cmpb    %dl, (%rdi)
    jbe      .IJcpyErorr
    # cmp for j vs src len:
    cmpb    %cl, (%rsi)
    jbe      .IJcpyErorr
    # cmp for i vs j:
    sub     %dl, %cl        # j-i (length) -> cl
    jb      .IJcpyErorr
    inc     %cl
    
    # init calculation
    movzbq  %dl, %rdx
    movzbq  %cl, %rcx
    leaq    1(%rdi, %rdx, 1), %rdi
    leaq    1(%rsi, %rdx, 1), %rsi
    # cl is length
    
    cmp     $0, %cl         # edge case - string is lentgh 0
    je  .RCdone
.IJcpyloop:
    # copy char from src to dst
    movb    (%rsi), %r10b
    movb    %r10b, (%rdi)
    # moving to next char
    inc     %rsi
    inc     %rdi
        
    dec     %cl             # length--
    cmp     $0, %cl         # if not in last char
    jne     .IJcpyloop    
        
.IJcpydDone:
    ret
.IJcpyErorr:
    # printing "invalid input!"
    movq    %rax, %r10
    xor     %rax, %rax
    movq    $.format1, %rdi
    call    printf@PLT
    movq    %r10, %rax
    ret


.global swapCase
.type swapCase, @function
swapCase:
    # pstr->rdi
    movq    %rdi, %rax      # rax -> str (save)
    movb    (%rdi), %r10b   # lentgh-> r10b
    cmp     $0,%r10         # edge case - string is lentgh 0
    je      .SCdone
.SCloop:
    inc     %rdi            # moving to next char
    
    # upper case
    cmpb    $65,(%rdi)      # if rdi is below A
    jb      .SCnotUpper
    cmpb    $90,(%rdi)      # if rdi above Z
    ja      .SCnotUpper
    addb    $32, (%rdi)     # replace to lower
    jmp     .SCnotLower
    
.SCnotUpper:
    # lower case
    cmpb    $97,(%rdi)      # if rdi is below A
    jb      .SCnotLower
    cmpb    $122,(%rdi)     # if rdi above Z
    ja      .SCnotLower
    subb    $32, (%rdi)     # replace to upper
    
.SCnotLower:
    dec     %r10b           # length--
    cmpb    $0, %r10b       # if in last char
    jne     .SCloop
.SCdone:
    ret
    
    
.global pstrijcmp
.type pstrijcmp, @function
pstrijcmp:
                            # pstr1->rdi | pstr2->rsi | i->dl | j->cl
    movq    %rdi, %rax      # dst -> rax (save)
    
    # edge case - indexes out of bound
    # cmp for j vs dst len:
    cmpb    %cl, (%rdi)
    jb      .IJcmpErorr
    # cmp for j vs src len:
    cmpb    %cl, (%rsi)
    jb      .IJcmpErorr
    # cmp for i vs j:
    sub     %dl, %cl        # j-i (length) -> cl
    jb      .IJcmpErorr
    inc     %cl
    
    # init calculation
    movzbq  %dl, %rdx
    movzbq  %cl, %rcx
    leaq    1(%rdi, %rdx, 1), %rdi
    leaq    1(%rsi, %rdx, 1), %rsi
    xor     %rax, %rax
    movq    $1, %r10
    movq    $-1, %r11
    # cl is length
    
    cmp     $0, %cl         # edge case - string is lentgh 0
    je      .IJcmpDone
.IJcmploop:
    # comp pstr1 vs pstr2
    movb    (%rdi), %r8b
    cmpb    (%rsi), %r8b
    cmova   %r10, %rax
    cmovb   %r11, %rax
    jne     .IJcmpDone
    
    # moving to next char
    inc     %rsi
    inc     %rdi
    
    dec     %cl             # length--
    cmp     $0, %cl         # if not in last char
    jne     .IJcmploop    

.IJcmpDone:
    ret
.IJcmpErorr:
    # printing "invalid input!"
    xor     %rax, %rax
    movq    $.format1, %rdi
    call    printf@PLT
    movq    $-2, %rax
    ret
    
