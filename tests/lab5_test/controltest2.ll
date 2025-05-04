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
  %load_lval35 = load i32, i32* %a, align 4
  store i32 %load_lval35, i32* %result, align 4
  %load_lval36 = load i32, i32* %result, align 4
  ret i32 %load_lval36

while.stmt:                                       ; preds = %while.cond
  %load_lval4 = load i32, i32* %a, align 4
  %load_lval5 = load i32, i32* %b, align 4
  %add6 = add i32 %load_lval5, 10
  %cmp7 = icmp slt i32 %load_lval4, %add6
  %zext_to_i328 = zext i1 %cmp7 to i32
  %to_bool9 = icmp ne i32 %zext_to_i328, 0
  br i1 %to_bool9, label %if.then, label %if.else

while.cond:                                       ; preds = %merge, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %load_lval3 = load i32, i32* %a, align 4
  %add = add i32 %load_lval2, %load_lval3
  %cmp = icmp sgt i32 %add, 20
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %if.else, %merge10
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval11 = load i32, i32* %a, align 4
  %load_lval12 = load i32, i32* %b, align 4
  %add13 = add i32 %load_lval11, %load_lval12
  %cmp14 = icmp sgt i32 %add13, 50
  %zext_to_i3215 = zext i1 %cmp14 to i32
  %to_bool18 = icmp ne i32 %zext_to_i3215, 0
  br i1 %to_bool18, label %if.then16, label %if.else17

if.else:                                          ; preds = %while.stmt
  %load_lval32 = load i32, i32* %b, align 4
  %load_lval33 = load i32, i32* %a, align 4
  %sub34 = sub i32 %load_lval32, %load_lval33
  store i32 %sub34, i32* %b, align 4
  br label %merge

merge10:                                          ; preds = %merge21, %if.then16
  br label %merge

if.then16:                                        ; preds = %if.then
  %load_lval19 = load i32, i32* %a, align 4
  %load_lval20 = load i32, i32* %b, align 4
  %sub = sub i32 %load_lval19, %load_lval20
  store i32 %sub, i32* %a, align 4
  br label %merge10

if.else17:                                        ; preds = %if.then
  %load_lval22 = load i32, i32* %a, align 4
  %cmp23 = icmp sgt i32 %load_lval22, 10
  %zext_to_i3224 = zext i1 %cmp23 to i32
  %to_bool27 = icmp ne i32 %zext_to_i3224, 0
  br i1 %to_bool27, label %if.then25, label %if.else26

merge21:                                          ; preds = %if.else26, %if.then25
  br label %merge10

if.then25:                                        ; preds = %if.else17
  %load_lval28 = load i32, i32* %a, align 4
  %sub29 = sub i32 %load_lval28, 20
  store i32 %sub29, i32* %a, align 4
  br label %merge21

if.else26:                                        ; preds = %if.else17
  %load_lval30 = load i32, i32* %b, align 4
  %sub31 = sub i32 %load_lval30, 5
  store i32 %sub31, i32* %b, align 4
  br label %merge21
}
