; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 5

define i32 @main() {
mainEntry:
  store i32 6, i32* @x, align 4
  ret i32 6
}
