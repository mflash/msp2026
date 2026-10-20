#!/bin/bash
ARQUIVO_USUARIOS="usuarios.txt"

# IFS= desativa quebra automática de espaços em branco
# read -r impede que barras invertidas (\) sejam interpretadas como escape
while IFS= read -r linha; do
    # Ignora linhas vazias ou que iniciam com comentário (#)
    [[ -z "$linha" || "$linha" =~ ^# ]] && continue
    
    echo "Criando conta para o usuário: $linha"
done < "$ARQUIVO_USUARIOS"
