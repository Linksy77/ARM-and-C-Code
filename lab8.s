.text
.global _start

_start:
    ldr x1, =P          // x1 = P (point coordinates)
    ldr x2, [x1, #0]    // x2 = x val of P
    ldr x3, [x1, #8]    // x3 = y val of P
    ldr x4, =C          // x4 = C (center of circle)
    ldr x5, [x4, #0]    // x5 = x val of C
    ldr x6, [x4, #8]    // x6 = y val of C
    ldr x8, =R
    ldr x7, [x8]        // x7 = R (radius of circle)
calculation:
    sub x1, x2, x5      // x1 = x_P - x_C
    mul x1, x1, x1      // x1 = x1^2
    sub x4, x3, x6      // x4 = y_P - y_C
    mul x4, x4, x4      // x4 = x4^2
    add x0, x1, x4      // x0 = (x1^2 + x4^2)
    mul x7, x7, x7      // x7 = x7^2
    cmp x0, x7          // Comparing the radius & dist.
    bgt GreaterThan
    ldr x1, =yes
    b exit
GreaterThan:
    ldr x1, =no
exit:
    mov x0, #0
    mov w8, #93
    svc #0

.data

P:
    .quad 0, 0
C:
    .quad 1, 2
R:
    .quad 8
yes:
    .string "P is inside the circle."
no:
    .string "P is outside the circle."

