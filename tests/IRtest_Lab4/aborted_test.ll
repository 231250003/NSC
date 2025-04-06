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

merge:                                            ; preds = %merge10, %mainEntry
  %load_lval19 = load i32, i32* %x, align 4
  ret i32 %load_lval19

if.then:                                          ; preds = %mainEntry
  %load_lval2 = load i32, i32* %x, align 4
  %cmp3 = icmp slt i32 %load_lval2, 6
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool6 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool6, label %if.then5, label %merge1

merge1:                                           ; preds = %if.then5, %if.then
  %load_lval11 = load i32, i32* %x, align 4
  %cmp12 = icmp sgt i32 %load_lval11, 7
  %zext_to_i3213 = zext i1 %cmp12 to i32
  %to_bool15 = icmp ne i32 %zext_to_i3213, 0
  br i1 %to_bool15, label %if.then14, label %if.else

if.then5:                                         ; preds = %if.then
  %load_lval7 = load i32, i32* %x, align 4
  %not = icmp eq i32 %load_lval7, 0
  %zext_to_i328 = zext i1 %not to i32
  %load_lval9 = load i32, i32* %x, align 4
  %add = add i32 %zext_to_i328, %load_lval9
  store i32 %add, i32* %x, align 4
  br label %merge1

merge10:                                          ; preds = %if.else, %if.then14
  br label %merge

if.then14:                                        ; preds = %merge1
  %load_lval16 = load i32, i32* %x, align 4
  %add17 = add i32 %load_lval16, 1
  store i32 %add17, i32* %x, align 4
  br label %merge10

if.else:                                          ; preds = %merge1
  %load_lval18 = load i32, i32* %x, align 4
  %sub = sub i32 %load_lval18, 1
  store i32 %sub, i32* %x, align 4
  br label %merge10
}
