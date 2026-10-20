#include <stdlib.h>

void funcao_com_vazamento() {
    int *array = malloc(1000 * sizeof(int)); // Alocou 4000 bytes
    array[0] = 42;
    // Esqueceu de chamar free(array)!
}

int main() {
    funcao_com_vazamento();
    return 0;
}
