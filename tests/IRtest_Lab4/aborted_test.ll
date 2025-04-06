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
  %cmp = icmp sge i32 %load_lval, 5
  %zext_to_i32 = zext i1 %cmp to i32
  %lhs_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %lhs_bool, label %and.rhs, label %and.merge

merge:                                            ; preds = %if.then, %or.merge
  %load_lval20 = load i32, i32* %x, align 4
  ret i32 %load_lval20

and.rhs:                                          ; preds = %mainEntry
  %load_lval1 = load i32, i32* %x, align 4
  %not = icmp eq i32 %load_lval1, 0
  %zext_to_i322 = zext i1 %not to i32
  %rhs_bool = icmp ne i32 %zext_to_i322, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %mainEntry
  %and_result = phi i1 [ false, %mainEntry ], [ %rhs_bool, %and.rhs ]
  %zext_to_i323 = zext i1 %and_result to i32
  %lhs_bool4 = icmp ne i32 %zext_to_i323, 0
  br i1 %lhs_bool4, label %and.rhs5, label %and.merge6

and.rhs5:                                         ; preds = %and.merge
  %load_lval7 = load i32, i32* %y, align 4
  %cmp8 = icmp sgt i32 %load_lval7, 0
  %zext_to_i329 = zext i1 %cmp8 to i32
  %rhs_bool10 = icmp ne i32 %zext_to_i329, 0
  br label %and.merge6

and.merge6:                                       ; preds = %and.rhs5, %and.merge
  %and_result11 = phi i1 [ false, %and.merge ], [ %rhs_bool10, %and.rhs5 ]
  %zext_to_i3212 = zext i1 %and_result11 to i32
  %lhs_bool13 = icmp ne i32 %zext_to_i3212, 0
  br i1 %lhs_bool13, label %or.merge, label %or.rhs

or.rhs:                                           ; preds = %and.merge6
  %load_lval14 = load i32, i32* %y, align 4
  %div = sdiv i32 %load_lval14, 0
  %cmp15 = icmp eq i32 %div, 0
  %zext_to_i3216 = zext i1 %cmp15 to i32
  %rhs_bool17 = icmp ne i32 %zext_to_i3216, 0
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %and.merge6
  %or_result = phi i1 [ true, %and.merge6 ], [ %rhs_bool17, %or.rhs ]
  %zext_to_i3218 = zext i1 %or_result to i32
  %to_bool = icmp ne i32 %zext_to_i3218, 0
  br i1 %to_bool, label %if.then, label %merge

if.then:                                          ; preds = %or.merge
  %load_lval19 = load i32, i32* %x, align 4
  %add = add i32 %load_lval19, 1
  store i32 %add, i32* %x, align 4
  br label %merge
}
