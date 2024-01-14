/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_SYNTAXIQUEANALYSER_TAB_H_INCLUDED
# define YY_YY_SYNTAXIQUEANALYSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 12 "SyntaxiqueAnalyser.y"


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

#line 63 "SyntaxiqueAnalyser.tab.h"

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    IntType = 258,                 /* IntType  */
    StringType = 259,              /* StringType  */
    RealType = 260,                /* RealType  */
    BoolType = 261,                /* BoolType  */
    RETURN = 262,                  /* RETURN  */
    CONST = 263,                   /* CONST  */
    VAR = 264,                     /* VAR  */
    FOR = 265,                     /* FOR  */
    WHILE = 266,                   /* WHILE  */
    IF = 267,                      /* IF  */
    ELSE = 268,                    /* ELSE  */
    ELSEIF = 269,                  /* ELSEIF  */
    EACH = 270,                    /* EACH  */
    IN = 271,                      /* IN  */
    SCAN = 272,                    /* SCAN  */
    PRINT = 273,                   /* PRINT  */
    FUN = 274,                     /* FUN  */
    TO = 275,                      /* TO  */
    PROG = 276,                    /* PROG  */
    SWITCH = 277,                  /* SWITCH  */
    CASE = 278,                    /* CASE  */
    IMPORT = 279,                  /* IMPORT  */
    LIST = 280,                    /* LIST  */
    lettre = 281,                  /* lettre  */
    chiffre = 282,                 /* chiffre  */
    IDF = 283,                     /* IDF  */
    INT = 284,                     /* INT  */
    STRING = 285,                  /* STRING  */
    REAL = 286,                    /* REAL  */
    BOOL = 287,                    /* BOOL  */
    ADD = 288,                     /* ADD  */
    SUB = 289,                     /* SUB  */
    MUL = 290,                     /* MUL  */
    MOD = 291,                     /* MOD  */
    DIV = 292,                     /* DIV  */
    INC = 293,                     /* INC  */
    DEC = 294,                     /* DEC  */
    ADDEQUALS = 295,               /* ADDEQUALS  */
    SUBEQUALS = 296,               /* SUBEQUALS  */
    EQUALS = 297,                  /* EQUALS  */
    NEG = 298,                     /* NEG  */
    NOTEQUALS = 299,               /* NOTEQUALS  */
    LESS = 300,                    /* LESS  */
    LESSEQUALS = 301,              /* LESSEQUALS  */
    GREATER = 302,                 /* GREATER  */
    GREATEREQUALS = 303,           /* GREATEREQUALS  */
    DOUBLEEQUALS = 304,            /* DOUBLEEQUALS  */
    AND = 305,                     /* AND  */
    OR = 306,                      /* OR  */
    COMMENTL = 307,                /* COMMENTL  */
    COMMENTMULTILINE = 308,        /* COMMENTMULTILINE  */
    WHITESPACE = 309,              /* WHITESPACE  */
    virgule = 310,                 /* virgule  */
    Affectation = 311,             /* Affectation  */
    crochetouvrant = 312,          /* crochetouvrant  */
    crochetfermant = 313,          /* crochetfermant  */
    parentheseouvrante = 314,      /* parentheseouvrante  */
    parenthesefermante = 315,      /* parenthesefermante  */
    acolladeouvrante = 316,        /* acolladeouvrante  */
    acolladefermante = 317,        /* acolladefermante  */
    deuxpoints = 318,              /* deuxpoints  */
    COMA = 319,                    /* COMA  */
    MULT = 320                     /* MULT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 26 "SyntaxiqueAnalyser.y"

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

#line 158 "SyntaxiqueAnalyser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_SYNTAXIQUEANALYSER_TAB_H_INCLUDED  */
