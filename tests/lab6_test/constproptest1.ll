; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %load_lval2 = load i32, i32* @global_var, align 4
  %add = add i32 1, %load_lval2
  ret i32 %add
}
