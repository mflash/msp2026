#!/bin/bash

# Define a função de log com timestamp e cores
log_info() {
    local MENSAGEM="$1" # 'local' impede que a variável vaze para o escopo global
    local DATA
    DATA=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[INFO] [$DATA] $MENSAGEM"
}

log_erro() {
    local MENSAGEM="$1"
    echo -e "\033[31m[ERRO]\033[0m $MENSAGEM" >&2
}

# Invocando as funções:
log_info "Iniciando verificação de integridade..."
log_erro "Falha ao conectar no servidor de backup!"
