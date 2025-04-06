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

merge:                                            ; preds = %if.then, %fEntry
  %load_lval2 = load i32, i32* %param0_addr, align 4
  %cmp3 = icmp eq i32 %load_lval2, 1
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool6 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool6, label %if.then5, label %merge1

if.then:                                          ; preds = %fEntry
  ret i32 0
  br label %merge

merge1:                                           ; preds = %if.then5, %merge
  %load_lval7 = load i32, i32* %param0_addr, align 4
  %sub = sub i32 %load_lval7, 1
  %f = call i32 @f(i32 %sub)
  %load_lval8 = load i32, i32* %param0_addr, align 4
  %sub9 = sub i32 %load_lval8, 2
  %f10 = call i32 @f(i32 %sub9)
  %add = add i32 %f, %f10
  ret i32 %add

if.then5:                                         ; preds = %merge
  ret i32 1
  br label %merge1
}

define i32 @main() {
mainEntry:
  %f = call i32 @f(i32 8)
  ret i32 %f
}
