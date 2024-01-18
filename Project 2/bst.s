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
    ldr x23, =bst       // x23 = bst
    mov x20, -1         // x20 = -1 (constant)

    // Inserting root node & children manually
    ldr x0, [x21, #0]   // x0 = first value in array of nums
    str x0, [x23, #0]   // x23 @ offset 0 = x0 (first val)
    str x20, [x23, #8]  // x23 @ offset 8 = x20 (-1)
    str x20, [x23, #16] // x23 @ offset 16 = x20 (-1)


    // Initializing the bst
    mov x24, #1         // x24 = 1 (valIndex)
    mov x25, #3         // x25 = 3 (next_free)
bst_loop:
    cmp x24, x22        // comparing x24 (valIndex) and x22 (array length)
    bge bst_loop_exit   // if x24 (index) >= x22 (array length), jump to bst_loop_exit label
    mov x0, #0          // x0 = 0 (currIndex)
    lsl x1, x24, #3     // x1 = offset for valToIns = x24 (valIndex) * 8
    ldr x2, [x21, x1]   // x2 = valToIns = arrayOfNums @ offset for valToIns
    mov x3, x25         // x3 = x25 (next_free)

    bl bst_init         // call to bst_init function

    add x24, x24, #1    // x24 += 1 (index++)
    b bst_loop
bst_loop_exit:

    mov x26, #3         // x26 = 3 (constant)
    mov x0, #0          // x0 = 0 (index)
    bl in_order

prog_exit:
    // Program exit
    mov x0, #0          // resetting x0 to 0
    mov w8, #93
    svc #0              // ending program



/* FUNCTION TO INITIALIZE BST */
/*
    x20 = -1
    x21 = array of nums
    x22 = array length
    x23 = bst
    x24 = valIndex (0, 1, 2, etc.)
    x25 = next_free
    x0 = currIndex (0, 1, 2, etc.)
    x2 = valToIns
    x3 = next_free
    x4 = currOffset
    x5 = currVal
    x6 = incVal
    x7 = childIndex
    x8 = childOffset
    x9 = child
    x10 = next_free offset
    x11 = next_free offset + 8 / next_free offset + 16
*/
bst_init:
    sub sp, sp, #8
    str x30, [sp, #0]   // storing x30 (LR)

    mov x6, #0          // x6 = 0 (incVal)
    lsl x4, x0, #3      // x4 = x0 (currIndex) * 8 = currOffset
    ldr x5, [x23, x4]   // x5 = bst @ currOffset = currVal

    cmp x2, x5          // COMPARING valToIns and currVal
    ble lessThan        // IF valToIns <= currVal, jump to lessThan
    // ELSE:
    // valToIns should be right child
    add x6, x6, #1      // x6 += 1 (incVal += 1; incVal will be 2 by end)
lessThan:
    // valToIns should be left child
    add x6, x6, #1      // x6 += 1 (incVal += 1; incVal = 1 if le, 2 if gt)

    add x7, x0, x6      // x7 = currIndex + incVal (childIndex)
    lsl x8, x7, #3      // x8 = childIndex * 8 (childOffset)
    ldr x9, [x23, x8]   // x9 = child

    cmp x9, x20         // COMPARING child and -1
    bne recCall         // IF child != -1, jump to recCall
    // ELSE:
    // Insert valToIns
    str x3, [x23, x8]   // bst @ childOffset = next_free (index)
    lsl x10, x3, #3     // x10 = next_free * 8 (next_free offset)
    str x2, [x23, x10]  // bst @ next_free offset = valToIns
    add x11, x10, #8    // x11 = next_free offset + 8 (next_free left child)
    str x20, [x23, x11] // bst @ next_free offset + 8 = -1
    add x11, x11, #8    // x11 += 8 (next_free right child)
    str x20, [x23, x11] // bst @ next_free offset + 16 = -1

    add x25, x25, #3    // next_free += 3

baseCase:
    add sp, sp, #8      // popping stack
    ret

recCall:
    mov x0, x9          // x0 (currIndex) = x9 (child)
    bl bst_init

    ldr x30, [sp, #0]   // loading x30 (LR)
    add sp, sp, #8      // popping stack
    ret

/* FUNCTION TO PRINT OUT IN ORDER TRAVERSAL OF BST */
/*
    x0 = index
*/
in_order:
    sub sp, sp, #48
    str x30, [sp, #0]   // storing x30 (LR)
    str x0, [sp, #8]    // storing index
    add x1, x0, #1      // x1 = index + 1
    lsl x1, x1, #3      // x1 = x1 * 8 (index+1 Offset)
    str x1, [sp, #16]   // storing index+1 Offset
    ldr x2, [x23, x1]   // x2 = bst @ index+1 Offset
    str x2, [sp, #24]   // storing x2
    cmp x2, x20         // COMPARING valAtInd+1 and -1
    beq eqToNegOne      // IF valAtInd+1 == -1, jump to eqToNegOne
    // ELSE:
    mov x0, x2          // x0 (index) = x2 (valAtInd+1)
    bl in_order
eqToNegOne:
    ldr x30, [sp, #0]   // loading x30 (LR)
    ldr x0, [sp, #8]    // loading index
    ldr x1, [sp, #16]   // restoring x1

    lsl x3, x0, #3      // x3 = x0 * 8 (indexOffset)
    ldr x4, [x23, x3]   // x4 = bst @ indexOffset

    str x3, [sp, #32]   // storing x3
    str x4, [sp, #40]   // storing x4

    adr x0, printelem   // address of message to be printed loaded to x0
    mov x1, x4          // value to be printed moved to x1
    bl printf           // printing message & value

    ldr x0, [sp, #8]    // restoring x0
    ldr x1, [sp, #16]   // restoring x1
    ldr x2, [sp, #24]   // restoring x2
    ldr x3, [sp, #32]   // restoring x3
    ldr x4, [sp, #40]   // restoring x4

    add x5, x0, #16      // x5 = (indexOffset) + 16 = index+2 Offset
    ldr x6, [x23, x5]   // x6 = bst @ index+2 Offset (valAtInd+2)
    cmp x6, x20         // COMPARING valAtInd+2 to -1
    beq eqToNegOneTwo   // IF valAtInd+2 == -1, jump to eqToNegOneTwo
    // ELSE:
    mov x0, x6          // x0 (index) = x6 (valAtInd+2)
    bl in_order
eqToNegOneTwo:
    ldr x30, [sp, #0]   // loading x30 (LR)
    ldr x0, [sp, #8]    // loading index
    add sp, sp, #16     // popping stack
    ret

.bss
.align 8
bst:
    .space 768

.data
inpdata:
    .dword 4, 14, 1, 26, 7, 19
inplen:
    .dword 6
printelem:
    .asciz "%d\n"

