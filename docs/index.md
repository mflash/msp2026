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

![](img/mgp.jpg)

## Semana Acadêmica Integrada - PUCRS / Escola Politécnica - 2026

**Profs. Edson Ifarraguirre Moreno e Marcelo Cohen**  
*Porto Alegre, RS — Brasil*

---

### Apresentação

Bem-vindo ao **Manual de Sobrevivência de Programação**, desenvolvido para a Semana Acadêmica Integrada da Escola Politécnica da PUCRS - 2026.

O objetivo deste material é capacitar estudantes no uso produtivo da linha de comando e recursos do sistema e de programação em ambientes Unix/Linux — competência indispensável para o desenvolvimento de software moderno, engenharia de dados, computação em nuvem, segurança da informação e computação científica.

Este material é fortemente inspirado pelo [Missing Semester](https://missing.csail.mit.edu/), projeto do MIT com conteúdos que costumam estar ausentes ou incompletos em currículos de muitas graduações na área.

> 📊 **Slides de Abertura:** Acompanhe a contextualização e a motivação inicial do curso através dos [Slides da Introdução](slides_introducao.html){target="_blank" rel="noopener"}.  

> 🗳️ **Exemplos:** [Zip com todos os exemplos (scripts e dados) apresentados](img/exemplos.zip).  

---

### Índice dos Módulos do Tutorial

Navegue pelos módulos disponíveis abaixo para acessar o conteúdo teórico, diagramas e demonstrações práticas com exemplos passo a passo:

::: module-grid

::: module-card
::: module-card-header
[Disponível]{.module-badge .available}

<img src="https://mzc9kojc5a.map.azionedge.net/prd-semana-academica-2026-ss-v2/app/image/17/17_1792091256817.png?ims=filters:quality(75)" alt="Prof. Edson Ifarraguirre Moreno" title="Prof. Edson Ifarraguirre Moreno" class="instructor-avatar" loading="lazy">
:::

### [01. Introdução ao Shell e Comandos Básicos](01_shell.html)

Fundamentos históricos do Unix/Linux, arquitetura do sistema de arquivos, comandos essenciais de inspeção, variáveis de ambiente, navegação de diretórios e controle de permissões de arquivos.

- **Apresentação em Slides:** [Acessar Slides do Módulo 01](slides_01_shell.html){target="_blank" rel="noopener"}.
- **Histórico & Relevância:** Das origens nos Bell Labs à nuvem, IoT, Android e supercomputadores.
- **Linha do Tempo Visual:** Evolução do Unix, BSD, GNU e Linux.
- **O Shell & Terminais:** O conceito de shell e o legado de terminais físicos como o DEC VT100.
- **Sistema de Arquivos & FHS:** Raiz única, árvore de diretórios padrão (`/bin`, `/etc`, `/home`, etc.).
- **Primeiros Comandos:** `date`, `echo`, `man`, `tldr`, `ls` e `which`.
- **Variáveis de Ambiente:** Uso do `$PATH` e a relação entre `set` e `export`.
- **Navegação & Edição:** `pwd`, `cd`, `cp`, `mv`, `rm`, `cat`, `less` e `nano`.
- **Permissões de Acesso & chmod:** Anatomia do `rwx`, modos simbólico e octal (755, 644, 700).

[Acessar Módulo 01 →](01_shell.html){.module-btn}
:::

::: module-card
::: module-card-header
[Disponível]{.module-badge .available}

<img src="https://mzc9kojc5a.map.azionedge.net/prd-semana-academica-2026-ss-v2/app/image/17/17_1792091157911.png?ims=filters:quality(75)" alt="Prof. Marcelo Cohen" title="Prof. Marcelo Cohen" class="instructor-avatar" loading="lazy">
:::

### [02. Redirecionamento, Pipes e Filtros de Texto](02_redirecionamento_pipes.html)

A filosofia Unix em ação: combinando programas pequenos através de canais e manipulando grandes volumes de texto no terminal.

- **Apresentação em Slides:** [Acessar Slides do Módulo 02](slides_02_redirecionamento_pipes.html){target="_blank" rel="noopener"}.
- **Streams padrão:** Entrada (`stdin`), Saída (`stdout`) e Erros (`stderr`).
- **Operadores de redirecionamento:** `>`, `>>`, `<` e `2>&1`.
- **O operador de encadeamento:** *pipe* (`|`).
- **Filtros essenciais:** `grep`, `sort`, `uniq`, `wc`, `head`, `tail`, `cut` e `tr`.
- **Busca de arquivos:** Localização rápida e flexível com `find`.

[Acessar Módulo 02 →](02_redirecionamento_pipes.html){.module-btn}
:::

::: module-card
::: module-card-header
[Disponível]{.module-badge .available}

<img src="https://mzc9kojc5a.map.azionedge.net/prd-semana-academica-2026-ss-v2/app/image/17/17_1792091256817.png?ims=filters:quality(75)" alt="Prof. Edson Ifarraguirre Moreno" title="Prof. Edson Ifarraguirre Moreno" class="instructor-avatar" loading="lazy">
:::

### [03. Gerenciamento de Processos e Monitoramento](03_processos_monitoramento.html)

Como o sistema operacional gerencia recursos, memória e CPU, e como inspecionar e controlar processos ativos pelo shell.

- **Apresentação em Slides:** [Acessar Slides do Módulo 03](slides_03_processos_monitoramento.html){target="_blank" rel="noopener"}.
- **Ciclo de vida:** Identificadores de processos (`PID`, `PPID`).
- **Inspeção de processos:** Monitoramento com `ps`, `top` e `htop`.
- **Controle de tarefas:** Primeiro plano (`fg`), segundo plano (`bg`, `&`) e `jobs`.
- **Sinais de encerramento:** Finalizando processos com `kill` e `killall`.
- **Uso de memória e disco:** Diagnóstico com `free`, `df` e `du`.

[Acessar Módulo 03 →](03_processos_monitoramento.html){.module-btn}
:::

::: module-card
::: module-card-header
[Disponível]{.module-badge .available}

<img src="https://mzc9kojc5a.map.azionedge.net/prd-semana-academica-2026-ss-v2/app/image/17/17_1792091157911.png?ims=filters:quality(75)" alt="Prof. Marcelo Cohen" title="Prof. Marcelo Cohen" class="instructor-avatar" loading="lazy">
:::

### [04. Automação e Shell Scripting](04_automacao_shell_scripting.html)

Construindo scripts executáveis em Bash para automatizar rotinas, pipelines de compilação e tarefas de administração.

- **Apresentação em Slides:** [Acessar Slides do Módulo 04](slides_04_automacao_shell_scripting.html){target="_blank" rel="noopener"}.
- **Criação de scripts:** Permissão de execução e o *Shebang* (`#!/bin/bash`).
- **Parâmetros de linha de comando:** `$1`, `$2`, `$#`, `$@`.
- **Controle de fluxo:** `if / then / else` e testes condicionais (`[ ... ]`).
- **Laços de repetição:** Estruturas com `for` e `while`.
- **Códigos de retorno:** Códigos de saída com `$?`.

[Acessar Módulo 04 →](04_automacao_shell_scripting.html){.module-btn}
:::

::: module-card
::: module-card-header
[Disponível]{.module-badge .available}

<img src="https://mzc9kojc5a.map.azionedge.net/prd-semana-academica-2026-ss-v2/app/image/17/17_1792091157911.png?ims=filters:quality(75)" alt="Prof. Marcelo Cohen" title="Prof. Marcelo Cohen" class="instructor-avatar" loading="lazy">
:::

### [05. Depuração e Profiling (Java, Python e C)](05_depuracao_profiling.html)

Identificando gargalos de CPU e vazamentos de memória usando ferramentas gratuitas e de código aberto para C/C++, Python e Java.

- **Apresentação em Slides:** [Acessar Slides do Módulo 05](slides_05_depuracao_profiling.html){target="_blank" rel="noopener"}.
- **Depuração & Logging:** Do "print debugging" ao logging estruturado, níveis de severidade, macros em C, `logging` nativo em Python e SLF4J/Logback em Java.
- **Conceitos de Profiling:** Tracing vs. Sampling e anatomia dos Flame Graphs.
- **Ecossistema C/C++:** `perf` (hardware counters), `Valgrind` (Memory Leaks com Memcheck) e `Callgrind`.
- **Ecossistema Python:** `cProfile` (nativo), `py-spy` (Flame Graphs e top ao vivo) e `line_profiler`.
- **Ecossistema Java / JVM:** `JFR` + `JMC` (Flight Recorder oficial), `VisualVM`, `async-profiler` e ferramentas CLI (`jps`, `jstack`, `jstat`).

[Acessar Módulo 05 →](05_depuracao_profiling.html){.module-btn}
:::

::: module-card
::: module-card-header
[Disponível]{.module-badge .available}

<img src="https://mzc9kojc5a.map.azionedge.net/prd-semana-academica-2026-ss-v2/app/image/17/17_1792091256817.png?ims=filters:quality(75)" alt="Prof. Edson Ifarraguirre Moreno" title="Prof. Edson Ifarraguirre Moreno" class="instructor-avatar" loading="lazy">
:::

### [06. Git e Controle de Versão Colaborativo](06_git_colaborativo.html)

Filosofia e princípios do Git distribuído, os três estados de arquivos, ramificações (branches) e resolução prática de conflitos em equipe.

- **Apresentação em Slides:** [Acessar Slides do Módulo 06](slides_06_git_colaborativo.html){target="_blank" rel="noopener"}.
- **Filosofia do Git:** Linus Torvalds, sistemas distribuídos vs. centralizados, snapshots e hashes criptográficos.
- **As Quatro Áreas:** Working Directory, Staging Area (Index), Repositório Local (.git) e Remoto.
- **Ciclo de Vida:** `git status`, `git diff`, `git add`, `git commit`, `git log` e o arquivo `.gitignore`.
- **Branches & Integração:** `git switch -c`, `git merge`, sincronização (`git fetch` vs `git pull`) e resolução passo a passo de conflitos de merge.

[Acessar Módulo 06 →](06_git_colaborativo.html){.module-btn}
:::

:::

---

### Dicas Úteis de Utilização

- **Modo Escuro / Claro:** Utilize o botão localizado no canto superior direito para alternar a interface entre o tema claro e escuro a qualquer momento. Sua preferência fica salva automaticamente no navegador.
- **Diagramas Ampliáveis:** Todas as figuras e diagramas vetoriais (SVG) do tutorial são interativos e de alta resolução. Clique sobre qualquer um deles para visualizá-lo em tamanho real com zoom.
- **Códigos e Comandos:** Todos os blocos de código trazem exemplos prontos para teste no terminal. O caractere `$` nos exemplos indica o prompt de comando de usuário comum; comandos iniciados por `#` representam comentários explicativos (ou ações que requereriam privilégios de superusuário/root).

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
