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
  %load_lval39 = load i32, i32* %sum, align 4
  %sub40 = sub i32 %load_lval39, 10
  %add41 = add i32 0, %sub40
  %add44 = add i32 %add41, 0
  ret i32 %add44

while.stmt:                                       ; preds = %while.cond
  %load_lval16 = load i32, i32* %sum, align 4
  %load_lval17 = load i32, i32* %n, align 4
  %add18 = add i32 %load_lval16, %load_lval17
  store i32 %add18, i32* %sum, align 4
  %load_lval19 = load i32, i32* %n, align 4
  %add20 = add i32 %load_lval19, 1
  store i32 %add20, i32* %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval12 = load i32, i32* %n, align 4
  %cmp13 = icmp slt i32 %load_lval12, 5
  %zext_to_i3214 = zext i1 %cmp13 to i32
  %to_bool15 = icmp ne i32 %zext_to_i3214, 0
  br i1 %to_bool15, label %while.stmt, label %cur
}
