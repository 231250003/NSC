; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 1
@dddd = global i32 111
@crxz = global i32 0
@cccc = global i32 0

define i32 @main() {
mainEntry:
  %load_lval = load i32, i32* @a, align 4
  %add = add i32 %load_lval, 1
  %load_lval1 = load i32, i32* @cccc, align 4
  %not = icmp eq i32 %load_lval1, 0
  %zext_to_i32 = zext i1 %not to i32
  %not2 = icmp eq i32 %zext_to_i32, 0
  %zext_to_i323 = zext i1 %not2 to i32
  %add4 = add i32 %add, %zext_to_i323
  store i32 %add4, i32* @crxz, align 4
  %load_lval5 = load i32, i32* @crxz, align 4
  ret i32 %load_lval5
}
