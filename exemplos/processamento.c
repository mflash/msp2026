#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Função rápida: executa poucas iterações simples (baixo consumo de CPU)
void funcao_rapida(int n) {
    volatile double soma = 0.0;
    for (int i = 0; i < n; i++) {
        soma += i * 0.5;
    }
}

// Função lenta: contém operações matemáticas intensivas e laço aninhado.
// Este será o hotspot (> 95% do tempo de CPU) que o profiler irá apontar!
void funcao_lenta_gargalo(int n) {
    volatile double soma = 0.0;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < 2000; j++) {
            soma += sin((double)i) * cos((double)j);
        }
    }
}

int main(void) {
    printf("Iniciando processamento para análise de profiling...\n");

    // Executando ambas as funções:
    funcao_rapida(100000);
    funcao_lenta_gargalo(20000);

    printf("Processamento concluído com sucesso!\n");
    return 0;
}
