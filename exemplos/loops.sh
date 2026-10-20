#!/bin/bash

# A. Iterando sobre uma lista explícita de palavras:
for servidor in web01 web02 db01 cache01; do
    echo "Conectando ao host: $servidor"
done

# B. Iterando sobre intervalos de números ({inicio..fim..passo}):
for i in {1..5}; do
    echo "Tentativa número $i..."
done

# C. Iterando sobre arquivos do disco usando Globbing (*):
# ATENÇÃO: coloque sempre aspas duplas "$arquivo" para suportar nomes com espaços!
for arquivo in docs/*.md; do
    echo "Processando documento: $arquivo"
done

# D. Sintaxe estilo linguagem C:
for (( i = 0; i < 5; i++ )); do
    echo "Índice: $i"
done
