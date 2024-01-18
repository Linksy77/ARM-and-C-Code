.text
.global _start

_start:
    ldr x0, =array  // x0 = array   
    ldr x8, =k
    ldr x1, [x8]    // x1 = k (num of elems to add)
    ldr x8, =option
    ldr x2, [x8]    // x2 = option (option value)
    ldr x8, =length
    ldr x3, [x8]    // x3 = length (total num of elems in array)
    ldr x8, =array
    cmp x2, #0      // comparing option and 0
    bne sec_comp    // if option != 0, go to sec_comp
    bl sum_func     // if option == 0, go to sum_func
    mov x9, x0      // x9 = x0 (result)
    b printing_sum  // jump to printing_sum
sec_comp:
    cmp x2, #1      // comparing option and 1
    bne exit        // if option != 1, jump to exit
    bl max_func     // if option == 1, go to max_func
    mov x9, x0      // x9 = x0 (result)
    b printing_max  // jump to printing_max  
printing_sum:
    adr x0, print_sum   // address of message to be printed loaded to x0
    mov x1, x9          // value to be printed moved to x1
    bl printf           // printing message & value
    b exit              // jump to exit
printing_max:
    adr x0, print_max   // address of message to be printed loaded to x0
    mov x1, x9          // value to be printed moved to x1
    bl printf           // printing message & value
exit:
    mov x0, #0          // resetting x0 to 0
    mov w8, #93
    svc #0              // ending program

sum_func:               // function that sums first k elements of the array
    mov x6, #0          // x6 = sum; initializing sum
    cmp x1, x3          // comparing k and length
    blt sum_calc        // if k is less than length, go to sum_calc
    mov x1, x3          // otherwise, set k equal to length
sum_calc:
    sub x1, x1, #1      // x1 = k - 1 (final index you'd add)
    lsl x1, x1, #3      // x1 = k * 8 (total offset value)
sum_loop:
    cmp x1, #0
    blt sum_end         // if offput < 0 (no nums left to add), got to sum_end
    ldr x5, [x0, x1]    // x5 = array[x1]
    add x6, x6, x5      // x6 = sum; sum = sum + array[x2]
    sub x1, x1, #8      // k -= 1
    b sum_loop          // jump back to beginning of loop
sum_end:
    mov x0, x6          // x0 = x6 (sum)
    ret                 // return


max_func:               // function that finds max value in array
    mov x7, #1          // x7 = 1 (counter)
    ldr x4, [x0, #0]    // x4 = [first value of array] (curr max)
max_loop:
    cmp x7, x3          // comparing x7 (counter) and x3 (length)
    beq max_end         // if counter == length, go to max_end
    lsl x5, x7, #3      // x5 = x7 * 8 (offset value)
    ldr x6, [x0, x5]    // x6 = array[x2]
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


.data
array:
    .dword 1, 2, 3, 4, 5, 6, 7  // array of doublewords
length:
    .dword 7    // length of array
option:
    .dword 0    // option value
k:
    .dword 4    // k value
print_sum:
    .asciz "Sum of first k values in the array: %d\n"
print_max:
    .asciz "Maximum value in the array: %d\n"

