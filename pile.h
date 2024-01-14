#define MAX 128

// pile de tableau
 
typedef struct pile pile;
struct pile{
    int sommet;
    int table[MAX];
};

void initPile(pile *P);

int pileVide(pile *P);

int pilePleine(pile *P);

void empiler(pile *p, int x);

int depiler(pile *p);

void sommet(pile *p, int *x);

void afficherPile(pile *p);