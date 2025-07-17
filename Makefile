LLVM_JAR = $(shell echo `find utils -name "llvm-*.jar"` | sed  "s/\s\+/:/g")
JAVACPP_JAR = $(shell echo `find utils -name "javacpp-*.jar"` | sed  "s/\s\+/:/g")
ANTLR_PATH = $(shell find utils -name "antlr-*-complete.jar")

export CLASSPATH=$(ANTLR_PATH):$(LLVM_JAR):$(JAVACPP_JAR)

DOMAINNAME = oj.compilers.cpl.icu
ANTLR = java -jar $(ANTLR_PATH) -listener -visitor -long-messages
JAVAC = javac -g
JAVA = java


PFILE = $(shell find . -name "SysYParser.g4")
LFILE = $(shell find . -name "SysYLexer.g4")
JAVAFILE = $(shell find ./src -name "*.java")

compile: antlr
	mkdir -p classes
	$(JAVAC) -classpath $(CLASSPATH) $(JAVAFILE) -d classes

run: compile
	java -classpath ./classes:$(CLASSPATH) Main $(SRCFILE) $(OUTFILE)

antlr: $(LFILE) $(PFILE)
	$(ANTLR) $(PFILE) $(LFILE)


clean:
	rm -f src/*.tokens
	rm -f src/*.interp
	rm -f src/SysYLexer.java src/SysYParser.java src/SysYParserBaseListener.java src/SysYParserBaseVisitor.java src/SysYParserListener.java src/SysYParserVisitor.java
	rm -rf classes
	rm -rf out


.PHONY: compile antlr test run clean submit