#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "tableSymboles.h"
// Fonction pour gérer les erreurs sémantiques
extern void erreurSemantique(char *s);

// Fonction pour allouer dynamiquement un nouveau symbole
symbole *_allouerEspaceSymbole() {
    symbole *pointer = (symbole *)malloc(sizeof(symbole));
    return pointer;
}

// Fonction pour créer un nouveau symbole avec les informations spécifiées
symbole *creerSymbole(char *nom, int type, bool isConstant, int length) {
    symbole *pointer = _allouerEspaceSymbole();
    
    // Copie du nom dans le champ nom du symbole
    strcpy(pointer->nom, nom);
    pointer->type = type;
    pointer->isConstant = isConstant;
    pointer->isInitialized = false;
   
    return pointer;
}

// Fonction pour insérer un symbole dans la table des symboles
void insererSymbole(symbole **tableSymboles, symbole *nouveauSymbole) {
    if (nouveauSymbole == NULL)
        return;

    if (tableSymboles != NULL) {
        nouveauSymbole->suivant = *tableSymboles;
    }

    *tableSymboles = nouveauSymbole;
}

// Fonction pour afficher la table des symboles
void afficherTs(symbole *tableSymboles) {
    if (tableSymboles == NULL) {
        printf("Table des symboles est vide");
        return;
    }

    symbole *pointer = tableSymboles;

    printf("************************ TABLE DES SYMBOLES *****************************************\n");
    printf("******************************************************************************************\n");
    printf("******************************************************************************************\n");

    printf("\tNom var\t\tType var\t\tConstant ?\tValeur   \n");

    while (pointer != NULL) {  
    printf("******************************************************************************************\n");

        char type[COLS];
        getTypeChar(pointer, type);

        printf("\t%s", pointer->nom);
        printf("\t\t%s", type);
        printf("\t%s", pointer->isConstant ? "Oui" : "Non");
        if (pointer->isInitialized) {
            printf("\t\t%s", pointer->valeur);
        }
        printf("\n");
        pointer = pointer->suivant;
    }

    printf("******************************************************************************************\n");
    printf("******************************************************************************************\n");

}

// Fonction pour rechercher un symbole dans la table des symboles par son nom
symbole *rechercherSymbole(symbole *tableSymboles, char *nom) {
    if (tableSymboles == NULL || nom == NULL) {
        return NULL;
    }
    
    symbole *pointer = tableSymboles;

    while (pointer != NULL) {
        if (!strcmp(pointer->nom, nom)) {
            return pointer;
        }
        pointer = pointer->suivant;
    }
    return NULL;
}

// Fonction pour obtenir le nom d'un symbole
void getNom(symbole *symbole, char *nom) {
    if (symbole == NULL || nom == NULL) {
        return;
    }
    strcpy(nom, symbole->nom);
}

// Fonction pour obtenir la valeur d'un symbole
void getValeur(symbole *symbole, char *valeur) {
    if (symbole == NULL || !symbole->isInitialized || valeur == NULL) {
        return;
    }
    strcpy(valeur, symbole->valeur);
}

// Fonction pour obtenir le type d'un symbole
int getType(symbole *symbole) {
    if (symbole == NULL) {
        return -1;
    }

    return symbole->type;
}

// Fonction interne pour mapper le type entier à une chaîne de caractères
void _mapTypeIntToChar(int type, char *typeChar) {
    if (typeChar == NULL)
        return;

    switch (type) {
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

// Fonction pour obtenir le type d'un symbole sous forme de chaîne de caractères
void getTypeChar(symbole *symbole, char *type) {
    if (symbole == NULL || type == NULL) {
        return;
    }

    _mapTypeIntToChar(symbole->type, type);
}

// Fonction pour définir la valeur d'un symbole
void setValeur(symbole *symbole, char *valeur) {
    if (symbole == NULL) {
        return;
    }

    if (symbole->isInitialized && symbole->isConstant) {
        return;
    }

    // Copie de la valeur dans le champ valeur du symbole
    if (symbole->type <= 3)
        strcpy(symbole->valeur, valeur);
    
    symbole->isInitialized = true;
}

// Fonction pour définir la valeur d'un tableau de symboles dans le cas dune constante 
void setTabValeur(symbole *symbole, char tabValeur[ROWS][COLS], int length) {
    if (symbole == NULL) {
        return;
    }

    if (symbole->isInitialized && symbole->isConstant) {
        printf("Can't reassign a value to a constant");
        return;
    }

    symbole->isInitialized = true;
}





