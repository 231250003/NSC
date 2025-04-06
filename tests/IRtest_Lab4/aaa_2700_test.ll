; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @f(i32 %x) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %cmp = icmp sgt i32 %load_lval, 100
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %if.then, %fEntry
  %load_lval2 = load i32, i32* %param0_addr, align 4
  %add3 = add i32 %load_lval2, 1
  %f = call i32 @f(i32 %add3)
  ret i32 %f

if.then:                                          ; preds = %fEntry
  %load_lval1 = load i32, i32* %param0_addr, align 4
  %add = add i32 %load_lval1, 2
  ret i32 %add
  br label %merge
}

define i32 @g(i32 %y) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %y, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %cmp = icmp sgt i32 %load_lval, 100
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %if.then, %gEntry
  %load_lval2 = load i32, i32* %param0_addr, align 4
  %add3 = add i32 %load_lval2, 2
  %f = call i32 @f(i32 %add3)
  ret i32 %f

if.then:                                          ; preds = %gEntry
  %load_lval1 = load i32, i32* %param0_addr, align 4
  %add = add i32 %load_lval1, 2
  ret i32 %add
  br label %merge
}

define i32 @main() {
mainEntry:
  %g = call i32 @g(i32 1)
  ret i32 %g
}
