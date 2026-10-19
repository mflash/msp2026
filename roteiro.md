# Roteiro de Apresentação: Manual de Sobrevivência de Programação

**Semana Acadêmica Integrada — PUCRS / Escola Politécnica (2026)**  
**Duração total:** 1h30 (90 minutos)  
**Ministrantes:** Profs. Edson Ifarraguirre Moreno e Marcelo Cohen  
**Premissa pedagógica:** Foco prático nos módulos essenciais para o dia a dia dos alunos (01, 02, 04 e 06), tratando as seções de Gerenciamento de Processos (03) e Profiling (05) como vitrines conceituais de alto impacto visual e curta duração.

---

## 1. Cronograma Geral (90 Minutos)

| Bloco / Seção | Duração | Horário Relativo | Foco Pedagógico | Formato Principal |
| :--- | :---: | :---: | :--- | :--- |
| **Abertura & Motivação** | **5 min** | 00:00 – 00:05 | *Missing Semester*, relevância do terminal e filosofia Unix. | Fala rápida / Slides |
| **01. Shell e Comandos Básicos** | **15 min** | 00:05 – 00:20 | Navegação ágil, `$PATH`, comandos essenciais e `chmod`. | Terminal ao vivo |
| **02. Redirecionamento, Pipes e Filtros** | **15 min** | 00:20 – 00:38 | O coração do Unix: `stdin`/`stdout`, `grep`, `sort`, `uniq` e `\|`. | Terminal / Demonstração |
| **03. Gerenciamento de Processos** | **10 min** | 00:38 – 00:45 | *Superficial:* O que é PID, monitoramento com `htop` e como matar processos (`kill -9`). | Pílula prática |
| **04. Automação e Shell Scripting** | **10 min** | 00:45 – 01:00 | Transformar pipelines em scripts reutilizáveis (`.sh`) com `$1`. | Editor + Terminal |
| **05. Depuração e Profiling** | **15 min** | 01:00 – 01:08 | *Superficial:* Princípio de Pareto, demonstração do Flame Graph e panorama de ferramentas. | Visual / Navegador |
| **06. Git e Trabalho Colaborativo** | **15 min** | 01:08 – 01:25 | As 3 áreas locais, fluxo de *branches* e resolução de conflitos. | Terminal / Diagramas |
| **Encerramento & Dúvidas** | **5 min** | 01:25 – 01:30 | Apresentação do repositório/site do curso e encerramento. | Diálogo |

---

## 2. Roteiro Detalhado por Seção

### Abertura & Motivação (5 min | 00:00 – 00:05)
- **Mensagem-chave:** O mercado e a academia exigem fluência em ambientes Linux/Unix (servidores, containers Docker, computação em nuvem e data science), mas esses tópicos raramente são ensinados de forma sistemática nas disciplinas regulares.
- **Inspiração:** O projeto *The Missing Semester of Your CS Education* (MIT CSAIL).
- **Filosofia Unix em uma frase:** *"Escreva programas que façam uma coisa bem feita e que se comuniquem através de texto simples"*.

---

### Módulo 01: Shell e Comandos Básicos (15 min | 00:05 – 00:20)
- **Objetivo:** Garantir que todos compreendam onde estão pisando antes de compor comandos avançados.
- **Tópicos a cobrir rapidamente:**
  1. **Árvore de Diretórios (FHS):** Raiz única (`/`), `/home` dos usuários e onde ficam os binários (`/bin`, `/usr/bin`).
  2. **Navegação ágil:** Caminhos absolutos vs. relativos (`.`, `..`, `~`), autocompletar com `Tab` e histórico com `Ctrl+R`.
  3. **A variável `$PATH`:** Explicar por que digitamos `python3` e o sistema sabe qual executável rodar sem precisarmos digitar `/usr/bin/python3`.
  4. **Permissões de Acesso:** Anatomia do `rwx` (leitura, escrita e execução). Mostrar a diferença entre um arquivo de texto comum (`644`) e um script executável (`chmod +x script.sh` ou `755`).
- *Armadilha a evitar:* Não gaste tempo listando sintaxes obscuras de comandos; foque na intuição de `pwd`, `ls -la`, `cd` e `chmod`.

---

### Módulo 02: Redirecionamento, Pipes e Filtros de Texto (18 min | 00:20 – 00:38)
- **Objetivo:** É o momento de maior impacto conceitual da primeira metade da oficina.
- **Conceitos fundamentais:**
  1. Os três fluxos padrão: `stdin` (0), `stdout` (1) e `stderr` (2).
  2. Redirecionamento de arquivos: `>` (sobrescreve), `>>` (acrescenta) e `2>&1` (redireciona erros).
  3. O *Pipe* (`|`): Conectar a saída de um programa diretamente na entrada do próximo sem arquivos intermediários em disco.
- **Demonstração Prática ao Vivo:**
  - Partir de uma entrada crua (ex.: um arquivo de log, lista de alunos ou consulta com `curl` a uma API pública).
  - Construir o encadeamento passo a passo diante dos alunos:
    ```bash
    cat dados.txt | grep "ERRO" | cut -d':' -f2 | sort | uniq -c | sort -nr | head -n 5
    ```
- **Conexão Narrativa:** *"Guardem esse comando de uma linha; no Módulo 04 nós vamos transformá-lo em uma ferramenta automatizada."*

---

### Módulo 03: Gerenciamento de Processos e Monitoramento (7 min | 00:38 – 00:45)
> **Abordagem: Pílula rápida e estritamente prática.**
- **Objetivo:** Dar ao estudante a capacidade de diagnosticar e destravar sua própria máquina sem precisar reiniciar.
- **Os 3 pontos essenciais para mostrar:**
  1. **O que é um PID:** Identificador único atribuído pelo kernel a cada programa em execução.
  2. **Como inspecionar:** Abrir o `htop` (ou `top`) no terminal para mostrar a ordenação interativa por uso de CPU e memória RAM.
  3. **Como encerrar processos:**
     - `Ctrl+C` (envia `SIGINT`, pedido educado de finalização);
     - Se o programa travou e não responde: `kill -9 <PID>` ou `killall -9 nome_programa` (`SIGKILL`, encerramento imediato pelo kernel).
  4. *(Menção rápida em 30 segundos):* O que significa colocar `&` no final de um comando para rodar em segundo plano (`background`), e trazer de volta com `fg`.

---

### Módulo 04: Automação e Shell Scripting (15 min | 00:45 – 01:00)
- **Objetivo:** Mostrar como deixar o computador trabalhar pelo desenvolvedor, transformando rotinas manuais em ferramentas reproduzíveis.
- **Estrutura da Demonstração:**
  1. **Anatomia do Script:**
     - A linha do *Shebang* (`#!/bin/bash`);
     - Permissão de execução (`chmod +x processar.sh`).
  2. **Parâmetros de Entrada:** Recebendo argumentos dinâmicos via `$1`, `$2` e checando contagem com `$#`.
  3. **Estrutura de Repetição:** Processar vários arquivos em lote usando um laço simples:
     ```bash
     for arquivo in *.log; do
         echo "Analisando: $arquivo"
         ./analisar.sh "$arquivo"
     done
     ```
  4. **Código de Saída (`$?`):** Explicar brevemente que `0` indica sucesso e valores diferentes de zero indicam erro.

---

### Módulo 05: Depuração e Profiling (8 min | 01:00 – 01:08)
> **Abordagem: Inspiracional e visual (desmistificação de ferramentas corporativas).**
- **Objetivo:** Incutir a disciplina de medir antes de otimizar e apresentar o que a indústria moderna utiliza.
- **Roteiro dos 8 minutos:**
  1. **Mentalidade (2 min):** A regra de ouro do desempenho — *Princípio de Pareto e Lei de Amdahl*. Desenvolvedores quase sempre erram ao tentar adivinhar no "olhômetro" onde está a lentidão. O profiler aponta com precisão científica qual função consome os ciclos de máquina.
  2. **Demonstração Visual do Flame Graph (3 min):**
     - Abrir no navegador o arquivo interativo `perfil_execucao.svg` (gerado com `py-spy`).
     - Explicar rapidamente:
       - Eixo X = proporção do tempo gasto na função;
       - Eixo Y = profundidade da pilha de chamadas;
       - Clicar em um bloco para demonstrar a interatividade de zoom e busca.
  3. **Cardápio de Ferramentas Gratuitas (3 min):**
     - **C / C++:** `Valgrind` (localizar vazamentos de memória e ponteiros perdidos sem recompilar) e `perf`.
     - **Python:** `cProfile` (embutido na linguagem), `py-spy` e visualização com `speedscope.app`.
     - **Java:** `JDK Flight Recorder (JFR)` nativo no OpenJDK (< 1% de overhead, seguro para servidores de produção) e `VisualVM`.

---

### Módulo 06: Git e Trabalho Colaborativo (17 min | 01:08 – 01:25)
- **Objetivo:** O Git é o padrão absoluto da indústria; os estudantes precisam dominar o modelo mental por trás dos comandos.
- **Estrutura da Apresentação:**
  1. **O Modelo Mental das Áreas Locais:**
     - *Working Tree* (arquivos modificados no editor);
     - *Staging Area / Index* (a "caixa pronta para envio" via `git add`);
     - *Repositório Local* (o histórico imutável via `git commit`).
  2. **Fluxo de Trabalho com Branches:**
     - Nunca trabalhar diretamente na `main`;
     - Criar uma ramificação para desenvolver uma funcionalidade (`git switch -c feature-x`);
     - Integrar de volta com `git merge`.
  3. **Desmistificando o Conflito de Merge:**
     - Mostrar que conflitos não são bugs, mas sim o Git protegendo alterações concorrentes;
     - Exibir as marcações visuais (`<<<<<<< HEAD`, `=======`, `>>>>>>>`);
     - Explicar como editar o arquivo, salvar, adicionar com `git add` e concluir o merge.

---

### Encerramento & Dúvidas (5 min | 01:25 – 01:30)
- Exibir a página inicial do manual (`index.html`).
- Indicar que todos os códigos de exemplo (`processamento.c`, `fibonacci.py`, `ExemploJFR.java`) estão disponíveis no repositório para reprodução em casa ou laboratório.
- Abrir para perguntas dos estudantes.

---

## 3. Checklist de Preparação Pré-Apresentação

- [ ] **Terminal:** Fonte grande (mínimo 18pt), tema com alto contraste (fundo escuro legível ou claro sem ofuscamento).
- [ ] **Prompt limpo:** Preferencialmente configurado para exibir apenas o diretório atual, evitando caminhos excessivamente longos na tela.
- [ ] **Arquivos preparados em uma pasta de demonstração:**
  - `dados.txt` ou arquivo de log pronto para demonstrar a Seção 02;
  - `perfil_execucao.svg` pronto para ser aberto no navegador durante a Seção 05;
  - Um mini repositório Git de teste com duas branches prontas para simular um merge na Seção 06.
- [ ] **Abas do Navegador Abertas:**
  - Página inicial do Manual de Sobrevivência (`index.html`);
  - `perfil_execucao.svg` (Flame Graph);
  - [speedscope.app](https://www.speedscope.app/) (opcional, para demonstração complementar).
