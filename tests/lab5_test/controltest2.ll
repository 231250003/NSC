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
  %load_lval26 = load i32, i32* %a, align 4
  store i32 %load_lval26, i32* %result, align 4
  %load_lval27 = load i32, i32* %result, align 4
  ret i32 %load_lval27

while.stmt:                                       ; preds = %while.cond
  br label %while.cond6

while.cond:                                       ; preds = %merge16, %if.then20, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %load_lval3 = load i32, i32* %a, align 4
  %add = add i32 %load_lval2, %load_lval3
  %cmp = icmp sgt i32 %add, 20
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

cur4:                                             ; preds = %if.else, %if.then, %while.cond6
  %load_lval17 = load i32, i32* %b, align 4
  %cmp18 = icmp sgt i32 %load_lval17, 70
  %zext_to_i3219 = zext i1 %cmp18 to i32
  %to_bool21 = icmp ne i32 %zext_to_i3219, 0
  br i1 %to_bool21, label %if.then20, label %merge16

while.stmt5:                                      ; preds = %while.cond6
  %load_lval11 = load i32, i32* %a, align 4
  %cmp12 = icmp sgt i32 %load_lval11, 40
  %zext_to_i3213 = zext i1 %cmp12 to i32
  %to_bool14 = icmp ne i32 %zext_to_i3213, 0
  br i1 %to_bool14, label %if.then, label %if.else

while.cond6:                                      ; preds = %merge, %while.stmt
  %load_lval7 = load i32, i32* %a, align 4
  %cmp8 = icmp sgt i32 %load_lval7, 10
  %zext_to_i329 = zext i1 %cmp8 to i32
  %to_bool10 = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool10, label %while.stmt5, label %cur4

merge:                                            ; No predecessors!
  br label %while.cond6

if.then:                                          ; preds = %while.stmt5
  %load_lval15 = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval15, 5
  store i32 %sub, i32* %a, align 4
  br label %cur4

if.else:                                          ; preds = %while.stmt5
  br label %cur4

merge16:                                          ; preds = %cur4
  %load_lval24 = load i32, i32* %b, align 4
  %sub25 = sub i32 %load_lval24, 10
  store i32 %sub25, i32* %b, align 4
  br label %while.cond

if.then20:                                        ; preds = %cur4
  %load_lval22 = load i32, i32* %b, align 4
  %sub23 = sub i32 %load_lval22, 5
  store i32 %sub23, i32* %b, align 4
  br label %while.cond
}
