; ModuleID = 'my_module'
source_filename = "my_module"

@z = global i32 3

define i32 @print() {
printEntry:
  %load_lval = load i32, i32* @z, align 4
  %add = add i32 %load_lval, 3
  store i32 %add, i32* @z, align 4
  %load_lval1 = load i32, i32* @z, align 4
  %add2 = add i32 %load_lval1, 3
  ret i32 %add2
}

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 1, i32* %x, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %print = call i32 @print()
  %load_lval = load i32, i32* @z, align 4
  ret i32 %load_lval
}
