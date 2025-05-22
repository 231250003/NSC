; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 1
@y = global i32 2
@z = global i32 3
@a = global i32 4

define i32 @main() {
mainEntry:
  %x1 = alloca i32, align 4
  store i32 1, i32* %x1, align 4
  %x2 = alloca i32, align 4
  store i32 2, i32* %x2, align 4
  %x3 = alloca i32, align 4
  store i32 3, i32* %x3, align 4
  store i32 2, i32* @x, align 4
  store i32 4, i32* @y, align 4
  store i32 6, i32* @z, align 4
  store i32 8, i32* @a, align 4
  ret i32 32
}
