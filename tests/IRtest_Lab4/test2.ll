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
  %to_bool = icmp ne i32 %load_lval, 0
  %cmp = icmp slt i1 %to_bool, true
  br label %while.cond

cur:                                              ; preds = %if.else40, %while.cond
  ret i32 1

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %x, align 4
  %add = add i32 %load_lval1, 1
  store i32 %add, i32* %x, align 4
  %load_lval2 = load i32, i32* %x, align 4
  %to_bool3 = icmp ne i32 %load_lval2, 0
  %cmp4 = icmp sgt i1 %to_bool3, true
  br i1 %cmp4, label %if.then, label %merge

while.cond:                                       ; preds = %merge35, %mainEntry
  br i1 %cmp, label %while.stmt, label %cur

merge:                                            ; preds = %cur5, %while.stmt
  %load_lval36 = load i32, i32* %x, align 4
  %to_bool37 = icmp ne i32 %load_lval36, 0
  %cmp38 = icmp sgt i1 %to_bool37, true
  br i1 %cmp38, label %if.then39, label %if.else40

if.then:                                          ; preds = %while.stmt
  %load_lval6 = load i32, i32* %x, align 4
  %to_bool7 = icmp ne i32 %load_lval6, 0
  %cmp8 = icmp sgt i1 %to_bool7, true
  br label %while.cond10

cur5:                                             ; preds = %if.else29, %while.cond10
  %load_lval32 = load i32, i32* %x, align 4
  %sub33 = sub i32 %load_lval32, 1
  store i32 %sub33, i32* %x, align 4
  %load_lval34 = load i32, i32* %x, align 4
  ret i32 %load_lval34
  br label %merge

while.stmt9:                                      ; preds = %while.cond10
  %load_lval12 = load i32, i32* %x, align 4
  %to_bool13 = icmp ne i32 %load_lval12, 0
  %cmp14 = icmp sgt i1 %to_bool13, true
  br i1 %cmp14, label %if.then15, label %if.else

while.cond10:                                     ; preds = %merge11, %merge16, %if.then
  br i1 %cmp8, label %while.stmt9, label %cur5

merge11:                                          ; preds = %merge24, %merge16
  br label %while.cond10

if.then15:                                        ; preds = %while.stmt9
  %load_lval17 = load i32, i32* %x, align 4
  %to_bool18 = icmp ne i32 %load_lval17, 0
  %cmp19 = icmp sgt i1 %to_bool18, true
  br i1 %cmp19, label %if.then20, label %merge16

if.else:                                          ; preds = %while.stmt9
  %load_lval25 = load i32, i32* %x, align 4
  %to_bool26 = icmp ne i32 %load_lval25, 0
  %cmp27 = icmp sgt i1 %to_bool26, true
  br i1 %cmp27, label %if.then28, label %if.else29

merge16:                                          ; preds = %if.then20, %if.then15
  %load_lval22 = load i32, i32* %x, align 4
  %sub23 = sub i32 %load_lval22, 1
  store i32 %sub23, i32* %x, align 4
  br label %while.cond10
  br label %merge11

if.then20:                                        ; preds = %if.then15
  %load_lval21 = load i32, i32* %x, align 4
  %sub = sub i32 %load_lval21, 5
  store i32 %sub, i32* %x, align 4
  br label %merge16

merge24:                                          ; preds = %if.else29, %if.then28
  br label %merge11

if.then28:                                        ; preds = %if.else
  %load_lval30 = load i32, i32* %x, align 4
  %add31 = add i32 %load_lval30, 1
  store i32 %add31, i32* %x, align 4
  br label %merge24

if.else29:                                        ; preds = %if.else
  br label %cur5
  br label %merge24

merge35:                                          ; preds = %if.else40, %if.then39
  br label %while.cond

if.then39:                                        ; preds = %merge
  %load_lval41 = load i32, i32* %x, align 4
  %add42 = add i32 %load_lval41, 5
  store i32 %add42, i32* %x, align 4
  br label %merge35

if.else40:                                        ; preds = %merge
  br label %cur
  br label %merge35
}
