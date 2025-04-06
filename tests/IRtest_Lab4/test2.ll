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
  br label %while.cond

cur:                                              ; preds = %if.else13, %while.cond
  ret i32 1

while.stmt:                                       ; preds = %while.cond
  store i32 11, i32 10, align 4
  br i1 false, label %if.then, label %merge

while.cond:                                       ; preds = %merge11, %mainEntry
  br i1 true, label %while.stmt, label %cur

merge:                                            ; preds = %cur1, %while.stmt
  br i1 false, label %if.then12, label %if.else13

if.then:                                          ; preds = %while.stmt
  br label %while.cond3

cur1:                                             ; preds = %if.else10, %while.cond3
  store i32 9, i32 10, align 4
  ret i32 10
  br label %merge

while.stmt2:                                      ; preds = %while.cond3
  br i1 false, label %if.then5, label %if.else

while.cond3:                                      ; preds = %merge4, %merge6, %if.then
  br i1 false, label %while.stmt2, label %cur1

merge4:                                           ; preds = %merge8, %merge6
  br label %while.cond3

if.then5:                                         ; preds = %while.stmt2
  br i1 false, label %if.then7, label %merge6

if.else:                                          ; preds = %while.stmt2
  br i1 false, label %if.then9, label %if.else10

merge6:                                           ; preds = %if.then7, %if.then5
  store i32 9, i32 10, align 4
  br label %while.cond3
  br label %merge4

if.then7:                                         ; preds = %if.then5
  store i32 5, i32 10, align 4
  br label %merge6

merge8:                                           ; preds = %if.else10, %if.then9
  br label %merge4

if.then9:                                         ; preds = %if.else
  store i32 11, i32 10, align 4
  br label %merge8

if.else10:                                        ; preds = %if.else
  br label %cur1
  br label %merge8

merge11:                                          ; preds = %if.else13, %if.then12
  br label %while.cond

if.then12:                                        ; preds = %merge
  store i32 15, i32 10, align 4
  br label %merge11

if.else13:                                        ; preds = %merge
  br label %cur
  br label %merge11
}
