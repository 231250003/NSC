; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 1
@dddd = global i32 111
@b = global i32 0
@cccc = global i32 0

define i32 @main() {
mainEntry:
  %c = alloca i32, align 4
  store i32 3, i32* %c, align 4
  %z = alloca i32, align 4
  store i32 64, i32* %z, align 4
  store i32 4, i32* %z, align 4
  %p = alloca i32, align 4
  store i32 -2, i32* %p, align 4
  %q = alloca i32, align 4
  store i32 0, i32* %q, align 4
  %d = alloca i32, align 4
  %load_lval = load i32, i32* @a, align 4
  %add = add i32 10, %load_lval
  %load_lval1 = load i32, i32* @b, align 4
  %add2 = add i32 %add, %load_lval1
  %load_lval3 = load i32, i32* %c, align 4
  %add4 = add i32 %add2, %load_lval3
  %add5 = add i32 %add4, 16
  %load_lval6 = load i32, i32* %z, align 4
  %add7 = add i32 %add5, %load_lval6
  %load_lval8 = load i32, i32* %p, align 4
  %add9 = add i32 %add7, %load_lval8
  %load_lval10 = load i32, i32* %q, align 4
  %add11 = add i32 %add9, %load_lval10
  %load_lval12 = load i32, i32* @dddd, align 4
  %add13 = add i32 %add11, %load_lval12
  store i32 %add13, i32* %d, align 4
  %load_lval14 = load i32, i32* @a, align 4
  %load_lval15 = load i32, i32* @b, align 4
  %add16 = add i32 %load_lval14, %load_lval15
  %load_lval17 = load i32, i32* %c, align 4
  %add18 = add i32 %add16, %load_lval17
  %load_lval19 = load i32, i32* %d, align 4
  %add20 = add i32 %add18, %load_lval19
  %add21 = add i32 %add20, 16
  %load_lval22 = load i32, i32* %z, align 4
  %add23 = add i32 %add21, %load_lval22
  %load_lval24 = load i32, i32* %p, align 4
  %add25 = add i32 %add23, %load_lval24
  %load_lval26 = load i32, i32* %q, align 4
  %add27 = add i32 %add25, %load_lval26
  %load_lval28 = load i32, i32* @dddd, align 4
  %add29 = add i32 %add27, %load_lval28
  ret i32 %add29
}
