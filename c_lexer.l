%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex(void);
extern FILE *yyin;
int yywrap(void) { return 1; }

int line_num = 1;

void print_tok(const char *toktype, const char *lexeme) {
    printf("%-12s %-30s %4d\n", toktype, lexeme, line_num);
}

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

/* definiciones */
DIGIT       [0-9]
INT_CONST   {DIGIT}+
FLOAT_CONST ({DIGIT}+"."{DIGIT}*([eE][+-]?{DIGIT}+)?)|({DIGIT}+[eE][+-]?{DIGIT}+)
ID          [A-Za-z_][A-Za-z0-9_]*
STRLIT      \"(\\.|[^"\\])*\"
CHARLIT     \'(\\.|[^'\\])\'
WS          [ \t\r]+

%x COMMENT

%%

{WS}                     { /* ignore whitespace */ }

"//".*                   { print_tok("COMMENT_LINE", yytext); }

"/*"                     { BEGIN(COMMENT); }

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

<COMMENT>"*/"             { BEGIN(INITIAL); print_tok("COMMENT_BLOCK", "/*...*/"); }
<COMMENT>\n               { line_num++; }
<COMMENT>.                { /* consume all other characters */ }

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
