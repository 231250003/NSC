; ModuleID = 'my_module'
source_filename = "my_module"

@y = global i32 0

define i32 @main() {
mainEntry:
  %t = alloca i32, align 4
  store i32 100, i32* %t, align 4
  %x = alloca i32, align 4
  store i32 5, i32* %x, align 4
  %load_lval = load i32, i32* %x, align 4
  %cmp = icmp sge i32 %load_lval, 5
  %zext_to_i32 = zext i1 %cmp to i32
  %lhs_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %lhs_bool, label %and.rhs, label %and.merge

merge:                                            ; preds = %if.then, %or.merge
  %load_lval11 = load i32, i32* %x, align 4
  ret i32 %load_lval11

and.rhs:                                          ; preds = %mainEntry
  %load_lval1 = load i32, i32* @y, align 4
  %cmp2 = icmp sgt i32 %load_lval1, 0
  %zext_to_i323 = zext i1 %cmp2 to i32
  %rhs_bool = icmp ne i32 %zext_to_i323, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %mainEntry
  %and_result = phi i1 [ false, %mainEntry ], [ %rhs_bool, %and.rhs ]
  %zext_to_i324 = zext i1 %and_result to i32
  %lhs_bool5 = icmp ne i32 %zext_to_i324, 0
  br i1 %lhs_bool5, label %or.merge, label %or.rhs

or.rhs:                                           ; preds = %and.merge
  %load_lval6 = load i32, i32* @y, align 4
  %div = sdiv i32 %load_lval6, 0
  %cmp7 = icmp eq i32 %div, 0
  %zext_to_i328 = zext i1 %cmp7 to i32
  %rhs_bool9 = icmp ne i32 %zext_to_i328, 0
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %and.merge
  %or_result = phi i1 [ true, %and.merge ], [ %rhs_bool9, %or.rhs ]
  %zext_to_i3210 = zext i1 %or_result to i32
  %to_bool = icmp ne i32 %zext_to_i3210, 0
  br i1 %to_bool, label %if.then, label %merge

if.then:                                          ; preds = %or.merge
  br label %merge
}
