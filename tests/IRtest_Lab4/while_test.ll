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
  %to_bool = icmp ne i32 %load_lval, 0
  %cmp = icmp slt i1 %to_bool, true
  br label %while.cond

cur:                                              ; preds = %cur1, %while.cond
  %load_lval15 = load i32, i32* %param0_addr, align 4
  %add16 = add i32 %load_lval15, 1
  store i32 %add16, i32* %param0_addr, align 4
  %load_lval18 = load i32, i32* %param0_addr, align 4
  %g = call i32 @g(i32 %load_lval18)
  %not = icmp eq i32 %g, 0
  %zext_to_i32 = zext i1 %not to i32
  %to_bool19 = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool19, label %if.then20, label %merge17

while.stmt:                                       ; preds = %while.cond
  %load_lval2 = load i32, i32* @a, align 4
  %to_bool3 = icmp ne i32 %load_lval2, 0
  %cmp4 = icmp slt i1 %to_bool3, true
  br label %while.cond6

while.cond:                                       ; preds = %cur1, %mainEntry
  br i1 %cmp, label %while.stmt, label %cur

cur1:                                             ; preds = %merge, %while.cond6
  br label %cur
  br label %while.cond

while.stmt5:                                      ; preds = %while.cond6
  %load_lval7 = load i32, i32* @a, align 4
  %to_bool8 = icmp ne i32 %load_lval7, 0
  %cmp9 = icmp eq i1 %to_bool8, true
  br i1 %cmp9, label %if.then, label %merge

while.cond6:                                      ; preds = %merge, %if.then, %while.stmt
  br i1 %cmp4, label %while.stmt5, label %cur1

merge:                                            ; preds = %if.then, %while.stmt5
  %load_lval10 = load i32, i32* @a, align 4
  %add = add i32 %load_lval10, 1
  store i32 %add, i32* @a, align 4
  %load_lval11 = load i32, i32* @a, align 4
  %add12 = add i32 %load_lval11, 1
  store i32 %add12, i32* %b, align 4
  %load_lval13 = load i32, i32* %b, align 4
  %add14 = add i32 %load_lval13, 1
  store i32 %add14, i32* @a, align 4
  br label %cur1
  br label %while.cond6

if.then:                                          ; preds = %while.stmt5
  br label %while.cond6
  br label %merge

merge17:                                          ; preds = %if.then20, %cur
  %load_lval23 = load i32, i32* %param0_addr, align 4
  ret i32 %load_lval23

if.then20:                                        ; preds = %cur
  %load_lval21 = load i32, i32* %param0_addr, align 4
  %add22 = add i32 %load_lval21, 2
  ret i32 %add22
  br label %merge17
}
