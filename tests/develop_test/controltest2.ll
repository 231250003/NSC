; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 56
@y = global i32 98

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  %load_lval = load i32, i32* @x, align 4
  store i32 %load_lval, i32* %a, align 4
  %b = alloca i32, align 4
  %load_lval1 = load i32, i32* @y, align 4
  store i32 %load_lval1, i32* %b, align 4
  %result = alloca i32, align 4
  %load_lval2 = load i32, i32* %a, align 4
  store i32 %load_lval2, i32* %result, align 4
  %load_lval3 = load i32, i32* %result, align 4
  ret i32 %load_lval3
}
