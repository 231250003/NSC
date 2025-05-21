; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 1, i32* %num, align 4
  %x = alloca i32, align 4
  store i32 1, i32* %x, align 4
  store i32 3, i32* %x, align 4
  store i32 1, i32* %x, align 4
  %load_lval3 = load i32, i32* %x, align 4
  %add = add i32 1, %load_lval3
  ret i32 %add
}
