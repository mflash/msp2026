# 02. Redirecionamento, Pipes e Filtros de Texto

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

![](img/msp2026.jpg)

## Semana Acadêmica Integrada - PUCRS / Escola Politécnica - 2026

**Profs. Edson Ifarraguirre Moreno e Marcelo Cohen**  
*Módulo 02 — Redirecionamento de Entrada/Saída, Encadeamento (Pipes) e Processamento de Texto*  
📊 **Slides da Apresentação:** [Acessar Slides do Módulo 02](slides_02_redirecionamento_pipes.html){target="_blank" rel="noopener"}

---

### A Filosofia Unix: O Poder da Composição

Uma das ideias mais revolucionárias da história da computação foi formulada nos laboratórios Bell Labs durante a concepção do Unix:

> *"Escreva programas que façam apenas uma coisa e a façam com perfeição. Escreva programas que trabalhem juntos. Escreva programas que manipulem fluxos de texto, porque essa é uma interface universal."*  
> — **Doug McIlroy**, inventor dos *pipes* no Unix

Em vez de criar aplicativos gigantescos e monolíticos repletos de funções secundárias, o ecossistema Linux fornece centenas de utilitários enxutos e altamente especializados. A verdadeira mágica do terminal acontece quando você **combina esses pequenos programas como blocos de LEGO**, conectando a saída de um na entrada de outro para resolver problemas complexos em uma única linha de comando.

---

### Os Três Fluxos Padrão (*Streams*)

Sempre que você executa um programa no Linux, o sistema operacional abre automaticamente para ele três canais de comunicação com o mundo externo, identificados por números conhecidos como **Descritores de Arquivo** (*File Descriptors* ou **FD**):

| Descritor (FD) | Nome | Função | Dispositivo Padrão |
| :---: | :---: | :--- | :--- |
| **`0`** | **`stdin`** (*Standard Input*) | Canal de entrada por onde o programa lê seus dados. | **Teclado** |
| **`1`** | **`stdout`** (*Standard Output*) | Canal de saída por onde o programa envia os dados normais gerados. | **Tela (Terminal)** |
| **`2`** | **`stderr`** (*Standard Error*) | Canal de saída exclusivo para mensagens de erro e alertas de diagnóstico. | **Tela (Terminal)** |

#### Por que o `stderr` é separado do `stdout`?
Pela tela, você pode ter a impressão de que `stdout` e `stderr` são a mesma coisa, pois ambos aparecem no seu terminal. No entanto, o sistema os trata como **duas saídas completamente distintas**. 

Se um script estiver gerando um relatório em `stdout` e encontrar um aviso pontual, o aviso viaja pelo `stderr`. Dessa forma, você pode salvar o relatório limpo em um arquivo sem poluí-lo com mensagens de erro, ou enviar os erros para um arquivo de log dedicado.

[![Redirecionamento de Fluxos e Pipes no Linux (clique para ampliar)](img/linux-redirection-pipes.svg)](img/linux-redirection-pipes.svg)

---

### Redirecionamento de Entrada e Saída

O shell permite alterar a rota padrão desses canais usando símbolos de redirecionamento, apontando-os para arquivos ou outros dispositivos.

#### 1. `>` : Sobrescrever a Saída Padrão (`stdout`)

O operador `>` desvia a saída padrão (`stdout`) de um comando para um arquivo. Se o arquivo já existir, **ele será completamente substituído (truncado)**. Se não existir, ele será criado:

```bash
# Salva a data atual em um novo arquivo (ou sobrescreve se já existir)
$ date > data_hoje.txt

# Confere o conteúdo gerado
$ cat data_hoje.txt
Sat Oct 17 18:45:00 -03 2026

# Se executarmos outro comando com '>', o conteúdo antigo é apagado:
$ echo "Novo texto de teste" > data_hoje.txt
$ cat data_hoje.txt
Novo texto de teste
```

> **Atenção:** Tenha cuidado ao usar `>`, pois a sobrescrita é imediata e irreversível.

---

#### 2. `>>` : Anexar (*Append*) à Saída Padrão

O operador `>>` adiciona os novos dados **ao final** do arquivo existente, preservando o que já estava gravado lá. É a forma clássica de registrar eventos e logs:

```bash
# Cria ou adiciona linhas a um arquivo de histórico
$ echo "Início da sessão: $(date)" >> auditoria.log
$ echo "Backup concluído com sucesso" >> auditoria.log

# Exibe o arquivo com todas as linhas preservadas:
$ cat auditoria.log
Início da sessão: Sat Oct 17 18:45:10 -03 2026
Backup concluído com sucesso
```

---

#### 3. `<` : Redirecionar a Entrada Padrão (`stdin`)

O operador `<` faz um comando ler seus dados a partir de um arquivo em disco, em vez de esperar que o usuário digite algo no teclado:

```bash
# Envia o arquivo 'lista.txt' para a entrada padrão do comando 'sort'
$ sort < nomes_desordenados.txt

# Conta quantas linhas existem no arquivo passando-o pelo stdin:
$ wc -l < /etc/passwd
48
```

---

#### 4. Redirecionando Erros: `2>`, `2>&1` e `&>`

Como vimos, os erros viajam pelo descritor `2` (`stderr`). Você pode manipulá-los especificamente:

```bash
# 1. Separar o resultado válido dos erros:
# Sucesso vai para 'arquivos_encontrados.txt' e permissões negadas vão para 'erros.log'
$ ls -l /root /home 1> arquivos_encontrados.txt 2> erros.log

# 2. Silenciar erros enviando-os para o "buraco negro" do Linux (/dev/null):
# O arquivo especial /dev/null descarta imediatamente tudo o que é escrito nele!
$ ls -l /root 2> /dev/null

# 3. Combinar stdout e stderr no mesmo arquivo (sintaxe moderna no Bash):
$ comando_demorado &> saida_completa.log

# Ou na sintaxe tradicional compatível com qualquer shell POSIX (2>&1 significa: 'direcione o canal 2 para onde o canal 1 estiver apontando'):
$ comando_demorado > saida_completa.log 2>&1
```

---

#### 5. Here Documents (`<<`) e Here Strings (`<<<`)

Para enviar múltiplas linhas de texto para um comando de dentro de um script ou diretamente no terminal, usamos o **Here Document** delimitado por uma palavra-chave (normalmente `EOF` — *End of File*):

```bash
# Cria um arquivo com várias linhas sem abrir um editor:
$ cat << EOF > config.ini
[servidor]
ip = 192.168.1.100
porta = 8080
ambiente = producao
EOF

$ cat config.ini
[servidor]
ip = 192.168.1.100
porta = 8080
ambiente = producao
```

A **Here String** (`<<<`) envia uma única variável ou string curta direto para a entrada de um comando:

```bash
# Envia o conteúdo de uma variável para o utilitário 'tr' para converter em maiúsculas:
$ NOME="marcelo"
$ tr '[:lower:]' '[:upper:]' <<< "$NOME"
MARCELO
```

---

### O Operador Pipe (`|`): Conectando Processos

O caractere barra vertical (`|`), chamado de **Pipe** (tubo ou canalizador), é um dos recursos mais poderosos do Linux.

Ele conecta a saída padrão (`stdout`) do comando à esquerda diretamente na entrada padrão (`stdin`) do comando à direita:
> **Comando A** `(stdout)` ───▶ **`|`** *(Pipe em memória)* ───▶ `(stdin)` **Comando B**

#### Por que o Pipe é tão rápido e eficiente?

1. **Sem arquivos em disco:** O dado não precisa ser salvo em um arquivo temporário intermediário no SSD/HD.
2. **Buffer em RAM:** O kernel cria um buffer circular na memória e transfere os bytes em tempo real.
3. **Concorrência:** Ambos os programas rodam **ao mesmo tempo**. Assim que o Comando A cospe os primeiros bytes, o Comando B já começa a processá-los.

---

### Filtros Essenciais para Processamento de Texto

Um **filtro** no Linux é um comando que recebe texto pela entrada padrão, aplica uma transformação ou seleção e envia o resultado para a saída padrão. A seguir estão os filtros mais importantes do dia a dia:

#### 1. `head` e `tail` : Início e Fim de Arquivos

```bash
# Exibe as primeiras 5 linhas de um arquivo (-n 5)
$ head -n 5 /etc/passwd

# Exibe as últimas 10 linhas de um log (padrão é 10)
$ tail -n 10 /var/log/syslog

# MONITORE EM TEMPO REAL (-f / follow):
# O terminal continua aberto exibindo novas linhas assim que elas forem gravadas no log!
# Ideal para acompanhar servidores e deploys (pressione Ctrl+C para sair).
$ tail -f /var/log/nginx/access.log
```

---

#### 2. `wc` (*Word Count*) : Contagem de Linhas, Palavras e Bytes

```bash
# wc sem opções: exibe linhas, palavras e bytes
$ wc /etc/hosts
      15      35     420 /etc/hosts

# Contar exclusivamente o número de LINHAS (-l):
# Extremamente comum ao final de pipes para responder "quantos itens existem?"
$ wc -l /etc/passwd
48

# Quantos arquivos existem no diretório atual?
$ ls -1 | wc -l
12
```

---

#### 3. `sort` : Ordenação de Linhas

O comando `sort` organiza as linhas de texto em ordem alfabética ou numérica:

```bash
# Ordenação alfabética padrão (A-Z)
$ cat frutas.txt
banana
laranja
abacaxi
uva

$ sort frutas.txt
abacaxi
banana
laranja
uva

# Ordenação reversa (-r):
$ sort -r frutas.txt

# Ordenação numérica correta (-n):
# Sem -n, o número 10 viria antes de 2 na ordem alfabética!
$ cat numeros.txt
10
2
100
5

$ sort -n numeros.txt
2
5
10
100

# Ordenar por uma coluna específica (-k):
# Ordena pelo 2º campo (-k2) usando espaço como delimitador
$ sort -k2 lista_pessoas.txt
```

---

#### 4. `uniq` : Filtragem de Duplicatas

O `uniq` detecta e remove linhas repetidas. 

> **Regra Crucial do `uniq`:** Ele **só compara linhas consecutivas adjacentes**! Por isso, na grande maioria das vezes, você deve rodar `sort` **antes** de passar pelo `uniq`:

```bash
$ cat acessos.txt
marcelo
edson
marcelo
lucas
edson

# 1. Remover duplicatas após ordenar:
$ sort acessos.txt | uniq
edson
lucas
marcelo

# 2. Contar a frequência de cada item (-c / count):
$ sort acessos.txt | uniq -c
      2 edson
      1 lucas
      2 marcelo

# 3. Mostrar os mais frequentes no topo (combinando sort -nr):
$ sort acessos.txt | uniq -c | sort -nr
      2 marcelo
      2 edson
      1 lucas
```

---

#### 5. `grep` : Busca de Padrões e Expressões Regulares

O `grep` (*Global Regular Expression Print*) pesquisa palavras, expressões ou padrões dentro de arquivos ou fluxos de texto. É uma das ferramentas mais usadas por programadores no mundo inteiro.

```bash
# Busca simples: linhas que contêm a palavra "root"
$ grep "root" /etc/passwd
root:x:0:0:root:/root:/bin/bash

# Ignorar maiúsculas/minúsculas (-i / case-insensitive):
$ grep -i "python" script.py

# Inverter a busca (-v): mostra apenas as linhas que NÃO contêm a palavra
# Útil para remover comentários e linhas em branco de arquivos de configuração:
$ grep -v "^#" /etc/ssh/sshd_config | grep -v "^$"

# Numerar as linhas encontradas (-n):
$ grep -n "main" programa.c
42:int main(int argc, char *argv[]) {

# Busca recursiva em todo o projeto (-r):
# Procura pela função "conectarBanco" em todos os arquivos da pasta atual:
$ grep -r "conectarBanco" src/

# Contar quantas vezes a ocorrência apareceu (-c):
$ grep -c "ERROR" log_aplicacao.txt
```

---

#### 6. `cut` : Extração de Colunas e Campos

O utilitário `cut` fatia linhas de texto, extraindo colunas delimitadas por caracteres (como vírgula em CSVs ou dois-pontos em arquivos do sistema):

```bash
# No /etc/passwd, os campos são separados por dois-pontos (:).
# O primeiro campo (-f1) é o nome de usuário; o sétimo (-f7) é o shell:
# Formato: username:password:uid:gid:gecos:homedir:shell

# Extrair apenas a lista de nomes de usuários do sistema (-d: para delimitador, -f1 para 1ª coluna):
$ cut -d':' -f1 /etc/passwd | head -n 5
root
daemon
bin
sys
sync

# Extrair apenas o usuário e seu respectivo shell (-f1,7):
$ cut -d':' -f1,7 /etc/passwd | head -n 5
root:/bin/bash
daemon:/usr/sbin/nologin
bin:/usr/sbin/nologin
sys:/usr/sbin/nologin
sync:/bin/sync

# Extrair por posição de caracteres (-c 1-10 para os primeiros 10 caracteres):
$ cut -c 1-10 arquivo.txt
```

---

#### 7. `tr` : Tradução e Substituição de Caracteres

O `tr` (*translate*) lê de `stdin` e substitui, comprime ou deleta caracteres específicos:

```bash
# Converter todo o texto para letras MAIÚSCULAS:
$ echo "aprendendo shell linux" | tr '[:lower:]' '[:upper:]'
APRENDENDO SHELL LINUX

# Substituir espaços por quebras de linha (cada palavra em uma linha):
$ echo "um dois tres quatro" | tr ' ' '\n'
um
dois
tres
quatro

# Deletar caracteres indesejados (-d), como quebras de linha Windows (\r):
$ tr -d '\r' < arquivo_windows.txt > arquivo_unix.txt

# Comprimir repetições de múltiplos espaços em um único espaço (-s / squeeze):
$ echo "texto     com    muito        espaco" | tr -s ' '
texto com muito espaco
```

---

#### 8. `tee` : O "T" Hidráulico

Às vezes você quer salvar a saída de um comando em um arquivo, mas **ao mesmo tempo** quer continuar vendo o progresso na tela do terminal ou encaminhá-lo para outro comando no pipe. O `tee` funciona como uma conexão em forma de "T" encanada:

```bash
# Mostra na tela E salva em 'compilacao.log' simultaneamente:
$ make build | tee compilacao.log

# Adicionar sem sobrescrever com a opção -a (--append):
$ echo "Nova etapa concluída" | tee -a auditoria.log
```

---

### Casos Reais: Pipelines Avançados no Dia a Dia

Agora que você conhece as peças do tabuleiro, veja exemplos práticos de como administradores e desenvolvedores combinam esses comandos para realizar análises poderosas:

#### Exemplo 1: Consumindo uma API Web Pública com `curl` e Encadeando Múltiplos Pipes

O comando **`curl`** (*Client URL*) é a ferramenta universal de linha de comando para realizar requisições de rede (HTTP, HTTPS, FTP, etc.) diretamente pelo terminal. Ao usá-lo com a opção `-s` (*silent*, que oculta medidores de progresso de download), ele envia o corpo da resposta HTTP diretamente para `stdout`.

Isso nos permite criar um pipeline completo de extração, limpeza, ordenação e armazenamento de dados em nuvem usando exclusivamente filtros padrão do Unix.

Neste exemplo, vamos consultar o serviço web público [JSONPlaceholder](https://jsonplaceholder.typicode.com/) (uma API REST pública gratuita muito usada em testes), filtrar e higienizar a lista de e-mails dos usuários cadastrados:

```bash
# Pipeline completo com 6 pipes em uma única instrução:
$ curl -s https://jsonplaceholder.typicode.com/users | grep '"email"' | cut -d':' -f2 | tr -d '", ' | sort | head -n 5 | tee emails_top5.txt
Chaim_McDermott@dana.io
Julianne.OConner@kory.org
Karley_Dach@jasper.info
Lucio_Hettinger@annie.ca
Nathan@yesenia.net
```

##### Passo a Passo: O que Acontece em Cada Pipe (`|`):

1. **`curl -s https://jsonplaceholder.typicode.com/users`**  
   Faz a requisição `GET` ao serviço web e transmite o JSON com a lista completa de usuários para a saída padrão (`stdout`).
2. **`| grep '"email"'`**  
   Filtra o JSON recebido pelo canal, mantendo somente as linhas que possuem a chave de e-mail (ex.: `"email": "Sincere@april.biz",`).
3. **`| cut -d':' -f2`**  
   Fatia a linha nos dois-pontos (`:`) e extrai apenas a segunda coluna (o valor do e-mail, descartando o rótulo `"email"`).
4. **`| tr -d '", '`**  
   Remove (*delete* `-d`) aspas duplas, vírgulas e espaços em branco excedentes da formatação original do JSON.
5. **`| sort`**  
   Ordena os e-mails alfabeticamente de A a Z.
6. **`| head -n 5`**  
   Filtra e seleciona apenas os 5 primeiros e-mails da lista ordenada.
7. **`| tee emails_top5.txt`**  
   Exibe o resultado final na tela do terminal e, **simultaneamente**, salva uma cópia no arquivo `emails_top5.txt`.

##### Variação Analítica: Extraindo Domínios e Contando Provedores

Alterando o delimitador do `cut` para `@` e agrupando com `uniq -c`, podemos descobrir a frequência de cada provedor de e-mail retornado pela API:

```bash
# Extrai o domínio de cada e-mail, agrupa com sort, conta com uniq -c e ordena decrescente:
$ curl -s https://jsonplaceholder.typicode.com/users \
    | grep '"email"' \
    | cut -d'@' -f2 \
    | tr -d '",' \
    | sort \
    | uniq -c \
    | sort -nr
      1 yesenia.net
      1 rosamond.me
      1 melissa.tv
      1 kory.org
      1 karina.biz
      1 jasper.info
      1 dana.io
      1 billy.biz
      1 april.biz
      1 annie.ca
```

---

#### Exemplo 2: Descobrir quais são os shells mais utilizados no servidor
```bash
# Passo a passo da mágica:
# 1. cut extrai o shell (7º campo do /etc/passwd)
# 2. sort agrupa os shells idênticos
# 3. uniq -c conta quantas vezes cada shell apareceu
# 4. sort -nr ordena do mais utilizado para o menos utilizado
$ cut -d':' -f7 /etc/passwd | sort | uniq -c | sort -nr
     32 /usr/sbin/nologin
     10 /bin/bash
      4 /bin/false
      2 /bin/zsh
```

---

#### Exemplo 3: Descobrir os 5 endereços IP com maior número de requisições em um log web
```bash
# Em logs do Nginx/Apache, o 1º campo geralmente é o endereço IP do visitante:
$ cut -d' ' -f1 /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -n 5
    1452 192.168.1.45
     823 10.0.0.12
     430 172.16.2.8
     215 192.168.1.100
      98 10.0.0.50
```

---

#### Exemplo 4: Listar os 5 maiores arquivos ou diretórios que estão consumindo espaço em disco
```bash
# du -ah calcula o tamanho de todos os itens
# sort -rh ordena por tamanho de arquivo decrescente legível para humanos (G, M, K)
# head -n 5 pega apenas os 5 maiores
$ du -ah /home/marcelo | sort -rh | head -n 5
3.2G    /home/marcelo/projetos/dataset_ia.bin
1.4G    /home/marcelo/virtualenv/lib
850M    /home/marcelo/downloads/ubuntu.iso
420M    /home/marcelo/docs/video_aula.mp4
120M    /home/marcelo/.cache
```

---

#### Exemplo 5: Contar a frequência de palavras em um documento de texto
```bash
# Converte para minúsculas, transforma pontuações e espaços em quebras de linha,
# remove linhas vazias, ordena e conta as 10 palavras mais usadas:
$ cat artigo.txt | tr '[:upper:]' '[:lower:]' | tr -cs '[:alnum:]' '\n' | sort | uniq -c | sort -nr | head -n 10
```

---

### Resumo dos Operadores de Redirecionamento

| Operador | O que faz | Exemplo |
| :--- | :--- | :--- |
| **`>`** | Sobrescreve a saída padrão (`stdout`) em um arquivo | `echo "ok" > status.txt` |
| **`>>`** | Anexa à saída padrão (`stdout`) de um arquivo existente | `echo "ok" >> status.txt` |
| **`<`** | Lê a entrada padrão (`stdin`) a partir de um arquivo | `sort < lista.txt` |
| **`2>`** | Redireciona apenas as mensagens de erro (`stderr`) | `ls /root 2> erros.log` |
| **`2> /dev/null`** | Descarta e silencia qualquer mensagem de erro | `find / -name "*.conf" 2> /dev/null` |
| **`2>&1`** ou **`&>`** | Combina `stdout` e `stderr` no mesmo arquivo | `backup.sh &> backup.log` |
| **`|`** | Conecta o `stdout` de um programa ao `stdin` do próximo | `cat log.txt | grep ERROR | wc -l` |
| **`tee`** | Grava em arquivo e repassa o fluxo adiante na tela/pipe | `make | tee comp.log | grep Error` |

---

<p class="nav-footer" style="display: flex; justify-content: space-between; align-items: center; max-width: 650px; margin: 3rem auto 1.5rem auto;">
  <a href="01_shell.html" class="module-btn secondary">← Módulo 01: Shell Básico</a>
  <a href="index.html" class="module-btn secondary">Índice</a>
  <a href="03_processos_monitoramento.html" class="module-btn">Próximo: Módulo 03 (Processos) →</a>
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
