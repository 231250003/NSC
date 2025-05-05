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
  mv x9, x1
  li t2, 0
  xor t0, x9, t2
  seqz t0, t0
  mv x10, t0
  mv t1, x10
  mv x11, t1
  mv x12, x4
  add t2, x11, x12
  mv x13, t2
  li t0, 10
  slt t1, x13, t0
  seqz t1, t1
  mv x14, t1
  mv t2, x14
  mv x15, t2
  li t0, 0
  xor t1, x15, t0
  snez t1, t1
  mv x16, t1
  bnez x16, if.then
  j merge
merge:
  j while.cond
if.then:
  mv x17, x1
  li t2, 10
  sgt t0, x17, t2
  seqz t0, t0
  mv x18, t0
  mv t1, x18
  mv x19, t1
  li t2, 0
  xor t0, x19, t2
  snez t0, t0
  mv x20, t0
  bnez x20, if.then9
  j merge5
merge5:
  j merge
if.then9:
  li t1, 2
  mv a0, t1
  addi sp, sp, 512
  li a7, 93
  ecall
cur:
  j while.cond30
while.stmt:
  mv x21, x1
  li t2, 2
  sub t0, x21, t2
  mv x22, t0
  mv x1, x22
  mv x23, x1
  li t1, 45
  xor t2, x23, t1
  seqz t2, t2
  mv x24, t2
  mv t0, x24
  mv x25, t0
  li t1, 0
  xor t2, x25, t1
  snez t2, t2
  mv x26, t2
  bnez x26, if.then16
  j if.else
while.cond:
  li t0, -1
  bnez t0, while.stmt
  j cur
merge12:
  j while.cond
if.then16:
  j cur
if.else:
  mv x27, x1
  li t1, 48
  xor t2, x27, t1
  seqz t2, t2
  mv x28, t2
  mv t0, x28
  mv x29, t0
  li t1, 0
  xor t2, x29, t1
  snez t2, t2
  mv x30, t2
  bnez x30, if.then22
  j merge18
merge18:
  j merge12
if.then22:
  mv x31, x4
  li t0, 3
  sub t1, x31, t0
  mv x16, t1
  mv x4, x16
  mv x15, x1
  li t2, 1
  add t0, x15, t2
  mv x13, t0
  mv x1, x13
  j merge18
cur28:
  mv x11, x1
  mv x3, x11
  mv x9, x3
  mv a0, x9
  addi sp, sp, 512
  li a7, 93
  ecall
while.stmt29:
  j while.cond39
while.cond30:
  mv x12, x4
  mv x8, x1
  add t1, x12, x8
  mv x14, t1
  li t2, 20
  sgt t0, x14, t2
  mv x10, t0
  mv t1, x10
  mv x19, t1
  li t2, 0
  xor t0, x19, t2
  snez t0, t0
  mv x18, t0
  bnez x18, while.stmt29
  j cur28
cur37:
  j while.cond55
while.stmt38:
  mv x17, x1
  li t1, 40
  sgt t2, x17, t1
  mv x20, t2
  mv t0, x20
  mv x23, t0
  li t1, 0
  xor t2, x23, t1
  snez t2, t2
  mv x21, t2
  bnez x21, if.then48
  j if.else49
while.cond39:
  mv x22, x1
  li t0, 10
  sgt t1, x22, t0
  mv x26, t1
  mv t2, x26
  mv x24, t2
  li t0, 0
  xor t1, x24, t0
  snez t1, t1
  mv x25, t1
  bnez x25, while.stmt38
  j cur37
merge44:
  j while.cond39
if.then48:
  mv x27, x1
  li t2, 5
  sub t0, x27, t2
  mv x16, t0
  mv x1, x16
  j cur37
if.else49:
  j cur37
cur53:
  mv x28, x4
  li t1, 3
  sub t2, x28, t1
  mv x13, t2
  mv x4, x13
  mv x15, x1
  li t0, 1
  add t1, x15, t0
  mv x31, t1
  mv x1, x31
  mv x29, x1
  mv x30, x4
  add t2, x29, x30
  mv x11, t2
  li t0, 50
  sgt t1, x11, t0
  mv x3, t1
  mv t2, x3
  mv x9, t2
  li t0, 0
  xor t1, x9, t0
  snez t1, t1
  mv x10, t1
  bnez x10, if.then113
  j merge107
while.stmt54:
  li t2, 30
  mv x18, t2
  j while.cond63
while.cond55:
  mv x19, x4
  li t0, 35
  sgt t1, x19, t0
  mv x14, t1
  mv t2, x14
  mv x12, t2
  li t0, 0
  xor t1, x12, t0
  snez t1, t1
  mv x8, t1
  bnez x8, while.stmt54
  j cur53
cur61:
  mv x24, x4
  li t2, 10
  sub t0, x24, t2
  mv x25, t0
  mv a0, x25
  addi sp, sp, 512
  li a7, 93
  ecall
while.stmt62:
  mv x26, x18
  li t1, 20
  slt t2, x26, t1
  mv x22, t2
  mv t0, x22
  mv x27, t0
  li t1, 0
  xor t2, x27, t1
  snez t2, t2
  mv x16, t2
  bnez x16, if.then68
  j if.else69
while.cond63:
  li t0, -1
  bnez t0, while.stmt62
  j cur61
merge64:
  j cur61
if.then68:
  mv x23, x18
  mv a0, x23
  addi sp, sp, 512
  li a7, 93
  ecall
if.else69:
  mv x21, x18
  li t1, 7
  sub t2, x21, t1
  mv x20, t2
  mv x18, x20
  j merge64
merge76:
  j while.cond55
if.then80:
  mv x17, x4
  li t0, 5
  sub t1, x17, t0
  mv x12, t1
  mv x4, x12
  j while.cond55
if.else81:
  mv x19, x4
  li t2, 50
  sgt t0, x19, t2
  mv x8, t0
  mv t1, x8
  mv x14, t1
  li t2, 0
  xor t0, x14, t2
  snez t0, t0
  mv x24, t0
  bnez x24, if.then89
  j if.else90
merge85:
  j merge76
if.then89:
  mv x25, x4
  li t1, 7
  sub t2, x25, t1
  mv x23, t2
  mv x4, x23
  j merge85
if.else90:
  mv x20, x4
  li t0, 30
  sgt t1, x20, t0
  mv x16, t1
  mv t2, x16
  mv x18, t2
  li t0, 0
  xor t1, x18, t0
  snez t1, t1
  mv x22, t1
  bnez x22, if.then98
  j if.else99
merge94:
  j merge85
if.then98:
  mv x26, x4
  li t2, 1
  sub t0, x26, t2
  mv x21, t0
  mv x4, x21
  j merge94
if.else99:
  li t1, 10
  mv a0, t1
  addi sp, sp, 512
  li a7, 93
  ecall
merge107:
  j while.cond30
if.then113:
  mv x27, x1
  li t2, 10
  sub t0, x27, t2
  mv x12, t0
  mv x1, x12
  j merge107
