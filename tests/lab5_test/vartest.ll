; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 1
@dddd = global i32 111
@b = global i32 0
@cccc = global i32 0

define i32 @main() {
mainEntry:
  store i32 2, i32* @b, align 4
  ret i32 2
}
