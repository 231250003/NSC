
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
  mv x9, x1
  li t2, 2
  xor t0, x9, t2
  seqz t0, t0
  mv x10, t0
  mv t1, x10
  mv x11, t1
  li t2, 0
  xor t0, x11, t2
  snez t0, t0
  mv x12, t0
  bnez x12, if.then
  j if.else
while.cond:
  mv x15, x1
  li t1, 8
  slt t2, x15, t1
  mv x16, t2
  mv t0, x16
  mv x17, t0
  li t1, 0
  xor t2, x17, t1
  snez t2, t2
  mv x18, t2
  bnez x18, while.stmt
  j cur
merge:
  mv x21, x1
  li t0, 1
  add t1, x21, t0
  mv x22, t1
  mv x1, x22
  j while.cond
if.then:
  mv x23, x3
  li t2, 3
  add t0, x23, t2
  mv x24, t0
  mv x3, x24
  j merge
if.else:
  mv x26, x1
  li t1, 4
  xor t2, x26, t1
  seqz t2, t2
  mv x27, t2
  mv t0, x27
  mv x28, t0
  li t1, 0
  xor t2, x28, t1
  snez t2, t2
  mv x29, t2
  bnez x29, if.then10
  j if.else11
merge6:
  j merge
if.then10:
  mv x8, x3
  li t0, 1
  sub t1, x8, t0
  mv x9, t1
  mv x3, x9
  j merge6
if.else11:
  mv x11, x3
  li t2, 1
  add t0, x11, t2
  mv x12, t0
  mv x3, x12
  j merge6
