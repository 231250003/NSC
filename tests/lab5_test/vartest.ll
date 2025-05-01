; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 1
@dddd = global i32 111
@b = global i32 0
@cccc = global i32 0

define i32 @main() {
mainEntry:
  %c = alloca i32, align 4
  store i32 3, i32* %c, align 4
  %z = alloca i32, align 4
  store i32 64, i32* %z, align 4
  store i32 4, i32* %z, align 4
  %p = alloca i32, align 4
  store i32 -2, i32* %p, align 4
  %q = alloca i32, align 4
  store i32 0, i32* %q, align 4
  %load_lval = load i32, i32* @a, align 4
  %load_lval1 = load i32, i32* @b, align 4
  %add = add i32 %load_lval, %load_lval1
  %load_lval2 = load i32, i32* %c, align 4
  %add3 = add i32 %add, %load_lval2
  %add4 = add i32 %add3, 16
  %load_lval5 = load i32, i32* %z, align 4
  %add6 = add i32 %add4, %load_lval5
  %load_lval7 = load i32, i32* %p, align 4
  %add8 = add i32 %add6, %load_lval7
  %load_lval9 = load i32, i32* %q, align 4
  %add10 = add i32 %add8, %load_lval9
  %load_lval11 = load i32, i32* @dddd, align 4
  %add12 = add i32 %add10, %load_lval11
  ret i32 %add12
}
