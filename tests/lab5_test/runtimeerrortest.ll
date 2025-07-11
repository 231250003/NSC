; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 5

define i32 @main() {
mainEntry:
  %load_lval = load i32, i32* @x, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* @x, align 4
  %load_lval1 = load i32, i32* @x, align 4
  ret i32 %load_lval1
}
