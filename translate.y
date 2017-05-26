%{
#include <stdio.h>
#include "windows.h"

FILE *output;
%}
/* declaration */
%token program id begin end t_const var real integer 
%token procedure read write t_if t_then numero_int numero_real t_else
%start prog

%% 
/* rules */
 /*
prog	: program ';' { printf("Yes\n");
			fprintf(output, "Yes");
		      }
	;
 */
prog	: program id ';' corpo '.' { printf("program\n");
				     fprintf(output, "program");
				   }
	;

corpo	: dc begin cmds end { printf("\nprocessed corpo\n"); } ;

dc	: dc_c dc_v dc_p ;

dc_c	: t_const id '=' num ';' dc_c
	| ;

dc_v	: var vars ':' t_var ';' dc_v
	| ;

t_var	: real
	| integer
	;

vars	: id m_var ;

m_var	: ',' vars
	| ;

dc_p	: procedure id param ';' corpo_p dc_p
	| ;

param	: '(' l_par ')'
	| ;

l_par	: vars ':' t_var m_par ;

m_par	: ';' l_par
	| ;

corpo_p	: dc_loc begin cmds end ';'	{ printf("\nprocessed corpo_p\n"); } ;

dc_loc	: dc_v ;

l_arg	: '(' args ')'
	| ;

args	: id m_id ;

m_id	: ';' args
	| ;

pfalsa	: t_else cmd
	| ;

cmds	: cmd ';' cmds			{ printf("\nprocessed cmds\n"); } ;
	| ;

cmd	: read '(' vars ')'		{ printf("\nprocessed cmd read\n"); } ;
	| write '(' vars ')'		{ printf("\nprocessed cmd write\n"); } ;
	| t_if cond t_then cmd pfalsa	{ printf("\nprocessed cmd if\n"); } ;
	| id ':' '=' exp		{ printf("\nprocessed cmd attr\n"); } ;
	| id l_arg			{ printf("\nprocessed id l_arg\n"); } ;
	| begin cmds end 		{ printf("\nprocessed begin\n"); } ;

cond	: exp rel exp 			{ printf("\nprocessed cond\n"); } ;

rel	: '='				{ //printf("\nprocessed rel eq\n"); } ;
	| '<' '>'			{ //printf("\nprocessed rel uneq\n"); } ;
	| '>' '='			{ //printf("\nprocessed rel greq\n"); } ;
	| '>'				{ //printf("\nprocessed rel gr\n"); } ;
	| '<'				{ //printf("\nprocessed rel less\n"); } ;
	;

exp	: termo ou_ter			{ printf("\nprocessed exp\n"); } ;

op_un	: '+'
	| '-'
	| ;

ou_ter	: op_ad termo ou_ter
	| ;

op_ad	: '+'
	| '-'
	;

termo	: op_un fator m_fator		{ printf("\nprocessed termo\n"); } ;

m_fator	: op_mul fator m_fator		{ //printf("\nprocessed m_fator full\n"); } ;
	| 				{ //printf("\nprocessed m_fator empty\n"); } ;

op_mul	: '*'				{ //printf("\nprocessed op_mul mul\n"); } ;
	| '/'				{ //printf("\nprocessed op_mul div\n"); } ;
	;

fator	: id				{ //printf("\nprocessed fator id\n"); } ;
	| num				{ //printf("\nprocessed fator num\n"); } ;
	| '(' exp ')'			{ //printf("\nprocessed exp\n"); } ;
	;

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
	output = fopen("log.txt", "w");
	if (!output) {
		return -1;
	}
	printf("Testando...\n");

	// open input file
	FILE *myfile = fopen("sample.pas", "r");
	if (!myfile) {
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	// testing lex
	// yyparse might not work if uncommented
	/*
	int in = yylex();
	while (in) {
		fprintf(output, "in: %d\n", in);
		printf("in: %d\n", in);
		in = yylex();
	}
	*/
	// parse through the input until there is no more:
	int ret = 0;
	ret = yyparse();
	/*
	int i = 0;
	do {
		i++;
		printf("%d\n", i);

	} while (!feof(yyin));
	*/

	Sleep(100000);
	return ret;
}

 void yyerror (char *s) {
	fprintf (stderr, "\n%s\n", s);
}