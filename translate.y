%{
#include <stdio.h>
#include "windows.h"
#include <stdlib.h>
#include <ctype.h>
#define YYSTYPE char *
FILE *output;
%}
/* declaration */
%token program t_const var
%token procedure read write t_if t_then numero_int numero_real t_else
%token ENDL PONTOEVIRGULA
%union
       {
               int number;
               char *string;
	       float real;
       };

%token <real> REAL
%token <number> INTEGER
%token <number> T_CONT
%token <string> ID
%token <string> PROGRAM
%token <string> T_BEGIN
%token <string> END
%token <string> VAR



%start proger

%% 
/* rules */
proger	: PROGRAM ID PONTOEVIRGULA	 {printf("program lucas\n");} 
	|error '\n'			 {yyerrok;}

%%
/* programs */


// stuff from lex that yacc needs to know about:
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int line_num;
main() {

	// open output file
	printf("Testando...\n");

	output = fopen("log.txt", "w");
	if (!output) {
		return -1;
	}
	fprintf(output, "oi\n");

	// open input file
	FILE *myfile = fopen("sample.pas", "r");
	if (!myfile) {
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	// testing lex
	char *in;
	
	/*while (in) {
		fprintf(output, "in: %s\n", in);
		printf("in: %s\n", in);
		in = yylval;
	}*/
	
	// parse through the input until there is no more:
	do {
		yyparse();
		//in = yylval;
		//printf("in: %s\n", in);
	} while (!feof(yyin));
	

	Sleep(1000000);

}

int yyerror(char *s) {
	fprintf(stderr,"line: %d - error: %s\n", line_num, s);
}
