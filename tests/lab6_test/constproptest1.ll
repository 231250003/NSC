; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 1, i32* %num, align 4
  %c = alloca i32, align 4
  store i32 1, i32* %c,  4
  ret i32 2
}
