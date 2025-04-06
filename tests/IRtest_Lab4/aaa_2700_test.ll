; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 100
@y = global i32 2
@z = global i32 3

define i32 @main() {
mainEntry:
  %load_lval = load i32, i32* @x, align 4
  %cmp = icmp sgt i32 %load_lval, 100
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %merge1, %mainEntry
  %load_lval21 = load i32, i32* @x, align 4
  ret i32 %load_lval21

if.then:                                          ; preds = %mainEntry
  %load_lval2 = load i32, i32* @x, align 4
  %cmp3 = icmp slt i32 %load_lval2, 10
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool6 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool6, label %if.then5, label %if.else

merge1:                                           ; preds = %merge7, %if.then5
  %load_lval20 = load i32, i32* @x, align 4
  %add = add i32 %load_lval20, 1
  store i32 %add, i32* @x, align 4
  br label %merge

if.then5:                                         ; preds = %if.then
  ret i32 0
  br label %merge1

if.else:                                          ; preds = %if.then
  %load_lval8 = load i32, i32* @x, align 4
  %cmp9 = icmp sgt i32 %load_lval8, 20
  %zext_to_i3210 = zext i1 %cmp9 to i32
  %to_bool13 = icmp ne i32 %zext_to_i3210, 0
  br i1 %to_bool13, label %if.then11, label %if.else12

merge7:                                           ; preds = %merge14, %if.then11
  br label %merge1

if.then11:                                        ; preds = %if.else
  ret i32 2
  br label %merge7

if.else12:                                        ; preds = %if.else
  %load_lval15 = load i32, i32* @x, align 4
  %cmp16 = icmp sgt i32 %load_lval15, 256
  %zext_to_i3217 = zext i1 %cmp16 to i32
  %to_bool19 = icmp ne i32 %zext_to_i3217, 0
  br i1 %to_bool19, label %if.then18, label %merge14

merge14:                                          ; preds = %if.then18, %if.else12
  br label %merge7

if.then18:                                        ; preds = %if.else12
  ret i32 3
  br label %merge14
}
