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
	| error ';' {yyerror("Falta de PROGRAM ou de ID ou de CORPO ou de PONTO FINAL\n"); yyerrok; yyclearin;}
	;

corpo	: dc begin cmds end
	| error ';' {yyerror("dc begin cmds end\n");yyerrok; yyclearin;}
	;

dc	: dc_c dc_v dc_p
	| error ';' {yyerror("dc_c dc_v dc_p\n");yyerrok; yyclearin;}
	;

dc_c	: t_const id '=' num ';' dc_c
	|
	| error '\n' {yyerror("t_const id '=' num ';' dc_c\n"); yyerrok; yyclearin;}
	;

dc_v	: var vars ':' t_var ';' dc_v
	|
	;

t_var	: real
	| integer
	| error ';' {yyerror("t_var: real\n"); yyerrok; yyclearin;}
	;

vars	: id m_var
	| error ';' {yyerror("vars: id m_var\n"); yyerrok; yyclearin;}
	;

m_var	: ',' vars
	|
	| error ';' {yyerror("m_var: ',' vars\n"); yyerrok;yyclearin;}
	;

dc_p	: procedure id param ';' corpo_p dc_p
	|
	;

param	: '(' l_par ')'
	|
	| error ';' {yyerror("param: '(' l_par ')'\n"); yyerrok; yyclearin;}
	;

l_par	: vars ':' t_var m_par
	| error ';' {yyerror("l_par: vars ':' t_var m_par\n"); yyerrok; yyclearin; }
	;

m_par	: ';' l_par
	|
	| error ';' {yyerror("m_par: ';' l_par\n"); yyerrok; yyclearin;}
	;

corpo_p	: dc_loc begin cmds end ';'
	| error ';' {yyerror("corpo_p	: dc_loc begin cmds end ';'\n"); yyerrok; yyclearin;}
	;

dc_loc	: dc_v
	| error '\n' {yyerror("dc_loc: dc_v\n") ;yyerrok; yyclearin;}
	;

l_arg	: '(' args ')'
	| error ';' {yyerror("l_arg: '(' args ')'\n"); yyerrok;yyerrok; yyclearin;}
	|
	;

args	: id m_id
	| error ';' {yyerror("args: id m_id\n");yyerrok; yyclearin;}
	;

m_id	: ';' args
	|
	| error ';' {yyerror("m_id: ';' args\n"); yyerrok; yyclearin;}
	;

pfalsa	: t_else cmd

	;

cmds	: cmd ';' cmds
	|
	| error ';' {yyerror("cmds: cmd ';' cmds\n"); yyerrok; yyclearin;}
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
	| error ';' {yyerror("cond: exp rel exp\n"); yyerrok; yyclearin;}
	;

rel	: '='
	| '<' '>'
	| '>' '='
	| '>'
	| '<'
	| error ';' {yyerror("REL\n"); yyerrok; yyclearin;}
	;

exp	: termo ou_ter
	| error ';' {yyerror("exp : termo ou_ter\n"); yyerrok; yyclearin;}
	;

op_un	: '+'
	| '-'
	|
	| error ';' {yyerror("OP_UN\n"); yyerrok; yyclearin;}
	;

ou_ter	: op_ad termo ou_ter
	|
	;

op_ad	: '+'
	| '-'
	;

termo	: op_un fator m_fator
	| error '\n' {yyerror("termo	: op_un fator m_fatorn"); yyerrok; yyclearin;}
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

int main() {

	// open output file
	output = fopen("log.txt", "w");
	if (!output) {
		return -1;
	}
	fprintf(output, "Results:\n");

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


	return ret;
}

int  yyerror(char *s) {
	fprintf(stderr,"\n\n\t\t\t\tline: %d - error: %s\n\n\n", line_num, s);
	fprintf(output,"\nline: %d - %s on rule: ", line_num, s);
	return 1;
}
