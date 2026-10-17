# Minicurso: Sistemas Operacionais e Shell Linux

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

Bem-vindo ao portal do tutorial prático de **Sistemas Operacionais e Shell Linux**, desenvolvido para a Semana Acadêmica Integrada da Escola Politécnica da PUCRS.

O objetivo deste material é capacitar estudantes e profissionais no uso produtivo da linha de comando em ambientes Unix/Linux — competência indispensável para o desenvolvimento de software moderno, engenharia de dados, computação em nuvem, segurança da informação e computação científica.

---

### Índice dos Módulos do Tutorial

Navegue pelos módulos disponíveis abaixo para acessar o conteúdo teórico, diagramas e demonstrações práticas com exemplos passo a passo:

::: module-grid

::: module-card
[Disponível]{.module-badge .available}

### [01. Introdução ao Shell e Comandos Básicos](01_shell.html)

Fundamentos históricos do Unix/Linux, arquitetura do sistema de arquivos, comandos essenciais de inspeção, variáveis de ambiente, navegação de diretórios e controle de permissões de arquivos.

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
[Em Breve]{.module-badge .upcoming}

### 02. Redirecionamento, Pipes e Filtros de Texto

A filosofia Unix em ação: combinando programas pequenos através de canais e manipulando grandes volumes de texto no terminal.

- **Streams padrão:** Entrada (`stdin`), Saída (`stdout`) e Erros (`stderr`).
- **Operadores de redirecionamento:** `>`, `>>`, `<` e `2>&1`.
- **O operador de encadeamento:** *pipe* (`|`).
- **Filtros essenciais:** `grep`, `sort`, `uniq`, `wc`, `head`, `tail`, `cut` e `tr`.
- **Busca de arquivos:** Localização rápida e flexível com `find`.

[Próxima Etapa]{.module-btn .secondary}
:::

::: module-card
[Em Breve]{.module-badge .upcoming}

### 03. Gerenciamento de Processos e Monitoramento

Como o sistema operacional gerencia recursos, memória e CPU, e como inspecionar e controlar processos ativos pelo shell.

- **Ciclo de vida:** Identificadores de processos (`PID`, `PPID`).
- **Inspeção de processos:** Monitoramento com `ps`, `top` e `htop`.
- **Controle de tarefas:** Primeiro plano (`fg`), segundo plano (`bg`, `&`) e `jobs`.
- **Sinais de encerramento:** Finalizando processos com `kill` e `killall`.
- **Uso de memória e disco:** Diagnóstico com `free`, `df` e `du`.

[Próxima Etapa]{.module-btn .secondary}
:::

::: module-card
[Em Breve]{.module-badge .upcoming}

### 04. Automação e Shell Scripting

Construindo scripts executáveis em Bash para automatizar rotinas, pipelines de compilação e tarefas de administração.

- **Criação de scripts:** Permissão de execução e o *Shebang* (`#!/bin/bash`).
- **Parâmetros de linha de comando:** `$1`, `$2`, `$#`, `$@`.
- **Controle de fluxo:** `if / then / else` e testes condicionais (`[ ... ]`).
- **Laços de repetição:** Estruturas com `for` e `while`.
- **Códigos de retorno:** Códigos de saída com `$?`.

[Próxima Etapa]{.module-btn .secondary}
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
