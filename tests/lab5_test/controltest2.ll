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
  %load_lval74 = load i32, i32* %a, align 4
  store i32 %load_lval74, i32* %result, align 4
  %load_lval75 = load i32, i32* %result, align 4
  ret i32 %load_lval75

while.stmt:                                       ; preds = %while.cond
  %load_lval4 = load i32, i32* %a, align 4
  %cmp5 = icmp ne i32 %load_lval4, 56
  %zext_to_i326 = zext i1 %cmp5 to i32
  %to_bool7 = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool7, label %if.then, label %if.else

while.cond:                                       ; preds = %merge64, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %load_lval3 = load i32, i32* %a, align 4
  %add = add i32 %load_lval2, %load_lval3
  %cmp = icmp sgt i32 %add, 20
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; No predecessors!
  br label %while.cond13

if.then:                                          ; preds = %while.stmt
  ret i32 1

if.else:                                          ; preds = %while.stmt
  %load_lval8 = load i32, i32* %a, align 4
  %load_lval9 = load i32, i32* %b, align 4
  %add10 = add i32 %load_lval8, %load_lval9
  ret i32 %add10

cur11:                                            ; preds = %if.else23, %if.then22, %while.cond13
  br label %while.cond28

while.stmt12:                                     ; preds = %while.cond13
  %load_lval19 = load i32, i32* %a, align 4
  %cmp20 = icmp sgt i32 %load_lval19, 40
  %zext_to_i3221 = zext i1 %cmp20 to i32
  %to_bool24 = icmp ne i32 %zext_to_i3221, 0
  br i1 %to_bool24, label %if.then22, label %if.else23

while.cond13:                                     ; preds = %merge18, %merge
  %load_lval14 = load i32, i32* %a, align 4
  %cmp15 = icmp sgt i32 %load_lval14, 10
  %zext_to_i3216 = zext i1 %cmp15 to i32
  %to_bool17 = icmp ne i32 %zext_to_i3216, 0
  br i1 %to_bool17, label %while.stmt12, label %cur11

merge18:                                          ; No predecessors!
  br label %while.cond13

if.then22:                                        ; preds = %while.stmt12
  %load_lval25 = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval25, 5
  store i32 %sub, i32* %a, align 4
  br label %cur11

if.else23:                                        ; preds = %while.stmt12
  br label %cur11

cur26:                                            ; preds = %while.cond28
  %load_lval60 = load i32, i32* %b, align 4
  %sub61 = sub i32 %load_lval60, 3
  store i32 %sub61, i32* %b, align 4
  %load_lval62 = load i32, i32* %a, align 4
  %add63 = add i32 %load_lval62, 1
  store i32 %add63, i32* %a, align 4
  %load_lval65 = load i32, i32* %a, align 4
  %load_lval66 = load i32, i32* %b, align 4
  %add67 = add i32 %load_lval65, %load_lval66
  %cmp68 = icmp sgt i32 %add67, 50
  %zext_to_i3269 = zext i1 %cmp68 to i32
  %to_bool71 = icmp ne i32 %zext_to_i3269, 0
  br i1 %to_bool71, label %if.then70, label %merge64

while.stmt27:                                     ; preds = %while.cond28
  %load_lval34 = load i32, i32* %b, align 4
  %cmp35 = icmp sgt i32 %load_lval34, 70
  %zext_to_i3236 = zext i1 %cmp35 to i32
  %to_bool39 = icmp ne i32 %zext_to_i3236, 0
  br i1 %to_bool39, label %if.then37, label %if.else38

while.cond28:                                     ; preds = %merge33, %if.then37, %cur11
  %load_lval29 = load i32, i32* %b, align 4
  %cmp30 = icmp sgt i32 %load_lval29, 35
  %zext_to_i3231 = zext i1 %cmp30 to i32
  %to_bool32 = icmp ne i32 %zext_to_i3231, 0
  br i1 %to_bool32, label %while.stmt27, label %cur26

merge33:                                          ; preds = %merge42
  br label %while.cond28

if.then37:                                        ; preds = %while.stmt27
  %load_lval40 = load i32, i32* %b, align 4
  %sub41 = sub i32 %load_lval40, 5
  store i32 %sub41, i32* %b, align 4
  br label %while.cond28

if.else38:                                        ; preds = %while.stmt27
  %load_lval43 = load i32, i32* %b, align 4
  %cmp44 = icmp sgt i32 %load_lval43, 50
  %zext_to_i3245 = zext i1 %cmp44 to i32
  %to_bool48 = icmp ne i32 %zext_to_i3245, 0
  br i1 %to_bool48, label %if.then46, label %if.else47

merge42:                                          ; preds = %merge51, %if.then46
  br label %merge33

if.then46:                                        ; preds = %if.else38
  %load_lval49 = load i32, i32* %b, align 4
  %sub50 = sub i32 %load_lval49, 7
  store i32 %sub50, i32* %b, align 4
  br label %merge42

if.else47:                                        ; preds = %if.else38
  %load_lval52 = load i32, i32* %b, align 4
  %cmp53 = icmp sgt i32 %load_lval52, 30
  %zext_to_i3254 = zext i1 %cmp53 to i32
  %to_bool57 = icmp ne i32 %zext_to_i3254, 0
  br i1 %to_bool57, label %if.then55, label %if.else56

merge51:                                          ; preds = %if.then55
  br label %merge42

if.then55:                                        ; preds = %if.else47
  %load_lval58 = load i32, i32* %b, align 4
  %sub59 = sub i32 %load_lval58, 1
  store i32 %sub59, i32* %b, align 4
  br label %merge51

if.else56:                                        ; preds = %if.else47
  ret i32 10

merge64:                                          ; preds = %if.then70, %cur26
  br label %while.cond

if.then70:                                        ; preds = %cur26
  %load_lval72 = load i32, i32* %a, align 4
  %sub73 = sub i32 %load_lval72, 10
  store i32 %sub73, i32* %a, align 4
  br label %merge64
}
