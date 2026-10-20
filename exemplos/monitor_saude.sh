#!/bin/bash
# ==============================================================================
# Script: monitor_saude.sh
# ==============================================================================
set -euo pipefail

LIMITE_DISCO_PERCENTUAL=80

# Cores ANSI só quando a saída é um terminal (-t 1). Ao rodar pelo cron com
# saída redirecionada para um arquivo, as variáveis ficam vazias e o log não
# fica poluído com códigos como \033[31m:
if [[ -t 1 ]]; then
    VERMELHO=$'\033[31m'; VERDE=$'\033[32m'; RESET=$'\033[0m'
else
    VERMELHO=""; VERDE=""; RESET=""
fi

echo "--- RELATÓRIO DE SAÚDE DO SISTEMA ($(date '+%d/%m/%Y %H:%M:%S')) ---"

# 1. Checagem de Disco da partição raiz (/)
# df -P (formato POSIX) garante uma linha por partição, mesmo com nomes de
# dispositivo longos; extraímos a coluna de percentual e removemos o '%':
USO_DISCO=$(df -P / | awk 'NR==2 {print $5}' | tr -d '%')

if (( USO_DISCO >= LIMITE_DISCO_PERCENTUAL )); then
    echo "${VERMELHO}[ALERTA CRÍTICO]${RESET} Uso de disco em ${USO_DISCO}% (acima do limite de ${LIMITE_DISCO_PERCENTUAL}%)!"
else
    echo "${VERDE}[OK]${RESET} Uso de disco saudável: ${USO_DISCO}%"
fi

# 2. Checagem de Memória RAM Disponível
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_DISP=$(free -m | awk '/Mem:/ {print $7}')
PERCENTUAL_LIVRE=$(( (MEM_DISP * 100) / MEM_TOTAL ))

echo "Memória Disponível: ${MEM_DISP} MB de ${MEM_TOTAL} MB (${PERCENTUAL_LIVRE}% livre)"

if (( PERCENTUAL_LIVRE < 10 )); then
    echo "${VERMELHO}[ALERTA CRÍTICO]${RESET} Menos de 10% de memória RAM disponível!"
fi

# 3. Uptime e Carga
echo "Carga do Processador: $(uptime | awk -F'load average:' '{print $2}')"
echo "--- FIM DO RELATÓRIO ---"
