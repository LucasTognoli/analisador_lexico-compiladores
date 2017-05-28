all:
	/usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
	rm -f translate.output translate.tab.c translate.tab.h trab2 lex.yy.c
	bison -d translate.y -t --debug --verbose
	flex lex.l
	gcc -o trab2 translate.tab.c lex.yy.c -ll -ly -std=gnu89 -lstdc++
	./trab2
