# Roteiro de Apresentação: Manual de Sobrevivência de Programação

**Semana Acadêmica Integrada — PUCRS / Escola Politécnica (2026)**  
**Duração total:** 1h30 (90 minutos)  
**Ministrantes:** Profs. Edson Ifarraguirre Moreno e Marcelo Cohen  
**Premissa pedagógica:** Os módulos 01 e 02 (fundamentos) recebem 15 minutos cada. O Módulo 03 (Processos) vira uma pílula de 4 minutos, só com o essencial para destravar a máquina, e o tempo liberado reforça o 04 (12 min), o 05 (17 min) e o 06 (17 min). Todos os exemplos vêm do material publicado em `docs/`, para que os alunos possam reproduzir em casa exatamente o que viram na apresentação.

**Como ler este roteiro:** cada seção traz três partes:
- **Por que apresentar:** a motivação para dar aos alunos;
- **O que e como apresentar:** passos com tempo, comandos e onde estão no material;
- **Ponte:** a ligação com o módulo seguinte, que costura a narrativa.

---

## 1. Cronograma Geral (90 Minutos)

| Bloco / Seção | Duração | Horário Relativo | Foco Pedagógico | Formato Principal |
| :--- | :---: | :---: | :--- | :--- |
| **Abertura & Motivação** | **5 min** | 00:00 – 00:05 | *Missing Semester*, onipresença do Linux e filosofia Unix. | Slides (`slides_introducao.html`) |
| **01. Shell e Comandos Básicos** | **15 min** | 00:05 – 00:20 | Shell vs. terminal, FHS, navegação, `$PATH` e `chmod`. | Terminal ao vivo + diagramas |
| **02. Redirecionamento, Pipes e Filtros** | **15 min** | 00:20 – 00:35 | `stdin`/`stdout`/`stderr`, `>`/`2>`, pipe e montagem de pipelines. | Terminal ao vivo |
| **03. Gerenciamento de Processos** | **4 min** | 00:35 – 00:39 | PID, `ps`/`htop` e sinais (`kill` antes de `kill -9`). | Pílula relâmpago |
| **04. Automação e Shell Scripting** | **12 min** | 00:39 – 00:51 | Shebang, modo estrito, argumentos, `$?`, decisões com `[[ ]]`, um script real e `cron`. | Editor + terminal (scripts prontos) |
| **05. Depuração e Profiling** | **17 min** | 00:51 – 01:08 | Medir antes de otimizar: logging, flame graph, `cProfile`, Callgrind e Valgrind/Memcheck. | Terminal + navegador |
| **06. Git e Trabalho Colaborativo** | **17 min** | 01:08 – 01:25 | As quatro áreas, `.gitignore`, branches, conflito e sincronização com o remoto. | Terminal + diagramas |
| **Encerramento & Dúvidas** | **5 min** | 01:25 – 01:30 | Onde está o material e como continuar estudando. | Diálogo |

---

## 2. Roteiro Detalhado por Seção

### Abertura & Motivação (5 min | 00:00 – 00:05)

**Por que apresentar:** os alunos precisam sair dos primeiros 5 minutos convencidos de que o terminal não é um assunto de nostalgia, e sim a ferramenta com que se opera a nuvem, os containers e os servidores em que vão trabalhar. Sem essa motivação, os 80 minutos seguintes parecem "decoreba de comandos".

**O que e como apresentar** (slides `slides_introducao.html`):
1. **O "Missing Semester" (1 min):** o projeto do MIT CSAIL que inspira o material. Mensagem: são competências cobradas no estágio e no mercado, mas que raramente aparecem de forma sistemática nas disciplinas.
2. **"O Linux move a tecnologia global" (2 min):** use os números do Módulo 01 (`01_shell.md`, "A Importância do Linux Hoje"):
   - mais de 70% das instâncias de nuvem;
   - Android (kernel Linux) em mais de 70% dos smartphones;
   - 100% dos 500 maiores supercomputadores desde 2017;
   - Docker e Kubernetes construídos sobre *namespaces* e *cgroups*;
   - o helicóptero *Ingenuity* em Marte.
3. **Linha do tempo (1 min):** imagem `timeline-unix-linux.svg`. Bell Labs, depois o Unix reescrito em C (1973, portabilidade), GNU, e o Linus em 1991. Não leia as datas; conte a história em três frases.
4. **Filosofia Unix (1 min):** a citação de Doug McIlroy ("programas que façam uma coisa bem, que trabalhem juntos, que manipulem texto"). Diga explicitamente que essa frase é o fio condutor da oficina: ela explica os pipes (02), os scripts (04) e por que logs são texto (05).

> Os slides "O que é o Shell?" e "O Sistema de Arquivos (FHS)" ficam para o Módulo 01. O slide "Roteiro da Oficina" fecha a abertura.

---

### Módulo 01: Shell e Comandos Básicos (15 min | 00:05 – 00:20)

**Por que apresentar:** antes de compor comandos, o aluno precisa de um mapa mental: onde está, quem interpreta o que ele digita e por que às vezes recebe `command not found` ou `Permission denied`. Esses dois erros são os mais frequentes de quem está começando, e o módulo explica a causa dos dois.

**O que e como apresentar:**
1. **Shell vs. terminal (2 min):** mostre a foto do DEC VT100 (`vt100.jpg`).
   - **Explicação:** o terminal físico só enviava teclas e exibia texto. Quem interpretava os comandos era um programa no computador central: o **shell**.
   - Hoje o terminal virou uma janela (emulador), mas o shell faz o mesmo trabalho de sempre.
   - **Por quê:** desfaz a confusão comum entre "terminal", "shell" e "bash".
2. **Sistema de arquivos e FHS (3 min):** diagrama `linux-filesystem.svg`. Enfatize quatro princípios:
   - raiz única `/` (não existe `C:`);
   - diferença entre maiúsculas e minúsculas;
   - "tudo é um arquivo";
   - arquivos ocultos começam com `.`.

   Aponte só os diretórios que eles vão usar: `/home`, `/bin` e `/usr/bin`, `/etc`, `/tmp` e `/dev/null` (que volta no Módulo 02).
3. **Navegação ao vivo (3 min):**
   ```bash
   pwd
   ls -la          # mostra os ocultos (.bashrc, .git)
   cd docs ; cd .. ; cd ~ ; cd -
   ```
   - **Dicas orais:** `Tab` para autocompletar e `Ctrl+R` para buscar no histórico. Elas não estão no material escrito, então vale citá-las como "bônus".
   - **Por quê:** é o que eles vão fazer centenas de vezes por dia, e o `Tab` sozinho elimina a maioria dos erros de digitação.
4. **A variável `$PATH` (3 min):**
   ```bash
   echo $PATH
   which ls
   which python3
   ```
   - **Explicação:** o shell percorre os diretórios do `$PATH` da esquerda para a direita. Se não achar o comando em nenhum deles, mostra `command not found` (`01_shell.md`, seção 7).
   - **Por quê:** é a resposta para "instalei, mas o terminal não acha", e prepara o `./script.sh` do Módulo 04.
5. **Permissões e `chmod` (4 min):** diagrama `linux-permissions.svg`.
   - Leia uma linha de `ls -l`: tipo, depois dono, grupo e outros, com `r=4`, `w=2`, `x=1`.
   - **Demonstração com o erro primeiro:** crie `script.sh` com `echo 'echo oi' > script.sh` e rode `./script.sh`. Aparece `Permission denied`. Em seguida, rode `chmod +x script.sh` e `./script.sh` de novo.
   - Mostre a diferença entre `644` (arquivos comuns) e `755` (executáveis). Cite `700` e `600` para `~/.ssh`, que volta no Módulo 06.
   - **Por quê:** mostrar o erro antes da solução fixa por que a permissão existe: arquivo novo não nasce executável, por segurança.

- *Armadilha a evitar:* não percorra `cp`, `mv`, `rm`, `nano` e `set`/`export` em sala. Estão no material para estudo; diga isso e siga em frente.

**Ponte para o 02:** *"Todo comando que vimos escreve texto na tela. E se, em vez da tela, esse texto fosse para um arquivo ou para outro programa?"*

---

### Módulo 02: Redirecionamento, Pipes e Filtros de Texto (15 min | 00:20 – 00:35)

**Por que apresentar:** é o momento de maior impacto conceitual da oficina. Aqui a filosofia Unix deixa de ser frase e vira prática: programas pequenos, combinados, resolvem em uma linha o que exigiria um programa inteiro em outra linguagem.

**O que e como apresentar:**
1. **Os três fluxos (3 min):** tabela de `stdin` (0), `stdout` (1) e `stderr` (2), mais o diagrama `linux-redirection-pipes.svg`.
   - **Pergunta para a turma:** *"Se os dois aparecem na tela, por que separar saída e erro?"*
   - **Resposta:** para salvar um relatório limpo sem misturar avisos nele.
2. **Redirecionamento ao vivo (3 min):**
   ```bash
   date > agora.txt ; cat agora.txt
   date >> agora.txt ; cat agora.txt           # > sobrescreve, >> acrescenta
   ls -l /root /home 1> ok.txt 2> erros.log    # sucesso e erro em arquivos separados
   ls -l /root 2> /dev/null                     # silencia o erro ("buraco negro")
   ```
   - Mostre `cat ok.txt` e `cat erros.log` para provar que são canais distintos.
   - Explique o `2>&1` lendo-o em voz alta: "mande o canal 2 para onde o canal 1 aponta".
3. **O pipe (2 min):** `|` conecta o `stdout` de um programa ao `stdin` do seguinte. Explique por que é eficiente (`02_redirecionamento_pipes.md`):
   - nenhum arquivo intermediário em disco;
   - um buffer em RAM;
   - os dois programas rodam **ao mesmo tempo**.
4. **Pipeline montado peça por peça (5 min):** *"Quais shells são mais usados nesta máquina?"* Rode cada linha e mostre a saída antes de acrescentar o próximo filtro:
   ```bash
   cat /etc/passwd | head -n 3                           # o dado cru: campos separados por ':'
   cut -d':' -f7 /etc/passwd | head                      # só o 7º campo (o shell)
   cut -d':' -f7 /etc/passwd | sort | head               # sort agrupa os iguais
   cut -d':' -f7 /etc/passwd | sort | uniq -c            # uniq -c conta cada grupo
   cut -d':' -f7 /etc/passwd | sort | uniq -c | sort -nr # do mais usado ao menos usado
   ```
   - **Por que este exemplo:** roda em qualquer Linux sem preparar arquivo nenhum, e cada filtro tem um efeito visível.
   - Destaque que o `uniq` só conta repetições vizinhas. Por isso o `sort` vem antes.
5. **Caso real com a web (2 min):** a mesma ideia aplicada a uma API pública (o "Exemplo 1" do material):
   ```bash
   curl -s https://jsonplaceholder.typicode.com/users | grep '"email"' | cut -d':' -f2 | tr -d '", ' | sort | head -n 5 | tee emails_top5.txt
   ```
   - Explique o `tee`: mostra na tela e salva em arquivo ao mesmo tempo.
   - **Por quê:** prova que os mesmos filtros servem para dados da internet, não só para arquivos do sistema.
   - *Plano B sem internet:* o Exemplo 4 (`du -ah ~ | sort -rh | head -n 5`, os maiores arquivos).

**Ponte para o 03:** *"Vimos que, num pipe, os dois programas rodam ao mesmo tempo. Cada um deles é um **processo**. Vamos ver como enxergar e controlar esses processos."*

---

### Módulo 03: Gerenciamento de Processos e Monitoramento (4 min | 00:35 – 00:39)
> **Abordagem: pílula relâmpago. Uma única demonstração contínua, sem slides.**

**Por que apresentar:** dar ao estudante o mínimo para destravar a própria máquina, ou um servidor remoto, sem reiniciar: achar o processo e encerrá-lo do jeito certo. Também corrige um vício comum: usar `kill -9` como primeira opção.

**O que e como apresentar** (um único fio de demonstração):
1. **Processo e PID (1 min):**
   - O programa é um arquivo passivo no disco; o processo é esse programa em execução, com memória, CPU e um **PID**.
   - Para criar um processo "de estimação" para o resto da demonstração, rode:
   ```bash
   python3 -m http.server 8080 &    # o & libera o terminal; o shell mostra [1] (job) e o PID
   ```
2. **Achar o processo (1,5 min):**
   ```bash
   ps aux | grep "[p]ython"     # lá está o PID do servidor
   htop                          # P ordena por CPU, M por memória; q sai
   ```
   - **Explique o truque `[p]ython`:** evita que o próprio `grep` apareça no resultado.
   - **Por quê:** é o pipe do Módulo 02 resolvendo um problema real.
3. **Encerrar na ordem certa (1,5 min):**
   - `Ctrl+C` envia `SIGINT` (programa em primeiro plano);
   - `kill <PID>` envia `SIGTERM`, o padrão: o programa pode salvar e fechar conexões;
   - só se ele ignorar, use `kill -9 <PID>` (`SIGKILL`): o kernel descarta o processo sem conversa.
   - Encerre o `http.server` com `kill` simples, ao vivo.
   - **Por quê:** o `-9` pode deixar arquivos corrompidos e conexões abertas. É o último recurso, não o primeiro.

- **Fica para estudo no material** (diga isso em uma frase): árvore de processos (`pstree`), *job control* (`Ctrl+Z`, `bg`, `fg`), `nohup`, `watch`, `nice` e `systemctl`, todos em `03_processos_monitoramento.md`.

**Ponte para o 04:** *"Até agora digitamos tudo à mão. E se essas sequências de comandos virassem um programa que roda sozinho?"*

---

### Módulo 04: Automação e Shell Scripting (12 min | 00:39 – 00:51)
> **Abordagem: scripts já escritos.** Abra os scripts no editor e execute-os. Não os digite ao vivo.

**Por que apresentar:** mostrar que um script é só "o que eu já digito no terminal, salvo num arquivo". O aluno descobre que já sabe 80% do shell scripting por causa dos módulos anteriores, e que automatizar é o que separa uma tarefa manual de uma ferramenta reproduzível.

**O que e como apresentar:**
1. **Anatomia de um script (3 min):** `backup_simples.sh` (`04_automacao_shell_scripting.md`, "Anatomia e Execução"):
   - **Shebang `#!/bin/bash`:** o kernel lê esses primeiros bytes e sabe qual interpretador chamar.
   - **`set -euo pipefail`:** para no primeiro erro, trata variável inexistente como erro e considera falhas no meio de um pipe.
     - **Por quê:** sem isso, um script com erro continua rodando "em silêncio", e um backup quebrado parece ter funcionado.
   - **`$(whoami)` e `$(date ...)`:** guardam a saída de um comando numa variável.
   - **Execução:** `chmod +x backup_simples.sh && ./backup_simples.sh`.
     - **Por que o `./`:** o diretório atual não está no `$PATH` (Módulo 01). Isso fecha uma pergunta que ficou aberta lá.
2. **Argumentos, validação e código de saída (3 min):** `converter_imagem.sh` (seção "Argumentos de Linha de Comando"):
   ```bash
   ./converter_imagem.sh ; echo $?          # sem argumentos: mensagem de uso e código 1
   ./converter_imagem.sh foto.png jpg ; echo $?   # correto: código 0
   ```
   - Mostre `$1`, `$2` e `$#` (quantidade de argumentos).
   - A mensagem de erro vai para o `stderr` (`>&2`), como no Módulo 02.
   - `$?`: 0 é sucesso, qualquer outro valor é erro.
   - **Por quê:** um script que valida a entrada e devolve um código de saída correto pode ser usado por outros scripts, pelo `cron` e pelo CI.
3. **Decisões com `[[ ... ]]` (1 min, novo):** trecho do `backup_sistema.sh` ("Exemplos do Mundo Real", Exemplo 1):
   ```bash
   if [[ ! -d "$DIR_ORIGEM" ]]; then
       echo "Erro: Diretório de origem '$DIR_ORIGEM' não encontrado!" >&2
       exit 1
   fi
   ```
   - Mostre a tabela de testes de arquivo (`-f`, `-d`, `-e`, `-x`).
   - Alerte que os espaços dentro de `[[ ]]` são obrigatórios: `[[-f arq]]` gera `command not found`.
   - **Por quê:** um script robusto verifica antes de agir. Sem esse teste, o `tar` falharia no meio do caminho.
4. **Laço sobre arquivos (1 min):**
   ```bash
   for arquivo in docs/*.md; do
       echo "Processando documento: $arquivo"
   done
   ```
   - Insista nas aspas em `"$arquivo"`: nomes com espaço quebram scripts sem aspas.
5. **Um script real (3 min):** execute o `monitor_saude.sh` ("Exemplos do Mundo Real", Exemplo 2) e leia três trechos com a turma:
   - `df -P / | awk 'NR==2 {print $5}' | tr -d '%'`: pipes e filtros do Módulo 02;
   - `free -m`: memória disponível, um recurso do sistema como os do Módulo 03;
   - `if (( USO_DISCO >= LIMITE ))`: a decisão que gera o alerta.
   - **Por quê:** este script junta os módulos anteriores numa ferramenta útil de verdade.
6. **Agendamento com `cron` (1 min, novo):** mostre o diagrama dos cinco campos (`minuto hora dia mês dia-da-semana`) e a linha do material:
   ```bash
   */15 * * * * /home/marcelo/scripts/monitor_saude.sh >> $HOME/logs/saude.log 2>&1
   ```
   - Leia a linha em voz alta: "a cada 15 minutos, rode o monitor e acrescente saída e erros ao log". É o `>>` e o `2>&1` do Módulo 02 de novo.
   - **Por quê:** fecha o arco da automação. O script deixa de depender de alguém lembrar de rodá-lo, e é o fechamento da primeira metade da oficina.

**Ponte para o 05:** *"Automatizamos tarefas. Mas e quando o programa, em vez de dar erro, simplesmente fica lento? Ou quando dá erro e não sabemos onde?"*

---

### Módulo 05: Depuração e Profiling (17 min | 00:51 – 01:08)
> **Abordagem: visual e demonstrativa. Medir antes de otimizar.**

**Por que apresentar:** alunos depuram com `print` e otimizam "no olhômetro". O módulo troca as duas coisas por método: **logs** para entender *por que* falhou e **profilers** para medir *onde* o tempo é gasto. A mensagem central: *a intuição erra; a medição não*.

**O que e como apresentar:**
1. **Mentalidade (3 min):** (`05_depuracao_profiling.md`, "Introdução")
   - Depuração responde *"por que falhou?"*; profiling responde *"onde o programa gasta recursos?"*
   - Knuth: *"A otimização prematura é a raiz de todos os males."*
   - **Pareto:** poucos trechos concentram o tempo, e a intuição costuma errar onde estão.
   - **Amdahl,** com os dois exemplos do material:
     - acelerar 4× uma função que ocupa 80% do tempo deixa o programa **2,5× mais rápido**;
     - deixar *infinitamente* rápida uma função que ocupa 5% dá só **5% de ganho**.
   - **Por quê:** com números concretos, a turma entende que otimizar o trecho errado é esforço jogado fora.
2. **Do `print` ao logging (3 min):**
   - Problemas do `print`: fica esquecido no código, não traz data, nível nem linha, e em C o `stdout` bufferizado pode "esconder" o último print antes de um *segfault*.
   - Mostre a tabela de níveis (`DEBUG` … `CRITICAL`) e a ideia do **filtro global**: em produção basta subir o nível para `INFO` e os `DEBUG` somem sem mudar código.
   - Ao vivo, com `faturamento.py`:
     ```bash
     python3 faturamento.py 2> app.log
     cat app.log
     grep -E "WARNING|ERROR" app.log
     grep -oE "\[(DEBUG|INFO|WARNING|ERROR|CRITICAL)" app.log | sort | uniq -c
     ```
   - **Por quê:** o `logging` escreve no `stderr` (Módulo 02), e o último comando é o pipeline `sort | uniq -c` do Módulo 02 aplicado a logs. Os alunos reconhecem a ferramenta.
3. **Como ler um Flame Graph (2 min):** diagrama `linux-profiling-flamegraph.svg`.
   - Eixo X: proporção do tempo (inclusivo). A ordem horizontal é alfabética, não cronológica.
   - Eixo Y: profundidade da pilha.
   - **O gargalo não é o bloco mais largo** (a `main` sempre ocupa 100%). São os **platôs do topo**, blocos largos sem nada empilhado acima. No exemplo, `parse_json()` é larga, mas o tempo é de `regex_match()`.
   - **Por quê:** é o erro de leitura mais comum, e o mesmo conceito reaparece como `cumtime` vs. `tottime`.
4. **Python: `cProfile` e `py-spy` (3 min):**
   - Ao vivo, `python3 -m cProfile -s tottime teste_gargalo.py | head -n 15` (cerca de 11 s). Explique `ncalls`, `tottime` (só a função) e `cumtime` (função e filhas).
   - **Atenção:** confira o Problema 1 no fim deste roteiro antes de apresentar.
   - Em seguida, abra o `perfil_execucao.svg`, gerado antes com `py-spy record -o perfil_execucao.svg -- python3 fibonacci.py`.
     - Clique num bloco para dar zoom e use a busca.
     - Avise que o `py-spy` desenha o gráfico **invertido** (*icicle*): a `main` fica no topo.
   - **Por quê:** o `cProfile` não exige instalação. O `py-spy` não desacelera o programa, então pode ser usado em produção.
5. **C: a história do `processamento.c` com Callgrind (3 min):** mostre a saída já gerada do `callgrind_annotate` e o KCachegrind (`linux-kcachegrind.svg`). Conte como investigação:
   - `funcao_lenta_gargalo` responde por quase 100% (inclusivo), mas só 10% é código dela.
   - O gargalo real é **`cos()`**, com cerca de 40 milhões de chamadas. Só que `cos(j)` só assume **2.000 valores distintos**: o programa recalcula os mesmos cossenos 20 mil vezes.
   - **Surpresa:** `sin()` foi chamada só cerca de 20 mil vezes, porque o próprio GCC (`-O2`) tirou o cálculo do laço interno. *O código-fonte nem sempre é o que executa.*
   - Correção: uma tabela com os 2.000 cossenos. O tempo cai de 0,63 s para 0,13 s (**5× mais rápido**) com poucas linhas, no ponto exato que o profiler apontou.
   - **Por quê:** é o ciclo completo (medir, diagnosticar, corrigir, medir de novo) num exemplo pequeno.
   - **Não rode o Callgrind ao vivo:** ele é mais de 100× mais lento.
6. **C: vazamento de memória com Valgrind/Memcheck (2 min, novo):** mostre o `vazamento.c` do material (um `malloc` sem `free`) e a saída de `valgrind --leak-check=full ./vazamento`.
   - Destaque a linha `4,000 bytes in 1 blocks are definitely lost`, seguida de `by 0x10915E: funcao_com_vazamento (vazamento.c:4)`.
   - **Explicação:** o Valgrind aponta **a função e a linha** que alocou a memória esquecida, sem precisar mudar o código. Lembre de compilar com `-g`.
   - **Por quê:** vazamento de memória é o bug mais típico das disciplinas de C, e quase ninguém conhece uma ferramenta que o encontra sozinha. Também mostra que "depuração" vai além de logs.
7. **Panorama (1 min):** mostre a tabela "Resumo Comparativo" do fim do módulo e cite uma ferramenta por linguagem:
   - `perf` em C;
   - `cProfile` e `py-spy` em Python;
   - JFR em Java (menos de 1% de overhead, seguro em produção).

   Diga que o `ExemploJFR.java` está no repositório para quem programa em Java.

**Ponte para o 06:** *"Otimizamos o código, e agora? Como guardar essa versão, compará-la com a anterior e trabalhar em equipe sem um sobrescrever o outro?"*

---

### Módulo 06: Git e Trabalho Colaborativo (17 min | 01:08 – 01:25)

**Por que apresentar:** o Git é o padrão absoluto da indústria, e o que trava os alunos não são os comandos, é o **modelo mental**. Quem entende as áreas e o que é um commit para de "decorar receitas" e para de ter medo de conflito.

**O que e como apresentar:**
1. **Filosofia em três ideias (2 min):** (`06_git_colaborativo.md`, "Origem e Filosofia")
   - Linus criou o Git em 2005 para versionar o kernel.
   - **Distribuído:** todo clone tem o histórico completo, e é possível trabalhar offline.
   - **Snapshots:** cada commit é uma foto do projeto inteiro.
   - **Hashes:** cada commit depende do anterior, então alterar o passado é sempre detectável.
   - Avise que apagar a pasta `.git/` apaga o histórico.
2. **As quatro áreas e os estados do arquivo (4 min):** diagrama `linux-git-workflow.svg`.
   - Working Directory, depois `git add`, Staging Area, depois `git commit`, Repositório Local, depois `git push`, Remoto.
   - Os estados: `Untracked`, `Modified`, `Staged` e `Committed`.
   - Ao vivo:
     ```bash
     git status ; git add arquivo ; git status ; git commit -m "..." ; git log --oneline
     ```
   - **Por que a Staging Area existe:** permite escolher o que entra em cada commit e fazer commits pequenos e explicáveis.
3. **O `.gitignore` (1 min, novo):** mostre o modelo do material (`node_modules/`, `*.o`, `*.class`, `*.log`, `.env`, `*.pem`).
   - Cite o repositório [github/gitignore](https://github.com/github/gitignore), com modelos prontos por linguagem.
   - **Alerta do material:** se uma senha foi commitada, apagá-la num commit novo **não basta**, porque ela continua no histórico. É preciso trocar a credencial.
   - **Por quê:** binários e senhas no repositório são erros clássicos de trabalhos em grupo, e o segundo pode ter consequências reais.
4. **Branches e os dois tipos de merge (3 min):**
   ```bash
   git switch -c feature/login     # nunca trabalhe direto na main
   # ...commit na branch...
   git switch main
   git merge feature/login
   ```
   - **Fast-forward:** a `main` não mudou desde a criação da branch, e o ponteiro só avança.
   - **Merge commit:** os dois lados mudaram, e surge um commit com dois pais.
   - Mostre `linux-git-merge-sem-conflito.svg`: históricos divergentes **na maioria das vezes não geram conflito**.
5. **Conflito, sem pânico (5 min):** use o exemplo do material no mini-repositório preparado. A `main` define `PORTA_SERVIDOR 8080` e a `feature/login` define `9000` no `config.h`.
   ```bash
   git merge feature/login        # CONFLICT (content): Merge conflict in config.h
   git status                     # both modified: config.h
   cat config.h                   # <<<<<<< HEAD / ======= / >>>>>>> feature/login
   # editar: escolher a versão, apagar os marcadores
   git add config.h
   git commit -m "merge: resolve conflito de configuracao de porta do servidor"
   ```
   - Mostre `linux-git-merge-com-conflito.svg` e compare com o diagrama anterior: o histórico é igual, só que agora as duas branches mexeram **na mesma linha**.
   - **Mensagem:** o conflito não é bug; é o Git se recusando a adivinhar e pedindo que um humano decida.
   - Apresente a saída de emergência `git merge --abort`.
   - **Por quê:** é o momento em que os alunos mais travam em trabalhos em grupo.
6. **Sincronizando com o remoto e Pull Requests (2 min, ampliado):**
   - `git push -u origin feature/x` envia a branch.
   - **`git fetch` vs. `git pull`:** o `fetch` só baixa e não toca nos seus arquivos, então é seguro para olhar. O `pull` é `fetch` seguido de `merge`.
   - Mostre o erro *"divergent branches"* do material e a solução de uma vez por todas: `git config --global pull.rebase false`.
   - **Pull Request:** na equipe, ninguém faz merge direto na `main` do servidor. O fluxo é push, abrir o PR, revisão, e só então merge.
   - **Por quê:** o `pull` que falha com "divergent branches" é o primeiro susto de quem começa a usar o GitHub em grupo. Explicar que o `pull` é um merge conecta com o conflito que acabaram de ver. O PR garante que outra pessoa sempre olhe o código antes de ele chegar à `main`.
   - O resto (`--amend`, `revert`, `reflog`, chaves SSH) fica indicado para estudo no material.

---

### Encerramento & Dúvidas (5 min | 01:25 – 01:30)
- **Recapitule em uma frase por módulo, mostrando a ponte entre eles:**
  - os comandos escrevem texto (01);
  - o texto flui por pipes (02);
  - cada programa é um processo (03);
  - os processos viram scripts (04);
  - os scripts geram logs e são medidos (05);
  - tudo vai para o Git (06).
- Exiba a página inicial do manual (`index.html`) e mostre os botões de cada módulo.
- Indique os exemplos no repositório, prontos para reproduzir em casa ou no laboratório:
  - `processamento.c` e `logging.c`;
  - `teste_gargalo.py`, `fibonacci.py` e `faturamento.py`;
  - `ExemploJFR.java`.
- Abra para perguntas.

---

## 3. Checklist de Preparação Pré-Apresentação

- [ ] **Terminal:** fonte grande (mínimo 18pt), tema de alto contraste, prompt curto (só o diretório atual).
- [ ] **Pasta de demonstração** com:
  - **Módulo 04:** `backup_simples.sh`, `converter_imagem.sh`, `backup_sistema.sh` e `monitor_saude.sh`, copiados do `docs/04_automacao_shell_scripting.md` (hoje eles existem só dentro do `.md`), já com `chmod +x`, e um `foto.png` qualquer;
  - **Módulo 05:** `vazamento.c` copiado do `docs/05_depuracao_profiling.md` (também só existe no `.md`), compilado com `gcc -g`, e a saída do Valgrind já gerada como reserva;
  - **Módulo 05:** `faturamento.py` e `teste_gargalo.py` (do `docs/`);
  - **Módulo 05:** `perfil_execucao.svg` já gerado com `py-spy` (existe em `img/`);
  - **Módulo 05:** saída do `callgrind_annotate` do `processamento.c` já gerada, ou o arquivo `callgrind.out.*` aberto no KCachegrind;
  - **Módulo 06:** mini-repositório Git com a `main` (`PORTA_SERVIDOR 8080`) e a `feature/login` (`PORTA_SERVIDOR 9000`) no `config.h`, pronto para o conflito, e uma cópia de reserva para repetir a demonstração.
- [ ] **Ferramentas instaladas:** `htop`, `curl`, `py-spy`, `valgrind` e `kcachegrind` (ou só a saída pronta).
- [ ] **Internet** para o `curl` do Módulo 02. Plano B: o exemplo com `du`.
- [ ] **Abas do navegador abertas:**
  - `slides_introducao.html`;
  - `index.html` do manual;
  - `perfil_execucao.svg`;
  - [speedscope.app](https://www.speedscope.app/) (opcional).

---

## 4. Problemas encontrados no material (`docs/`) que afetam a apresentação

1. **`05_depuracao_profiling.md`, seção do `cProfile`:** o texto afirma que *"`processamento_lento` responde por mais de 90% do tempo"*, mas a saída exibida mostra o contrário:
   - `processamento_rapido` tem `cumtime` de 9,04 s (cerca de 81%), por causa do `sum` sobre 100 milhões de itens;
   - `processamento_lento` tem 2,07 s.

   Ao rodar ao vivo, os alunos vão ver o "rápido" como gargalo. Há duas saídas:
   - corrigir o texto, transformando isso numa lição ("a função com nome de lenta não é a lenta: a intuição errou, e o profiler mostrou");
   - ajustar os tamanhos no `teste_gargalo.py`.
2. **`05_depuracao_profiling.md`, `processamento.c`:** o `perf stat` mostra 2,42 s, enquanto a seção do Callgrind cita 0,63 s a 0,67 s para o mesmo programa. Vale padronizar, ou avisar que as medições vieram de máquinas diferentes.
