%{
#define YYDEBUG 1

#include <stdio.h>
#include <unistd.h>
int yydebug=0;
FILE *output;
%}
/* declaration */
%debug
%token program id begin end t_const var real integer subrange
%token procedure t_read t_write t_if t_then numero_int numero_real t_else
%start prog

%%
/* rules */

prog	: program id ';' corpo '.'
	| error ';' {fprintf(output,"PROG\n"); yyerrok; yyclearin;}
	;

corpo	: dc begin cmds end
	| error ';' {fprintf(output,"CORPO\n");yyerrok; yyclearin;}
	;


dc	: dc_c dc_v dc_p
	| error ';' {fprintf(output,"DC\n");yyerrok; yyclearin;}
	;

dc_c	: t_const id '=' num ';' dc_c
	|
	| error '\n' {fprintf(output,"DC_C\n"); yyerrok; yyclearin;}
	;

dc_v	: var vars ':' t_var ';' dc_v
	|
	;

t_var	: real
	| integer
	| error ';' {fprintf(output,"T_VAR\n"); yyerrok; yyclearin;}
	;

vars	: id m_var
	| error ';' {fprintf(output,"VARS\n"); yyerrok; yyclearin;}
	;

m_var	: ',' vars
	|
	| error ';' {fprintf(output,"M_VAR\n"); yyerrok;yyclearin;}
	;

dc_p	: procedure id param ';' corpo_p dc_p
	|
	;

param	: '(' l_par ')'
	|
	| error ';' {fprintf(output,"PARAM\n"); yyerrok; yyclearin;}
	;

l_par	: vars ':' t_var m_par
	| error ';' {fprintf(output,"L_PAR\n"); yyerrok; yyclearin; }
	;

m_par	: ';' l_par
	|
	| error ';' {fprintf(output,"M_PAR\n"); yyerrok; yyclearin;}
	;

corpo_p	: dc_loc begin cmds end ';'
	| error ';' {fprintf(output,"CORPO_P\n"); yyerrok; yyclearin;}
	;

dc_loc	: dc_v
	| error '\n' {fprintf(output,"DC_LOC\n") ;yyerrok; yyclearin;}
	;

l_arg	: '(' args ')'
	| error ';' {fprintf(output,"L_ARG\n"); yyerrok;yyerrok; yyclearin;}
	|
	;

args	: id m_id
	| error ';' {fprintf(output,"ARGS\n");yyerrok; yyclearin;}
	;

m_id	: ';' args
	|
	| error ';' {fprintf(output,"M_ID\n"); yyerrok; yyclearin;}
	;

pfalsa	: t_else cmd

	;

cmds	: cmd ';' cmds
	|
	| error ';' {fprintf(output,"CMDS\n"); yyerrok; yyclearin;}
	;

cmd	: t_read '(' vars ')'
	| t_write '(' vars ')'
	| t_if cond t_then cmd pfalsa
	| id ':' '=' exp
	| id l_arg
	| begin cmds end
	| error ';' {fprintf(output, "CMD\n"); yyerrok; yyclearin; }
	;

cond	: exp rel exp
	| error ';' {fprintf(output,"COND\n"); yyerrok; yyclearin;}
	;

rel	: '='
	| '<' '>'
	| '>' '='
	| '>'
	| '<'
	| error ';' {fprintf(output,"REL\n"); yyerrok; yyclearin;}
	;

exp	: termo ou_ter
	| error ';' {fprintf(output,"EXP\n"); yyerrok; yyclearin;}
	;

op_un	: '+'
	| '-'
	|
	| error ';' {fprintf(output,"OP_UN\n"); yyerrok; yyclearin;}
	;

ou_ter	: op_ad termo ou_ter
	|
	;

op_ad	: '+'
	| '-'
	;

termo	: op_un fator m_fator
	| error '\n' {fprintf(output,"TERMO\n"); yyerrok; yyclearin;}
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
	fprintf(output, "Results:\n\n");

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

	fclose(output);
	return ret;
}

int  yyerror(char *s) {
	fprintf(output,"\nline: %d - %s", line_num, s);
	fprintf(output,". Token: '%s' on rule: ", yytext);
	return 1;
}

void print_log(char *s){
	fprintf(output,"%s", s);
}