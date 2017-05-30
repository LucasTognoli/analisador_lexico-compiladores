%{
#define YYDEBUG 1

#include <stdio.h>
#include <unistd.h>
int yydebug=0;
%}
/* declaration */
%debug
%token program id begin end t_const var real integer subrange semicolon
%token procedure t_read t_write t_if t_then numero_int numero_real t_else
%start prog

%%
/* rules */

prog	: program id semicolon corpo '.'
	| error program id semicolon corpo '.' {fprintf(stderr,"esperado 'program'\n"); yyerrok;yyclearin;}
	| program error semicolon corpo '.' {fprintf(stderr,"esperado identificador\n"); yyerrok;yyclearin;}
	| program id error corpo '.' {fprintf(stderr,"esperado ';'\n"); yyerrok;yyclearin;}
	| program id semicolon error '.' {fprintf(stderr,"esperado CORPO\n"); yyerrok;yyclearin;}
	| program id semicolon corpo error {fprintf(stderr,"esperado '.'\n"); yyerrok;yyclearin;}
	;

corpo	: dc begin cmds end
	| error begin cmds end {fprintf(stderr,"esperado dc\n");yyerrok;yyclearin;}
	| dc error cmds end {fprintf(stderr,"esperado 'begin'\n");yyerrok;yyclearin;}
	| dc begin error end {fprintf(stderr,"esperado comandos\n");yyerrok;yyclearin;}
	| dc begin cmds error {fprintf(stderr,"esperado 'end'\n");yyerrok;yyclearin;}
	;


dc	: dc_c dc_v dc_p
	| error dc_v dc_p {fprintf(stderr,"esperado DC_C\n");yyerrok;yyclearin;}
	| dc_c error dc_p {fprintf(stderr,"esperado DC_V\n");yyerrok;yyclearin;}
	| dc_c dc_v error {fprintf(stderr,"esperado DC_P\n");yyerrok;yyclearin;}
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
	| error m_var {fprintf(stderr,"esperado identificador\n"); yyerrok;}
	| id error {fprintf(stderr,"esperado mais variaveis\n"); yyerrok;}
	;

m_var	: ',' vars
	|
	| error vars {fprintf(stderr,"esperado ','\n"); yyerrok;}
	;

dc_p	: procedure id param semicolon corpo_p dc_p
	|
	| error id param semicolon corpo_p dc_p {fprintf(stderr,"esperado procedimento\n"); yyerrok;}
	| procedure error param semicolon corpo_p dc_p {fprintf(stderr,"esperado identificador\n"); yyerrok;}
	| procedure id error semicolon corpo_p dc_p {fprintf(stderr,"esperado parametros\n"); yyerrok;}
	| procedure id param error corpo_p dc_p {fprintf(stderr,"esperado ';'\n"); yyerrok;}
	| procedure id param semicolon error dc_p {fprintf(stderr,"esperado CORPO_P\n"); yyerrok;}
	| procedure id param semicolon corpo_p error {fprintf(stderr,"esperado DC_P\n"); yyerrok;}
	;

param	: '(' l_par ')'
	|
	| error {fprintf(stderr,"esperado L_PAR\n"); yyerrok; yyclearin;}
	;

l_par	: vars ':' t_var m_par
	| error ':' t_var m_par {fprintf(stderr,"esperado variaveis\n"); yyerrok;}
	| vars error t_var m_par {fprintf(stderr,"esperado ':'\n"); yyerrok;}
	| vars ':' error m_par {fprintf(stderr,"esperado T_VAR\n"); yyerrok;}
	| vars ':' t_var error {fprintf(stderr,"esperado M_PAR\n"); yyerrok;}
	
	;

m_par	: semicolon l_par
	|
	| error l_par {fprintf(stderr,"M_PAR - esperado ';'\n"); yyerrok;}
	| semicolon error {fprintf(stderr,"M_PAR - esperado L_PAR\n"); yyerrok;}
	;

corpo_p	: dc_loc begin cmds end semicolon
	| error begin cmds end semicolon {fprintf(stderr,"esperado DC_LOC\n"); yyerrok;}
	| dc_loc error cmds end semicolon {fprintf(stderr,"esperado 'begin'\n"); yyerrok;}
	| dc_loc begin error end semicolon {fprintf(stderr,"esperado comandos\n"); yyerrok;}
	| dc_loc begin cmds error semicolon {fprintf(stderr,"esperado 'end'\n"); yyerrok;}
	| dc_loc begin cmds end error {fprintf(stderr,"esperado ';'\n"); yyerrok;}
	;

dc_loc	: dc_v
	
	| error {fprintf(stderr,"esperado DC_V\n") ;yyerrok;}
	
	;

l_arg	: '(' args ')'
	| error {fprintf(stderr,"esperado argumentos\n"); yyerrok;yyerrok;}
	|
	
	;

args	: id m_id
	| error m_id {fprintf(stderr,"esperado identificador\n");yyerrok;}
	| id error {fprintf(stderr,"esperado mais identificadores\n");yyerrok;}
	;

m_id	: semicolon args
	|
	| error args {fprintf(stderr,"esperado ';'\n"); yyerrok;}
	;

pfalsa	: t_else cmd
	|
	;

cmds	: cmd semicolon cmds
	|
	| error semicolon cmds {fprintf(stderr,"esperado comandos\n"); yyerrok;}
	| cmd error cmds {fprintf(stderr,"esperado ';'\n"); yyerrok;}
	| cmd semicolon error {fprintf(stderr,"esperado comandos\n"); yyerrok;}
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
	| error rel exp {fprintf(stderr,"esperado expressão\n"); yyerrok;}
	| exp error exp {fprintf(stderr,"esperado relação\n"); yyerrok;}
	| exp rel error {fprintf(stderr,"esperado expressão\n"); yyerrok;}
	;

rel	: '='
	| '<' '>'
	| '>' '='
	| '>'
	| '<'
	| error {fprintf(stderr,"esperado relacao\n"); yyerrok; yyclearin;}
	;

exp	: termo ou_ter
	;

op_un	: '+'
	| '-'
	|
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

	fprintf(stderr, "Resultados:\n\n");

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
	printf("\n\nAperte ENTER para sair ... ");
	getchar();
	return ret;
}

int  yyerror(char *s) {
	fprintf(stderr,"\nLinha: %d - Erro Sintatico: ", line_num);
	return 1;
}

