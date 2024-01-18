.text
.global _start

_start:
    .global lab1_func
lab1_func:
    mov x9, #1
    mov x11, #0
whileloop:
    cmp x9, #11
    beq exit
    add x11, x11, x9
    add x9, x9, #1
    b whileloop
exit:
    adr x0, printmsg
    mov x1, x11
    bl printf

    mov x0, #0
    mov w8, #93
    svc #0
    
.data
printmsg:
    .asciz "Value: %d\n"