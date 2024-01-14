cclone: lexicalAnalyser.l SyntaxiqueAnalyser.y 
	flex -l lexicalAnalyser.l
	bison -d SyntaxiqueAnalyser.y 
	gcc lex.yy.c SyntaxiqueAnalyser.tab.c quadruplets.c pile.c list.c semantic.c tableSymboles.c -lm -lfl -o test.exe
