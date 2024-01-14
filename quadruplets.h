// la structure QUAD (qui contienne les quadreplets) sera implémentée comme 
// liste lineare chainée de chaines de caractères
typedef struct quad quad;
struct quad
{   
    char operateur[30];
	char operande1[30];
	char operande2[30];   
	char resultat[30];   
	int qc;    //it's named qc par convontion
    struct quad *suivant; // suivant pour liste lineare chainée
};

// machine abstraite 

quad * creerQuadreplet(char opr[30],char op1[30],char op2[30],char res[30],int num);

void insererQuadreplet(quad ** p,char opr[],char op1[],char op2[],char res[],int num);

void updateQuadreplet(quad * q, int qc,char num[30]);

void afficherQuad(quad * q);


void enregistrerQuad(quad * q);
void ajouterQuadreplet(quad ** q,quad * nouveauQuadreplet,int num);

