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
  %load_lval1 = load i32, i32* %y, align 4
  %div = sdiv i32 %load_lval1, 0
  %cmp2 = icmp eq i32 %div, 0
  %left_is_nonzero = icmp ne i1 %cmp, false
  %short_circuit = select i1 %left_is_nonzero, i1 true, i1 %cmp2
  br i1 %short_circuit, label %if.then, label %merge

merge:                                            ; preds = %if.then, %mainEntry

if.then:                                          ; preds = %mainEntry
  %load_lval3 = load i32, i32* %y, align 4
  ret i32 %load_lval3
  br label %merge
}
