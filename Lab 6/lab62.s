.text
.global _start

_start:
    .global lab1_func
lab1_func:
    ldr x8, =a
    ldr x9, [x8]    // x9 = a
    ldr x8, =b
    ldr x10, [x8]    // x10 = b
    add x11, x9, x10
    cmp x11, #4
    beq thirteen
    b negtwelve
thirteen:
    mov x11, #13
    b exit
negtwelve:
    mov x11, #0
    sub x11, x11, #12
    b exit
exit:
    adr x0, printmsg
    mov x1, x11
    bl printf

    mov x0, #0
    mov w8, #93
    svc #0
    
.data
a:
    .dword 0
b:
    .dword 4
printmsg:
    .asciz "Value: %d\n"