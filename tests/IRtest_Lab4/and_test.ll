; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 100, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 10, i32* %y, align 4
  %load_lval = load i32, i32* %x, align 4
  %cmp = icmp sgt i32 %load_lval, 50
  %lhs_bool = icmp ne i1 %cmp, false
  br i1 %lhs_bool, label %or.merge, label %or.rhs

merge:                                            ; preds = %if.then, %or.merge
  ret i32 0

or.rhs:                                           ; preds = %mainEntry
  %load_lval1 = load i32, i32* %y, align 4
  %div = sdiv i32 %load_lval1, 0
  %cmp2 = icmp eq i32 %div, 0
  %rhs_bool = icmp ne i1 %cmp2, i32 0
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %mainEntry
  %or_result = phi i1 [ true, %mainEntry ], [ %rhs_bool, %or.rhs ]
  br i1 %or_result, label %if.then, label %merge

if.then:                                          ; preds = %or.merge
  %load_lval3 = load i32, i32* %y, align 4
  ret i32 %load_lval3
  br label %merge
}
