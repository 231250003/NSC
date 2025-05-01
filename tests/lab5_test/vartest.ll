; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 1
@b = global i32 0

define i32 @main() {
mainEntry:
  %c = alloca i32, align 4
  store i32 3, i32* %c, align 4
  %load_lval = load i32, i32* %c, align 4
  %load_lval1 = load i32, i32* @a, align 4
  %add = add i32 %load_lval, %load_lval1
  %add2 = add i32 %add, 1
  store i32 %add2, i32* @b, align 4
  %d = alloca i32, align 4
  store i32 10, i32* %d, align 4
  %load_lval3 = load i32, i32* @a, align 4
  %load_lval4 = load i32, i32* @b, align 4
  %add5 = add i32 %load_lval3, %load_lval4
  %load_lval6 = load i32, i32* %c, align 4
  %add7 = add i32 %add5, %load_lval6
  %load_lval8 = load i32, i32* %d, align 4
  %add9 = add i32 %add7, %load_lval8
  %add10 = add i32 %add9, 16
  ret i32 %add10
}
