; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 1

define i32 @main(i32 %x) {
mainEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %b = alloca i32, align 4
  store i32 0, i32* %b, align 4
  %load_lval = load i32, i32* @a, align 4
  %cmp = icmp slt i32 %load_lval, 9
  br label %while.cond

cur:                                              ; preds = %cur1, %while.cond
  %load_lval13 = load i32, i32* %param0_addr, align 4
  %add14 = add i32 %load_lval13, 1
  store i32 %add14, i32* %param0_addr, align 4
  %load_lval15 = load i32, i32* %param0_addr, align 4
  ret i32 %load_lval15

while.stmt:                                       ; preds = %while.cond
  %load_lval2 = load i32, i32* @a, align 4
  %cmp3 = icmp slt i32 %load_lval2, 10
  br label %while.cond5

while.cond:                                       ; preds = %cur1, %mainEntry
  br i1 %cmp, label %while.stmt, label %cur

cur1:                                             ; preds = %merge, %while.cond5
  br label %cur
  br label %while.cond

while.stmt4:                                      ; preds = %while.cond5
  %load_lval6 = load i32, i32* @a, align 4
  %cmp7 = icmp eq i32 %load_lval6, 77
  br i1 %cmp7, label %if.then, label %merge

while.cond5:                                      ; preds = %merge, %if.then, %while.stmt
  br i1 %cmp3, label %while.stmt4, label %cur1

merge:                                            ; preds = %if.then, %while.stmt4
  %load_lval8 = load i32, i32* @a, align 4
  %add = add i32 %load_lval8, 1
  store i32 %add, i32* @a, align 4
  %load_lval9 = load i32, i32* @a, align 4
  %add10 = add i32 %load_lval9, 1
  store i32 %add10, i32* %b, align 4
  %load_lval11 = load i32, i32* %b, align 4
  %add12 = add i32 %load_lval11, 1
  store i32 %add12, i32* @a, align 4
  br label %cur1
  br label %while.cond5

if.then:                                          ; preds = %while.stmt4
  br label %while.cond5
  br label %merge
}
