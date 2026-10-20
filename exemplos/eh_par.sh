#!/bin/bash

# 1. Código de saída: a função responde "sim" (0) ou "não" (1)
eh_par() {
    (( $1 % 2 == 0 ))         # o resultado desta expressão vira o código de saída
}

# 2. Dados: a função imprime o resultado
dobro() {
    echo $(( $1 * 2 ))
}

if eh_par 4; then
    echo "4 é par"
fi

RESULTADO=$(dobro 21)          # captura a saída da função
echo "Dobro: $RESULTADO"       # Dobro: 42
