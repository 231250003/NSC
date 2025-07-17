; ModuleID = 'my_module'
source_filename = "my_module"

@g1 = global i32 1
@g2 = global i32 2

define i32 @main() {
mainEntry:
  br label %while.cond

cur:                                              ; preds = %while.cond
  ret i32 -1

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* @g2, align 4
  %cmp2 = icmp slt i32 %load_lval1, 1
  %zext_to_i323 = zext i1 %cmp2 to i32
  %to_bool4 = icmp ne i32 %zext_to_i323, 0
  br i1 %to_bool4, label %if.then, label %merge

while.cond:                                       ; preds = %merge, %mainEntry
  %load_lval = load i32, i32* @g1, align 4
  %cmp = icmp sgt i32 %load_lval, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %while.stmt
  %load_lval16 = load i32, i32* @g2, align 4
  %sub = sub i32 %load_lval16, 1
  store i32 %sub, i32* @g2, align 4
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval6 = load i32, i32* @g1, align 4
  %cmp7 = icmp sgt i32 %load_lval6, 1
  %zext_to_i328 = zext i1 %cmp7 to i32
  %to_bool10 = icmp ne i32 %zext_to_i328, 0
  br i1 %to_bool10, label %if.then9, label %merge5

merge5:                                           ; preds = %if.then
  %load_lval13 = load i32, i32* @g1, align 4
  %add14 = add i32 %load_lval13, 1
  store i32 %add14, i32* @g1, align 4
  %load_lval15 = load i32, i32* @g2, align 4
  ret i32 %load_lval15

if.then9:                                         ; preds = %if.then
  %load_lval11 = load i32, i32* @g2, align 4
  %add = add i32 %load_lval11, 1
  store i32 %add, i32* @g2, align 4
  %load_lval12 = load i32, i32* @g1, align 4
  ret i32 %load_lval12
}
