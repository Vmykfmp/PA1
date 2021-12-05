.section .data
# There are two global variables:
#  1. array: Store the input numbers.
#  2. size: the number of the list
# You can modify the following two lines to test your program,
# but DO NOT change the line number
array: .dword 15, 20, 6, 35, 70, 7, 14, 36, 1, 21, 13, 3, 24, 5, 22, 2, 4, 10, 8, 12
size: .dword 20

# Variables for print function
# DO NOT modify these
dummy_msg: .ascii "   "
newline_msg: .ascii "\n"
ascii_msg: .ascii "Test"
magic_mem: .space 64

.section .text
.global main
main:

  # save return pointer
  addi sp, sp, -8
  sd ra, 0(sp)

  la a0, array      # assign array address to a0
  ld a2, size       # assign array size to a2

  li a3, 0          # low
  addi a2, a2, -1   # high

  jal quickSort     # jump to function

  jal print         # show results

  li a0, 0

  ld ra, 0(sp)
  addi sp, sp, 8

  ret               # return (jump to the address stored in register ra)

.global quickSort
quickSort:

  #########################
  # Finish your code here #
  #########################

  slli a2, a2, 3    # a2 = high
  slli a3, a3, 3    # a3 = low
  
  bge a3, a2, else1 # low >= high
  addi sp, sp, -8   # partition(low,high)
  sd ra,0(sp)
  jal partition      
  ld ra,0(sp)
  addi sp, sp, 8
  
  srli a2, a2, 3    # a2 = high
  srli a3, a3, 3    # a3 = low

  addi sp, sp, -16   # qsort(low,pivot-1)
  sd ra, 0(sp)
  sd a2, 8(sp)
  addi a2, a6, -1
  jal quickSort
  ld a2 ,8(sp)     
  ld ra ,0(sp)
  addi sp, sp, 16

  addi sp, sp, -16   # qsort(pivot+1,high)
  sd ra, 0(sp)
  sd a3, 8(sp)
  addi a3, a6, 1
  jal quickSort
  ld a3 ,8(sp)     
  ld ra ,0(sp)
  addi sp, sp, 16

else1:
  ret

.global partition
partition:
  add a0, a0, a2    # s3 = pivot = arr[high]
  ld s3, 0(a0)      
  sub a0, a0, a2

  addi a4, a3, 0    # a4 = i 
  addi a5, a3, 0    # a5 = j 
  
loop:
  bge a5, a2, exit  # j >= high
  add a0, a0, a5    # s4 = arr[j]
  ld s4, 0(a0)      
  sub a0, a0, a5
  
  bge s4, s3, else2 # arr[j] >= pivot   
  addi sp, sp, -8   # swag arr[i] arr[j]
  sd ra,0(sp)
  jal swag      
  ld ra,0(sp)
  addi sp, sp, 8

  addi a4, a4, 8    # i++
else2:
  addi a5, a5, 8    # j++
  j    loop

exit:
  addi a5, a2, 0    # j = high
  addi sp, sp, -8  # swag arr[i] arr[high]
  sd ra, 0(sp)
  jal swag  
  ld ra, 0(sp)
  addi sp, sp, 8
  addi a6, a4, 0   # return i 
  srli a6, a6, 3
  jalr x0, 0(x1)

.global swag
swag:
  add s5, a0, a4
  add s6, a0, a5
  ld s7, 0(s5)
  ld s8, 0(s6)   
  sd s7, 0(s6)
  sd s8, 0(s5)
  jalr x0, 0(x1)


####################################
# Helper function to print results #
#     DO NOT modify this!!!!!!     #
####################################
.global print
print:

  addi sp, sp, -72
  sd s7, 64(sp)
  sd s6, 56(sp)
  sd s5, 48(sp)
  sd s4, 40(sp)
  sd s3, 32(sp)
  sd s2, 24(sp)
  sd s1, 16(sp)
  sd s0, 8(sp)
  sd ra, 0(sp)

  la s0, array
  ld s1, size

  li s2, 0

print_loop:
  slli s3, s2, 3
  add s3, s0, s3
  ld s4, 0(s3)

  li s3, 10
  div s5, s4, s3
  rem s4, s4, s3

  beq s5, zero, less_than_10

  addi s5, s5, 48
  la s7, ascii_msg 
  sw s5, 0(s7)

  la s7, magic_mem
  li s6, 64
  sw s6, 0(s7)
  li s6, 1
  sw s6, 8(s7)
  la s6, ascii_msg
  sw s6, 16(s7)
  li s6, 1
  sw s6, 24(s7)
  la s6, tohost
  sw s7, 0(s6)

wait1:
  la s6, fromhost
  ld s7, 0(s6)
  beq s7, zero, wait1

  sw zero, 0(s6)

less_than_10:

  addi s4, s4, 48
  la s7, ascii_msg 
  sw s4, 0(s7)

  la s7, magic_mem
  li s6, 64
  sw s6, 0(s7)
  li s6, 1
  sw s6, 8(s7)
  la s6, ascii_msg
  sw s6, 16(s7)
  li s6, 1
  sw s6, 24(s7)
  la s6, tohost
  sw s7, 0(s6)

wait2:
  la s6, fromhost
  ld s7, 0(s6)
  beq s7, zero, wait2

  sw zero, 0(s6)

  la s7, magic_mem
  li s6, 64
  sw s6, 0(s7)
  li s6, 1
  sw s6, 8(s7)
  la s6, newline_msg
  sw s6, 16(s7)
  li s6, 1
  sw s6, 24(s7)
  la s6, tohost
  sw s7, 0(s6)

wait3:
  la s6, fromhost
  ld s7, 0(s6)
  beq s7, zero, wait3

  sw zero, 0(s6)

  addi s2, s2, 1
  bne s2, s1, print_loop

  ld ra, 0(sp)
  ld s0, 8(sp)
  ld s1, 16(sp)
  ld s2, 24(sp)
  ld s3, 32(sp)
  ld s4, 40(sp)
  ld s5, 48(sp)
  ld s6, 56(sp)
  ld s7, 64(sp)
  addi sp, sp, 72

  ret
