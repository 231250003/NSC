; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 56
@y = global i32 98

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  %load_lval = load i32, i32* @x, align 4
  store i32 %load_lval, i32* %a, align 4
  %b = alloca i32, align 4
  %load_lval1 = load i32, i32* @y, align 4
  store i32 %load_lval1, i32* %b, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %result = alloca i32, align 4
  %load_lval42 = load i32, i32* %a, align 4
  store i32 %load_lval42, i32* %result, align 4
  %load_lval43 = load i32, i32* %result, align 4
  ret i32 %load_lval43

while.stmt:                                       ; preds = %while.cond
  %load_lval4 = load i32, i32* %a, align 4
  %load_lval5 = load i32, i32* %b, align 4
  %add6 = add i32 %load_lval5, 10
  %cmp7 = icmp slt i32 %load_lval4, %add6
  %zext_to_i328 = zext i1 %cmp7 to i32
  %to_bool9 = icmp ne i32 %zext_to_i328, 0
  br i1 %to_bool9, label %if.then, label %if.else

while.cond:                                       ; preds = %merge, %if.then16, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %load_lval3 = load i32, i32* %a, align 4
  %add = add i32 %load_lval2, %load_lval3
  %cmp = icmp sgt i32 %add, 20
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %if.else, %merge28
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval11 = load i32, i32* %a, align 4
  %load_lval12 = load i32, i32* %b, align 4
  %add13 = add i32 %load_lval11, %load_lval12
  %cmp14 = icmp sgt i32 %add13, 50
  %zext_to_i3215 = zext i1 %cmp14 to i32
  %to_bool17 = icmp ne i32 %zext_to_i3215, 0
  br i1 %to_bool17, label %if.then16, label %merge10

if.else:                                          ; preds = %while.stmt
  %load_lval39 = load i32, i32* %b, align 4
  %load_lval40 = load i32, i32* %a, align 4
  %sub41 = sub i32 %load_lval39, %load_lval40
  store i32 %sub41, i32* %b, align 4
  br label %merge

merge10:                                          ; preds = %if.then
  %load_lval21 = load i32, i32* %b, align 4
  %cmp22 = icmp sgt i32 %load_lval21, 5
  %zext_to_i3223 = zext i1 %cmp22 to i32
  %to_bool25 = icmp ne i32 %zext_to_i3223, 0
  br i1 %to_bool25, label %if.then24, label %merge20

if.then16:                                        ; preds = %if.then
  %load_lval18 = load i32, i32* %a, align 4
  %load_lval19 = load i32, i32* %b, align 4
  %sub = sub i32 %load_lval18, %load_lval19
  store i32 %sub, i32* %a, align 4
  br label %while.cond

merge20:                                          ; preds = %if.then24, %merge10
  %load_lval29 = load i32, i32* %a, align 4
  %cmp30 = icmp sgt i32 %load_lval29, 10
  %zext_to_i3231 = zext i1 %cmp30 to i32
  %to_bool34 = icmp ne i32 %zext_to_i3231, 0
  br i1 %to_bool34, label %if.then32, label %if.else33

if.then24:                                        ; preds = %merge10
  %load_lval26 = load i32, i32* %b, align 4
  %add27 = add i32 %load_lval26, 1
  store i32 %add27, i32* %b, align 4
  br label %merge20

merge28:                                          ; preds = %if.else33, %if.then32
  br label %merge

if.then32:                                        ; preds = %merge20
  %load_lval35 = load i32, i32* %a, align 4
  %sub36 = sub i32 %load_lval35, 20
  store i32 %sub36, i32* %a, align 4
  br label %merge28

if.else33:                                        ; preds = %merge20
  %load_lval37 = load i32, i32* %b, align 4
  %sub38 = sub i32 %load_lval37, 5
  store i32 %sub38, i32* %b, align 4
  br label %merge28
}
