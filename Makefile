LLVM_JAR = $(shell echo `find compiler/utils -name "llvm-*.jar"` | sed  "s/\s\+/:/g")
JAVACPP_JAR = $(shell echo `find compiler/utils -name "javacpp-*.jar"` | sed  "s/\s\+/:/g")
ANTLR_PATH = $(shell find compiler/utils -name "antlr-*-complete.jar")

export CLASSPATH=$(ANTLR_PATH):$(LLVM_JAR):$(JAVACPP_JAR)

DOMAINNAME = oj.compilers.cpl.icu
ANTLR = java -jar $(ANTLR_PATH) -listener -visitor -long-messages
JAVAC = javac -g
JAVA = java


PFILE = $(shell find . -name "SysYParser.g4")
LFILE = $(shell find . -name "SysYLexer.g4")
JAVAFILE = $(shell find ./compiler/src -name "*.java")

compile_: antlr
	mkdir -p classes
	$(JAVAC) -classpath $(CLASSPATH) $(JAVAFILE) -d classes

compile: compile_
	java -classpath ./classes:$(CLASSPATH) Main $(SRCFILE) $(ARGS)

antlr: $(LFILE) $(PFILE)
	$(ANTLR) $(PFILE) $(LFILE)

run_os:
	g++ os/syscall.cpp os/console.cpp os/process.cpp os/os.cpp os/main.cpp -o nos

clean:
	rm -f src/*.tokens
	rm -f src/*.interp
	rm -f src/SysYLexer.java src/SysYParser.java src/SysYParserBaseListener.java src/SysYParserBaseVisitor.java src/SysYParserListener.java src/SysYParserVisitor.java
	rm -rf classes
	rm -rf out


.PHONY: compile antlr test run clean submit