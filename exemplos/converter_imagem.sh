#!/bin/bash
# Script: converter_imagem.sh

if [[ $# -lt 2 ]]; then
    # Mensagens de erro vão para stderr (>&2), como vimos no Módulo 02:
    echo "Erro: Argumentos insuficientes!" >&2
    echo "Uso: $0 <arquivo_origem> <formato_destino>" >&2
    exit 1
fi

ARQUIVO_ORIGEM="$1"
FORMATO="$2"

echo "Processando o arquivo '$ARQUIVO_ORIGEM' para o formato '$FORMATO'..."
# Lógica de conversão...
