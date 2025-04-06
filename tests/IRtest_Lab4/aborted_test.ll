; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 5, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 100, i32* %y, align 4
  %load_lval = load i32, i32* %x, align 4
  %cmp = icmp sge i32 %load_lval, 5
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %merge16, %mainEntry
  %load_lval26 = load i32, i32* %x, align 4
  ret i32 %load_lval26

if.then:                                          ; preds = %mainEntry
  %load_lval2 = load i32, i32* %x, align 4
  %cmp3 = icmp slt i32 %load_lval2, 6
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool6 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool6, label %if.then5, label %merge1

merge1:                                           ; preds = %if.then5, %if.then
  %load_lval17 = load i32, i32* %x, align 4
  %cmp18 = icmp sgt i32 %load_lval17, 7
  %zext_to_i3219 = zext i1 %cmp18 to i32
  %to_bool21 = icmp ne i32 %zext_to_i3219, 0
  br i1 %to_bool21, label %if.then20, label %if.else

if.then5:                                         ; preds = %if.then
  %load_lval7 = load i32, i32* %x, align 4
  %not = icmp eq i32 %load_lval7, 0
  %zext_to_i328 = zext i1 %not to i32
  %load_lval9 = load i32, i32* %x, align 4
  %not10 = icmp eq i32 %load_lval9, 0
  %zext_to_i3211 = zext i1 %not10 to i32
  %add = add i32 %zext_to_i328, %zext_to_i3211
  %load_lval12 = load i32, i32* %x, align 4
  %not13 = icmp eq i32 %load_lval12, 0
  %zext_to_i3214 = zext i1 %not13 to i32
  %add15 = add i32 %add, %zext_to_i3214
  store i32 %add15, i32* %x, align 4
  br label %merge1

merge16:                                          ; preds = %if.else, %if.then20
  br label %merge

if.then20:                                        ; preds = %merge1
  %load_lval22 = load i32, i32* %x, align 4
  %add23 = add i32 %load_lval22, 1
  store i32 %add23, i32* %x, align 4
  br label %merge16

if.else:                                          ; preds = %merge1
  %load_lval24 = load i32, i32* %x, align 4
  %add25 = add i32 %load_lval24, 100
  store i32 %add25, i32* %x, align 4
  br label %merge16
}
