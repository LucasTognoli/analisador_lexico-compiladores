%{
	#include<stdio.h>
}%

/* declaration */
%token program id begin end const var real integer procedure read write t_if t_then numero_int numero_real
%start prog

%% 
/* rules */
prog	: program id ';' corpo '.' ;

corpo	: dc begin cmds end ;

dc	: dc_c dc_v dc_p ;

dc_c	: const id '=' num ';' dc_c
	| ;

dc_v	: var vars ':' t_var ';' dc_v
	| ;

t_var	: real
	| integer
	;

vars	: id m_var ;

m_var	: ',' vars
	| ;

dc_p	: procedure id parm ';' corpo_p dc_p
	| ;

param	: '(' l_par ')'
	| ;

l_par	: vars ':' t_var m_par ;

m_par	: ';' l_par
	| ;

corpo_p	: dc_loc begin cmds end ';' ;

dc_loc	: dc_v ;

l_arg	: '(' args ')'
	| ;

args	: id m_id ;

m_id	: ';' args
	| ;

pfalsa	: else cmd
	| ;

cmds	: cmd ';' cmds
	| ;

cmd	: read '(' vars ')'
	| write '(' vars ')'
	| t_if cond t_then cmd pfalsa
	| id ':' '=' exp
	| id l_arg
	| begin cmds end ;

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

fator	: id
	| num
	| '(' exp ')' ;

num	: numero_int
	| numero_real ;
%%
/* programs */