; ModuleID = 'my_module'
source_filename = "my_module"

@z = global i32 3
@a = constant [4 x [4 x i32]] [[4 x i32] [i32 1, i32 2, i32 3, i32 3], [4 x i32] [i32 4, i32 0, i32 0, i32 0], [4 x i32] zeroinitializer, [4 x i32] zeroinitializer]

define i32 @print() {
printEntry:
  %load_lval = load i32, i32* @z, align 4
  %add = add i32 %load_lval, 3
  ret i32 %add
}

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 1, i32* %x, align 4
  ret i32 0
}
