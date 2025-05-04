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

cur:                                              ; preds = %if.then, %while.cond
  %result = alloca i32, align 4
  %load_lval41 = load i32, i32* %a, align 4
  store i32 %load_lval41, i32* %result, align 4
  %load_lval42 = load i32, i32* %result, align 4
  ret i32 %load_lval42

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
  br label %cur

merge9:                                           ; preds = %if.else, %merge27
  br label %while.cond

if.then15:                                        ; preds = %merge
  %load_lval18 = load i32, i32* %a, align 4
  %load_lval19 = load i32, i32* %b, align 4
  %add20 = add i32 %load_lval18, %load_lval19
  %cmp21 = icmp sgt i32 %add20, 50
  %zext_to_i3222 = zext i1 %cmp21 to i32
  %to_bool24 = icmp ne i32 %zext_to_i3222, 0
  br i1 %to_bool24, label %if.then23, label %merge17

if.else:                                          ; preds = %merge
  %load_lval38 = load i32, i32* %b, align 4
  %load_lval39 = load i32, i32* %a, align 4
  %sub40 = sub i32 %load_lval38, %load_lval39
  store i32 %sub40, i32* %b, align 4
  br label %merge9

merge17:                                          ; preds = %if.then23, %if.then15
  %load_lval28 = load i32, i32* %a, align 4
  %cmp29 = icmp sgt i32 %load_lval28, 10
  %zext_to_i3230 = zext i1 %cmp29 to i32
  %to_bool33 = icmp ne i32 %zext_to_i3230, 0
  br i1 %to_bool33, label %if.then31, label %if.else32

if.then23:                                        ; preds = %if.then15
  %load_lval25 = load i32, i32* %a, align 4
  %load_lval26 = load i32, i32* %b, align 4
  %sub = sub i32 %load_lval25, %load_lval26
  store i32 %sub, i32* %a, align 4
  br label %merge17

merge27:                                          ; preds = %if.else32, %if.then31
  br label %merge9

if.then31:                                        ; preds = %merge17
  %load_lval34 = load i32, i32* %a, align 4
  %sub35 = sub i32 %load_lval34, 20
  store i32 %sub35, i32* %a, align 4
  br label %merge27

if.else32:                                        ; preds = %merge17
  %load_lval36 = load i32, i32* %b, align 4
  %sub37 = sub i32 %load_lval36, 5
  store i32 %sub37, i32* %b, align 4
  br label %merge27
}
