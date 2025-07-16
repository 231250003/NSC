; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  store i32 0, i32* %a, align 4
  %b = alloca i32, align 4
  store i32 0, i32* %b, align 4
  %c = alloca i32, align 4
  store i32 0, i32* %c, align 4
  %add = add i32 0, 2
  %mul = mul i32 2, 2
  %add4 = add i32 4, 1
  %mul7 = mul i32 5, 0
  ret i32 0
}
