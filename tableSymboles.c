#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "tableSymboles.h"

extern void yyerrorSemantic(char *s);

symbole * _allouerSymbole(){
    symbole * pointer = (symbole *) malloc(sizeof(symbole));
    return pointer;
}

symbole * creerSymbole(char * nom, int type, bool isConstant, int length){
    symbole * pointer = _allouerSymbole();
    
    strcpy(pointer->nom, nom);
    pointer->type = type;
    pointer->isConstant = isConstant;
    pointer->hasBeenInitialized = false;
   
    return pointer;
}

void insererSymbole(symbole ** tableSymboles, symbole * nouveauSymbole){
    if(nouveauSymbole == NULL)
        return;

    if (tableSymboles != NULL){
        nouveauSymbole->suivant = *tableSymboles;
    }

    *tableSymboles = nouveauSymbole;

}

void afficherTableSymboles(symbole * tableSymboles){

    if(tableSymboles == NULL){
        printf("Table des symboles est vide");
        return;
    }

    symbole * pointer = tableSymboles;

    printf("************************ TABLE DES SYMBOLES ************************\n");
    printf("--------------------------------------------------------------------\n");
    printf("\tName\t\tType\t\tConstant\tValue   \n");

    while(pointer != NULL){  
    printf("--------------------------------------------------------------------\n");

        char type[COLS];
        getTypeChar(pointer, type);

        printf("\t%s", pointer->nom);
        printf("\t\t%s", type);
        printf("\t%s", pointer->isConstant ? "Oui" : "Non");
        if(pointer->hasBeenInitialized){
            
                printf("\t\t%s", pointer->valeur);
        }
        printf("\n");
        pointer=pointer->suivant;
    }

    printf("********************************************************************\n");
}

symbole * rechercherSymbole(symbole * tableSymboles, char * nom){

    if(tableSymboles == NULL || nom == NULL){
        return NULL;
    }
    
    symbole * pointer = tableSymboles;

    while(pointer!=NULL){
        if (!strcmp(pointer->nom, nom)){
            return pointer;
        }
        pointer = pointer->suivant;
    }
    return NULL;
    
}

void getNom(symbole * symbole, char * nom){
    if(symbole == NULL || nom == NULL){
        return;
    }
    strcpy(nom, symbole->nom);
}

void getValeur(symbole * symbole, char * valeur){
    if(symbole == NULL || !symbole->hasBeenInitialized || valeur == NULL){
        return;
    }
    strcpy(valeur, symbole->valeur);
}

int getType(symbole * symbole){
    if(symbole == NULL){
        return -1;
    }

    return symbole->type;
}

void _mapTypeIntToChar(int type, char * typeChar){
    if(typeChar == NULL)
        return;

    switch (type){
        case TYPE_INTEGER:
            sprintf(typeChar, "%s", "Integer\t");
            break;
        case TYPE_FLOAT:
            sprintf(typeChar, "%s", "Float\t");
            break;
        case TYPE_STRING:
            sprintf(typeChar, "%s", "String\t");
            break;
        case TYPE_BOOLEAN:
            sprintf(typeChar, "%s", "Boolean\t");
            break;
        case TYPE_ARRAY_BOOLEAN:
            sprintf(typeChar, "%s", "Boolean[]");
            break;
        case TYPE_ARRAY_FLOAT:
            sprintf(typeChar, "%s", "Float[]");
            break;
        case TYPE_ARRAY_INTEGER:
            sprintf(typeChar, "%s", "Integer[]");
            break;
        case TYPE_ARRAY_STRING:
            sprintf(typeChar, "%s", "String[]");
            break;
        default:
            break;
    }
}

void getTypeChar(symbole * symbole, char * type){
    if(symbole == NULL || type == NULL){
        return;
    }

    _mapTypeIntToChar(symbole->type, type);

}

void setValeur(symbole * symbole, char * valeur){

    if(symbole == NULL){
        return;
    }

    if(symbole->hasBeenInitialized && symbole->isConstant){
        return;
    }

    if(symbole->type <= 3)
        strcpy(symbole->valeur, valeur);
    
    symbole->hasBeenInitialized = true;

}

void setTabValeur(symbole * symbole, char tabValeur[ROWS][COLS], int length){
    if(symbole == NULL){
        return;
    }

    if(symbole->hasBeenInitialized && symbole->isConstant){
        printf("Can't reassign a vlue to a constant");
        return;
    }

  
    symbole->hasBeenInitialized = true;
}


