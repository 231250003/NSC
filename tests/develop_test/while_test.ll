; ModuleID = 'my_module'
source_filename = "my_module"

@e = global [10 x [10 x i32]] zeroinitializer
@dis = global [15 x i32] zeroinitializer
@book = global [15 x i32] zeroinitializer

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 1, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 2, i32* %y, align 4
  br label %while.cond

cur:                                              ; preds = %if.then, %while.cond
  %load_lval24 = load i32, i32* %x, align 4
  %load_lval25 = load i32, i32* %y, align 4
  %add26 = add i32 %load_lval24, %load_lval25
  ret i32 %add26

while.stmt:                                       ; preds = %while.cond
  br label %while.cond3

while.cond:                                       ; preds = %merge, %mainEntry
  br i1 true, label %while.stmt, label %cur

cur1:                                             ; preds = %while.cond3
  %load_lval18 = load i32, i32* %x, align 4
  %add19 = add i32 %load_lval18, 2
  store i32 %add19, i32* %x, align 4
  %load_lval20 = load i32, i32* %x, align 4
  %cmp21 = icmp sgt i32 %load_lval20, 30
  %zext_to_i3222 = zext i1 %cmp21 to i32
  %to_bool23 = icmp ne i32 %zext_to_i3222, 0
  br i1 %to_bool23, label %if.then, label %merge

while.stmt2:                                      ; preds = %while.cond3
  %load_lval4 = load i32, i32* %x, align 4
  %add = add i32 %load_lval4, 1
  store i32 %add, i32* %x, align 4
  %load_lval5 = load i32, i32* %y, align 4
  store i32 %load_lval5, i32* %x, align 4
  br label %while.cond8

while.cond3:                                      ; preds = %cur6, %while.stmt
  %load_lval = load i32, i32* %x, align 4
  %cmp = icmp slt i32 %load_lval, 10
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt2, label %cur1

cur6:                                             ; preds = %while.cond8
  %load_lval16 = load i32, i32* %x, align 4
  %add17 = add i32 %load_lval16, 1
  store i32 %add17, i32* %x, align 4
  br label %while.cond3

while.stmt7:                                      ; preds = %while.cond8
  %load_lval13 = load i32, i32* %x, align 4
  %load_lval14 = load i32, i32* %y, align 4
  %add15 = add i32 %load_lval13, %load_lval14
  store i32 %add15, i32* %y, align 4
  br label %while.cond8

while.cond8:                                      ; preds = %while.stmt7, %while.stmt2
  %load_lval9 = load i32, i32* %y, align 4
  %cmp10 = icmp slt i32 %load_lval9, 20
  %zext_to_i3211 = zext i1 %cmp10 to i32
  %to_bool12 = icmp ne i32 %zext_to_i3211, 0
  br i1 %to_bool12, label %while.stmt7, label %cur6

merge:                                            ; preds = %cur1
  br label %while.cond

if.then:                                          ; preds = %cur1
  br label %cur
}
