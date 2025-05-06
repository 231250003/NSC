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
  mv x12, t1
  mv x4, x12
  j while.cond
cur:
  mv x13, x1
  la t2, x
  lw t2, 0(t2)
  mv x17, t2
  li t0, 0
  xor t1, x17, t0
  seqz t1, t1
  mv x18, t1
  mv t2, x18
  mv x22, t2
  li t0, 3
  add t1, x22, t0
  mv x14, t1
  xor t2, x13, x14
  snez t2, t2
  mv x16, t2
  mv t0, x16
  mv x21, t0
  li t1, 0
  xor t2, x21, t1
  snez t2, t2
  mv x19, t2
  bnez x19, if.then19
  j merge13
while.stmt:
  mv x23, x1
  mv x3, x4
  sgt t0, x23, x3
  mv x24, t0
  mv t1, x24
  mv x26, t1
  li t2, 0
  xor t0, x26, t2
  snez t0, t0
  mv x29, t0
  bnez x29, if.then
  j if.else
while.cond:
  mv x10, x4
  li t1, 0
  xor t2, x10, t1
  snez t2, t2
  mv x9, t2
  mv t0, x9
  mv x8, t0
  li t1, 0
  xor t2, x8, t1
  snez t2, t2
  mv x11, t2
  bnez x11, while.stmt
  j cur
merge:
  j while.cond
if.then:
  mv x30, x1
  mv x31, x4
  sub t0, x30, x31
  mv x25, t0
  mv x1, x25
  j merge
if.else:
  mv x28, x4
  mv x27, x1
  sub t1, x28, x27
  mv x12, t1
  mv x4, x12
  j merge
merge13:
  mv x24, x1
  mv a0, x24
  addi sp, sp, 512
  li a7, 93
  ecall
if.then19:
  mv x20, x1
  li t2, 1
  add t0, x20, t2
  mv x15, t0
  mv x1, x15
  j merge13
