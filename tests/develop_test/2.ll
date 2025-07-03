; ModuleID = 'my_module'
source_filename = "my_module"

@sort_arr = global [5 x i32] zeroinitializer

define i32 @combine([2 x i32]* %arr1, i32 %arr1_length, [3 x i32]* %arr2, i32 %arr2_length) {
combineEntry:
  %param0_addr = alloca [2 x i32]*, align 8
  store [2 x i32]* %arr1, [2 x i32]** %param0_addr, align 8
  %param1_addr = alloca i32, align 4
  store i32 %arr1_length, i32* %param1_addr, align 4
  %param2_addr = alloca [3 x i32]*, align 8
  store [3 x i32]* %arr2, [3 x i32]** %param2_addr, align 8
  %param3_addr = alloca i32, align 4
  store i32 %arr2_length, i32* %param3_addr, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  ret i32 0
}

define i32 @main() {
mainEntry:
  %a = alloca [2 x i32], align 4
  %elemPtr = getelementptr [2 x i32], [2 x i32]* %a, i32 0, i32 0
  store i32 1, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [2 x i32], [2 x i32]* %a, i32 0, i32 1
  store i32 5, i32* %elemPtr1, align 4
  %b = alloca [3 x i32], align 4
  %elemPtr2 = getelementptr [3 x i32], [3 x i32]* %b, i32 0, i32 0
  store i32 1, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [3 x i32], [3 x i32]* %b, i32 0, i32 1
  store i32 4, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [3 x i32], [3 x i32]* %b, i32 0, i32 2
  store i32 14, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [2 x i32], [2 x i32]* %a, i32 0
  %elemPtr6 = getelementptr [3 x i32], [3 x i32]* %b, i32 0
  %combine = call i32 @combine([2 x i32]* %elemPtr5, i32 2, [3 x i32]* %elemPtr6, i32 3)
  ret i32 %combine
}
