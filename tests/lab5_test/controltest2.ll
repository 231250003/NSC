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
  %load_lval39 = load i32, i32* %a, align 4
  store i32 %load_lval39, i32* %result, align 4
  %load_lval40 = load i32, i32* %result, align 4
  ret i32 %load_lval40

while.stmt:                                       ; preds = %while.cond
  %load_lval4 = load i32, i32* %a, align 4
  %to_bool5 = icmp ne i32 %load_lval4, 0
  br i1 %to_bool5, label %if.then, label %merge

while.cond:                                       ; preds = %merge6, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %load_lval3 = load i32, i32* %a, align 4
  %add = add i32 %load_lval2, %load_lval3
  %cmp = icmp sgt i32 %add, 20
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %while.stmt
  %load_lval7 = load i32, i32* %a, align 4
  %load_lval8 = load i32, i32* %b, align 4
  %add9 = add i32 %load_lval8, 10
  %cmp10 = icmp slt i32 %load_lval7, %add9
  %zext_to_i3211 = zext i1 %cmp10 to i32
  %to_bool13 = icmp ne i32 %zext_to_i3211, 0
  br i1 %to_bool13, label %if.then12, label %if.else

if.then:                                          ; preds = %while.stmt
  ret i32 100

merge6:                                           ; preds = %if.else, %merge14
  br label %while.cond

if.then12:                                        ; preds = %merge
  %load_lval15 = load i32, i32* %a, align 4
  %load_lval16 = load i32, i32* %b, align 4
  %add17 = add i32 %load_lval15, %load_lval16
  %cmp18 = icmp sgt i32 %add17, 50
  %zext_to_i3219 = zext i1 %cmp18 to i32
  %to_bool22 = icmp ne i32 %zext_to_i3219, 0
  br i1 %to_bool22, label %if.then20, label %if.else21

if.else:                                          ; preds = %merge
  %load_lval36 = load i32, i32* %b, align 4
  %load_lval37 = load i32, i32* %a, align 4
  %sub38 = sub i32 %load_lval36, %load_lval37
  store i32 %sub38, i32* %b, align 4
  br label %merge6

merge14:                                          ; preds = %merge25, %if.then20
  br label %merge6

if.then20:                                        ; preds = %if.then12
  %load_lval23 = load i32, i32* %a, align 4
  %load_lval24 = load i32, i32* %b, align 4
  %sub = sub i32 %load_lval23, %load_lval24
  store i32 %sub, i32* %a, align 4
  br label %merge14

if.else21:                                        ; preds = %if.then12
  %load_lval26 = load i32, i32* %a, align 4
  %cmp27 = icmp sgt i32 %load_lval26, 10
  %zext_to_i3228 = zext i1 %cmp27 to i32
  %to_bool31 = icmp ne i32 %zext_to_i3228, 0
  br i1 %to_bool31, label %if.then29, label %if.else30

merge25:                                          ; preds = %if.else30, %if.then29
  br label %merge14

if.then29:                                        ; preds = %if.else21
  %load_lval32 = load i32, i32* %a, align 4
  %sub33 = sub i32 %load_lval32, 20
  store i32 %sub33, i32* %a, align 4
  br label %merge25

if.else30:                                        ; preds = %if.else21
  %load_lval34 = load i32, i32* %b, align 4
  %sub35 = sub i32 %load_lval34, 5
  store i32 %sub35, i32* %b, align 4
  br label %merge25
}
