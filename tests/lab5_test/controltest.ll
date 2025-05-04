; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 0, i32* %x, align 4
  br label %while.cond

cur:                                              ; preds = %if.then, %while.cond
  %load_lval15 = load i32, i32* %x, align 4
  ret i32 %load_lval15

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %x, align 4
  %cmp2 = icmp eq i32 %load_lval1, 5
  %zext_to_i323 = zext i1 %cmp2 to i32
  %to_bool4 = icmp ne i32 %zext_to_i323, 0
  br i1 %to_bool4, label %if.then, label %if.else

while.cond:                                       ; preds = %merge, %mainEntry
  %load_lval = load i32, i32* %x, align 4
  %cmp = icmp slt i32 %load_lval, 10
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %merge5
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  br label %cur

if.else:                                          ; preds = %while.stmt
  %load_lval6 = load i32, i32* %x, align 4
  %cmp7 = icmp eq i32 %load_lval6, 3
  %zext_to_i328 = zext i1 %cmp7 to i32
  %to_bool11 = icmp ne i32 %zext_to_i328, 0
  br i1 %to_bool11, label %if.then9, label %if.else10

merge5:                                           ; preds = %if.else10, %if.then9
  br label %merge

if.then9:                                         ; preds = %if.else
  %load_lval12 = load i32, i32* %x, align 4
  %add = add i32 %load_lval12, 2
  store i32 %add, i32* %x, align 4
  br label %merge5

if.else10:                                        ; preds = %if.else
  %load_lval13 = load i32, i32* %x, align 4
  %add14 = add i32 %load_lval13, 1
  store i32 %add14, i32* %x, align 4
  br label %merge5
}
