.text
.global _start

_start:
    .global lab1_func
lab1_func:
    ldr x8, =i
    ldr x9, [x8]    // x9 = i
    ldr x8, =g
    ldr x10, [x8]    // x10 = g
    cmp x9, #4
    beq addvals
    b subvals
addvals:
    add x11, x10, #12
    b exit
subvals:
    sub x11, x10, #24   // if i != 4: x2 (f) = g - 24
    b exit
exit:
    adr x0, printmsg
    mov x1, x11
    bl printf

    mov x0, #0
    mov w8, #93
    svc #0
    
.data
i:
    .dword 10
g:
    .dword 10
printmsg:
    .asciz "Value: %d\n"