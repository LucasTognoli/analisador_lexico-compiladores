%{
#define YYDEBUG 1

#include <stdio.h>
#include <unistd.h>
int yydebug=1;
FILE *output;
%}
/* declaration */
%debug
%token program id begin end t_const var real integer subrange semicolon
%token procedure t_read t_write t_if t_then numero_int numero_real t_else
%start prog

%%
/* rules */

prog	: program id semicolon corpo '.'
	| error semicolon {fprintf(stderr,"PROG\n"); yyerrok;yyclearin;}
	;

corpo	: dc begin cmds end
	| error semicolon {fprintf(stderr,"CORPO\n");yyerrok;yyclearin;}
	;


dc	: dc_c dc_v dc_p
	| error semicolon {fprintf(stderr,"DC\n");yyerrok;yyclearin;}
	;

dc_c	: t_const id '=' num semicolon dc_c
	|
	
	;

dc_v	: var vars ':' t_var semicolon dc_v
	|
	
	;

t_var	: real
	| integer
	| error semicolon {fprintf(stderr,"T_VAR\n"); yyerrok;yyclearin; }
	;

vars	: id m_var
	| error semicolon {fprintf(stderr,"VARS\n"); yyerrok;}
	;

m_var	: ',' vars
	|
	| error semicolon {fprintf(stderr,"M_VAR\n"); yyerrok;}
	;

dc_p	: procedure id param semicolon corpo_p dc_p
	|
	;

param	: '(' l_par ')'
	|
	| error semicolon {fprintf(stderr,"PARAM\n"); yyerrok; yyclearin;}
	;

l_par	: vars ':' t_var m_par
	| error semicolon {fprintf(stderr,"L_PAR\n"); yyerrok; yyclearin; }
	;

m_par	: semicolon l_par
	|
	| error semicolon {fprintf(stderr,"M_PAR\n"); yyerrok; yyclearin;}
	;

corpo_p	: dc_loc begin cmds end semicolon
	| error semicolon {fprintf(stderr,"CORPO_P\n"); yyerrok; yyclearin;}
	;

dc_loc	: dc_v
	| error '\n' {fprintf(stderr,"DC_LOC\n") ;yyerrok; yyclearin;}
	;

l_arg	: '(' args ')'
	| error semicolon {fprintf(stderr,"L_ARG\n"); yyerrok;yyerrok; yyclearin;}
	|
	;

args	: id m_id
	| error semicolon {fprintf(stderr,"ARGS\n");yyerrok; yyclearin;}
	;

m_id	: semicolon args
	|
	| error semicolon {fprintf(stderr,"M_ID\n"); yyerrok; yyclearin;}
	;

pfalsa	: t_else cmd
	|
	;

cmds	: cmd semicolon cmds
	|
	| error semicolon {fprintf(stderr,"CMDS\n"); yyerrok; yyclearin;}
	;

cmd	: t_read '(' vars ')'
	| t_write '(' vars ')'
	| t_if cond t_then cmd pfalsa
	| id ':' '=' exp
	| id l_arg
	| begin cmds end
	| error semicolon {fprintf(stderr, "CMD\n"); yyerrok;}
	;

cond	: exp rel exp
	| error semicolon {fprintf(stderr,"COND\n"); yyerrok;}
	;

rel	: '='
	| '<' '>'
	| '>' '='
	| '>'
	| '<'
	| error semicolon {fprintf(stderr,"REL\n"); yyerrok; yyclearin;}
	;

exp	: termo ou_ter
	| error semicolon {fprintf(stderr,"EXP\n"); yyerrok; yyclearin;}
	;

op_un	: '+'
	| '-'
	|
	| error semicolon {fprintf(stderr,"OP_UN\n"); yyerrok; yyclearin;}
	;

ou_ter	: op_ad termo ou_ter
	|
	;

op_ad	: '+'
	| '-'
	;

termo	: op_un fator m_fator
	;

m_fator	: op_mul fator m_fator
	|
	;

op_mul	: '*'
	| '/'
	;

fator	: id
	| num
	| '(' exp ')'
	;

num	: numero_int
	| numero_real
	| subrange
	;

%%
/* programs */


// stuff from lex that yacc needs to know about:
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int line_num;
extern char* yytext;

int main() {

	// open output file
	output = fopen("log.txt", "w");
	if (!output) {
		return -1;
	}
	fprintf(stderr, "Results:\n\n");

	// open input file
	FILE *myfile = fopen("sample.pas", "r");
	if (!myfile) {
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	// parse through the input until there is no more:
	int ret = 0;
	ret = yyparse();
	getchar();
	fclose(output);
	return ret;
}

int  yyerror(char *s) {
	fprintf(stderr,"\nline: %d - %s", line_num, s);
	fprintf(stderr,". Token: '%s' on rule: ", yytext);
	return 1;
}

