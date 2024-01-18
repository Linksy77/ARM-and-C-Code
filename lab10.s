.text
.global _start

_start:
    ldr x8, =a
    ldr d1, [x8]        // d1 = a (left limit)
    ldr x8, =b           
    ldr d2, [x8]        // d2 = b (right limit)
    ldr x8, =n           
    ldr d3, [x8]        // d3 = n (num of rectangles under curve)
    ldr x9, =result     // x9 = result

    ldr x8, =coeff1
    ldr d4, [x8]         // d4 = x^4 coefficient
    ldr x8, =coeff2
    ldr d5, [x8]         // d5 = x^2 coefficient (positive)
    ldr x8, =coeff3
    ldr d6, [x8]         // d6 = x coefficient
    ldr x8, =coeff4
    ldr d7, [x8]         // d7 = constant

    bl calcMidPVal
    fmov d0, d28            // moving result into d0 to print

    str d0, [x9, #0]        // result[0] = d0 (result)

    ldr x0, =printstring    // address of message to be printed loaded to x0
    bl printf               // printing message & value

    mov x0, #0              // resetting x0 to 0
    mov w8, #93
    svc #0                  // ending program


calcMidPVal:
    fsub d16, d2, d1    // d16 (int.len) = d2 (rlim) - d1 (llim)
    fdiv d17, d16, d3   // d17 (rect width) = d16 (int.len)/d3 (numOfRect)
    ldr x27, =two
    ldr d27, [x27]      // d27 = 2
    fdiv d19, d17, d27  // d19 (halfOfRect) = d17 (rect width)/d27 (2)
    fadd d19, d19, d1   // d19 (x) = d19 (halfOfRect) + d1 (llim)
    mov x0, #0          // x0 = 0 (curveArea initialization)
midPLoop:
    fcmp d19, d2        // comparing d19 (x) and d2 (rlim)
    bge endLoop         // if d18 (currRect) > d3 (numOfRect), jump to endLoop
    fmul d21, d19, d19  // d21 = x^2
    fmul d21, d21, d21  // d21 (x^4 term) = x^4
    fmul d22, d19, d19  // d22 (x^2 term) = d19 (x) * d19 (x)
    fmul d23, d19, d6   // d23 (x term) = d19 (x) * d6 (9.34) (x coeff)
    fmul d21, d21, d4   // d21 (leading term) = d21 (x^4) * d4 (8.32) (x^4 coeff)
    fmul d22, d22, d5   // d22 (x^2 term) = d22 (x^2) * d5 (6.53) (x^2 coeff)
    /* yValCalc: */
    fadd d25, d23, d7   // d25 (y) = d23 (9.34x) + d7 (12.32)
    fadd d25, d25, d21  // d25 (y) += d21 (8.32x^4)
    fsub d25, d25, d22  // d25 (y) -= d22 (6.53x^2)
    /* rectArea: */
    fmul d26, d25, d17  // d26 (rectArea) = d25 (y) (rectHeight) * d17 (rect width)
    fadd d0, d0, d26    // d0 (curveArea) += d26 (rectArea) * d19 (x)
    fadd d19, d19, d17  // d19 (x) += d17 (rect width)
    b midPLoop
endLoop:
    fmov d28, d0
    ret

.data
a:  .double -1
b:  .double 1
n:  .double 56

coeff1: .double 8.32
coeff2: .double 6.53
coeff3: .double 9.34
coeff4: .double 12.32

two: .double 2

printstring: .asciz "Area under curve: %lf\nValue of a: %lf\nValue of b: %lf\nNumber of rectangles: %lf\n"

.bss
result: .skip 8

