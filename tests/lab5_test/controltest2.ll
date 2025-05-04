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
  %add6 = add i32 %load_lval4, %load_lval5
  %not = icmp eq i32 %add6, 0
  %zext_to_i327 = zext i1 %not to i32
  %to_bool8 = icmp ne i32 %zext_to_i327, 0
  br i1 %to_bool8, label %if.then, label %merge

while.cond:                                       ; preds = %merge9, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %load_lval3 = load i32, i32* %a, align 4
  %add = add i32 %load_lval2, %load_lval3
  %cmp = icmp sgt i32 %add, 20
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %while.stmt
  %load_lval10 = load i32, i32* %a, align 4
  %load_lval11 = load i32, i32* %b, align 4
  %add12 = add i32 %load_lval11, 10
  %cmp13 = icmp slt i32 %load_lval10, %add12
  %zext_to_i3214 = zext i1 %cmp13 to i32
  %to_bool16 = icmp ne i32 %zext_to_i3214, 0
  br i1 %to_bool16, label %if.then15, label %if.else

if.then:                                          ; preds = %while.stmt
  ret i32 100

merge9:                                           ; preds = %if.else, %merge17
  br label %while.cond

if.then15:                                        ; preds = %merge
  %load_lval18 = load i32, i32* %a, align 4
  %load_lval19 = load i32, i32* %b, align 4
  %add20 = add i32 %load_lval18, %load_lval19
  %cmp21 = icmp sgt i32 %add20, 50
  %zext_to_i3222 = zext i1 %cmp21 to i32
  %to_bool25 = icmp ne i32 %zext_to_i3222, 0
  br i1 %to_bool25, label %if.then23, label %if.else24

if.else:                                          ; preds = %merge
  %load_lval39 = load i32, i32* %b, align 4
  %load_lval40 = load i32, i32* %a, align 4
  %sub41 = sub i32 %load_lval39, %load_lval40
  store i32 %sub41, i32* %b, align 4
  br label %merge9

merge17:                                          ; preds = %merge28, %if.then23
  br label %merge9

if.then23:                                        ; preds = %if.then15
  %load_lval26 = load i32, i32* %a, align 4
  %load_lval27 = load i32, i32* %b, align 4
  %sub = sub i32 %load_lval26, %load_lval27
  store i32 %sub, i32* %a, align 4
  br label %merge17

if.else24:                                        ; preds = %if.then15
  %load_lval29 = load i32, i32* %a, align 4
  %cmp30 = icmp sgt i32 %load_lval29, 10
  %zext_to_i3231 = zext i1 %cmp30 to i32
  %to_bool34 = icmp ne i32 %zext_to_i3231, 0
  br i1 %to_bool34, label %if.then32, label %if.else33

merge28:                                          ; preds = %if.else33, %if.then32
  br label %merge17

if.then32:                                        ; preds = %if.else24
  %load_lval35 = load i32, i32* %a, align 4
  %sub36 = sub i32 %load_lval35, 20
  store i32 %sub36, i32* %a, align 4
  br label %merge28

if.else33:                                        ; preds = %if.else24
  %load_lval37 = load i32, i32* %b, align 4
  %sub38 = sub i32 %load_lval37, 5
  store i32 %sub38, i32* %b, align 4
  br label %merge28
}
