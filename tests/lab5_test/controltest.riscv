
  .text
  .globl main
main:
  addi sp, sp, -512
mainEntry:
  li t0, 0
  sw t0, 4(sp)
  li t1, 0
  sw t1, 8(sp)
  j while.cond
cur:
  lw t2, 8(sp)
  sw t2, 12(sp)
  lw t0, 12(sp)
  mv a0, t0
  addi sp, sp, 512
  li a7, 93
  ecall
while.stmt:
  lw t1, 4(sp)
  sw t1, 16(sp)
  lw t2, 16(sp)
  li t0, 2
  xor t1, t2, t0
  seqz t1, t1
  sw t1, 20(sp)
  lw t2, 20(sp)
  mv t0, t2
  sw t0, 24(sp)
  lw t1, 24(sp)
  li t2, 0
  xor t0, t1, t2
  snez t0, t0
  sw t0, 28(sp)
  lw t1, 28(sp)
  bnez t1, if.then
  j if.else
while.cond:
  lw t2, 4(sp)
  sw t2, 32(sp)
  lw t0, 32(sp)
  li t1, 8
  slt t2, t0, t1
  sw t2, 36(sp)
  lw t0, 36(sp)
  mv t1, t0
  sw t1, 40(sp)
  lw t2, 40(sp)
  li t0, 0
  xor t1, t2, t0
  snez t1, t1
  sw t1, 44(sp)
  lw t2, 44(sp)
  bnez t2, while.stmt
  j cur
merge:
  lw t0, 4(sp)
  sw t0, 48(sp)
  lw t1, 48(sp)
  li t2, 1
  add t0, t1, t2
  sw t0, 52(sp)
  lw t1, 52(sp)
  sw t1, 4(sp)
  j while.cond
if.then:
  lw t2, 8(sp)
  sw t2, 56(sp)
  lw t0, 56(sp)
  li t1, 3
  add t2, t0, t1
  sw t2, 60(sp)
  lw t0, 60(sp)
  sw t0, 8(sp)
  j merge
if.else:
  lw t1, 4(sp)
  sw t1, 64(sp)
  lw t2, 64(sp)
  li t0, 4
  xor t1, t2, t0
  seqz t1, t1
  sw t1, 68(sp)
  lw t2, 68(sp)
  mv t0, t2
  sw t0, 72(sp)
  lw t1, 72(sp)
  li t2, 0
  xor t0, t1, t2
  snez t0, t0
  sw t0, 76(sp)
  lw t1, 76(sp)
  bnez t1, if.then10
  j if.else11
merge6:
  j merge
if.then10:
  lw t2, 8(sp)
  sw t2, 80(sp)
  lw t0, 80(sp)
  li t1, 1
  sub t2, t0, t1
  sw t2, 84(sp)
  lw t0, 84(sp)
  sw t0, 8(sp)
  j merge6
if.else11:
  lw t1, 8(sp)
  sw t1, 88(sp)
  lw t2, 88(sp)
  li t0, 1
  add t1, t2, t0
  sw t1, 92(sp)
  lw t2, 92(sp)
  sw t2, 8(sp)
  j merge6
