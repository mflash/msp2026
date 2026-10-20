#!/bin/bash
ACAO="${1:-status}" # Se não passar argumento, assume 'status' por padrão

case "$ACAO" in
    start|iniciar)
        echo "Iniciando o serviço do banco de dados..."
        ;;
    stop|parar)
        echo "Parando o serviço com segurança..."
        ;;
    restart|reiniciar)
        echo "Reiniciando o serviço..."
        ;;
    status)
        echo "Serviço operacional."
        ;;
    *)
        echo "Opção inválida: '$ACAO'"
        echo "Uso: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
