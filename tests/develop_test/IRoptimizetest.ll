; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %n = alloca i32, align 4
  store i32 6, i32* %n, align 4
  %load_lval = load i32, i32* %i, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* %i, align 4
  %load_lval1 = load i32, i32* %i, align 4
  %add2 = add i32 %load_lval1, 1
  ret i32 %add2
}
