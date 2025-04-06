; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 1

define i32 @g(i32 %x) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %load_lval1 = load i32, i32* %param0_addr, align 4
  %not = icmp eq i32 %load_lval1, 0
  %zext_to_i32 = zext i1 %not to i32
  %add = add i32 %load_lval, %zext_to_i32
  ret i32 %add
}

define i32 @main(i32 %x) {
mainEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %b = alloca i32, align 4
  store i32 0, i32* %b, align 4
  %load_lval = load i32, i32* @a, align 4
  %cmp = icmp slt i32 %load_lval, 9
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br label %while.cond

cur:                                              ; preds = %cur1, %while.cond
  %load_lval17 = load i32, i32* %param0_addr, align 4
  %add18 = add i32 %load_lval17, 1
  store i32 %add18, i32* %param0_addr, align 4
  %load_lval20 = load i32, i32* %param0_addr, align 4
  %g = call i32 @g(i32 %load_lval20)
  %not = icmp eq i32 %g, 0
  %zext_to_i3221 = zext i1 %not to i32
  %to_bool23 = icmp ne i32 %zext_to_i3221, 0
  br i1 %to_bool23, label %if.then22, label %merge19

while.stmt:                                       ; preds = %while.cond
  %load_lval2 = load i32, i32* @a, align 4
  %cmp3 = icmp slt i32 %load_lval2, 10
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool5 = icmp ne i32 %zext_to_i324, 0
  br label %while.cond7

while.cond:                                       ; preds = %cur1, %mainEntry
  br i1 %to_bool, label %while.stmt, label %cur

cur1:                                             ; preds = %merge, %while.cond7
  br label %cur
  br label %while.cond

while.stmt6:                                      ; preds = %while.cond7
  %load_lval8 = load i32, i32* @a, align 4
  %cmp9 = icmp eq i32 %load_lval8, 77
  %zext_to_i3210 = zext i1 %cmp9 to i32
  %to_bool11 = icmp ne i32 %zext_to_i3210, 0
  br i1 %to_bool11, label %if.then, label %merge

while.cond7:                                      ; preds = %merge, %if.then, %while.stmt
  br i1 %to_bool5, label %while.stmt6, label %cur1

merge:                                            ; preds = %if.then, %while.stmt6
  %load_lval12 = load i32, i32* @a, align 4
  %add = add i32 %load_lval12, 1
  store i32 %add, i32* @a, align 4
  %load_lval13 = load i32, i32* @a, align 4
  %add14 = add i32 %load_lval13, 1
  store i32 %add14, i32* %b, align 4
  %load_lval15 = load i32, i32* %b, align 4
  %add16 = add i32 %load_lval15, 1
  store i32 %add16, i32* @a, align 4
  br label %cur1
  br label %while.cond7

if.then:                                          ; preds = %while.stmt6
  br label %while.cond7
  br label %merge

merge19:                                          ; preds = %if.then22, %cur
  %load_lval26 = load i32, i32* %param0_addr, align 4
  ret i32 %load_lval26

if.then22:                                        ; preds = %cur
  %load_lval24 = load i32, i32* %param0_addr, align 4
  %add25 = add i32 %load_lval24, 2
  ret i32 %add25
  br label %merge19
}
