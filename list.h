#define FIFOSIZE 10

typedef struct qFifo
{
    int head;
    int tail;
    struct quad * fifo[FIFOSIZE];
}qFifo ;

qFifo * initializeFifo();

void pushFifo(qFifo * fifo, struct quad * q);

struct quad * popFifo(qFifo * fifo);

bool fifoIsEmpty(qFifo * fifo);

bool fifoIsFull(qFifo * fifo);