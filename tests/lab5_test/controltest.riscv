
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
  mv x4, x3
  mv a0, x4
  addi sp, sp, 512
  li a7, 93
  ecall
while.stmt:
  mv x9, x1
  li t2, 2
  xor t0, x9, t2
  seqz t0, t0
  mv x10, t0
  mv t1, x10
  mv x13, t1
  li t2, 0
  xor t0, x13, t2
  snez t0, t0
  mv x14, t0
  bnez x14, if.then
  j if.else
while.cond:
  mv x17, x1
  li t1, 8
  slt t2, x17, t1
  mv x19, t2
  mv t0, x19
  mv x20, t0
  li t1, 0
  xor t2, x20, t1
  snez t2, t2
  mv x23, t2
  bnez x23, while.stmt
  j cur
merge:
  mv x25, x1
  li t0, 1
  add t1, x25, t0
  mv x26, t1
  mv x1, x26
  j while.cond
if.then:
  mv x29, x3
  li t2, 3
  add t0, x29, t2
  mv x30, t0
  mv x3, x30
  j merge
if.else:
  mv x8, x1
  li t1, 4
  xor t2, x8, t1
  seqz t2, t2
  mv x11, t2
  mv t0, x11
  mv x12, t0
  li t1, 0
  xor t2, x12, t1
  snez t2, t2
  mv x14, t2
  bnez x14, if.then10
  j if.else11
merge6:
  j merge
if.then10:
  mv x17, x3
  li t0, 1
  sub t1, x17, t0
  mv x18, t1
  mv x3, x18
  j merge6
if.else11:
  mv x23, x3
  li t2, 1
  add t0, x23, t2
  mv x24, t0
  mv x3, x24
  j merge6
