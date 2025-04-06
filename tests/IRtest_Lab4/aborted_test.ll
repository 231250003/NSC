; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 5, i32* %x, align 4
  %load_lval = load i32, i32* %x, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* %x, align 4
  %load_lval1 = load i32, i32* %x, align 4
  ret i32 %load_lval1
}
