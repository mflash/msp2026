#!/bin/bash
# ==============================================================================
# Script: backup_simples.sh
# Descrição: Demonstração inicial de script em Bash
# ==============================================================================

# Opcional, mas altamente recomendado: modo estrito para evitar comportamentos silenciosos
set -euo pipefail

echo "Iniciando execução do script..."
NOME_USUARIO=$(whoami)
DATA_ATUAL=$(date "+%Y-%m-%d %H:%M:%S")

echo "Olá, $NOME_USUARIO! Hoje é $DATA_ATUAL."
exit 0
