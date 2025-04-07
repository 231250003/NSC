; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @g(i32 %x) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %add = add i32 %load_lval, 1
  ret i32 %add
}

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  %g = call i32 @g(i32 10)
  store i32 %g, i32* %x, align 4
  br label %while.cond

cur:                                              ; preds = %if.else42, %while.cond
  ret i32 1

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %x, align 4
  %add = add i32 %load_lval1, 1
  store i32 %add, i32* %x, align 4
  %load_lval2 = load i32, i32* %x, align 4
  %cmp3 = icmp sgt i32 %load_lval2, 30
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool5 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool5, label %if.then, <null operand!>

while.cond:                                       ; preds = %merge46, %mainEntry
  %load_lval = load i32, i32* %x, align 4
  %cmp = icmp slt i32 %load_lval, 100
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

if.then:                                          ; preds = %while.stmt
  br label %while.cond8

cur6:                                             ; preds = %if.else30, %while.cond8
  %load_lval35 = load i32, i32* %x, align 4
  %sub36 = sub i32 %load_lval35, 1
  store i32 %sub36, i32* %x, align 4
  %load_lval37 = load i32, i32* %x, align 4
  ret i32 %load_lval37
  %load_lval38 = load i32, i32* %x, align 4
  %cmp39 = icmp sgt i32 %load_lval38, 10
  %zext_to_i3240 = zext i1 %cmp39 to i32
  %to_bool43 = icmp ne i32 %zext_to_i3240, 0
  br i1 %to_bool43, label %if.then41, label %if.else42

while.stmt7:                                      ; preds = %while.cond8
  %load_lval13 = load i32, i32* %x, align 4
  %cmp14 = icmp sgt i32 %load_lval13, 20
  %zext_to_i3215 = zext i1 %cmp14 to i32
  %to_bool17 = icmp ne i32 %zext_to_i3215, 0
  br i1 %to_bool17, label %if.then16, label %if.else

while.cond8:                                      ; preds = %merge34, %merge, %if.then
  %load_lval9 = load i32, i32* %x, align 4
  %cmp10 = icmp sgt i32 %load_lval9, 10
  %zext_to_i3211 = zext i1 %cmp10 to i32
  %to_bool12 = icmp ne i32 %zext_to_i3211, 0
  br i1 %to_bool12, label %while.stmt7, label %cur6

if.then16:                                        ; preds = %while.stmt7
  %load_lval18 = load i32, i32* %x, align 4
  %cmp19 = icmp sgt i32 %load_lval18, 21
  %zext_to_i3220 = zext i1 %cmp19 to i32
  %to_bool22 = icmp ne i32 %zext_to_i3220, 0
  br i1 %to_bool22, label %if.then21, <null operand!>

if.else:                                          ; preds = %while.stmt7
  %load_lval26 = load i32, i32* %x, align 4
  %cmp27 = icmp sgt i32 %load_lval26, 25
  %zext_to_i3228 = zext i1 %cmp27 to i32
  %to_bool31 = icmp ne i32 %zext_to_i3228, 0
  br i1 %to_bool31, label %if.then29, label %if.else30

if.then21:                                        ; preds = %if.then16
  %load_lval23 = load i32, i32* %x, align 4
  %sub = sub i32 %load_lval23, 5
  store i32 %sub, i32* %x, align 4
  br label %merge

merge:                                            ; preds = %if.then21
  %load_lval24 = load i32, i32* %x, align 4
  %sub25 = sub i32 %load_lval24, 1
  store i32 %sub25, i32* %x, align 4
  br label %while.cond8

if.then29:                                        ; preds = %if.else
  %load_lval32 = load i32, i32* %x, align 4
  %add33 = add i32 %load_lval32, 1
  store i32 %add33, i32* %x, align 4
  br label %merge34

if.else30:                                        ; preds = %if.else
  br label %cur6

merge34:                                          ; preds = %if.then29
  br label %while.cond8

if.then41:                                        ; preds = %cur6
  %load_lval44 = load i32, i32* %x, align 4
  %add45 = add i32 %load_lval44, 5
  store i32 %add45, i32* %x, align 4
  br label %merge46

if.else42:                                        ; preds = %cur6
  br label %cur

merge46:                                          ; preds = %if.then41
  br label %while.cond
}
