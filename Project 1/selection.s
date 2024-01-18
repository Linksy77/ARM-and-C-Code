.text
.global _start
.extern printf

_start:
    .global main
main:
    // Loading values as is necessary
    ldr x21, =inpdata   // x21 = array of nums
    ldr x8, =inplen
    ldr x22, [x8]       // x22 = array length
    ldr x23, =histogram // x23 = histogram
    ldr x8, =rank
    ldr x24, [x8]       // x24 = rank

    mov x0, x21         // x0 = x21 (array of nums)
    mov x1, x22         // x1 = x22 (array length)

    // Calculating the max number
    bl max_func
    mov x26, x0          // x26 = maxnum (x0, calculated in max_func)

    mov x0, x21         // x0 = x21 (array of nums)
    mov x1, x22         // x1 = x22 (array length)
    mov x2, x23         // x2 = x23 (histogram)

    // Function call to make/modify histogram
    bl make_hist
    mov x23, x0          // x23 = modified histogram

    // Printing histogram
    // Printing out column titles
    adr x0, columntitles
    bl printf
    mov x20, #0         // x20 = num (starts at 0)

print_loop:
    cmp x20, x26         // comparing x20 (num) and x26 (maxnum)
    bgt print_exit      // if num (x20) > maxnum (x4), jump to print_exit

    lsl x18, x20, #3      // x18 = x20 * 8 ==> x18 = num * 8 (offset for index of histogram)
    ldr x19, [x23, x18]   // x19 = histogram[x6] ==> x19 = numcount

    // Printing x20 (num) and x19 (numcount)
    adr x0, printnum    // address of message to be printed loaded to x0
    mov x1, x20         // value to be printed (num we're counting) moved to x1
    bl printf
    adr x0, printcount  // address of message to be printed loaded to x0
    mov x1, x19         // value to be printed (numcount) moved to x1
    bl printf

    add x20, x20, #1    // x20++ ==> num++
    b print_loop        // jump back to print_loop
print_exit:

    mov x0, x23         // x0 = x23 (histogram)
    mov x1, x24         // x1 = x24 (rank)

    // Function call to calculate rank-r
    bl find_rank
    mov x25, x0         // x25 = x0 (numatrank)

    // Printing rank-r
    adr x0, printrank       // address of message to be printed loaded to x0
    mov x1, x24             // value to be printed (rank) moved to x1
    bl printf
    adr x0, printnumatrank  // address of message to be printed loaded to x0
    mov x1, x25             // value to be printed (numatrank) moved to x1
    bl printf

    mov x0, #0          // resetting x0 to 0
    mov w8, #93
    svc #0              // ending program


/* FUNCTION TO MAKE/MODIFY HISTOGRAM */
make_hist:
    mov x5, #0          // x5 = index (starts at 0)
hist_loop:
    cmp x5, x1          // comparing index (x5) and length (x1)
    bge loop_exit       // if index (x5) >= length (x1), jump to loop_exit
    
    lsl x6, x5, #3      // x6 = x5 * 8 ==> x6 = index * 8 (offset)
    ldr x7, [x0, x6]    // x7 = array[x6]

    lsl x8, x7, #3      // x8 = x7 * 8 ==> x8 = num * 8 (offset for index of histogram)
    ldr x9, [x2, x8]   // x9 = histogram[x8] ==> x9 = count of num found
    
    add x9, x9, #1      // x9++ ==> incrementing count of num found by 1
    str x9, [x2, x8]   // histogram[x8] = x9 ==> storing incremented count back in histogram

    add x5, x5, #1      // index++
    
    b hist_loop
loop_exit:
    mov x0, x2
    ret

/* FUNCTION TO FIND RANK-R NUMBER */
find_rank:
    mov x5, #0          // x5 = num (starts at 0)
    mov x6, #0          // x6 = rankcount (starts at 0)
rank_loop:
    lsl x7, x5, #3      // x7 = x5 * 8 ==> x7 = num * 8 (offset for index of histogram)
    ldr x8, [x0, x7]   // x8 = histogram[x7] ==> x8 = numcount
    add x6, x6, x8      // x6 += x8 ==> rankcount += numcount
    
    cmp x6, x1          // comparing x6 (rankcount) and x1 (rank)
    bge rank_exit       // if rankcount (x6) >= rank (x1), jump to rank_exit
    add x5, x5, #1      // otherwise, x5++ ==> num++
    b rank_loop         // jump back to rank_loop
rank_exit:
    mov x0, x5          // x0 = x5 (numatrank)
    ret


/* FUNCTION TO FIND MAX. VALUE */
max_func:               // function that finds max value in array
    mov x7, #1          // x7 = 1 (counter)
    ldr x4, [x0, #0]    // x4 = [first value of array] (curr max)
max_loop:
    cmp x7, x1          // comparing x7 (counter) and x1 (length)
    beq max_end         // if counter == length, go to max_end
    lsl x5, x7, #3      // x5 = x7 * 8 (offset value)
    ldr x6, [x0, x5]    // x6 = array[x5]
    cmp x6, x4          // comparing x6 (curr val) & x4 (curr max)
    bgt set_max         // if x6 (curr val) > x4 (curr max), jump to set_max
    add x7, x7, #1      // x7 (counter) += 1
    b max_loop          // jump back to beginning of loop
set_max:
    mov x4, x6          // x4 (curr max) = x6 (curr val)
    add x7, x7, #1      // x7 (counter) += 1
    b max_loop          // jump back to beginning of loop
max_end:
    mov x0, x4          // x0 = x4 (curr max)
    ret                 // return


.bss
.align 8
histogram:
    .space 101


.data
inpdata:
    .dword 2, 0, 2, 3, 4, 6
inplen:
    .dword 6
rank:
    .dword 4
columntitles:
    .asciz "Number\tCount\n"
printnum:
    .asciz "%d\t"
printcount:
    .asciz "%d\n"
printrank:
    .asciz "The value of the rank-%d element is "
printnumatrank:
    .asciz "%d\n"


