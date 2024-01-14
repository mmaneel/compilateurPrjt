#include <stdbool.h>

#define TYPE_BOOLEAN 0
#define TYPE_INTEGER 1
#define TYPE_FLOAT 2
#define TYPE_STRING 3
#define TYPE_ARRAY_BOOLEAN 4
#define TYPE_ARRAY_INTEGER 5
#define TYPE_ARRAY_FLOAT 6
#define TYPE_ARRAY_STRING 7

#define ROWS 128
#define COLS 32

typedef struct arraySubSymbol arraySubSymbol;
struct arraySubSymbol{
    char tabValeur[ROWS][COLS];
    int length;
};

typedef struct symbole symbole;
struct symbole{
    char nom[COLS];
    int type;
    char valeur[COLS];
    bool isConstant;
    bool isInitialized ;

    symbole *suivant;
};

//machine abstraite

symbole * _allouerSymbole();

void _mapTypeIntToChar(int type, char * typeChar);

symbole * creerSymbole(char * nom, int type, bool isConstant, int length);

void insererSymbole(symbole ** tableSymboles, symbole * nouveauSymbole);

void afficherTableSymboles(symbole * tableSymboles);

symbole * rechercherSymbole(symbole * tableSymboles, char * nom);

void getNom(symbole * symbole, char * nom);

void getValeur(symbole * symbole, char * valeur);

int getType(symbole * symbole);

void getTypeChar(symbole * symbole, char * type);

void setValeur(symbole * symbole, char * valeur);

void setTabValeur(symbole * symbole, char tabValeur[ROWS][COLS], int length);

void getArrayElement(symbole * symbole, int index, char * valeur);

void setArrayElement(symbole * symbole, int index, char * valeur);
