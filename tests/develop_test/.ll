; ModuleID = 'my_module'
source_filename = "my_module"

@z = global i32 3

define i32 @print() {
printEntry:
  ret i32 6
}

define i32 @main() {
mainEntry:
  ret i32 0
}
