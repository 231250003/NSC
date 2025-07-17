; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  %load_lval2 = load i32, i32* @global_var, align 4
  store i32 %load_lval2, i32* %x, align 4
  store i32 3, i32* %x, align 4
  %load_lval3 = load i32, i32* @global_var, align 4
  store i32 %load_lval3, i32* %x, align 4
  %load_lval5 = load i32, i32* %x, align 4
  %add = add i32 3, %load_lval5
  ret i32 %add
}
