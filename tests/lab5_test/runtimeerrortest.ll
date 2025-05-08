
  .text
  .globl main
main:
  addi sp, sp, -4
mainEntry:
  li a0, 6
  addi sp, sp, 4
  li a7, 93
  ecall
