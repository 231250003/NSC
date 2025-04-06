; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @g(i32 %x) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %add = add i32 %load_lval, 1
  ret i32 %add
}

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  %g = call i32 @g(i32 10)
  store i32 %g, i32* %x, align 4
  %load_lval = load i32, i32* %x, align 4
  %cmp = icmp slt i32 %load_lval, 100
  br label %while.cond

cur:                                              ; preds = %if.else34, %while.cond
  ret i32 1

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %x, align 4
  %add = add i32 %load_lval1, 1
  store i32 %add, i32* %x, align 4
  %load_lval2 = load i32, i32* %x, align 4
  %cmp3 = icmp sgt i32 %load_lval2, 30
  br i1 %cmp3, label %if.then, label %merge

while.cond:                                       ; preds = %merge30, %mainEntry
  br i1 %cmp, label %while.stmt, label %cur

merge:                                            ; preds = %cur4, %while.stmt
  %load_lval31 = load i32, i32* %x, align 4
  %cmp32 = icmp sgt i32 %load_lval31, 10
  br i1 %cmp32, label %if.then33, label %if.else34

if.then:                                          ; preds = %while.stmt
  %load_lval5 = load i32, i32* %x, align 4
  %cmp6 = icmp sgt i32 %load_lval5, 10
  br label %while.cond8

cur4:                                             ; preds = %if.else24, %while.cond8
  %load_lval27 = load i32, i32* %x, align 4
  %sub28 = sub i32 %load_lval27, 1
  store i32 %sub28, i32* %x, align 4
  %load_lval29 = load i32, i32* %x, align 4
  ret i32 %load_lval29
  br label %merge

while.stmt7:                                      ; preds = %while.cond8
  %load_lval10 = load i32, i32* %x, align 4
  %cmp11 = icmp sgt i32 %load_lval10, 20
  br i1 %cmp11, label %if.then12, label %if.else

while.cond8:                                      ; preds = %merge9, %merge13, %if.then
  br i1 %cmp6, label %while.stmt7, label %cur4

merge9:                                           ; preds = %merge20, %merge13
  br label %while.cond8

if.then12:                                        ; preds = %while.stmt7
  %load_lval14 = load i32, i32* %x, align 4
  %cmp15 = icmp sgt i32 %load_lval14, 21
  br i1 %cmp15, label %if.then16, label %merge13

if.else:                                          ; preds = %while.stmt7
  %load_lval21 = load i32, i32* %x, align 4
  %cmp22 = icmp sgt i32 %load_lval21, 25
  br i1 %cmp22, label %if.then23, label %if.else24

merge13:                                          ; preds = %if.then16, %if.then12
  %load_lval18 = load i32, i32* %x, align 4
  %sub19 = sub i32 %load_lval18, 1
  store i32 %sub19, i32* %x, align 4
  br label %while.cond8
  br label %merge9

if.then16:                                        ; preds = %if.then12
  %load_lval17 = load i32, i32* %x, align 4
  %sub = sub i32 %load_lval17, 5
  store i32 %sub, i32* %x, align 4
  br label %merge13

merge20:                                          ; preds = %if.else24, %if.then23
  br label %merge9

if.then23:                                        ; preds = %if.else
  %load_lval25 = load i32, i32* %x, align 4
  %add26 = add i32 %load_lval25, 1
  store i32 %add26, i32* %x, align 4
  br label %merge20

if.else24:                                        ; preds = %if.else
  br label %cur4
  br label %merge20

merge30:                                          ; preds = %if.else34, %if.then33
  br label %while.cond

if.then33:                                        ; preds = %merge
  %load_lval35 = load i32, i32* %x, align 4
  %add36 = add i32 %load_lval35, 5
  store i32 %add36, i32* %x, align 4
  br label %merge30

if.else34:                                        ; preds = %merge
  br label %cur
  br label %merge30
}
