; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  br label %if.else

if.then:                                          ; No predecessors!
  ret i32 3

if.else:                                          ; preds = %mainEntry
  ret i32 4
}
