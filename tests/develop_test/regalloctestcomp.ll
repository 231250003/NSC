; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %x1 = alloca i32, align 4
  store i32 1, i32* %x1, align 4
  %load_lval = load i32, i32* %x1, align 4
  ret i32 %load_lval
}
