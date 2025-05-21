; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  br i1 false, label %if.then, label %if.else

merge:                                            ; preds = %if.else, %if.then
  unreachable

if.then:                                          ; preds = %mainEntry
  ret i32 3
  br label %merge

if.else:                                          ; preds = %mainEntry
  ret i32 4
  br label %merge
}
