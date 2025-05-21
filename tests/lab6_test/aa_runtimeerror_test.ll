; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 3

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 0, i32* %num, align 4
  store i32 4, i32* @x, align 4
  %c = alloca i32, align 4
  store i32 2, i32* %c, align 4
  store i32 0, i32* %c, align 4
  store i32 1, i32* %c, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval27 = load i32, i32* %c, align 4
  %load_lval28 = load i32, i32* %num, align 4
  %add29 = add i32 %load_lval27, %load_lval28
  ret i32 %add29

while.stmt:                                       ; preds = %while.cond
  br label %while.cond12

while.cond:                                       ; preds = %cur10, %mainEntry
  %load_lval6 = load i32, i32* %num, align 4
  %cmp7 = icmp sle i32 %load_lval6, 10
  %zext_to_i328 = zext i1 %cmp7 to i32
  %to_bool9 = icmp ne i32 %zext_to_i328, 0
  br i1 %to_bool9, label %while.stmt, label %cur

cur10:                                            ; preds = %while.stmt11, %while.cond12
  %load_lval19 = load i32, i32* %num, align 4
  %add20 = add i32 %load_lval19, 1
  %load_lval21 = load i32, i32* @x, align 4
  %add22 = add i32 %add20, %load_lval21
  store i32 %add22, i32* %num, align 4
  %load_lval23 = load i32, i32* %c, align 4
  %add24 = add i32 %load_lval23, 1
  store i32 %add24, i32* %c, align 4
  %load_lval25 = load i32, i32* %c, align 4
  %add26 = add i32 %load_lval25, 2
  store i32 %add26, i32* %c, align 4
  br label %while.cond

while.stmt11:                                     ; preds = %while.cond12
  %load_lval17 = load i32, i32* @x, align 4
  %add18 = add i32 %load_lval17, 1
  store i32 %add18, i32* @x, align 4
  br label %cur10
  br label %while.cond12

while.cond12:                                     ; preds = %while.stmt11, %while.stmt
  %load_lval13 = load i32, i32* @x, align 4
  %cmp14 = icmp sle i32 %load_lval13, 4
  %zext_to_i3215 = zext i1 %cmp14 to i32
  %to_bool16 = icmp ne i32 %zext_to_i3215, 0
  br i1 %to_bool16, label %while.stmt11, label %cur10
}
