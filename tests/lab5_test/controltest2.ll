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
  %load_lval15 = load i32, i32* %a, align 4
  store i32 %load_lval15, i32* %result, align 4
  %load_lval16 = load i32, i32* %result, align 4
  ret i32 %load_lval16

while.stmt:                                       ; preds = %while.cond
  %load_lval4 = load i32, i32* %a, align 4
  %load_lval5 = load i32, i32* %b, align 4
  %add6 = add i32 %load_lval5, 10
  %cmp7 = icmp sgt i32 %load_lval4, %add6
  %zext_to_i328 = zext i1 %cmp7 to i32
  %to_bool9 = icmp ne i32 %zext_to_i328, 0
  br i1 %to_bool9, label %if.then, label %if.else

while.cond:                                       ; preds = %merge, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %load_lval3 = load i32, i32* %a, align 4
  %add = add i32 %load_lval2, %load_lval3
  %cmp = icmp sgt i32 %add, 20
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %if.else, %if.then
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval10 = load i32, i32* %a, align 4
  %load_lval11 = load i32, i32* %b, align 4
  %sub = sub i32 %load_lval10, %load_lval11
  store i32 %sub, i32* %a, align 4
  br label %merge

if.else:                                          ; preds = %while.stmt
  %load_lval12 = load i32, i32* %b, align 4
  %load_lval13 = load i32, i32* %a, align 4
  %sub14 = sub i32 %load_lval12, %load_lval13
  store i32 %sub14, i32* %b, align 4
  br label %merge
}
