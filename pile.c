#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include "pile.h"

void initPile(pile *P){

    P->sommet = -1;
}
 

int pileVide(pile *P){

   return (P->sommet == -1) ;
}
 
int pilePleine(pile *P){

    return (P->sommet == (MAX - 1));
}
 
void empiler(pile *p, int x){

    if (!pilePleine(p))
    {
        p->sommet++;
        p->table[p->sommet] = x;
    }
    else
    {
        printf("Erreur: Ne peut pas empile - Pile Pleine ...\n");
    }
}
 
int depiler(pile *p){

    int x;
    if (!pileVide(p))
    {
        x = p->table[p->sommet];
        p->sommet--; return x;
    }
    else
    {
        printf("pile Vide\n");
         return 1;
    }
}
 
void sommet(pile *p, int *x){

    if (!pileVide(p))
    {
        *x = p->table[p->sommet];
    }
    else
    {
        printf("Pile vide\n");
    }
}

void afficherPile(pile *p){ 
    int x;
    while(!pileVide(p)){  
        x=depiler(p);
        printf(" %d ",x);
    }
    printf(" \n fin ");
}