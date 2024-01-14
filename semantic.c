#include "semantic.h"
#include "tableSymboles.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

void valeurToString(expression expression, char * valeur){
    switch (expression.type){
        case TYPE_INTEGER:
            sprintf(valeur, "%d", expression.integerValue);
            break;
        case TYPE_FLOAT:
            sprintf(valeur, "%.4f", expression.floatValue);
            break;
        case TYPE_STRING:
            sprintf(valeur, "%s", expression.stringValue);
            break;
        case TYPE_BOOLEAN:
            sprintf(valeur, "%s", expression.booleanValue ? "true" : "false");
            break;
        default:
            break;
    }
    
}

    

