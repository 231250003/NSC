
  .text
  .globl main
main:
  addi sp, sp, -512
mainEntry:
  li t0, 0
  mv x1, t0
  li t1, 0
  mv x3, t1
  j while.cond
cur:
  mv x8, x3
  mv a0, x8
  addi sp, sp, 512
  li a7, 93
  ecall
while.stmt:
  sw x8, 4(sp)
  mv x9, x1
  li t2, 2
  xor t0, x9, t2
  seqz t0, t0
  mv x10, t0
  sw x9, 8(sp)
  mv t1, x10
  mv x11, t1
  sw x10, 12(sp)
  li t2, 0
  xor t0, x11, t2
  snez t0, t0
  mv x12, t0
  sw x11, 16(sp)
  bnez x12, if.then
  j if.else
while.cond:
  sw x12, 20(sp)
  sw x14, 24(sp)
  sw x13, 28(sp)
  mv x15, x1
  li t1, 8
  slt t2, x15, t1
  mv x16, t2
  sw x15, 32(sp)
  mv t0, x16
  mv x17, t0
  sw x16, 36(sp)
  li t1, 0
  xor t2, x17, t1
  snez t2, t2
  mv x18, t2
  sw x17, 40(sp)
  bnez x18, while.stmt
  j cur
merge:
  sw x20, 44(sp)
  sw x18, 48(sp)
  sw x19, 52(sp)
  mv x21, x1
  li t0, 1
  add t1, x21, t0
  mv x22, t1
  sw x21, 56(sp)
  mv x1, x22
  sw x22, 60(sp)
  j while.cond
if.then:
  sw x4, 64(sp)
  mv x23, x3
  li t2, 3
  add t0, x23, t2
  mv x24, t0
  sw x23, 68(sp)
  mv x3, x24
  sw x24, 72(sp)
  j merge
if.else:
  mv x26, x1
  sw x1, 76(sp)
  li t1, 4
  xor t2, x26, t1
  seqz t2, t2
  mv x27, t2
  sw x26, 80(sp)
  mv t0, x27
  mv x28, t0
  sw x27, 84(sp)
  li t1, 0
  xor t2, x28, t1
  snez t2, t2
  mv x29, t2
  sw x28, 88(sp)
  bnez x29, if.then10
  j if.else11
merge6:
  sw x29, 92(sp)
  sw x30, 96(sp)
  sw x31, 100(sp)
  j merge
if.then10:
  sw x25, 104(sp)
  mv x8, x3
  li t0, 1
  sub t1, x8, t0
  mv x9, t1
  sw x8, 108(sp)
  mv x3, x9
  sw x9, 112(sp)
  j merge6
if.else11:
  mv x11, x3
  li t2, 1
  add t0, x11, t2
  mv x12, t0
  sw x11, 116(sp)
  mv x3, x12
  sw x12, 120(sp)
  sw x3, 124(sp)
  j merge6
