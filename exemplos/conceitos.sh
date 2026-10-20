#!/bin/bash

NOTA=85

if (( NOTA >= 90 )); then
    echo "Conceito: A (Excelente!)"
elif (( NOTA >= 80 )); then
    echo "Conceito: B (Muito bom!)"
elif (( NOTA >= 70 )); then
    echo "Conceito: C (Aprovado)"
else
    echo "Conceito: D (Reprovado)"
fi
