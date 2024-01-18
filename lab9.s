.text
.global _start

_start:
    ldr x2, =array      // x2 = array   
    ldr x8, =length
    ldr x3, [x8]        // x3 = length (total num of elems in array)
    sub x3, x3, #1      // x3 = final index position

    mov x0, #0          // x0 = index (starts at 0)
    bl max_func         // jump to max_func
    mov x4, x21         // x4 = x21 (max)

    adr x0, print_max   // address of message to be printed loaded to x0
    mov x1, x4          // value to be printed moved to x1
    bl printf           // printing message & value

    mov x0, #0          // resetting x0 to 0
    mov w8, #93
    svc #0              // ending program

max_func:               // function that finds max value in array
    sub sp, sp, #8      // save return address and x30 on stack
    str x30, [sp, #0]
    cmp x0, x3          // comparing x0 (index) to x3 (final index)
    blt max_rec         // if x0 (index) < x3 (final index), jump to max_rec
base_case:
    lsl x1, x0, #3      // x1 = x0 * 8 ==> x1 = index * 8 (offset)
    ldr x21, [x2, x1]   // x21 = final value in array
    add sp, sp, #8      // popping stack, not restoring values
    ret                 // return
max_rec:
    add x0, x0, #1      // x0++ ==> index++
    bl max_func         // recursive call to max_func
    ldr x30, [sp, #0]   // restoring caller's index
    add sp, sp, #8      // popping stack
    sub x0, x0, #1      // x0-- ==> index--
    lsl x1, x0, #3      // x1 = x0 * 8 ==> x1 = index * 8 (offset)
    ldr x20, [x2, x1]   // x20 = array[x1] (curr value in array)
    cmp x20, x21
    bge set_max         // if x20 (curr value) >= x21 (curr max), jump to set_max
    ret                 // else: return
set_max:
    mov x21, x20        // x21 (curr max) = x20 (curr value)
    ret                 // return



.data
array:
    .dword 1,5,4,3,10,2,7,8  // array of doublewords
length:
    .dword 8    // length of array
print_max:
    .asciz "Maximum value in the array: %d\n"

