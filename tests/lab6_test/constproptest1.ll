; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 1, i32* %num, align 4
  %c = alloca i32, align 4
  %load_lval = load i32, i32* null, align 4
  store i32 1, i32* %c, align 4
  %load_lval1 = load i32, i32* null, align 4
  %load_lval2 = load i32, i32* null, align 4
  %mul = mul i32 0, 0
  %load_lval3 = load i32, i32* null, align 4
  %add = add i32 0, 0
  ret i32 2
}
