%define parse.error verbose

%{
#define simpleToArrayOffset 4
#define YYDEBUG 1
#define RESET "\033[0m"
#define RED "\033[31m"     
#define MAGENTA "\033[35m"
#define GREEN "\033[32m" 
%}

%code requires{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include "semantic.h"
#include "tableSymboles.h"
#include "quadruplets.h"
#include "pile.h"
#include "list.h"
}

%union{
    char identifier[255];
    int type;
    int integerValue;
    double floatValue;
    bool booleanValue;
    bool isConstant;
    char stringValue[255];
    symbole * symbole;
    expression expression;
    variable variable;
}




/* token definition */

%token <type> IntType StringType RealType BoolType  
%token RETURN
%token CONST
%token VAR
%token FOR
%token WHILE
%token IF
%token ELSE
%token ELSEIF
%token EACH
%token IN
%token SCAN
%token PRINT
%token FUN
%token TO
%token PROG
%token SWITCH
%token CASE
%token IMPORT
%token LIST

%token lettre
%token chiffre

%token <identifier> IDF

%token <integerValue> INT
%token <stringValue> STRING
%token <floatValue > REAL
%token <booleanValue> BOOL

%token ADD
%token SUB
%token MUL
%token MOD
%token DIV
%token INC
%token DEC
%token ADDEQUALS
%token SUBEQUALS



%token EQUALS
%token NEG
%token NOTEQUALS
%token LESS
%token LESSEQUALS
%token GREATER
%token GREATEREQUALS
%token DOUBLEEQUALS
%token AND
%token OR

%token COMMENTL
%token COMMENTMULTILINE
%token WHITESPACE
%token virgule
%token Affectation
%token crochetouvrant
%token crochetfermant
%token parentheseouvrante
%token parenthesefermante
%token acolladeouvrante
%token acolladefermante
%token deuxpoints


%left COMA
%left OR
%left AND
%left NEG

%nonassoc Affectation EQUALS LESS GREATER LESSEQUALS GREATEREQUALS
%nonassoc NOTEQUALS ADDEQUALS SUBEQUALS 
%left ADD SUB
%left MULT DIV MOD

%type <type> SimpleType;
%type <symbole> DeclarationSimple;
%type <symbole> DeclarationInitial;
%type <expression> Expression;
%type <variable> Variable;
%type <expression> Valeur;
%type <tableau> Tableau;

%{
extern FILE *yyin;
extern int yylineno;
extern int yyleng;
extern int yylex();

char* file = "test.txt";

int currentColumn = 1;
symbole * tableSymboles = NULL;

pile * stack;
quad * q;
int qc = 1;

bool isForLoop = false;
bool hasFailed = false;
qFifo * quadFifo;

void yysuccess(char *s);
void yyerror(const char *s);
void yyerrorSemantic(char *s);
void showLexicalError();

%}



%%
ProgrammePrincipal: %empty
    | PROG IDF acolladeouvrante  Bloc acolladefermante
    ;
Fonction:
    FUN IDF parentheseouvrante Parametres parenthesefermante  acolladeouvrante Bloc acolladefermante 
    ; 
Parametres: %empty
    | IDF Parametre
    ; 
Parametre: %empty
    | virgule IDF Parametre
    
Bloc: %empty
    | Statement Bloc
    ; 

SimpleType:
    IntType { $$ = TYPE_INTEGER; }
    | RealType { $$ = TYPE_FLOAT; }
    | StringType{ $$ = TYPE_STRING; }
    | BoolType{ $$ = TYPE_BOOLEAN; }
       
Expression:
    parentheseouvrante Expression parenthesefermante{
            $$=$2;
    }

    | Expression ADD Expression {
            if($1.type == $3.type){
                    if($1.type == TYPE_STRING)
                    {
                        strcpy($$.stringValue,$1.stringValue);
                        strcat($$.stringValue,$3.stringValue);

                        char qcString[20];
                        sprintf(qcString, "%s%d", "R",qc);
                        strcpy($$.nameVariable,qcString);
                        $$.isVariable=true;
                        if($1.isVariable == true & $3.isVariable == true)
                        {
                            insererQuadreplet(&q, "ADD",$1.nameVariable, $3.nameVariable, qcString, qc);
                        }
                        else
                        {
                            if($1.isVariable == true)
                            {
                                insererQuadreplet(&q, "ADD",$1.nameVariable, $3.stringValue, qcString, qc);
                            }
                            else
                            {
                                if($3.isVariable == true)
                                {
                                    insererQuadreplet(&q, "ADD",$1.stringValue, $3.nameVariable, qcString, qc);
                                }
                                else
                                {
                                    insererQuadreplet(&q, "ADD",$1.stringValue, $3.stringValue, qcString, qc);
                                }
                            }
                        }
                        qc++;
                    }
                    else{
                        if($1.type == TYPE_INTEGER)
                        {
                            $$.integerValue=$1.integerValue+$3.integerValue;

                            char buff[255];
                            char buff2[255];
                            char qcString[20];
                            sprintf(qcString, "%s%d", "R",qc);
                            strcpy($$.nameVariable,qcString);
                            $$.isVariable=true;
                            if($1.isVariable == true & $3.isVariable == true)
                            {
                                insererQuadreplet(&q, "ADD",$1.nameVariable, $3.nameVariable, qcString, qc);
                            }
                            else
                            {
                                if($1.isVariable == true)
                                {
                                    sprintf(buff2, "%d", $3.integerValue);
                                    insererQuadreplet(&q, "ADD",$1.nameVariable, buff2, qcString, qc);
                                }
                                else
                                {
                                    if($3.isVariable == true)
                                    {
                                        sprintf(buff, "%d", $1.integerValue);
                                        insererQuadreplet(&q, "ADD",buff, $3.nameVariable, qcString, qc);
                                    }
                                    else
                                    {
                                        sprintf(buff, "%d", $1.integerValue);
                                        sprintf(buff2, "%d", $3.integerValue);
                                        insererQuadreplet(&q, "ADD",buff, buff2,qcString, qc);
                                    }
                                }
                            }
                            qc++;
                        }
                        else {
                            if($1.type == TYPE_FLOAT)
                            {
                                $$.floatValue=$1.floatValue+$3.floatValue;
                                
                                char buff[255];
                                char buff2[255];
                                char qcString[20];
                                sprintf(qcString, "%s%d", "R",qc);
                                strcpy($$.nameVariable,qcString);
                                $$.isVariable=true;
                                if($1.isVariable == true & $3.isVariable == true)
                                {
                                    insererQuadreplet(&q, "ADD",$1.nameVariable, $3.nameVariable, qcString, qc);
                                }
                                else
                                {
                                    if($1.isVariable == true)
                                    {
                                        sprintf(buff2, "%f", $3.floatValue);
                                        insererQuadreplet(&q, "ADD",$1.nameVariable, buff2, qcString, qc);
                                    }
                                    else
                                    {
                                        if($3.isVariable == true)
                                        {
                                            sprintf(buff, "%f", $1.floatValue);
                                            insererQuadreplet(&q, "ADD",buff, $3.nameVariable, qcString, qc);
                                        }
                                        else
                                        {
                                            sprintf(buff, "%f", $1.floatValue);
                                            sprintf(buff2, "%f", $3.floatValue);
                                            insererQuadreplet(&q, "ADD",buff, buff2,qcString, qc);
                                        }
                                    }
                                }
                                qc++;
                            }
                            else
                            {
                                if($1.type == TYPE_BOOLEAN)
                                {
                                    $$.type=TYPE_BOOLEAN;
                                    if(($1.booleanValue) || ($3.booleanValue))
                                    {
                                        $$.booleanValue=true;
                                    }
                                    else
                                    {
                                        $$.booleanValue=false;
                                    };

                                    char buff[255];
                                    char buff2[255];
                                    char qcString[20];
                                    sprintf(qcString, "%s%d", "R",qc);
                                    strcpy($$.nameVariable,qcString);
                                    $$.isVariable=true;
                                    if($1.isVariable == true & $3.isVariable == true)
                                    {
                                        insererQuadreplet(&q, "ADD",$1.nameVariable, $3.nameVariable, qcString, qc);
                                    }
                                    else
                                    {
                                        if($1.isVariable == true)
                                        {
                                            strcpy(buff, ($3.booleanValue == true) ? "true" : "false");
                                            insererQuadreplet(&q, "ADD",$1.nameVariable, buff, qcString, qc);
                                        }
                                        else
                                        {
                                            if($3.isVariable == true)
                                            {
                                                strcpy(buff, ($1.booleanValue == true) ? "true" : "false");
                                                insererQuadreplet(&q, "ADD",buff, $3.nameVariable, qcString, qc);
                                            }
                                            else
                                            {
                                                strcpy(buff, ($1.booleanValue == true) ? "true" : "false");
                                                strcpy(buff2, ($3.booleanValue == true) ? "true" : "false");
                                                insererQuadreplet(&q, "ADD",buff, buff2,qcString, qc);
                                            }
                                        }
                                    }
                                    qc++;
                                }
                            }
                        }
                    }
            }
            else
            {
                yyerrorSemantic( "Incompatibilité de types");
            }
    }
    | Variable{
        if($1.symbole != NULL){
            char valeurString[255];
            char nameString[255];
            $$.isVariable = true;
            if($1.symbole->type < simpleToArrayOffset){
                getNom($1.symbole, nameString);
                strcpy($$.nameVariable, nameString);
                getValeur($1.symbole, valeurString);
                switch ($1.symbole->type){
                    case TYPE_INTEGER:
                        $$.integerValue = atoi(valeurString);
                        $$.type = TYPE_INTEGER;
                        break;
                    case TYPE_FLOAT:
                        $$.integerValue = atof(valeurString);
                        $$.type = TYPE_FLOAT;
                        break;
                    case TYPE_STRING:
                        strcpy($$.stringValue, valeurString);
                        $$.type = TYPE_STRING;
                        break;
                    case TYPE_BOOLEAN:
                        $$.booleanValue = strcmp(valeurString, "true") == 0;
                        $$.type = TYPE_BOOLEAN;
                        break;
                    default :
                        $$.type = -1;
                        break;
                    }
            }
        }
    }
    | Expression LESS Expression {
            if($1.type == $3.type){
                    $$.type=TYPE_BOOLEAN;
                        if($1.type == TYPE_STRING)
                        {
                            if(strcmp($1.stringValue,$3.stringValue)< 0)
                            {
                                $$.booleanValue=true;
                            }
                            else{
                                $$.booleanValue=false;
                            }
                            char buff[255];
                            char buff2[255];
                            char qcString[20];
                            sprintf(qcString, "%s%d", "R",qc);
                            strcpy($$.nameVariable,qcString);
                            $$.isVariable=true;
                            if($1.isVariable == true && $3.isVariable == true)
                            {
                                insererQuadreplet(&q, "LT",$1.nameVariable, $3.nameVariable,qcString, qc);
                            }
                            else
                            {
                                if($1.isVariable==true)
                                {
                                    strcpy(buff2, $3.stringValue);
                                    insererQuadreplet(&q, "LT",$1.nameVariable, buff2,qcString, qc);
                                }
                                else
                                {
                                    if($3.isVariable==true)
                                    {
                                        strcpy(buff, $1.stringValue);
                                        insererQuadreplet(&q, "LT",buff, $3.nameVariable,qcString, qc);
                                    }
                                    else
                                    {
                                        strcpy(buff, $1.stringValue);
                                        strcpy(buff2, $3.stringValue);
                                        insererQuadreplet(&q, "LT",buff, buff2,qcString, qc);
                                    }
                                }
                            }
                            qc++;
                        }
                        else{
                            if($1.type == TYPE_INTEGER)
                            {
                                if($1.integerValue < $3.integerValue)
                                {
                                    $$.booleanValue=true;
                                }
                                else{
                                    $$.booleanValue=false;
                                }
                                char buff[255];
                                char buff2[255];
                                char qcString[20];
                                sprintf(qcString, "%s%d", "R",qc);
                                strcpy($$.nameVariable,qcString);
                                $$.isVariable=true;
                                if($1.isVariable == true && $3.isVariable == true)
                                {
                                    insererQuadreplet(&q, "LT",$1.nameVariable, $3.nameVariable,qcString, qc);
                                }
                                else
                                {
                                    if($1.isVariable==true)
                                    {
                                        sprintf(buff2, "%d", $3.integerValue);
                                        insererQuadreplet(&q, "LT",$1.nameVariable, buff2,qcString, qc);
                                    }
                                    else
                                    {
                                        if($3.isVariable==true)
                                        {
                                            sprintf(buff, "%d", $1.integerValue);
                                            insererQuadreplet(&q, "LT",buff, $3.nameVariable,qcString, qc);
                                        }
                                        else
                                        {
                                            sprintf(buff, "%d", $1.integerValue);
                                            sprintf(buff2, "%d", $3.integerValue);
                                            insererQuadreplet(&q, "LT",buff, buff2,qcString, qc);
                                        }
                                    }
                                }
                                qc++;
                            }
                            else {
                                if($1.type == TYPE_FLOAT)
                                {
                                    if($1.floatValue < $3.floatValue)
                                    {
                                        $$.booleanValue=true;
                                    }
                                    else{
                                        $$.booleanValue=false;
                                    }
                                    char buff[255];
                                    char buff2[255];
                                    char qcString[20];
                                    sprintf(qcString, "%s%d", "R",qc);
                                    strcpy($$.nameVariable,qcString);
                                    $$.isVariable=true;
                                    if($1.isVariable == true && $3.isVariable == true)
                                    {
                                        insererQuadreplet(&q, "LT",$1.nameVariable, $3.nameVariable,qcString, qc);
                                    }
                                    else
                                    {
                                        if($1.isVariable==true)
                                        {
                                            sprintf(buff2, "%f", $3.floatValue);
                                            insererQuadreplet(&q, "LT",$1.nameVariable, buff2,qcString, qc);
                                        }
                                        else
                                        {
                                            if($3.isVariable==true)
                                            {
                                                sprintf(buff, "%f", $1.floatValue);
                                                insererQuadreplet(&q, "LT",buff, $3.nameVariable,qcString, qc);
                                            }
                                            else
                                            {
                                                sprintf(buff, "%f", $1.floatValue);
                                                sprintf(buff2, "%f", $3.floatValue);
                                                insererQuadreplet(&q, "LT",buff, buff2,qcString, qc);
                                            }
                                        }
                                    }
                                    qc++;
                                }
                            }
                        }   
            }
            else
            {
                yyerrorSemantic( "Incompatibilité de types");
            }
    }
    | ADD Expression {
        if($2.type==NULL){
          yyerrorSemantic( "expression est ulle dans 420");

        }
            if($2.type != TYPE_STRING)
            {
                if($2.type == TYPE_INTEGER)
                {
                    $$.type=TYPE_INTEGER;
                    $$.integerValue=0+$2.integerValue;
                }
                else
                {
                    if($2.type == TYPE_FLOAT)
                    {
                        $$.type=TYPE_FLOAT;
                        $$.floatValue=0.0+$2.floatValue;
                    }
                }
            }
            else{
                yyerrorSemantic( "Expression non numérique détectée");
            }
    }
    | Expression LESS Expression {
            if($1.type == $3.type){
                    $$.type=TYPE_BOOLEAN;
                        if($1.type == TYPE_STRING)
                        {
                            if(strcmp($1.stringValue,$3.stringValue)< 0)
                            {
                                $$.booleanValue=true;
                            }
                            else{
                                $$.booleanValue=false;
                            }
                            char buff[255];
                            char buff2[255];
                            char qcString[20];
                            sprintf(qcString, "%s%d", "R",qc);
                            strcpy($$.nameVariable,qcString);
                            $$.isVariable=true;
                            if($1.isVariable == true && $3.isVariable == true)
                            {
                                insererQuadreplet(&q, "LT",$1.nameVariable, $3.nameVariable,qcString, qc);
                            }
                            else
                            {
                                if($1.isVariable==true)
                                {
                                    strcpy(buff2, $3.stringValue);
                                    insererQuadreplet(&q, "LT",$1.nameVariable, buff2,qcString, qc);
                                }
                                else
                                {
                                    if($3.isVariable==true)
                                    {
                                        strcpy(buff, $1.stringValue);
                                        insererQuadreplet(&q, "LT",buff, $3.nameVariable,qcString, qc);
                                    }
                                    else
                                    {
                                        strcpy(buff, $1.stringValue);
                                        strcpy(buff2, $3.stringValue);
                                        insererQuadreplet(&q, "LT",buff, buff2,qcString, qc);
                                    }
                                }
                            }
                            qc++;
                        }
                        else{
                            if($1.type == TYPE_INTEGER)
                            {
                                if($1.integerValue < $3.integerValue)
                                {
                                    $$.booleanValue=true;
                                }
                                else{
                                    $$.booleanValue=false;
                                }
                                char buff[255];
                                char buff2[255];
                                char qcString[20];
                                sprintf(qcString, "%s%d", "R",qc);
                                strcpy($$.nameVariable,qcString);
                                $$.isVariable=true;
                                if($1.isVariable == true && $3.isVariable == true)
                                {
                                    insererQuadreplet(&q, "LT",$1.nameVariable, $3.nameVariable,qcString, qc);
                                }
                                else
                                {
                                    if($1.isVariable==true)
                                    {
                                        sprintf(buff2, "%d", $3.integerValue);
                                        insererQuadreplet(&q, "LT",$1.nameVariable, buff2,qcString, qc);
                                    }
                                    else
                                    {
                                        if($3.isVariable==true)
                                        {
                                            sprintf(buff, "%d", $1.integerValue);
                                            insererQuadreplet(&q, "LT",buff, $3.nameVariable,qcString, qc);
                                        }
                                        else
                                        {
                                            sprintf(buff, "%d", $1.integerValue);
                                            sprintf(buff2, "%d", $3.integerValue);
                                            insererQuadreplet(&q, "LT",buff, buff2,qcString, qc);
                                        }
                                    }
                                }
                                qc++;
                            }
                            else {
                                if($1.type == TYPE_FLOAT)
                                {
                                    if($1.floatValue < $3.floatValue)
                                    {
                                        $$.booleanValue=true;
                                    }
                                    else{
                                        $$.booleanValue=false;
                                    }
                                    char buff[255];
                                    char buff2[255];
                                    char qcString[20];
                                    sprintf(qcString, "%s%d", "R",qc);
                                    strcpy($$.nameVariable,qcString);
                                    $$.isVariable=true;
                                    if($1.isVariable == true && $3.isVariable == true)
                                    {
                                        insererQuadreplet(&q, "LT",$1.nameVariable, $3.nameVariable,qcString, qc);
                                    }
                                    else
                                    {
                                        if($1.isVariable==true)
                                        {
                                            sprintf(buff2, "%f", $3.floatValue);
                                            insererQuadreplet(&q, "LT",$1.nameVariable, buff2,qcString, qc);
                                        }
                                        else
                                        {
                                            if($3.isVariable==true)
                                            {
                                                sprintf(buff, "%f", $1.floatValue);
                                                insererQuadreplet(&q, "LT",buff, $3.nameVariable,qcString, qc);
                                            }
                                            else
                                            {
                                                sprintf(buff, "%f", $1.floatValue);
                                                sprintf(buff2, "%f", $3.floatValue);
                                                insererQuadreplet(&q, "LT",buff, buff2,qcString, qc);
                                            }
                                        }
                                    }
                                    qc++;
                                }
                            }
                        }   
            }
            else
            {
                yyerrorSemantic( "Incompatibilité de types");
            }
    }
    | Expression MUL Expression {
            if($1.type == $3.type){
                    if($1.type == TYPE_STRING)
                    {
                        yyerrorSemantic( "Type mismatch");
                    }
                    else{
                        if($1.type == TYPE_INTEGER)
                        {
                            $$.integerValue=$1.integerValue * $3.integerValue;

                            char buff[255];
                            char buff2[255];
                            char qcString[20];
                            sprintf(qcString, "%s%d", "R",qc);
                            strcpy($$.nameVariable,qcString);
                            $$.isVariable=true;
                            if($1.isVariable == true & $3.isVariable == true)
                            {
                                insererQuadreplet(&q, "MUL",$1.nameVariable, $3.nameVariable, qcString, qc);
                            }
                            else
                            {
                                if($1.isVariable == true)
                                {
                                    sprintf(buff2, "%d", $3.integerValue);
                                    insererQuadreplet(&q, "MUL",$1.nameVariable, buff2, qcString, qc);
                                }
                                else
                                {
                                    if($3.isVariable == true)
                                    {
                                        sprintf(buff, "%d", $1.integerValue);
                                        insererQuadreplet(&q, "MUL",buff, $3.nameVariable, qcString, qc);
                                    }
                                    else
                                    {
                                        sprintf(buff, "%d", $1.integerValue);
                                        sprintf(buff2, "%d", $3.integerValue);
                                        insererQuadreplet(&q, "MUL",buff, buff2,qcString, qc);
                                    }
                                }
                            }
                            qc++;
                        }
                        else {
                            if($1.type == TYPE_FLOAT)
                            {
                                $$.floatValue=$1.floatValue * $3.floatValue;

                                char buff[255];
                                char buff2[255];
                                char qcString[20];
                                sprintf(qcString, "%s%d", "R",qc);
                                strcpy($$.nameVariable,qcString);
                                $$.isVariable=true;
                                if($1.isVariable == true & $3.isVariable == true)
                                {
                                    insererQuadreplet(&q, "MUL",$1.nameVariable, $3.nameVariable, qcString, qc);
                                }
                                else
                                {
                                    if($1.isVariable == true)
                                    {
                                        sprintf(buff2, "%f", $3.floatValue);
                                        insererQuadreplet(&q, "MUL",$1.nameVariable, buff2, qcString, qc);
                                    }
                                    else
                                    {
                                        if($3.isVariable == true)
                                        {
                                            sprintf(buff, "%f", $1.floatValue);
                                            insererQuadreplet(&q, "MUL",buff, $3.nameVariable, qcString, qc);
                                        }
                                        else
                                        {
                                            sprintf(buff, "%f", $1.floatValue);
                                            sprintf(buff2, "%f", $3.floatValue);
                                            insererQuadreplet(&q, "MUL",buff, buff2,qcString, qc);
                                        }
                                    }
                                }
                                qc++;
                            }
                            else
                            {
                                if($1.type == TYPE_BOOLEAN)
                                {
                                    $$.type=TYPE_BOOLEAN;
                                    if(($1.booleanValue) && ($3.booleanValue))
                                    {
                                        $$.booleanValue=true;
                                    }
                                    else
                                    {
                                        $$.booleanValue=false;
                                    };

                                    char buff[255];
                                    char buff2[255];
                                    char qcString[20];
                                    sprintf(qcString, "%s%d", "R",qc);
                                    strcpy($$.nameVariable,qcString);
                                    $$.isVariable=true;
                                    if($1.isVariable == true & $3.isVariable == true)
                                    {
                                        insererQuadreplet(&q, "MUL",$1.nameVariable, $3.nameVariable, qcString, qc);
                                    }
                                    else
                                    {
                                        if($1.isVariable == true)
                                        {
                                            strcpy(buff, ($3.booleanValue == true) ? "true" : "false");
                                            insererQuadreplet(&q, "MUL",$1.nameVariable, buff, qcString, qc);
                                        }
                                        else
                                        {
                                            if($3.isVariable == true)
                                            {
                                                strcpy(buff, ($1.booleanValue == true) ? "true" : "false");
                                                insererQuadreplet(&q, "MUL",buff, $3.nameVariable, qcString, qc);
                                            }
                                            else
                                            {
                                                strcpy(buff, ($1.booleanValue == true) ? "true" : "false");
                                                strcpy(buff2, ($3.booleanValue == true) ? "true" : "false");
                                                insererQuadreplet(&q, "MUL",buff, buff2,qcString, qc);
                                            }
                                        }
                                    }
                                    qc++;
                                }
                            }
                        }
                    }
            }
            else
            {
                yyerrorSemantic( "Incompatibilité de types");
            }
    }
    | Expression DIV Expression {
            if($1.type == $3.type){
                    if((($3.type == TYPE_INTEGER) && ($3.integerValue == 0)) || (($3.type == TYPE_FLOAT) && ($3.floatValue == 0.0)))
                    {
                        yyerrorSemantic( "Division by zero");
                    }
                    else
                    {
                        if($1.type == TYPE_STRING)
                        {
                            yyerrorSemantic( "Incompatibilité de types");
                        }
                        else{
                            if($1.type == TYPE_INTEGER)
                            {
                                $$.integerValue=$1.integerValue / $3.integerValue;

                                char buff[255];
                                char buff2[255];
                                char qcString[20];
                                sprintf(qcString, "%s%d", "R",qc);
                                strcpy($$.nameVariable,qcString);
                                $$.isVariable=true;
                                if($1.isVariable == true && $3.isVariable == true)
                                    {
                                        insererQuadreplet(&q, "DIV",$1.nameVariable, $3.nameVariable,qcString, qc);
                                        qc++;
                                    }
                                    else
                                    {
                                        if($1.isVariable == true)
                                        {
                                            sprintf(buff2, "%d", $3.integerValue);
                                            insererQuadreplet(&q, "DIV",$1.nameVariable, buff2,qcString, qc);
                                            qc++;
                                        }
                                        else
                                        {
                                            if($3.isVariable == true)
                                            {
                                                sprintf(buff, "%d", $1.integerValue);
                                                insererQuadreplet(&q, "DIV",buff, $3.nameVariable,qcString, qc);
                                                qc++;
                                            }
                                            else
                                            {
                                                sprintf(buff, "%d", $1.integerValue);
                                                sprintf(buff2, "%d", $3.integerValue);
                                                sprintf(qcString, "%s%d", "R",qc);
                                                insererQuadreplet(&q, "DIV",buff, buff2,qcString, qc);
                                                qc++;   
                                            }
                                        }
                                    }
                                
                            }
                            else {
                                if($1.type == TYPE_FLOAT)
                                {
                                    $$.floatValue=$1.floatValue / $3.floatValue;
                                char buff2[255];
                                char buff[255];
                                char qcString[20];
                                sprintf(qcString, "%s%d", "R",qc);
                                strcpy($$.nameVariable,qcString);
                                $$.isVariable=true;
                                if($1.isVariable == true && $3.isVariable == true)
                                    {
                                        insererQuadreplet(&q, "DIV",$1.nameVariable, $3.nameVariable,qcString, qc);
                                        qc++;
                                    }
                                    else
                                    {
                                        if($1.isVariable == true)
                                        {
                                            sprintf(buff2, "%f", $3.floatValue);
                                            insererQuadreplet(&q, "DIV",$1.nameVariable, buff2,qcString, qc);
                                            qc++;
                                        }
                                        else
                                        {
                                            if($3.isVariable == true)
                                            {
                                                sprintf(buff, "%f", $1.floatValue);
                                                insererQuadreplet(&q, "DIV",buff, $3.nameVariable,qcString, qc);
                                                qc++;
                                            }
                                            else
                                            {
                                                sprintf(buff, "%f", $1.floatValue);
                                                sprintf(buff2, "%f", $3.floatValue);
                                                sprintf(qcString, "%s%d", "R",qc);
                                                insererQuadreplet(&q, "DIV",buff, buff2,qcString, qc);
                                                qc++;   
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
            else
            {
                yyerrorSemantic( "Type mismatch");
            }
    }
    | INT { $$.type = TYPE_INTEGER; $$.integerValue = $1; }
    | REAL { $$.type = TYPE_FLOAT; $$.floatValue = $1; }
    | STRING{ $$.type = TYPE_STRING; strcpy($$.stringValue, $1); }
    | BOOL { $$.type = TYPE_BOOLEAN; $$.booleanValue = $1; }

Operateur: 
      ADD
    | SUB
    | MUL
    | MOD
    | DIV
    | EQUALS
    | ADDEQUALS
    | SUBEQUALS
    | LESS
    | LESSEQUALS
    | GREATER
    | GREATEREQUALS
    | AND
    | OR
    | Affectation
DeclarationInitial:
    DeclarationSimple PureAffectation
    | CONST DeclarationSimple PureAffectation
    | VAR DeclarationSimple Parametre
    | DeclarationSimple PureAffectation
    | DeclarationSimple Affectation Expression {
        if($1 != NULL){
            if($1->type == $3.type){
                char valeurString[255];
                valeurToString($3, valeurString);
                setValeur($1, valeurString);
                if($3.isVariable)
                {
                    insererQuadreplet(&q, ":=", $3.nameVariable, "", $1->nom, qc);                    
                }
                else
                {
                    
                    insererQuadreplet(&q, ":=", valeurString, "", $1->nom, qc);
                }
                qc++;
            }else{
                yyerrorSemantic("Incompatibilité de types");
            }
        }
    }
    
    ;
DeclarationSimple:
     SimpleType IDF{
        if(rechercherSymbole(tableSymboles, $2) == NULL){
            // Si l'ID n'existe pas alors l'inserer
            symbole * nouveauSymbole = creerSymbole($2, $1, false, 0);
            insererSymbole(&tableSymboles, nouveauSymbole);
            $$ = nouveauSymbole;
        }else{
            yyerrorSemantic( "Id already declared");
            $$ = NULL;
        }
    }
     | IDF 
     ;
Tableau:
    crochetouvrant Valeur crochetfermant
    ;
PureAffectation:
    Affectation Expression
    | Affectation Tableau
    |Affectation List
    |Aff
    ;
Aff:
    Variable Affectation Expression
    | Variable INC {
        if($1.symbole != NULL){
            if(!$1.symbole->hasBeenInitialized){
                yyerrorSemantic( "Variable non initialisée");
            }else{
                if($1.symbole->isConstant){
                    yyerrorSemantic("Impossible de réassigner une valeur à une constante");
                }else{
                if($1.symbole->type % simpleToArrayOffset != TYPE_FLOAT
                && $1.symbole->type % simpleToArrayOffset != TYPE_INTEGER){
                    yyerrorSemantic( "Variable non numérique trouvée");
                }else{

                    char valeurString[255];

                    if($1.symbole->type < simpleToArrayOffset)

                        {
                            getValeur($1.symbole, valeurString);
                            if(isForLoop){
                                pushFifo(quadFifo, creerQuadreplet("ADD", $1.symbole->nom, "1", $1.symbole->nom, qc));
                            }else{

                                insererQuadreplet(&q, "ADD", $1.symbole->nom, "1", $1.symbole->nom, qc);
                                qc++;
                            }
                        
                        }
                    

                    if($1.symbole->type % simpleToArrayOffset == TYPE_INTEGER){
                        int valeur = atoi(valeurString);
                        valeur++;
                        sprintf(valeurString, "%d", valeur);
                    }else{
                        double valeur = atof(valeurString);
                        valeur++;
                        sprintf(valeurString,"%.4f",valeur);
                    };
                    if($1.symbole->type < simpleToArrayOffset)

                        {
                            setValeur($1.symbole, valeurString);
                        }

                }
            }
        }
        }
            
    }      
    | Variable Affectation 
    ;
RapidAffectation:
    OperateurUnaire
    | ADDEQUALS Expression
    | SUBEQUALS Expression
    ;            
Statement:
     DeclarationInitial
    | DeclarationSimple
    | Aff
    | AppelFonction
    | Fonction
    | Boucle
    | Conditions
    ;
List:
      LIST  parentheseouvrante Expression parenthesefermante 
    ;
OperateurUnaire:
    INC
    | DEC
    ;    
Conditions:
    IF Condition
    ;   
Condition:
   parentheseouvrante Variable Operateur Valeur parenthesefermante acolladeouvrante Bloc acolladefermante ConditionELSE
   ;
ConditionELSE: %empty 
   |ELSEIF Condition
   |ELSE acolladeouvrante Bloc acolladefermante
   ;
While:
   
    DebutWhile Bloc acolladefermante {
        char adresse[10];
    char adresseCondWhile [10];
    int sauvAdrDebutWhile = depiler(stack);
    int sauvAdrCondWhile = depiler(stack);
    sprintf(adresseCondWhile,"%d",sauvAdrCondWhile);
    insererQuadreplet(&q,"BR",adresseCondWhile,"","",qc);
    qc++;
    sprintf(adresse,"%d",qc);
    updateQuadreplet(q,sauvAdrDebutWhile,adresse);

    }
    ;
    DebutWhile:
        ConditionWhile Expression parenthesefermante acolladeouvrante {
            if($2.type == TYPE_BOOLEAN){
        char r[10]; // contien le resultat de l'expression de la condition
        sprintf(r,"R%d",qc-1);	// this writes R to the r string
		insererQuadreplet(&q,"BZ","tmp","",r,qc); // jump if condition returns false(0) 
        // to finWhile
		empiler(stack,qc); // on sauvgarde l'addresse de cette quadreplet pour updater le
        // quadreplet
		qc++;
    }else{
        yyerrorSemantic( "Expression non booléenne trouvée");
    }

        };
     ConditionWhile:   
      WHILE parentheseouvrante  {
        empiler(stack,qc);
      }   ;
    ;
For:
   FOR parentheseouvrante DeclarationInitial TO Expression parenthesefermante acolladeouvrante Bloc acolladefermante  
   |FOR parentheseouvrante EACH IDF IN IDF parenthesefermante acolladeouvrante Bloc acolladefermante
   ;    
Boucle:
    While
    |For
    ;
Valeur:
    | INT { $$.type = TYPE_INTEGER; $$.integerValue = $1; }
    | REAL { $$.type = TYPE_FLOAT; $$.floatValue = $1; }
    | STRING{ $$.type = TYPE_STRING; strcpy($$.stringValue, $1); }
    | BOOL { $$.type = TYPE_BOOLEAN; $$.booleanValue = $1; }
    ; 
AppelFonction:
   IDF parentheseouvrante parenthesefermante
   |IDF parentheseouvrante Arguments parenthesefermante
   ; 
Arguments:
    Expression
    | Expression virgule Arguments
    ;
 Variable:
    IDF {
        symbole * s = rechercherSymbole(tableSymboles, $1);
        if(s==NULL){
            yyerrorSemantic( "variable  inconnue");
            $$.symbole = NULL;
        }else{
            $$.symbole = s;
            $$.index = -1;
        }
    }
    | AppelFonction
    ;       

 
%%
void yysuccess(char *s){
    currentColumn+=yyleng;
}

void yyerror(const char *s) {
    fprintf(stdout, "File '%s', line %d, character %d :"GREEN" %s "RESET"\n", file, yylineno, currentColumn, s);
    hasFailed = true;
}

void yyerrorSemantic(char *s){
    fprintf(stdout, "File '%s', line %d, character %d, ssemantic error: " RED " %s " RESET "\n", file, yylineno, currentColumn, s);
    hasFailed = true;
    return;
}

int main (void)
{
    // yydebug = 1;
    yyin=fopen(file, "r");
    if(yyin==NULL){
        printf("Erreur dans louverture du fichier\n");
        return 1;
    }

    stack = (pile *)malloc(sizeof(pile));
    quadFifo = initializeFifo();

    yyparse();  
    if (!hasFailed){

    afficherTableSymboles(tableSymboles);
    
    afficherQuad(q);
    }
    
    if(tableSymboles != NULL){
        free(tableSymboles);
    }

    free(stack);
    free(quadFifo);
    fclose(yyin);


    return 0;
}

void showLexicalError() {

    char line[256], introError[80]; 

    fseek(yyin, 0, SEEK_SET);
    
    int i = 0; 

    while (fgets(line, sizeof(line), yyin)) { 
        i++; 
        if(i == yylineno) break;  
    } 
        
    sprintf(introError, "Lexical error in Line %d : Unrecognized character : ", yylineno);
    printf("%s%s", introError, line);  
    int j=1;
    while(j<currentColumn+strlen(introError)) { printf(" "); j++; }
    printf("^\n");
    hasFailed=true;


}
