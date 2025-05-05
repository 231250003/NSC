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
  mv x10, x1
  mv x9, x10
  mv x13, x9
  mv a0, x13
  addi sp, sp, 512
  li a7, 93
  ecall
while.stmt:
  mv x15, x1
  mv x16, x4
  sgt t2, x15, x16
  mv x17, t2
  mv t0, x17
  mv x20, t0
  li t1, 0
  xor t2, x20, t1
  snez t2, t2
  mv x23, t2
  bnez x23, if.then
  j if.else
while.cond:
  mv x25, x4
  li t0, 0
  xor t1, x25, t0
  snez t1, t1
  mv x26, t1
  mv t2, x26
  mv x28, t2
  li t0, 0
  xor t1, x28, t0
  snez t1, t1
  mv x31, t1
  bnez x31, while.stmt
  j cur
merge:
  j while.cond
if.then:
  mv x8, x1
  mv x10, x4
  sub t2, x8, x10
  mv x11, t2
  mv x1, x11
  j merge
if.else:
  mv x14, x4
  mv x16, x1
  sub t0, x14, x16
  mv x19, t0
  mv x4, x19
  j merge
