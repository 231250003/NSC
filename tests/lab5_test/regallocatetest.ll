; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %x1 = alloca i32, align 4
  store i32 1, i32* %x1, align 4
  %x2 = alloca i32, align 4
  store i32 2, i32* %x2, align 4
  %x3 = alloca i32, align 4
  store i32 3, i32* %x3, align 4
  %x4 = alloca i32, align 4
  store i32 4, i32* %x4, align 4
  %x5 = alloca i32, align 4
  store i32 5, i32* %x5, align 4
  %x6 = alloca i32, align 4
  store i32 6, i32* %x6, align 4
  %x7 = alloca i32, align 4
  store i32 7, i32* %x7, align 4
  %x8 = alloca i32, align 4
  store i32 8, i32* %x8, align 4
  %x9 = alloca i32, align 4
  store i32 9, i32* %x9, align 4
  %load_lval = load i32, i32* %x1, align 4
  %load_lval1 = load i32, i32* %x2, align 4
  %add = add i32 %load_lval, %load_lval1
  %load_lval2 = load i32, i32* %x3, align 4
  %add3 = add i32 %add, %load_lval2
  %load_lval4 = load i32, i32* %x4, align 4
  %add5 = add i32 %add3, %load_lval4
  %load_lval6 = load i32, i32* %x5, align 4
  %add7 = add i32 %add5, %load_lval6
  %load_lval8 = load i32, i32* %x6, align 4
  %add9 = add i32 %add7, %load_lval8
  %load_lval10 = load i32, i32* %x7, align 4
  %add11 = add i32 %add9, %load_lval10
  %load_lval12 = load i32, i32* %x8, align 4
  %add13 = add i32 %add11, %load_lval12
  %load_lval14 = load i32, i32* %x9, align 4
  %add15 = add i32 %add13, %load_lval14
  ret i32 %add15
}
