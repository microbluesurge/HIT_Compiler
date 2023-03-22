%{
    #include"syntax.tab.h"
    #include"node.h"

    extern boolean lexError;
    int lines = 0;
    int yycolumn = 1;

    #define YY_USER_ACTION \
    yylloc.first_line=yylloc.last_line=yylineno; \
    yylloc.first_column=yycolumn; \
    yylloc.last_column=yycolumn+yyleng-1; \
    yycolumn+=yyleng;
%}

%option yylineno

SEMI ;
COMMA ,
ASSIGNOP =
RELOP >|<|>=|<=|==|!=
PLUS \+
MINUS -
STAR \*
DIV \/
AND &&
OR \|\|
DOT \.
NOT !
TYPE int|float
LP \(
RP \)
LB \[
RB \]
LC \{
RC \}
STRUCT struct
RETURN return
IF if
ELSE else
WHILE while
ID [_a-zA-Z][_a-zA-Z0-9]*
INT [0-9]|[1-9][0-9]*
OCT 0[0-7]|0[1-7][0-7]*
HEX 0[xX][0-9A-Fa-f]|0[xX][1-9A-Fa-f][0-9A-Fa-f]*
FLOAT [0-9]+\.[0-9]+|[0-9]*\.[0-9]+[Ee][+-]?[0-9]+

%%

{SEMI}     { yylval.node = newNode(yylineno, TOKEN_OTHER, "SEMI", yytext, 0); return SEMI;}
{COMMA}    { yylval.node = newNode(yylineno, TOKEN_OTHER, "COMMA", yytext, 0); return COMMA;}
{ASSIGNOP} { yylval.node = newNode(yylineno, TOKEN_OTHER, "ASSIGNOP", yytext, 0); return ASSIGNOP;}
{RELOP}    { yylval.node = newNode(yylineno, TOKEN_OTHER, "RELOP", yytext, 0); return RELOP;}
{PLUS}     { yylval.node = newNode(yylineno, TOKEN_OTHER, "PLUS", yytext, 0); return PLUS;}
{MINUS}    { yylval.node = newNode(yylineno, TOKEN_OTHER, "MINUS", yytext, 0); return MINUS;}
{STAR}     { yylval.node = newNode(yylineno, TOKEN_OTHER, "STAR", yytext, 0); return STAR;}
{DIV}      { yylval.node = newNode(yylineno, TOKEN_OTHER, "DIV", yytext, 0); return DIV;}
{AND}      { yylval.node = newNode(yylineno, TOKEN_OTHER, "AND", yytext, 0); return AND;}
{OR}       { yylval.node = newNode(yylineno, TOKEN_OTHER, "OR", yytext, 0); return OR;}
{DOT}      { yylval.node = newNode(yylineno, TOKEN_OTHER, "DOT", yytext, 0); return DOT;}
{NOT}      { yylval.node = newNode(yylineno, TOKEN_OTHER, "NOT", yytext, 0); return NOT;}
{TYPE}     { yylval.node = newNode(yylineno, TOKEN_TYPE, "TYPE", yytext, 0); return TYPE;}
{LP}       { yylval.node = newNode(yylineno, TOKEN_OTHER, "LP", yytext, 0); return LP;}
{RP}       { yylval.node = newNode(yylineno, TOKEN_OTHER, "RP", yytext, 0); return RP;}
{LB}       { yylval.node = newNode(yylineno, TOKEN_OTHER, "LB", yytext, 0); return LB;}
{RB}       { yylval.node = newNode(yylineno, TOKEN_OTHER, "RB", yytext, 0); return RB;}
{LC}       { yylval.node = newNode(yylineno, TOKEN_OTHER, "LC", yytext, 0); return LC;}
{RC}       { yylval.node = newNode(yylineno, TOKEN_OTHER, "RC", yytext, 0); return RC;}
{STRUCT}   { yylval.node = newNode(yylineno, TOKEN_OTHER, "STRUCT", yytext, 0); return STRUCT;}
{RETURN}   { yylval.node = newNode(yylineno, TOKEN_OTHER, "RETURN", yytext, 0); return RETURN;}
{IF}       { yylval.node = newNode(yylineno, TOKEN_OTHER, "IF", yytext, 0); return IF; }
{ELSE}     { yylval.node = newNode(yylineno, TOKEN_OTHER, "ELSE", yytext, 0); return ELSE;}
{WHILE}    { yylval.node = newNode(yylineno, TOKEN_OTHER, "WHILE", yytext, 0); return WHILE;}
{ID}       { yylval.node = newNode(yylineno, TOKEN_ID, "ID", yytext, 0); return ID;}
{INT}      { yylval.node = newNode(yylineno, TOKEN_INT, "INT", yytext, 0); return INT;}
{OCT}      { yylval.node = newNode(yylineno, TOKEN_INT, "OCT", yytext, 0); return INT;}
{HEX}      { yylval.node = newNode(yylineno, TOKEN_INT, "HEX", yytext, 0); return INT;}
{FLOAT}    { yylval.node = newNode(yylineno, TOKEN_FLOAT, "FLOAT", yytext, 0); return FLOAT;}
[\t\r\f ]+ {}
\n|\r      { yycolumn = 1;}
.          { lexError = TRUE; printf("Error type A at line %d: mysterious characters %s\n", yylineno, yytext);}
%%