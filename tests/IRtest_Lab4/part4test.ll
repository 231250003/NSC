; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 10

define i32 @main() {
mainEntry:
  %b = alloca i32, align 4
  store i32 2, i32* %b, align 4
  %c = alloca i32, align 4
  store i32 3, i32* %c, align 4
  %load_lval = load i32, i32* @a, align 4
  %load_lval1 = load i32, i32* %b, align 4
  %cmp = icmp sgt i32 %load_lval, %load_lval1
  br i1 %cmp, label %if.then, label %merge

merge:                                            ; preds = %merge2, %mainEntry
  %load_lval10 = load i32, i32* @a, align 4
  ret i32 %load_lval10

if.then:                                          ; preds = %mainEntry
  %load_lval3 = load i32, i32* %b, align 4
  %load_lval4 = load i32, i32* %c, align 4
  %cmp5 = icmp sgt i32 %load_lval3, %load_lval4
  br i1 %cmp5, label %if.then6, label %merge2

merge2:                                           ; preds = %if.then6, %if.then
  %load_lval8 = load i32, i32* @a, align 4
  %add9 = add i32 %load_lval8, 1
  store i32 %add9, i32* @a, align 4
  br label %merge

if.then6:                                         ; preds = %if.then
  %load_lval7 = load i32, i32* @a, align 4
  %add = add i32 %load_lval7, 1
  store i32 %add, i32* @a, align 4
  br label %merge2
}
