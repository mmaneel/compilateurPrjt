%{
 
 #include "SyntaxiqueAnalyser.tab.h"
 #include <stdbool.h>
extern void yysuccess(char *s);
extern void yyerror(const char *s);
extern void showLexicalError();
extern int currentColumn;
%}

%option yylineno 
%option noyywrap

lettre  [a-zA-Z]      
chiffre [0-9]

IDF     [A-Za-z]({lettre}|{chiffre}|[_])*

INT     [-+]?{chiffre}+
STRING  \"[^\"]*\"
REAL    [+-]?{chiffre}+\.{chiffre}+ 
BOOL    (true|false)

COMMENTL        \/\/.*$
COMMENTMULTILINE      [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]

WHITESPACE         [[:space:]]+
  

RETURN return 
CONST  const
VAR    var
FOR    for
WHILE  while
EACH   each
IN     in
SCAN   scan
PRINT  print
FUN    fun
TO     to
PROG   prog
SWITCH switch
CASE   case
IMPORT import
IF     if
ELSE   else
ELSEIF elseif
LIST List


AND "&"
OR "|"
EQUALS "=="
LESS "<"
LESSEQUALS "<="
GREATER ">"
GREATEREQUALS ">="
NOTEQUALS "!=="
NEG "^"

ADD "+"
SUB "-"
MUL "*"
MOD "%"
DIV "/"
INC "++"
DEC "--"
ADDEQUALS "+="
SUBEQUALS "-="

IntType INT
StringType STRING
RealType REAL
BoolType BOOL

virgule ","
import  "##"
Affectation "="
crochetouvrant "["
crochetfermant "]"
parentheseouvrante "("
parenthesefermante ")"           
acolladeouvrante "{"
acolladefermante "}"
deuxpoints ":"

%%
{IntType} {
    yysuccess("INT TYPE");
    yylval.type = TYPE_INTEGER;
    return IntType;
}
{StringType} {
    yysuccess("STRING TYPE");
    yylval.type = TYPE_STRING;
    return StringType;
}
{RealType} {
    yysuccess("FLOAT TYPE");
    yylval.type = TYPE_FLOAT;
    return RealType;
}
{BoolType} {
    yysuccess("BOOLEAN TYPE");
    yylval.type = TYPE_BOOLEAN;
    return BoolType;
}
{CONST} {
    yysuccess("CONST");
    yylval.isConstant = true;
    return CONST;
}
{PROG} 	      {yysuccess("PROG"); return PROG;}							
{VAR}		  {yysuccess("VAR"); return VAR;}				
{IMPORT}  	  {yysuccess("IMPORT"); return IMPORT;}
{CASE}  	  {yysuccess("CASE"); return CASE;}
{SWITCH}  	  {yysuccess("SWITCH"); return SWITCH;}
{TO}  		  {yysuccess("TO"); return TO;}
{FUN}  		  {yysuccess("FUN"); return FUN;}
{RETURN}  	  {yysuccess("RETURN"); return RETURN;}

{WHILE}  	  {yysuccess("WHILE"); return WHILE;}
{FOR}  		  {yysuccess("FOR"); return FOR;}
{IF}  		  {yysuccess("IF"); return IF;}
{PRINT}  	  {yysuccess("PRINT"); return PRINT;}
{SCAN}  	  {yysuccess("SCAN"); return SCAN;}
{IN}  		  {yysuccess("IN"); return IN;}
{EACH}  	  {yysuccess("EACH"); return EACH;}
{ELSE}  	  {yysuccess("ELSE"); return ELSE;}
{ELSEIF}  	  {yysuccess("ELSEIF"); return ELSEIF;}
{LIST}        {yysuccess("LIST");return LIST;}
{OR}  		  {yysuccess("OR"); return OR;}
{EQUALS}  	  {yysuccess("EQUALS"); return EQUALS;}
{NEG}  		  {yysuccess("NEG"); return NEG;}
{LESS}  	  {yysuccess("LESS"); return LESS;}
{LESSEQUALS}  {yysuccess("LESSEQUALS"); return LESSEQUALS;}
{GREATER}  	  {yysuccess("GREATER"); return GREATER;}
{GREATEREQUALS}  {yysuccess("GREATEREQUALS"); return GREATEREQUALS;}
{NOTEQUALS}  	 {yysuccess("NOTEQUALS"); return NOTEQUALS;}


{IDF}      {
yysuccess("IDF"); 
    strcpy(yylval.identifier, yytext);
return IDF;}
{INT}    {
    yysuccess("INT");
    yylval.integerValue = atoi(yytext);
    return INT;
}
{STRING}  {
    yysuccess("STRING");
    strcpy(yylval.stringValue, yytext);
    return STRING;
}
{REAL}  {
    yysuccess("REAL");
    yylval.floatValue = strtod(yytext, NULL);
    return REAL;
}
{BOOL}    {
    yysuccess("BOOLEAN");
    if(!strcmp(yytext, "true")){
        yylval.booleanValue = true;
    }else{
        yylval.booleanValue = false;
    }
    return BOOL;
}

						



{COMMENTL} {}
{ADD}      {yysuccess("ADD"); return ADD;}
{SUB}      {yysuccess("SUB"); return SUB;} 				    
{MUL}      {yysuccess("MUL"); return MUL;} 
{DIV}      {yysuccess("DIV"); return DIV;} 
{MOD}      {yysuccess("MOD"); return MOD;} 		
{INC}      {yysuccess("INC"); return INC;} 
{DEC}      {yysuccess("DEC"); return DEC;} 
{ADDEQUALS} {yysuccess("ADDEQUALS"); return ADDEQUALS;} 
{SUBEQUALS} {yysuccess("SUBEQUALS"); return SUBEQUALS;} 

{COMMENTMULTILINE} {}                
{WHITESPACE}  {}
{virgule} 	  {yysuccess("virgule"); return virgule;}

{Affectation}           {yysuccess("Affectation"); return Affectation;}
{crochetouvrant}        {yysuccess("crochetouvrant"); return crochetouvrant;}
{crochetfermant}        {yysuccess("crochetfermant"); return crochetfermant;}
{parentheseouvrante} 	{yysuccess("parentheseouvrante"); return parentheseouvrante;}
{parenthesefermante} 	{yysuccess("parenthesefermante"); return parenthesefermante;}             
{acolladeouvrante}      {yysuccess("acolladeouvrante"); return acolladeouvrante;}
{acolladefermante} 		{yysuccess("acolladefermante"); return acolladefermante;}
{deuxpoints} 	{yysuccess("deuxpoints"); return deuxpoints;}




<<EOF>> yyterminate();

. {
    yyerror("Unexpected token");
    showLexicalError();
    yyterminate();
    }

%%
