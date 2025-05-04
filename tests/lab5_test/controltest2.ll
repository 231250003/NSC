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
  %load_lval2 = load i32, i32* %a, align 4
  %cmp = icmp ne i32 %load_lval2, 56
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %mainEntry
  br label %while.cond

if.then:                                          ; preds = %mainEntry
  ret i32 -1

cur:                                              ; preds = %while.cond
  %result = alloca i32, align 4
  %load_lval81 = load i32, i32* %a, align 4
  store i32 %load_lval81, i32* %result, align 4
  %load_lval82 = load i32, i32* %result, align 4
  ret i32 %load_lval82

while.stmt:                                       ; preds = %while.cond
  %load_lval9 = load i32, i32* %a, align 4
  %cmp10 = icmp ne i32 %load_lval9, 56
  %zext_to_i3211 = zext i1 %cmp10 to i32
  %to_bool13 = icmp ne i32 %zext_to_i3211, 0
  br i1 %to_bool13, label %if.then12, label %if.else

while.cond:                                       ; preds = %merge71, %merge
  %load_lval3 = load i32, i32* %b, align 4
  %load_lval4 = load i32, i32* %a, align 4
  %add = add i32 %load_lval3, %load_lval4
  %cmp5 = icmp sgt i32 %add, 20
  %zext_to_i326 = zext i1 %cmp5 to i32
  %to_bool7 = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool7, label %while.stmt, label %cur

merge8:                                           ; No predecessors!
  br label %while.cond20

if.then12:                                        ; preds = %while.stmt
  ret i32 1

if.else:                                          ; preds = %while.stmt
  %load_lval14 = load i32, i32* %a, align 4
  %not = icmp eq i32 %load_lval14, 0
  %zext_to_i3215 = zext i1 %not to i32
  %load_lval16 = load i32, i32* %b, align 4
  %add17 = add i32 %zext_to_i3215, %load_lval16
  ret i32 %add17

cur18:                                            ; preds = %if.else30, %if.then29, %while.cond20
  br label %while.cond35

while.stmt19:                                     ; preds = %while.cond20
  %load_lval26 = load i32, i32* %a, align 4
  %cmp27 = icmp sgt i32 %load_lval26, 40
  %zext_to_i3228 = zext i1 %cmp27 to i32
  %to_bool31 = icmp ne i32 %zext_to_i3228, 0
  br i1 %to_bool31, label %if.then29, label %if.else30

while.cond20:                                     ; preds = %merge25, %merge8
  %load_lval21 = load i32, i32* %a, align 4
  %cmp22 = icmp sgt i32 %load_lval21, 10
  %zext_to_i3223 = zext i1 %cmp22 to i32
  %to_bool24 = icmp ne i32 %zext_to_i3223, 0
  br i1 %to_bool24, label %while.stmt19, label %cur18

merge25:                                          ; No predecessors!
  br label %while.cond20

if.then29:                                        ; preds = %while.stmt19
  %load_lval32 = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval32, 5
  store i32 %sub, i32* %a, align 4
  br label %cur18

if.else30:                                        ; preds = %while.stmt19
  br label %cur18

cur33:                                            ; preds = %while.cond35
  %load_lval67 = load i32, i32* %b, align 4
  %sub68 = sub i32 %load_lval67, 3
  store i32 %sub68, i32* %b, align 4
  %load_lval69 = load i32, i32* %a, align 4
  %add70 = add i32 %load_lval69, 1
  store i32 %add70, i32* %a, align 4
  %load_lval72 = load i32, i32* %a, align 4
  %load_lval73 = load i32, i32* %b, align 4
  %add74 = add i32 %load_lval72, %load_lval73
  %cmp75 = icmp sgt i32 %add74, 50
  %zext_to_i3276 = zext i1 %cmp75 to i32
  %to_bool78 = icmp ne i32 %zext_to_i3276, 0
  br i1 %to_bool78, label %if.then77, label %merge71

while.stmt34:                                     ; preds = %while.cond35
  %load_lval41 = load i32, i32* %b, align 4
  %cmp42 = icmp sgt i32 %load_lval41, 70
  %zext_to_i3243 = zext i1 %cmp42 to i32
  %to_bool46 = icmp ne i32 %zext_to_i3243, 0
  br i1 %to_bool46, label %if.then44, label %if.else45

while.cond35:                                     ; preds = %merge40, %if.then44, %cur18
  %load_lval36 = load i32, i32* %b, align 4
  %cmp37 = icmp sgt i32 %load_lval36, 35
  %zext_to_i3238 = zext i1 %cmp37 to i32
  %to_bool39 = icmp ne i32 %zext_to_i3238, 0
  br i1 %to_bool39, label %while.stmt34, label %cur33

merge40:                                          ; preds = %merge49
  br label %while.cond35

if.then44:                                        ; preds = %while.stmt34
  %load_lval47 = load i32, i32* %b, align 4
  %sub48 = sub i32 %load_lval47, 5
  store i32 %sub48, i32* %b, align 4
  br label %while.cond35

if.else45:                                        ; preds = %while.stmt34
  %load_lval50 = load i32, i32* %b, align 4
  %cmp51 = icmp sgt i32 %load_lval50, 50
  %zext_to_i3252 = zext i1 %cmp51 to i32
  %to_bool55 = icmp ne i32 %zext_to_i3252, 0
  br i1 %to_bool55, label %if.then53, label %if.else54

merge49:                                          ; preds = %merge58, %if.then53
  br label %merge40

if.then53:                                        ; preds = %if.else45
  %load_lval56 = load i32, i32* %b, align 4
  %sub57 = sub i32 %load_lval56, 7
  store i32 %sub57, i32* %b, align 4
  br label %merge49

if.else54:                                        ; preds = %if.else45
  %load_lval59 = load i32, i32* %b, align 4
  %cmp60 = icmp sgt i32 %load_lval59, 30
  %zext_to_i3261 = zext i1 %cmp60 to i32
  %to_bool64 = icmp ne i32 %zext_to_i3261, 0
  br i1 %to_bool64, label %if.then62, label %if.else63

merge58:                                          ; preds = %if.then62
  br label %merge49

if.then62:                                        ; preds = %if.else54
  %load_lval65 = load i32, i32* %b, align 4
  %sub66 = sub i32 %load_lval65, 1
  store i32 %sub66, i32* %b, align 4
  br label %merge58

if.else63:                                        ; preds = %if.else54
  ret i32 10

merge71:                                          ; preds = %if.then77, %cur33
  br label %while.cond

if.then77:                                        ; preds = %cur33
  %load_lval79 = load i32, i32* %a, align 4
  %sub80 = sub i32 %load_lval79, 10
  store i32 %sub80, i32* %a, align 4
  br label %merge71
}
