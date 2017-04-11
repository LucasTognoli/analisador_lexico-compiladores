/*
Grupo 4 - Trabalho 1
(Jessica, Leonardo e Lucas)
*/

#include <stdio.h>
#include <ctype.h>

extern int yylex();
extern int yylineno;
extern char* yytext;

char *names[] = {NULL, "reserved word", "comment", "type", "identifier", "num_shortint", "num_longint", "num_int_out_of_range",
				 "simb_assignment", "simb_not_equal", "simb_colon", "simb_semicolon", "simb_comma", "simb_point",
				 "simb_open_parenthesis", "simb_close_parenthesis", "simb_star", "simb_slash", "simb_backslash", "simb_plus",
				 "simb_minus", "simb_percentage", "simb_equal", "simb_single_quote", "simb_quote", "simb_less", "simb_greater", "error", "num_smallint"};

int main(void) 
{
	int ntoken;

	FILE *f;
    f = fopen("log.txt", "w");

	ntoken = yylex();

	while(ntoken) {
		//escreve no log de saída caso o token não seja de comentario
		if(ntoken != 2 && ntoken != 99){
			//usado para colocar tudo em lowercase
			for(int i = 0; yytext[i]; i++){
  				yytext[i] = tolower(yytext[i]);
			}
			//tratamento especia para palavras reservadas
			if(ntoken == 1){
				fprintf(f, "%s - %s\n\n", yytext, yytext);
			}
			else{
				fprintf(f, "%s - %s\n\n", yytext, names[ntoken]);
			}
		}

		ntoken = yylex();
	}

	fclose(f);

	return 0;
}

