; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 10

define i32 @main() {
mainEntry:
  %b = alloca i32, align 4
  store i32 2, i32* %b, align 4
  %c = alloca i32, align 4
  store i32 3, i32* %c, align 4
  %load_lval = load i32, i32* %b, align 4
  %not = icmp eq i32 %load_lval, 0
  %zext_to_i32 = zext i1 %not to i32
  %cmp = icmp ne i32 %zext_to_i32, 2
  %zext_to_i321 = zext i1 %cmp to i32
  %lhs_bool = icmp ne i32 %zext_to_i321, 0
  br i1 %lhs_bool, label %and.rhs, label %and.merge

merge:                                            ; preds = %if.then, %and.merge
  %load_lval7 = load i32, i32* @a, align 4
  ret i32 %load_lval7

and.rhs:                                          ; preds = %mainEntry
  %load_lval2 = load i32, i32* %c, align 4
  %div = sdiv i32 %load_lval2, 0
  %cmp3 = icmp eq i32 %div, 0
  %zext_to_i324 = zext i1 %cmp3 to i32
  %rhs_bool = icmp ne i32 %zext_to_i324, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %mainEntry
  %and_result = phi i1 [ false, %mainEntry ], [ %rhs_bool, %and.rhs ]
  %zext_to_i325 = zext i1 %and_result to i32
  %to_bool = icmp ne i32 %zext_to_i325, 0
  br i1 %to_bool, label %if.then, label %merge

if.then:                                          ; preds = %and.merge
  %load_lval6 = load i32, i32* @a, align 4
  ret i32 %load_lval6
  br label %merge
}
