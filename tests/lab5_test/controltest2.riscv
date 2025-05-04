  .data
x:
  .word 56
  .data
y:
  .word 98

  .text
  .globl main
main:
  addi sp, sp, -512
mainEntry:
  la t0, x
  lw t0, 0(t0)
  mv x3, t0
  mv x1, x3
  la t1, y
  lw t1, 0(t1)
  mv x8, t1
  mv x4, x8
  j while.cond
cur:
  mv x11, x1
  mv x10, x11
  mv x12, x10
  mv a0, x12
  addi sp, sp, 512
  li a7, 93
  ecall
while.stmt:
  mv x13, x1
  mv x14, x4
  sgt t2, x13, x14
  mv x15, t2
  mv t0, x15
  mv x16, t0
  li t1, 0
  xor t2, x16, t1
  snez t2, t2
  mv x17, t2
  bnez x17, if.then
  j if.else
while.cond:
  mv x20, x4
  mv x21, x1
  add t0, x20, x21
  mv x22, t0
  li t1, 20
  sgt t2, x22, t1
  mv x23, t2
  mv t0, x23
  mv x24, t0
  li t1, 0
  xor t2, x24, t1
  snez t2, t2
  mv x25, t2
  bnez x25, while.stmt
  j cur
merge:
  j while.cond
if.then:
  mv x28, x1
  mv x29, x4
  sub t0, x28, x29
  mv x30, t0
  mv x1, x30
  j merge
if.else:
  mv x3, x4
  mv x8, x1
  sub t1, x3, x8
  mv x11, t1
  mv x4, x11
  j merge
