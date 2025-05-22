; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 1
@y = global i32 2
@z = global i32 3
@a = global i32 4

define i32 @main() {
mainEntry:
  store i32 2, i32* @x, align 4
  store i32 4, i32* @y, align 4
  store i32 6, i32* @z, align 4
  store i32 8, i32* @a, align 4
  %load_lval17 = load i32, i32* @x, align 4
  %add18 = add i32 12, %load_lval17
  %load_lval19 = load i32, i32* @y, align 4
  %add20 = add i32 %add18, %load_lval19
  %load_lval21 = load i32, i32* @z, align 4
  %add22 = add i32 %add20, %load_lval21
  %load_lval23 = load i32, i32* @a, align 4
  %add24 = add i32 %add22, %load_lval23
  ret i32 %add24
}
