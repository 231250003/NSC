; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @f(i32 %x) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %cmp = icmp eq i32 %load_lval, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %fEntry
  %load_lval2 = load i32, i32* %param0_addr, align 4
  %cmp3 = icmp eq i32 %load_lval2, 1
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool6 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool6, label %if.then5, label %if.else

if.then:                                          ; preds = %fEntry
  ret i32 0

if.then5:                                         ; preds = %merge
  ret i32 1

if.else:                                          ; preds = %merge
  %load_lval7 = load i32, i32* %param0_addr, align 4
  %sub = sub i32 %load_lval7, 1
  %f = call i32 @f(i32 %sub)
  %load_lval8 = load i32, i32* %param0_addr, align 4
  %sub9 = sub i32 %load_lval8, 2
  %f10 = call i32 @f(i32 %sub9)
  %add = add i32 %f, %f10
  ret i32 %add
}

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 1, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 2, i32* %y, align 4
  %z = alloca i32, align 4
  store i32 64, i32* %z, align 4
  %add = add i32 1, 2
  %f = call i32 @f(i32 5)
  ret i32 %f
}
