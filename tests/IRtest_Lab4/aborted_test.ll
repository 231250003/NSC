; ModuleID = 'my_module'
source_filename = "my_module"

@y = global i32 0

define i32 @main() {
mainEntry:
  %t = alloca i32, align 4
  store i32 100, i32* %t, align 4
  %x = alloca i32, align 4
  store i32 5, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 100, i32* %y, align 4
  %z = alloca i32, align 4
  %load_lval = load i32, i32* %y, align 4
  %add = add i32 %load_lval, 100
  store i32 %add, i32* %z, align 4
  %load_lval1 = load i32, i32* %x, align 4
  %lhs_bool = icmp ne i32 %load_lval1, 0
  br i1 %lhs_bool, label %or.merge, label %or.rhs

merge:                                            ; preds = %if.then, %or.merge5
  %load_lval12 = load i32, i32* %x, align 4
  ret i32 %load_lval12

or.rhs:                                           ; preds = %mainEntry
  %load_lval2 = load i32, i32* %x, align 4
  %mod = srem i32 %load_lval2, 0
  %rhs_bool = icmp ne i32 %mod, 0
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %mainEntry
  %or_result = phi i1 [ true, %mainEntry ], [ %rhs_bool, %or.rhs ]
  %zext_to_i32 = zext i1 %or_result to i32
  %lhs_bool3 = icmp ne i32 %zext_to_i32, 0
  br i1 %lhs_bool3, label %or.merge5, label %or.rhs4

or.rhs4:                                          ; preds = %or.merge
  %load_lval6 = load i32, i32* %x, align 4
  %div = sdiv i32 %load_lval6, 0
  %rhs_bool7 = icmp ne i32 %div, 0
  br label %or.merge5

or.merge5:                                        ; preds = %or.rhs4, %or.merge
  %or_result8 = phi i1 [ true, %or.merge ], [ %rhs_bool7, %or.rhs4 ]
  %zext_to_i329 = zext i1 %or_result8 to i32
  %to_bool = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool, label %if.then, label %merge

if.then:                                          ; preds = %or.merge5
  %load_lval10 = load i32, i32* %x, align 4
  %add11 = add i32 %load_lval10, 1
  store i32 %add11, i32* %x, align 4
  br label %merge
}
