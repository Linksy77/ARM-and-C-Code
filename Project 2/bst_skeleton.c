
#include <stdio.h>

int next_free = 3;

void BSTinsert(int BST[], int currInd, int nextFree, int valToIns) {
    int currVal = BST[currInd];

    int incVal = 0;
    if(valToIns > currVal) {
        incVal = 2;
    } else {
        incVal = 1;
    }

    int child = BST[currInd + incVal];
    if(child != -1) {
        BSTinsert(BST, child, nextFree, valToIns);
    } else {
        BST[currInd + incVal] = nextFree;
        BST[nextFree] = valToIns;
        BST[nextFree + 1] = -1;
        BST[nextFree + 2] = -1;
        next_free += 3;
        return;
    }
    return;
}


void inOrderTraversal(int BST[], int currInd) {
    if(BST[currInd + 1] != -1) {
        inOrderTraversal(BST, BST[currInd + 1]);
    }

    printf("%d ", BST[currInd]);

    if(BST[currInd + 2] != -1) {
        inOrderTraversal(BST, BST[currInd + 2]); 
    }
    return;
}


int main()
{
    int inp[] = {4, 14, 1, 26, 7, 19};
    int inp_len = 6;
    int BST[96]; // for 32 elements

    // Inserting root node manually
    BST[0] = inp[0];
    BST[1] = -1;
    BST[2] = -1;

    for(int i = 1; i < inp_len; i++) {
        BSTinsert(BST, 0, next_free, inp[i]);
    }
    
    printf("BST array after initialization:\n");
    for(int i = 0; i < (inp_len*3); i++) {
        printf("%d ", BST[i]);
    }
    
    printf("\n");

    printf("BST in order traversal:\n");

    inOrderTraversal(BST, 0);

    printf("\n");

}
