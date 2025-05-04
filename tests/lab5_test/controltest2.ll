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
  %load_lval47 = load i32, i32* %a, align 4
  store i32 %load_lval47, i32* %result, align 4
  %load_lval48 = load i32, i32* %result, align 4
  ret i32 %load_lval48

while.stmt:                                       ; preds = %while.cond
  br label %while.cond6

while.cond:                                       ; preds = %merge37, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %load_lval3 = load i32, i32* %a, align 4
  %add = add i32 %load_lval2, %load_lval3
  %cmp = icmp sgt i32 %add, 20
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

cur4:                                             ; preds = %if.else, %if.then, %while.cond6
  br label %while.cond18

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

cur16:                                            ; preds = %while.cond18
  %load_lval33 = load i32, i32* %b, align 4
  %sub34 = sub i32 %load_lval33, 3
  store i32 %sub34, i32* %b, align 4
  %load_lval35 = load i32, i32* %a, align 4
  %add36 = add i32 %load_lval35, 1
  store i32 %add36, i32* %a, align 4
  %load_lval38 = load i32, i32* %a, align 4
  %load_lval39 = load i32, i32* %b, align 4
  %add40 = add i32 %load_lval38, %load_lval39
  %cmp41 = icmp sgt i32 %add40, 50
  %zext_to_i3242 = zext i1 %cmp41 to i32
  %to_bool44 = icmp ne i32 %zext_to_i3242, 0
  br i1 %to_bool44, label %if.then43, label %merge37

while.stmt17:                                     ; preds = %while.cond18
  %load_lval24 = load i32, i32* %b, align 4
  %cmp25 = icmp sgt i32 %load_lval24, 70
  %zext_to_i3226 = zext i1 %cmp25 to i32
  %to_bool28 = icmp ne i32 %zext_to_i3226, 0
  br i1 %to_bool28, label %if.then27, label %merge23

while.cond18:                                     ; preds = %merge23, %if.then27, %cur4
  %load_lval19 = load i32, i32* %b, align 4
  %cmp20 = icmp sgt i32 %load_lval19, 35
  %zext_to_i3221 = zext i1 %cmp20 to i32
  %to_bool22 = icmp ne i32 %zext_to_i3221, 0
  br i1 %to_bool22, label %while.stmt17, label %cur16

merge23:                                          ; preds = %while.stmt17
  %load_lval31 = load i32, i32* %b, align 4
  %sub32 = sub i32 %load_lval31, 10
  store i32 %sub32, i32* %b, align 4
  br label %while.cond18

if.then27:                                        ; preds = %while.stmt17
  %load_lval29 = load i32, i32* %b, align 4
  %sub30 = sub i32 %load_lval29, 5
  store i32 %sub30, i32* %b, align 4
  br label %while.cond18

merge37:                                          ; preds = %if.then43, %cur16
  br label %while.cond

if.then43:                                        ; preds = %cur16
  %load_lval45 = load i32, i32* %a, align 4
  %sub46 = sub i32 %load_lval45, 10
  store i32 %sub46, i32* %a, align 4
  br label %merge37
}
