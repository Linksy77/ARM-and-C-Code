.text
.global _start

_start:
    mov x9, #0          // x9 = index i (outer loop)
    mov x10, #1         // x10 = index j (inner loop)
    mov x20, #0         // x20 = largestDist1 index
    mov x21, #0         // x21 = largestDist2 index
    mov x22, #0         // x22 = shortestDist1 index
    mov x23, #0         // x23 = shortestDist2 index
    ldr x8, =zero       // x8 = address for 0
    ldr d25, [x8]       // d25 = largestDist (init. to 0)
    ldr x8, =N          
    ldr x11, [x8]       // x11 = (length (N))
    sub x27, x11, #1    // x27 = x11 (N) - 1
    ldr x13, =x         // x13 = x array address
    ldr x14, =y         // x14 = y array address


    ldr d2, [x13, #0]  // d2 = x val of point1
    ldr d3, [x14, #0]  // d3 = y val of point1
    ldr d4, [x13, #8]  // d4 = x val of point2
    ldr d5, [x14, #8]  // d5 = y val of point2
    fsub d16, d4, d2    // d16 = x_2 - x_1
    fmul d16, d16, d16  // d16 = d16^2 (x diff squared)
    fsub d17, d5, d3    // d17 = y_2 - y_1
    fmul d17, d17, d17  // d17 = d17^2 (y diff squared)
    fadd d0, d16, d17   // d0 = (d16^2 + d17^2)
    fmov d25, d0        // d25 (largestDist) = d0 (dist.)
    mov x20, #0         // x20 (largestIndex1) = x9 (i)
    mov x21, #1         // x21 (largestIndex2) = x10 (j)
    fmov d26, d0        // d26 (shortestDist) = d0 (dist.)
    mov x22, #0         // x22 (shortestIndex1) = x9 (i)
    mov x23, #1         // x23 (shortestIndex2) = x10 (j)

outer_loop:
    cmp x9, x27
    bge outer_loop_exit // if x9 (i) >= x11 (length), jump to outer_loop_exit
    lsl x12, x9, #3     // x12 (offset1) = x9 (i) * 8 
    ldr d2, [x13, x12]  // d2 = x val of point1
    ldr d3, [x14, x12]  // d3 = y val of point1
inner_loop:
    cmp x10, x11
    bge inner_loop_exit // if x10 (j) >= x11 (length), jump to inner_loop_exit
    lsl x15, x10, #3    // x15 (offset2) = x10 (j) * 8
    ldr d4, [x13, x15]  // d4 = x val of point2
    ldr d5, [x14, x15]  // d5 = y val of point2
calculation:
    fsub d16, d4, d2    // d16 = x_2 - x_1
    fmul d16, d16, d16  // d16 = d16^2 (x diff squared)
    fsub d17, d5, d3    // d17 = y_2 - y_1
    fmul d17, d17, d17  // d17 = d17^2 (y diff squared)
    fadd d0, d16, d17   // d0 = (d16^2 + d17^2)
    fcmp d0, d25        // Comparing the dist. (d0) and largestDist (d25)
    bgt largestSet      // if dist. > largestDist, jump to largestSet
cont1:
    fcmp d0, d26        // Comparing the dist. (d0) and the shortestDist (d26)
    blt shortestSet     // if dist. < shortestDist, jump to shortestSet
cont2:
    add x10, x10, #1    // x10 += 1 (j++)
    b inner_loop 
inner_loop_exit:
    add x9, x9, #1      // x9 += 1 (i++)
    add x10, x9, #1     // x10 = x9 + 1 (j = i + 1)
    b outer_loop
largestSet:
    fmov d25, d0        // d25 (largestDist) = d0 (dist.)
    mov x20, x9         // x20 (largestIndex1) = x9 (i)
    mov x21, x10        // x21 (largestIndex2) = x10 (j)
    b cont1             // jump to cont1
shortestSet:
    fmov d26, d0        // d26 (shortestDist) = d0 (dist.)
    mov x22, x9         // x22 (shortestIndex1) = x9 (i)
    mov x23, x10        // x23 (shortestIndex2) = x10 (j)
    b cont2             // jump to cont2
outer_loop_exit:

    adr x0, print_largest_dist  // address of message to be printed loaded to x0
    mov x1, x20                 // value to be printed moved to x1
    mov x2, x21                 // value to be printed moved to x2
    bl printf                   // printing message & value

    adr x0, print_shortest_dist // address of message to be printed loaded to x0
    mov x1, x22                 // value to be printed moved to x1
    mov x2, x23                 // value to be printed moved to x2
    bl printf                   // printing message & value

    mov x0, #0
    mov x8, #93
    svc 0


.data
N:
	.dword 8
x:
	.double 0.0, 0.4140, 1.4949, 5.0014, 6.5163, 3.9303, 8.4813, 2.6505
y: 	
	.double 0.0, 3.9862, 6.1488, 1.047, 4.6102, 1.4057, 5.0371, 4.1196
print_largest_dist:
    .asciz "The largest distance is between points %d and %d\n"
print_shortest_dist:
    .asciz "The shortest distance is between points %d and %d\n"
zero:
    .double 0.0

