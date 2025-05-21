; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 1, i32* %num, align 4
  store i32 3, i32* %num, align 4
  %0 = load i32, i32* %num, align 4
  %1 = add i32 %0, 1
  ret i32 %1
}
