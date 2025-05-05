; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 0, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 0, i32* %y, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval18 = load i32, i32* %y, align 4
  ret i32 %load_lval18

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %x, align 4
  %cmp2 = icmp eq i32 %load_lval1, 2
  %zext_to_i323 = zext i1 %cmp2 to i32
  %to_bool4 = icmp ne i32 %zext_to_i323, 0
  br i1 %to_bool4, label %if.then, label %if.else

while.cond:                                       ; preds = %merge, %mainEntry
  %load_lval = load i32, i32* %x, align 4
  %cmp = icmp slt i32 %load_lval, 8
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %merge6, %if.then
  %load_lval16 = load i32, i32* %x, align 4
  %add17 = add i32 %load_lval16, 1
  store i32 %add17, i32* %x, align 4
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval5 = load i32, i32* %y, align 4
  %add = add i32 %load_lval5, 3
  store i32 %add, i32* %y, align 4
  br label %merge

if.else:                                          ; preds = %while.stmt
  %load_lval7 = load i32, i32* %x, align 4
  %cmp8 = icmp eq i32 %load_lval7, 4
  %zext_to_i329 = zext i1 %cmp8 to i32
  %to_bool12 = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool12, label %if.then10, label %if.else11

merge6:                                           ; preds = %if.else11, %if.then10
  br label %merge

if.then10:                                        ; preds = %if.else
  %load_lval13 = load i32, i32* %y, align 4
  %sub = sub i32 %load_lval13, 1
  store i32 %sub, i32* %y, align 4
  br label %merge6

if.else11:                                        ; preds = %if.else
  %load_lval14 = load i32, i32* %y, align 4
  %add15 = add i32 %load_lval14, 1
  store i32 %add15, i32* %y, align 4
  br label %merge6
}
