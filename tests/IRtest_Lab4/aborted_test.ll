; ModuleID = 'my_module'
source_filename = "my_module"

@y = global i32 0

define void @p() {
pEntry:
  %load_lval = load i32, i32* @y, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* @y, align 4
  ret void
}

define i32 @f(i32 %x, i32 %t) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %t, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %load_lval1 = load i32, i32* %param1_addr, align 4
  %add = add i32 %load_lval, %load_lval1
  %load_lval2 = load i32, i32* @y, align 4
  %add3 = add i32 %add, %load_lval2
  ret i32 %add3
}

define i32 @g(i32 %x, i32 %y, i32 %z) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %y, i32* %param1_addr, align 4
  %param2_addr = alloca i32, align 4
  store i32 %z, i32* %param2_addr, align 4
  %load_lval = load i32, i32* %param1_addr, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* %param1_addr, align 4
  %load_lval1 = load i32, i32* %param1_addr, align 4
  ret i32 %load_lval1
}

define i32 @main() {
mainEntry:
  %t = alloca i32, align 4
  store i32 100, i32* %t, align 4
  %x = alloca i32, align 4
  %load_lval = load i32, i32* %t, align 4
  %g = call i32 @g(i32 2, i32 4, i32 %load_lval)
  store i32 %g, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 100, i32* %y, align 4
  %z = alloca i32, align 4
  %load_lval1 = load i32, i32* %y, align 4
  %add = add i32 %load_lval1, 100
  store i32 %add, i32* %z, align 4
  %y2 = alloca i32, align 4
  store i32 100, i32* %y2, align 4
  %x3 = alloca i32, align 4
  store i32 5, i32* %x3, align 4
  br label %while.cond

cur:                                              ; preds = %merge, %while.cond
  %load_lval21 = load i32, i32* %x, align 4
  %load_lval22 = load i32, i32* %y2, align 4
  %add23 = add i32 %load_lval21, %load_lval22
  %add24 = add i32 %add23, 5
  store i32 %add24, i32* %x, align 4
  %load_lval25 = load i32, i32* %x, align 4
  ret i32 %load_lval25

while.stmt:                                       ; preds = %while.cond
  %load_lval5 = load i32, i32* %x3, align 4
  %add6 = add i32 %load_lval5, 5
  store i32 %add6, i32* %x3, align 4
  %load_lval7 = load i32, i32* %x3, align 4
  %cmp8 = icmp slt i32 %load_lval7, 100
  %zext_to_i329 = zext i1 %cmp8 to i32
  %to_bool10 = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool10, label %if.then, label %if.else

while.cond:                                       ; preds = %merge, %if.then17, %if.then, %mainEntry
  %load_lval4 = load i32, i32* %x3, align 4
  %cmp = icmp sgt i32 %load_lval4, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %merge13, %if.then
  br label %cur
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval11 = load i32, i32* %y2, align 4
  %add12 = add i32 %load_lval11, 1
  store i32 %add12, i32* %y2, align 4
  br label %while.cond
  br label %merge

if.else:                                          ; preds = %while.stmt
  %load_lval14 = load i32, i32* %x3, align 4
  %cmp15 = icmp slt i32 %load_lval14, 50
  %zext_to_i3216 = zext i1 %cmp15 to i32
  %to_bool18 = icmp ne i32 %zext_to_i3216, 0
  br i1 %to_bool18, label %if.then17, label %merge13

merge13:                                          ; preds = %if.then17, %if.else
  br label %merge

if.then17:                                        ; preds = %if.else
  %load_lval19 = load i32, i32* %y2, align 4
  %add20 = add i32 %load_lval19, 1
  store i32 %add20, i32* %y2, align 4
  br label %while.cond
  br label %merge13
}
