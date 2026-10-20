#!/bin/bash
# ==============================================================================
# Script: monitor_saude.sh
# ==============================================================================
set -euo pipefail

LIMITE_DISCO_PERCENTUAL=80

# Cores ANSI apenas quando a saída é um terminal (-t 1)
if [[ -t 1 ]]; then
    VERMELHO=$'\033[31m'; VERDE=$'\033[32m'; RESET=$'\033[0m'
else
    VERMELHO=""; VERDE=""; RESET=""
fi

echo "--- RELATÓRIO DE SAÚDE DO SISTEMA ($(date '+%d/%m/%Y %H:%M:%S')) ---"

# Detecta o Sistema Operacional
OS="$(uname -s)"

# 1. Checagem de Disco da partição raiz (/)
if [[ "$OS" == "Darwin" ]]; then
    # No macOS, a raiz pode reportar múltiplos mounts dependendo do volume (APFS).
    # Filtramos para pegar apenas a linha de dados reais.
    USO_DISCO=$(df -P / | awk 'END{print $(NF-1)}' | tr -d '%')
else
    # Padrão Linux
    USO_DISCO=$(df -P / | awk 'NR==2 {print $5}' | tr -d '%')
fi

if (( USO_DISCO >= LIMITE_DISCO_PERCENTUAL )); then
    echo "${VERMELHO}[ALERTA CRÍTICO]${RESET} Uso de disco em ${USO_DISCO}% (acima do limite de ${LIMITE_DISCO_PERCENTUAL}%)!"
else
    echo "${VERDE}[OK]${RESET} Uso de disco saudável: ${USO_DISCO}%"
fi

# 2. Checagem de Memória RAM Disponível
if [[ "$OS" == "Darwin" ]]; then
    # Extração multiplataforma nativa para macOS usando sysctl e vm_stat
    MEM_TOTAL_BYTES=$(sysctl -n hw.memsize)
    MEM_TOTAL=$(( MEM_TOTAL_BYTES / 1024 / 1024 ))
    
    PAGESIZE=$(vm_stat | awk '/page size of/ {print $8}')
    PAGE_FREE=$(vm_stat | awk '/Pages free:/ {print $3}' | tr -d '.')
    PAGE_PURGEABLE=$(vm_stat | awk '/Pages purgeable:/ {print $3}' | tr -d '.')
    PAGE_INACTIVE=$(vm_stat | awk '/Pages inactive:/ {print $3}' | tr -d '.')
    
    # Memória disponível no macOS = Free + Purgeable + Inactive
    MEM_DISP=$(( (PAGE_FREE + PAGE_PURGEABLE + PAGE_INACTIVE) * PAGESIZE / 1024 / 1024 ))
else
    # Padrão Linux usando free
    MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
    MEM_DISP=$(free -m | awk '/Mem:/ {print $7}')
fi

PERCENTUAL_LIVRE=$(( (MEM_DISP * 100) / MEM_TOTAL ))

echo "Memória Disponível: ${MEM_DISP} MB de ${MEM_TOTAL} MB (${PERCENTUAL_LIVRE}% livre)"

if (( PERCENTUAL_LIVRE < 10 )); then
    echo "${VERMELHO}[ALERTA CRÍTICO]${RESET} Menos de 10% de memória RAM disponível!"
fi

# 3. Uptime e Carga
if [[ "$OS" == "Darwin" ]]; then
    # No macOS, extrai diretamente o valor real e limpo via sysctl
    echo "Carga do Processador: $(sysctl -n vm.loadavg | awk '{print $2, $3, $4}')"
else
    # Padrão Linux (compatível com variações de caixa ou espaço)
    echo "Carga do Processador: $(uptime | awk -F'[Ll]oad [Aa]verage[s]*:' '{print $2}')"
fi

echo "--- FIM DO RELATÓRIO ---"



