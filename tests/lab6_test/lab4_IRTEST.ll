; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  br label %if.else

merge:                                            ; preds = %if.else, %if.then
  unreachable

if.then:                                          ; No predecessors!
  ret i32 3
  br label %merge

if.else:                                          ; preds = %mainEntry
  ret i32 4
  br label %merge
}
