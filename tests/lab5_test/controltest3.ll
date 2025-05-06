  .data
x:
  .word 56
  .data
y:
  .word 98

  .text
  .globl main
main:
  addi sp, sp, -2044
mainEntry:
  la t0, x
  lw t0, 0(t0)
  mv x3, t0
  mv x1, x3
  sw x1, 4(sp)
  sw x3, 8(sp)
  la t1, y
  lw t1, 0(t1)
  mv x8, t1
  mv x4, x8
  sw x4, 12(sp)
  sw x8, 16(sp)
  j while.cond
cur:
  lw t2, 4(sp)
  mv x3, t2
  la t0, x
  lw t0, 0(t0)
  mv x4, t0
  li t1, 0
  xor t2, x4, t1
  seqz t2, t2
  mv x8, t2
  sw x4, 24(sp)
  mv t0, x8
  mv x9, t0
  sw x8, 28(sp)
  li t1, 3
  add t2, x9, t1
  mv x10, t2
  sw x9, 32(sp)
  xor t0, x3, x10
  snez t0, t0
  mv x11, t0
  sw x10, 36(sp)
  sw x3, 20(sp)
  mv t1, x11
  mv x12, t1
  sw x11, 40(sp)
  li t2, 0
  xor t0, x12, t2
  snez t0, t0
  mv x13, t0
  sw x13, 48(sp)
  sw x12, 44(sp)
  lw t1, 48(sp)
  bnez t1, if.then19
  j merge13
while.stmt:
  lw t2, 4(sp)
  mv x3, t2
  lw t0, 12(sp)
  mv x8, t0
  sgt t1, x3, x8
  mv x9, t1
  sw x8, 56(sp)
  sw x3, 52(sp)
  mv t2, x9
  mv x10, t2
  sw x9, 60(sp)
  li t0, 0
  xor t1, x10, t0
  snez t1, t1
  mv x11, t1
  sw x10, 64(sp)
  sw x11, 68(sp)
  lw t2, 68(sp)
  bnez t2, if.then
  j if.else
while.cond:
  lw t0, 12(sp)
  mv x3, t0
  li t1, 0
  xor t2, x3, t1
  snez t2, t2
  mv x4, t2
  sw x3, 72(sp)
  mv t0, x4
  mv x8, t0
  sw x4, 76(sp)
  li t1, 0
  xor t2, x8, t1
  snez t2, t2
  mv x9, t2
  sw x8, 80(sp)
  sw x9, 84(sp)
  lw t0, 84(sp)
  bnez t0, while.stmt
  j cur
merge:
  j while.cond
if.then:
  lw t1, 4(sp)
  mv x3, t1
  lw t2, 12(sp)
  mv x8, t2
  sub t0, x3, x8
  mv x9, t0
  sw x3, 88(sp)
  sw x8, 92(sp)
  sw x9, 4(sp)
  sw x9, 96(sp)
  j merge
if.else:
  lw t1, 12(sp)
  mv x3, t1
  lw t2, 4(sp)
  mv x4, t2
  sub t0, x3, x4
  mv x9, t0
  sw x4, 104(sp)
  sw x3, 100(sp)
  sw x9, 12(sp)
  sw x9, 108(sp)
  j merge
merge13:
  lw t1, 4(sp)
  mv x1, t1
  sw x1, 112(sp)
  lw t2, 112(sp)
  mv a0, t2
  addi sp, sp, 2044
  li a7, 93
  ecall
if.then19:
  lw t0, 4(sp)
  mv x3, t0
  li t1, 1
  add t2, x3, t1
  mv x4, t2
  sw x3, 116(sp)
  sw x4, 4(sp)
  sw x4, 120(sp)
  j merge13
