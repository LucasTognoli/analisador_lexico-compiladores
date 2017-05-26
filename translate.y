%{
#include <stdio.h>
#include "windows.h"
#include <stdlib.h>
#include <ctype.h>
#define YYSTYPE double
FILE *output;
%}
/* declaration */
%token program t_const var
%token procedure read write t_if t_then numero_int numero_real t_else

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



%start prog

%% 
/* rules */
proger	: PROGRAM  {printf("program\n");}


prog	: PROGRAM ID ';' corpo '.' { 
					printf("program\n");
					fprintf(output, "program");
				   }

corpo	: dc T_BEGIN cmds END ;

dc	: dc_c dc_v dc_p ;

dc_c	: t_const ID '=' num ';' dc_c
	| ;

dc_v	: var vars ':' t_var ';' dc_v
	| ;

t_var	: REAL
	| INTEGER
	;

vars	: ID m_var ;

m_var	: ',' vars
	| ;

dc_p	: procedure ID param ';' corpo_p dc_p
	| ;

param	: '(' l_par ')'
	| ;

l_par	: vars ':' t_var m_par ;

m_par	: ';' l_par
	| ;

corpo_p	: dc_loc T_BEGIN cmds END ';' ;

dc_loc	: dc_v ;

l_arg	: '(' args ')'
	| ;

args	: ID m_id ;

m_id	: ';' args
	| ;

pfalsa	: t_else cmd
	| ;

cmds	: cmd ';' cmds
	| ;

cmd	: read '(' vars ')'
	| write '(' vars ')'
	| t_if cond t_then cmd pfalsa
	| ID ':' '=' exp
	| ID l_arg
	| T_BEGIN cmds END ;

cond	: exp rel exp ;

rel	: '='
	| '<' '>'
	| '>' '='
	| '>'
	| '<'
	;

exp	: termo ou_ter ;

op_un	: '+'
	| '-'
	| ;

ou_ter	: op_ad termo ou_ter
	| ;

op_ad	: '+'
	| '-'
	;

termo	: op_un fator m_fator

m_fator	: op_mul fator m_fator
	| ;

op_mul	: '*'
	| '/' ;

fator	: ID
	| num
	| '(' exp ')' ;

num	: numero_int
	| numero_real ;
%%
/* programs */


// stuff from lex that yacc needs to know about:
extern int yylex();
extern int yyparse();
extern FILE *yyin;

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
	int in = yylex();
	
	/*while (in) {
		fprintf(output, "in: %d\n", in);
		printf("in: %d\n", in);
		in = yylex();
	}
	
	// parse through the input until there is no more:
	int i = 0;
	do {
		i++;
		printf("%d\n", i);
		yyparse();
	} while (!feof(yyin));*/
	yyparse();

	Sleep(10000);

}

void yyerror(char *s) {
	fprintf(stderr,"error: %s\n",s);
}
