%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
 
/* Flex yacces*/
int yylex(void);
extern FILE *yyin;
int yywrap(void) { return 1; }
 
/* número de línea para reportes */
int line_num = 1;
 
/* función auxiliar para imprimir token */
void print_tok(const char *toktype, const char *lexeme) {
    printf("%-12s %-30s %4d\n", toktype, lexeme, line_num);
}
 
/* lista simple de keywords de C (no exhaustiva, pero útil) */
const char *keywords[] = {
    "auto","break","case","char","const","continue","default","do","double",
    "else","enum","extern","float","for","goto","if","inline","int","long",
    "register","restrict","return","short","signed","sizeof","static","struct",
    "switch","typedef","union","unsigned","void","volatile","while","_Bool",
    "_Complex","_Imaginary", NULL
};
 
int is_keyword(const char *s) {
    for (int i = 0; keywords[i]; ++i)
        if (strcmp(s, keywords[i]) == 0) return 1;
    return 0;
}
%}
 
/* definiciones (atajos de patrones) */
DIGIT       [0-9]
INT_CONST   {DIGIT}+
FLOAT_CONST ({DIGIT}+"."{DIGIT}*([eE][+-]?{DIGIT}+)?)|({DIGIT}+[eE][+-]?{DIGIT}+)
ID          [A-Za-z_][A-Za-z0-9_]*
STRLIT      \"(\\.|[^"\\])*\"
CHARLIT     \'(\\.|[^'\\])\'
WS          [ \t\r]+
 
/* estados para comentario multilinea */
%x COMMENT
 
%%

{WS}                     { /* ignorar espacios -> no hacer nada */ }
 
"//".*                   { print_tok("COMMENT_LINE", yytext); /* '//' hasta fin linea */ }
 
"/*"                     { BEGIN(COMMENT); /* entrar a estado comentario */ }
 
\n                       { line_num++; }
 
{STRLIT}                 { print_tok("STRING", yytext); }
 
{CHARLIT}                { print_tok("CHAR", yytext); }
 
{FLOAT_CONST}            { print_tok("FLOAT_CONST", yytext); }
 
{INT_CONST}              { print_tok("INT_CONST", yytext); }
 
"=="|"!="|"<="|">="      { print_tok("OPERATOR", yytext); }
"<<"|">>"                { print_tok("OPERATOR", yytext); }
"++"|"--"                { print_tok("OPERATOR", yytext); }
 
"&&"|"||"                { print_tok("OPERATOR", yytext); }
 
"+"|"-"|"*"|"/"|"="|"%"  { print_tok("OPERATOR", yytext); }
 
"<"|">"|"!"|"~"|"^"|"|"  { print_tok("OPERATOR", yytext); }
 
"(" | ")" | "{" | "}" | "[" | "]" | ";" | "," | ":" | "." { print_tok("PUNCT", yytext); }
 
{ID}                     {
                            if (is_keyword(yytext)) print_tok("KEYWORD", yytext);
                            else print_tok("IDENT", yytext);
                         }
 
.                        { print_tok("UNKNOWN", yytext); }
 
%%
 
<COMMENT>{
    "*/"                 { BEGIN(INITIAL); print_tok("COMMENT_BLOCK", "/*...*/"); }
    \n                   { line_num++; }
    .                    { /* consumir y seguir en comentario */ }
}
 
%%
 
int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) { perror("fopen"); return 1; }
    }

    printf("%-12s %-30s %s\n", "TOKEN", "LEXEMA", "LINE");
    printf("--------------------------------------------------------\n");
    yylex();
    return 0;
}