; ModuleID = 'my_module'
source_filename = "my_module"

@g1 = global i32 1
@g2 = global i32 2

define i32 @main() {
mainEntry:
  br label %while.stmt

while.stmt:                                       ; preds = %merge, %mainEntry
  %load_lval1 = load i32, i32* @g2, align 4
  %cmp2 = icmp slt i32 %load_lval1, 1
  %zext_to_i323 = zext i1 %cmp2 to i32
  %to_bool4 = icmp ne i32 %zext_to_i323, 0
  br i1 %to_bool4, label %merge5, label %merge

merge:                                            ; preds = %while.stmt
  %load_lval16 = load i32, i32* @g2, align 4
  %sub = sub i32 %load_lval16, 1
  store i32 %sub, i32* @g2, align 4
  br label %while.stmt

merge5:                                           ; preds = %while.stmt
  %load_lval15 = load i32, i32* @g2, align 4
  ret i32 %load_lval15
}
