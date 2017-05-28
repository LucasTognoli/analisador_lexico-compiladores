 /* Grupo 4 - Trabalho 2 - Analisador Lexico */

%option nounput yylineno
%option caseless
%{
#include "translate.tab.h"  // to get the token types that we return
int line_num = 1;
%}
%%

 /* variable name error*/
[0-9]+[_a-zA-Z]+[_a-zA-Z0-9]* {printf("Line %d - Lexical Error: Bad Identifier\n", line_num);}

 /* reserved words */
"begin"			{return begin;}
"end"			{return end;}
"if"			{return t_if;}
"then"			{return t_then;}
"else"			{return t_else;}
"procedure"		{return procedure;}
"program"		{return program;}
"read"			{return t_read;}
"write"     {return t_write;}
"var"			{return var;}
"const"			{return t_const;}
"real"			{return real;}
"integer"		{return integer;}

\n    { ++line_num;}

 /* comments */
"{"[^}]*"}"             {}
(\(\*)[^(\*\))]*(\*\))  {}
"//"[^\n]*		          {}

 /* identifiers */
[a-zA-Z][_a-zA-Z0-9]*	{return id;}

 /* out of range */
([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]+|214748364[8-9]|21474836[5-9][0-9]|2147483[7-9][0-9][0-9]|214748[4-9][0-9][0-9][0-9]|21474[9][0-9][0-9][0-9][0-9]|2147[5-9][0-9][0-9][0-9][0-9][0-9]|214[89][0-9][0-9][0-9][0-9][0-9][0-9]|21[5-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|2[2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|[3-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|-([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]+|2147483649|21474836[5-9][0-9]|2147483[7-9][0-9][0-9]|214748[4-9][0-9][0-9][0-9]|21474[9][0-9][0-9][0-9][0-9]|2147[5-9][0-9][0-9][0-9][0-9][0-9]|214[89][0-9][0-9][0-9][0-9][0-9][0-9]|21[5-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|2[2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|[3-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]))	{printf("Lexical Error: Integer out of range\n");}

 /* short int */
(12[0-7]|1[01][0-9]|[1-9]?[0-9])	{return numero_int;}

 /* small int */
(3276[0-7]|327[0-5]?[0-9]|32[0-6]?[0-9]?[0-9]|3[01]?[0-9]?[0-9]?[0-9]|[0-2][0-9]?[0-9]?[0-9]?[0-9])	{return numero_int;}

 /* long int */
(214748364[0-7]|21474836[0-3]?[0-9]|2147483[0-5]?[0-9]?[0-9]|214748[0-2]?[0-9]?[0-9]?[0-9]|21474[0-7]?[0-9]?[0-9]?[0-9]?[0-9]|2147[0-3]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]|214[0-6]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]|21[0-3]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]|2[0]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]|[01]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9])	{return numero_int;}

 /* int subrange */
 [0-9]*".."[0-9]*	{return subrange;}

 /* Error */
[+|-]*[_a-zA-Z0-9]*[@|$|&|{|}[|]|%|^]*[_a-zA-Z0-9]    {printf("Line %d - Lexical Error: Bad Number\n", line_num);}
"(*"    {printf("Line %d - Lexical Error\n", line_num);}
"*)"    {printf("Line %d - Lexical Error\n", line_num);}
[@|&|{|}[|]|%|^|$]    {printf("Line %d - Lexical Error: Forbidden Symbol\n", line_num);}
[_a-zA-Z0-9]        {printf("Line %d - Lexical Error\n", line_num);}
"{"[^}]*            {printf("Line %d - Lexical Error: Comment was not closed\n", line_num);}


 /* remove white space, new line and tab */
[ \t\n]   {}



 /* symbols */
.			{return *yytext;}

%%

int yywrap(void) {
	return 1;
}
