; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 1
@dddd = global i32 111
@b = global i32 0
@cccc = global i32 0

define i32 @main() {
mainEntry:
  %c = alloca i32, align 4
  store i32 3, i32* %c, align 4
  %z = alloca i32, align 4
  store i32 64, i32* %z, align 4
  store i32 4, i32* %z, align 4
  %p = alloca i32, align 4
  store i32 -2, i32* %p, align 4
  %q = alloca i32, align 4
  store i32 0, i32* %q, align 4
  %load_lval = load i32, i32* %c, align 4
  %load_lval1 = load i32, i32* @a, align 4
  %add = add i32 %load_lval, %load_lval1
  %add2 = add i32 %add, 1
  %load_lval3 = load i32, i32* @cccc, align 4
  %not = icmp eq i32 %load_lval3, 0
  %zext_to_i32 = zext i1 %not to i32
  %not4 = icmp eq i32 %zext_to_i32, 0
  %zext_to_i325 = zext i1 %not4 to i32
  %add6 = add i32 %add2, %zext_to_i325
  store i32 %add6, i32* @b, align 4
  %d = alloca i32, align 4
  %load_lval7 = load i32, i32* @a, align 4
  %add8 = add i32 10, %load_lval7
  %load_lval9 = load i32, i32* @b, align 4
  %add10 = add i32 %add8, %load_lval9
  %load_lval11 = load i32, i32* %c, align 4
  %add12 = add i32 %add10, %load_lval11
  %add13 = add i32 %add12, 16
  %load_lval14 = load i32, i32* %z, align 4
  %add15 = add i32 %add13, %load_lval14
  %load_lval16 = load i32, i32* %p, align 4
  %add17 = add i32 %add15, %load_lval16
  %load_lval18 = load i32, i32* %q, align 4
  %add19 = add i32 %add17, %load_lval18
  %load_lval20 = load i32, i32* @dddd, align 4
  %add21 = add i32 %add19, %load_lval20
  store i32 %add21, i32* %d, align 4
  %load_lval22 = load i32, i32* @a, align 4
  %load_lval23 = load i32, i32* @b, align 4
  %add24 = add i32 %load_lval22, %load_lval23
  %load_lval25 = load i32, i32* %c, align 4
  %add26 = add i32 %add24, %load_lval25
  %load_lval27 = load i32, i32* %d, align 4
  %add28 = add i32 %add26, %load_lval27
  %add29 = add i32 %add28, 16
  %load_lval30 = load i32, i32* %z, align 4
  %add31 = add i32 %add29, %load_lval30
  %load_lval32 = load i32, i32* %p, align 4
  %add33 = add i32 %add31, %load_lval32
  %load_lval34 = load i32, i32* %q, align 4
  %add35 = add i32 %add33, %load_lval34
  %load_lval36 = load i32, i32* @dddd, align 4
  %add37 = add i32 %add35, %load_lval36
  ret i32 %add37
}
