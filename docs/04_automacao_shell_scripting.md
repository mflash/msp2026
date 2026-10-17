# 04. Automação e Shell Scripting

<div class="theme-toggle-wrapper">
  <button id="theme-toggle" class="theme-toggle-btn" aria-label="Alternar modo claro e escuro" title="Alternar modo claro e escuro">
    <span class="icon icon-moon">🌙</span>
    <span class="icon icon-sun">☀️</span>
    <span class="theme-label">Tema</span>
  </button>
</div>

<script>
  (function() {
    var saved = localStorage.getItem('theme');
    if (saved) {
      document.documentElement.setAttribute('data-theme', saved);
    }
  })();
</script>

<p class="nav-breadcrumb">
  <a href="index.html" class="nav-link">← Voltar ao Índice Principal</a>
</p>

![](img/mgp.jpg)

## Semana Acadêmica Integrada - PUCRS / Escola Politécnica - 2026

**Profs. Edson Ifarraguirre Moreno e Marcelo Cohen**  
*Módulo 04 — Construção de Scripts Bash, Parâmetros, Controle de Fluxo e Automação de Tarefas*

---

### Por que Escrever Shell Scripts?

Até aqui, utilizamos a linha de comando de forma interativa: digitamos um comando, pressionamos Enter e inspecionamos o resultado. No entanto, na rotina real de engenheiros de software, administradores de sistemas e cientistas de dados, tarefas repetitivas precisam ser **automatizadas**:

- Gerar backups compactados diariamente na nuvem;
- Instalar dependências e provisionar servidores automaticamente;
- Processar, higienizar e converter milhares de arquivos em lote;
- Monitorar a saúde do sistema e enviar alertas quando o disco estiver quase cheio.

Um **Shell Script** é simplesmente um arquivo de texto contendo uma sequência de comandos do terminal, enriquecido com recursos de linguagens de programação: **variáveis**, **estruturas condicionais (`if/else`)**, **laços de repetição (`for/while`)** e **funções**.

---

### Anatomia e Execução de um Script

Para que um script seja reconhecido e executado diretamente pelo sistema operacional, ele segue uma estrutura bem definida:

```bash
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
```

#### 1. O que é o *Shebang* (`#!/bin/bash`)?
A primeira linha de todo script executável deve iniciar com os dois caracteres mágicos `#!` (conhecidos como **Shebang** ou *Hashbang*), seguidos pelo caminho absoluto do interpretador. 

Quando você tenta executar `./script.sh`, o kernel do Linux lê os primeiros bytes do arquivo. Ao encontrar `#!/bin/bash`, o kernel não tenta rodar o arquivo diretamente como código de máquina binário; em vez disso, ele invoca o interpretador `/bin/bash` e passa o arquivo como argumento para ele.

> **Portabilidade:** Você também pode usar `#!/usr/bin/env bash`, que localiza o executável do Bash no `$PATH` da máquina, sendo muito comum em distribuições com diretórios customizados ou no macOS.

#### 2. Dando Permissão de Execução (`chmod +x`):
Por razões de segurança, arquivos de texto recém-criados no Linux **não possuem permissão de execução**. Antes de rodá-lo, você deve conceder essa permissão:

```bash
# 1. Cria ou edita o arquivo de script
$ nano meu_script.sh

# 2. Torna o arquivo executável para o usuário (+x)
$ chmod +x meu_script.sh

# 3. Executa o script indicando o caminho relativo (./)
$ ./meu_script.sh
```

> **Por que o `./` é obrigatório?**  
> Como vimos no Módulo 01, o shell procura comandos apenas nos diretórios listados na variável `$PATH`. Como o diretório atual (`.`) não faz parte do `$PATH` por segurança, você precisa explicitar `./meu_script.sh` para dizer ao shell: *"execute o arquivo que está aqui nesta pasta atual"*.

#### 3. Modo Estrito: `set -euo pipefail`
Em scripts profissionais, coloque sempre a instrução `set -euo pipefail` logo após o Shebang. Ela ativa salvaguardas essenciais:
- **`-e`** (*errexit*): Interrompe a execução imediatamente se qualquer comando falhar (retornar código diferente de 0). Evita que o script continue rodando após erros graves!
- **`-u`** (*nounset*): Trata o uso de variáveis não declaradas como erro fatal (evita bugs por digitação incorreta de nomes de variáveis).
- **`-o pipefail`**: Garante que em pipelines (`cmd1 | cmd2`), se o `cmd1` falhar, o pipeline inteiro será considerado como erro.

[![Anatomia, Parâmetros e Estruturas do Shell Scripting (clique para ampliar)](img/linux-shell-scripting.svg)](img/linux-shell-scripting.svg)

---

### Argumentos de Linha de Comando e Variáveis Especiais

Scripts dinâmicos recebem parâmetros passados pelo usuário ao serem invocados. O shell disponibiliza esses valores automaticamente em variáveis especiais:

```bash
$ ./deploy.sh producao v2.4.0
```

| Variável | Conteúdo e Significado | Exemplo no comando acima |
| :---: | :--- | :--- |
| **`$0`** | O nome com o qual o script foi invocado. | `./deploy.sh` |
| **`$1`** | O primeiro argumento posicional. | `producao` |
| **`$2`** | O segundo argumento posicional. | `v2.4.0` |
| **`$3` ... `$9`** | Argumentos subsequentes (para argumentos a partir de 10, use `${10}`). | — |
| **`$#`** | O número total de argumentos passados. | `2` |
| **`$@`** | Todos os argumentos como uma lista individual (`"$@"` preserva espaços). | `"producao"` `"v2.4.0"` |
| **`$*`** | Todos os argumentos concatenados em uma única string (`"$*"`). | `"producao v2.4.0"` |
| **`$?`** | O código de saída (*exit status*) do último comando executado (`0` = sucesso). | `0` |
| **`$$`** | O **PID** do processo do próprio script (ótimo para gerar nomes de arquivos temporários únicos). | `4821` |

#### Exemplo Prático: Validando Argumentos de Entrada

```bash
#!/bin/bash
# Script: converter_imagem.sh

if [[ $# -lt 2 ]]; then
    echo "Erro: Argumentos insuficientes!"
    echo "Uso: $0 <arquivo_origem> <formato_destino>"
    exit 1
fi

ARQUIVO_ORIGEM="$1"
FORMATO="$2"

echo "Processando o arquivo '$ARQUIVO_ORIGEM' para o formato '$FORMATO'..."
# Lógica de conversão...
```

---

### Estruturas Condicionais: `if`, `test` e `[[ ... ]]`

Para tomar decisões no script, usamos o comando `if` em conjunto com a sintaxe moderna de teste **`[[ ... ]]`** (uma versão aprimorada e mais segura do antigo comando `[ ... ]` do Unix):

#### 1. Testes de Arquivos e Diretórios no Disco:

| Teste | Verdadeiro se... | Exemplo |
| :---: | :--- | :--- |
| **`-f $ARQ`** | O caminho existe e é um **arquivo comum** (*regular file*). | `[[ -f config.json ]]` |
| **`-d $DIR`** | O caminho existe e é um **diretório** (*folder*). | `[[ -d /var/log ]]` |
| **`-e $ITEM`** | O caminho **existe** (seja arquivo, pasta ou link). | `[[ -e /etc/hosts ]]` |
| **`-s $ARQ`** | O arquivo existe e seu tamanho é **maior que zero** (não está vazio). | `[[ -s relatorio.txt ]]` |
| **`-r $ARQ`** | O arquivo possui permissão de **leitura** para o usuário atual. | `[[ -r chave.pem ]]` |
| **`-w $ARQ`** | O arquivo possui permissão de **escrita**. | `[[ -w /tmp/log.txt ]]` |
| **`-x $ARQ`** | O arquivo possui permissão de **execução**. | `[[ -x backup.sh ]]` |

#### 2. Testes de Strings (Texto):

| Teste | Verdadeiro se... | Exemplo |
| :---: | :--- | :--- |
| **`"$A" == "$B"`** | As strings são idênticas (use `!=` para diferente). | `[[ "$RESPOSTA" == "sim" ]]` |
| **`-z "$STR"`** | A string está **vazia** (*zero length*). | `[[ -z "$SENHA" ]]` |
| **`-n "$STR"`** | A string **não está vazia** (*non-zero length*). | `[[ -n "$TOKEN" ]]` |

#### 3. Testes Numéricos (Inteiros):

| Teste | Comparação Aritmética | Equivalente com `(( ... ))` |
| :---: | :--- | :---: |
| **`$A -eq $B`** | Igual (*Equal*) | `(( A == B ))` |
| **`$A -ne $B`** | Diferente (*Not Equal*) | `(( A != B ))` |
| **`$A -lt $B`** | Menor que (*Less Than*) | `(( A < B ))` |
| **`$A -le $B`** | Menor ou igual (*Less or Equal*) | `(( A <= B ))` |
| **`$A -gt $B`** | Maior que (*Greater Than*) | `(( A > B ))` |
| **`$A -ge $B`** | Maior ou igual (*Greater or Equal*) | `(( A >= B ))` |

#### Exemplo de Sintaxe Completa: `if / elif / else`

```bash
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
```

---

### Estrutura de Seleção Múltipla: `case ... esac`

Quando você precisa comparar uma variável contra muitas opções textuais conhecidas, a estrutura `case` é muito mais legível que múltiplos blocos `if/elif`:

```bash
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
```

> **Atenção à sintaxe:** Cada bloco no `case` é encerrado obrigatoriamente por **dois pontos e vírgulas (`;;`)**, e a estrutura inteira é fechada pela palavra `esac` (`case` ao contrário).

---

### Laços de Repetição (*Loops*): `for` e `while`

Os laços permitem repetir comandos sobre coleções de itens, intervalos numéricos ou arquivos em disco.

#### 1. O Laço `for`

```bash
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
```

---

#### 2. O Laço `while`

O `while` repete o bloco enquanto uma condição for verdadeira.

```bash
# Contador simples:
CONTADOR=1
while (( CONTADOR <= 5 )); do
    echo "Contagem: $CONTADOR"
    (( CONTADOR++ ))
done
```

##### Como Ler Arquivos Linha por Linha de Forma Segura com `while`:
A forma canônica no Linux para ler um arquivo de texto linha a linha sem perder espaços nas pontas nem corromper barras invertidas é combinar `IFS=` com `read -r`:

```bash
#!/bin/bash
ARQUIVO_USUARIOS="usuarios.txt"

# IFS= desativa quebra automática de espaços em branco
# read -r impede que barras invertidas (\) sejam interpretadas como escape
while IFS= read -r linha; do
    # Ignora linhas vazias ou que iniciam com comentário (#)
    [[ -z "$linha" || "$linha" =~ ^# ]] && continue
    
    echo "Criando conta para o usuário: $linha"
done < "$ARQUIVO_USUARIOS"
```

---

### Funções em Shell Script

Funções permitem reutilizar blocos de código, tornar os scripts modulares e isolar variáveis locais:

```bash
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
```

---

### Exemplos do Mundo Real

Abaixo você encontra scripts completos e funcionais prontos para uso em projetos e servidores:

#### Exemplo 1: Script de Backup Automatizado com Timestamp e Rotação

Este script compacta uma pasta, calcula o hash SHA-256 para auditoria e exclui automaticamente backups com mais de 7 dias para não estourar o disco:

```bash
#!/bin/bash
# ==============================================================================
# Script: backup_sistema.sh
# ==============================================================================
set -euo pipefail

# Configurações
DIR_ORIGEM="${1:-/home/marcelo/msp2026/docs}"
DIR_DESTINO="/tmp/backups_msp2026"
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
NOME_ARQUIVO="backup_docs_${TIMESTAMP}.tar.gz"

echo "=== INICIANDO ROTINA DE BACKUP ==="

# 1. Verifica se a pasta de origem existe
if [[ ! -d "$DIR_ORIGEM" ]]; then
    echo "Erro: Diretório de origem '$DIR_ORIGEM' não encontrado!" >&2
    exit 1
fi

# 2. Cria a pasta de destino se não existir
mkdir -p "$DIR_DESTINO"

# 3. Compacta os dados em formato tar.gz
echo "Compactando '$DIR_ORIGEM' para '$DIR_DESTINO/$NOME_ARQUIVO'..."
tar -czf "$DIR_DESTINO/$NOME_ARQUIVO" -C "$(dirname "$DIR_ORIGEM")" "$(basename "$DIR_ORIGEM")"

# 4. Gera hash de integridade
HASH=$(sha256sum "$DIR_DESTINO/$NOME_ARQUIVO" | cut -d' ' -f1)
echo "Backup gerado com sucesso!"
echo "Tamanho: $(du -h "$DIR_DESTINO/$NOME_ARQUIVO" | cut -f1)"
echo "SHA-256: $HASH"

# 5. Rotação: exclui backups com mais de 7 dias (+7) na pasta de destino
echo "Limpando backups com mais de 7 dias..."
find "$DIR_DESTINO" -name "backup_docs_*.tar.gz" -type f -mtime +7 -delete

echo "=== BACKUP CONCLUÍDO COM SUCESSO ==="
exit 0
```

---

#### Exemplo 2: Monitor de Saúde do Servidor com Alertas

Este script analisa o uso da partição raiz (`/`) e da memória RAM. Se ultrapassarem os limites de tolerância, emite alertas imediatos:

```bash
#!/bin/bash
# ==============================================================================
# Script: monitor_saude.sh
# ==============================================================================

LIMITE_DISCO_PERCENTUAL=80

echo "--- RELATÓRIO DE SAÚDE DO SISTEMA ($(date '+%d/%m/%Y %H:%M:%S')) ---"

# 1. Checagem de Disco da partição raiz (/)
# df extrai a coluna de percentual de uso, remove o símbolo '%' e compara:
USO_DISCO=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

if (( USO_DISCO >= LIMITE_DISCO_PERCENTUAL )); then
    echo -e "\033[31m[ALERTA CRÍTICO]\033[0m Uso de disco em ${USO_DISCO}% (acima do limite de ${LIMITE_DISCO_PERCENTUAL}%)!"
else
    echo -e "\033[32m[OK]\033[0m Uso de disco saudável: ${USO_DISCO}%"
fi

# 2. Checagem de Memória RAM Disponível
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_DISP=$(free -m | awk '/Mem:/ {print $7}')
PERCENTUAL_LIVRE=$(( (MEM_DISP * 100) / MEM_TOTAL ))

echo "Memória Disponível: ${MEM_DISP} MB de ${MEM_TOTAL} MB (${PERCENTUAL_LIVRE}% livre)"

if (( PERCENTUAL_LIVRE < 10 )); then
    echo -e "\033[31m[ALERTA CRÍTICO]\033[0m Menos de 10% de memória RAM disponível!"
fi

# 3. Uptime e Carga
echo "Carga do Processador: $(uptime | awk -F'load average:' '{print $2}')"
echo "--- FIM DO RELATÓRIO ---"
```

---

#### Exemplo 3: Renomeação e Higienização de Arquivos em Massa

Em ambientes Linux, arquivos contendo espaços em branco no nome frequentemente quebram scripts e pipelines mal preparados. Este script localiza todos os arquivos com espaços em uma pasta e substitui os espaços por sublinhados (`_`):

```bash
#!/bin/bash
# ==============================================================================
# Script: higienizar_nomes.sh
# ==============================================================================
set -euo pipefail

PASTA_ALVO="${1:-.}"

echo "Buscando arquivos com espaços em '$PASTA_ALVO'..."

# Usa o find com -print0 e o read com -d '' para suportar com segurança
# nomes de arquivos complexos contendo quebras de linha e caracteres especiais
TOTAL=0
while IFS= read -r -d '' arquivo; do
    DIR=$(dirname "$arquivo")
    NOME_ANTIGO=$(basename "$arquivo")
    NOME_NOVO="${NOME_ANTIGO// /_}" # Substitui todos os espaços por '_'

    if [[ "$NOME_ANTIGO" != "$NOME_NOVO" ]]; then
        mv "$DIR/$NOME_ANTIGO" "$DIR/$NOME_NOVO"
        echo "Renomeado: '$NOME_ANTIGO' -> '$NOME_NOVO'"
        (( TOTAL++ ))
    fi
done < <(find "$PASTA_ALVO" -depth -name "* *" -print0)

echo "Higienização finalizada. Total de itens renomeados: $TOTAL"
```

---

### Agendamento Automático com o `cron`

Um dos maiores benefícios de criar scripts de automação é deixá-los rodando de forma periódica e autônoma usando o daemon **`cron`** do Linux.

Para agendar um script:

```bash
# Abre o arquivo de agendamentos do usuário atual no editor:
$ crontab -e
```

Cada linha do arquivo do `cron` possui **5 campos de tempo**, seguidos pelo comando a ser executado:

```text
# ┌───────────── Minuto (0 - 59)
# │ ┌────────────── Hora (0 - 23)
# │ │ ┌─────────────── Dia do mês (1 - 31)
# │ │ │ ┌──────────────── Mês (1 - 12)
# │ │ │ │ ┌───────────────── Dia da semana (0 - 6, onde 0 = Domingo)
# │ │ │ │ │
# * * * * * comando_a_executar
```

#### Exemplos de Agendamentos Práticos:

```bash
# Executa o backup todos os dias às 02:30 da madrugada:
30 02 * * * /home/marcelo/scripts/backup_sistema.sh >> /var/log/backup.log 2>&1

# Executa o monitor de saúde a cada 15 minutos:
*/15 * * * * /home/marcelo/scripts/monitor_saude.sh >> /var/log/saude.log 2>&1

# Executa toda segunda-feira às 08:00:
00 08 * * 1 /home/marcelo/scripts/relatorio_semanal.sh
```

---

### Resumo dos Comandos e Sintaxes de Scripting

| Sintaxe | O que faz / Significado | Exemplo |
| :--- | :--- | :--- |
| **`#!/bin/bash`** | *Shebang*: define o interpretador a ser usado | Primeira linha do script |
| **`chmod +x`** | Concede permissão de execução ao script | `chmod +x deploy.sh` |
| **`set -euo pipefail`** | Ativa o modo de segurança e parada imediata em falhas | Logo após o Shebang |
| **`$1`, `$2`, `$@`** | Parâmetros posicionais passados na linha de comando | `echo "Primeiro: $1"` |
| **`$#`** | Quantidade total de argumentos fornecidos | `if [[ $# -lt 1 ]]; then` |
| **`$?`** | Código de retorno do comando anterior (`0` = sucesso) | `echo "Status: $?"` |
| **`[[ -f $ARQ ]]`** | Testa se o caminho é um arquivo regular existente | `if [[ -f config.ini ]]` |
| **`[[ -d $DIR ]]`** | Testa se o caminho é uma pasta/diretório existente | `if [[ -d /tmp/dados ]]` |
| **`for X in ...`** | Laço de repetição sobre listas, números ou arquivos | `for f in *.txt; do` |
| **`while read ...`** | Leitura segura de arquivos linha por linha | `while IFS= read -r l; do` |
| **`crontab -e`** | Edita a tabela de agendamentos automáticos do sistema | `30 02 * * * /path/script.sh` |

---

<p class="nav-footer" style="display: flex; justify-content: space-between; align-items: center; max-width: 650px; margin: 3rem auto 1.5rem auto;">
  <a href="03_processos_monitoramento.html" class="module-btn secondary">← Módulo 03: Processos e Recursos</a>
  <a href="index.html" class="module-btn secondary">Índice</a>
  <a href="05_depuracao_profiling.html" class="module-btn">Próximo: Módulo 05 (Profiling) →</a>
</p>

<script>
  (function() {
    var btn = document.getElementById('theme-toggle');
    if (!btn) return;
    function currentTheme() {
      var attr = document.documentElement.getAttribute('data-theme');
      if (attr) return attr;
      return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    }
    btn.addEventListener('click', function() {
      var next = currentTheme() === 'dark' ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', next);
      localStorage.setItem('theme', next);
    });
  })();
</script>
