; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %n = alloca i32, align 4
  store i32 0, i32* %n, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval24 = load i32, i32* %sum, align 4
  %sub25 = sub i32 %load_lval24, 10
  %add26 = add i32 0, %sub25
  ret i32 %add26

while.stmt:                                       ; preds = %while.cond
  %load_lval11 = load i32, i32* %sum, align 4
  %load_lval12 = load i32, i32* %n, align 4
  %add13 = add i32 %load_lval11, %load_lval12
  store i32 %add13, i32* %sum, align 4
  %load_lval14 = load i32, i32* %n, align 4
  %add15 = add i32 %load_lval14, 1
  store i32 %add15, i32* %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval10 = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %load_lval10, 5
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
