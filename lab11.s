.text
.global _start

_start:
    // read params: x0 = fd (file descriptor, 0), x1 = buf (address of buffer to be // buffer in bss, 1 b/c you're only reading 1 thing), x2 = nbyte (1)
    ldr x21, =result    // x21 = result (buffer info)
    mov x23, #10        // x23 = 10 (for shifting later)
    mov x20, #0         // x20 = 0 (value read)
    mov x24, #0         // x24 = 0 (length of value)
    mov x25, #0         // x25 = copy of value to manipulate

loop:
    mov x0, #0      // fd = 0
    mov x1, x21     // x1 = x21 (buffer info)
    mov x2, #1      // x2 = 1 (nbyte)
    mov x8, #63     // x8 = 63 (read())
    svc 0           // system call

    ldr x1, [x21]
    cmp x1, #10     // checking if character is "\n"
    beq comp_square // if the character = "\n", jump to comp_square

    sub x22, x1, #48    // x22 = [ascii val] - 48
    mul x20, x20, x23   // x20 *= x23 (10) (base 10 shifting to the left)
    add x20, x20, x22   // x20 += x22 (new value)
    b loop              // jump to loop label

comp_square:
    mul x20, x20, x20   // x20 = x20^2

    // LOOP TO FIND LENGTH
    mov x25, x20        // x25 = x20 (copy of value)
len_loop:
    cmp x25, #0             // comparing x25 (copy of value) to 0
    beq len_loop_exit       // if x25 == 0; jump to end of len_loop
    sdiv x25, x25, x23      // otherwise, x25 /= 10
    add x24, x24, #1        // x24 += 1 (length++)
    b len_loop

len_loop_exit:

    // LOOP TO FIND VALUE TO DIVIDE BY AT FIRST
    mov x26, #1             // x26 = 10 (valToDiv)
    sub x27, x24, #1        // x27 = x24 (length) - 1
div_value_loop:
    cmp x27, #0             
    ble div_val_loop_exit   // if x27 (length - 1) <= 0, jump to div_val_loop_exit
    mul x26, x26, x23       // x26 *= 10 (x23)
    sub x27, x27, #1        // x27--
    b div_value_loop
div_val_loop_exit:

    // CONVERT TO ASCII & WRITE
print_ascii_loop:
    cmp x26, #1
    beq exit

    sdiv x28, x20, x26      // x28 = x20 / (valToDiv)                // x28 = 425/100 = 4
    mov x21, x28            // x21 = x28 (leftDigit -> buffer info)  // x21 = 4
    mul x28, x28, x26       // x28 = x28 (leftDigit) * (valToDiv)    // x28 = 4 * 100 = 400
    sub x20, x20, x28       // x20 -= x28 (value - leftDigit)        // x20 = 425 - 400 = 25

    add x21, x21, #48       // x21 = ascii val of leftDigit          // x21 = 4 + 48

    ldr x1, =result
    str x21, [x1]

    mov x0, #1              // fd = 1
    ldr x1, =result         // x21 = x21 (result)
    mov x2, #1              // x2 = 1 (nbyte)
    mov x8, #64             // x8 = 64 (write())
    svc 0                   // system call

    sdiv x26, x26, x23      // x26 /= 10                // x26 = 100/10 = 10

    b print_ascii_loop      // jump to print_ascii_loop label

exit:

    add x20, x20, #48       // x20 = ascii value of finalDigit 

    ldr x1, =result
    str x20, [x1]

    mov x0, #1              // fd = 1
    ldr x1, =result         // x21 = x21 (result)
    mov x2, #1              // x2 = 1 (nbyte)
    mov x8, #64             // x8 = 64 (write())
    svc 0                   // system call

    mov x0, #1              // fd = 1
    mov x1, #10             // x1 = x20 (buffer info)
    mov x2, #1              // x2 = 1 (nbyte)
    mov x8, #64             // x8 = 64 (write())
    svc 0                   // system call

    mov x0, #0
    mov x8, #93
    svc 0


.bss
result: .space 1

