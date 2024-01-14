#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "list.h"

qFifo * initializeFifo(){
    qFifo * fifo = (qFifo *)malloc(sizeof(qFifo));
    fifo->tail = FIFOSIZE -1;
    fifo->head = FIFOSIZE -1;
    return fifo;
}

void pushFifo(qFifo * fifo, struct quad * q){
    if(!fifoIsFull(fifo)){
        fifo->tail = (fifo->tail + 1) % FIFOSIZE;
        fifo->fifo[(fifo->tail)] = q;
    }
}

struct quad * popFifo(qFifo * fifo){
    if(!fifoIsEmpty(fifo)){
        fifo->head = (fifo->head + 1) % FIFOSIZE;
        return fifo->fifo[(fifo->head)];
    }
    return NULL;
}

bool fifoIsEmpty(qFifo * fifo){
    return (fifo->tail == fifo->head);
}

bool fifoIsFull(qFifo * fifo){
    return (fifo->head == (fifo->tail + 1 % (FIFOSIZE-1)));
}