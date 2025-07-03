; ModuleID = 'my_module'
source_filename = "my_module"

@z = global i32 3

define i32 @print() {
printEntry:
  %load_lval = load i32, i32* @z, align 4
  %add = add i32 %load_lval, 3
  ret i32 %add
}

define i32 @main() {
mainEntry:
  %a = alloca [1 x [1 x i32]], align 4
  %elemPtr = getelementptr [1 x [1 x i32]], [1 x [1 x i32]]* %a, i32 0, i32 0, i32 0
  store i32 1, i32* %elemPtr, align 4
  %x = alloca i32, align 4
  store i32 1, i32* %x, align 4
  ret i32 0
}
