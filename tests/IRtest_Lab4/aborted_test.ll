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
  %load_lval = load i32, i32* %x, align 4
  %lhs_bool = icmp ne i32 %load_lval, 0
  br i1 %lhs_bool, label %or.merge, label %or.rhs

merge:                                            ; preds = %if.then, %or.merge
  %load_lval3 = load i32, i32* %x, align 4
  ret i32 %load_lval3

or.rhs:                                           ; preds = %mainEntry
  %load_lval1 = load i32, i32* %x, align 4
  %div = sdiv i32 %load_lval1, 0
  %rhs_bool = icmp ne i32 %div, 0
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %mainEntry
  %or_result = phi i1 [ true, %mainEntry ], [ %rhs_bool, %or.rhs ]
  %zext_to_i32 = zext i1 %or_result to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

if.then:                                          ; preds = %or.merge
  %load_lval2 = load i32, i32* %x, align 4
  %add = add i32 %load_lval2, 1
  store i32 %add, i32* %x, align 4
  br label %merge
}
