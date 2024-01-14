#include <stdbool.h>

typedef struct expression expression;
struct expression{
    int type;
    char stringValue[255];
    char nameVariable[255];
    int integerValue;
    double floatValue;
    bool booleanValue;
    bool isVariable;
};
typedef struct tableau tableau;
struct tableau{
    int type;
    int length;
    char tabValeur[128][32];
};

typedef struct variable variable;
struct variable{
    struct symbole * symbole;
    int index;
    char indexString [20];
};


void valeurToString(expression expression, char * valeur);