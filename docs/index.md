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

## Semana Acadêmica Integrada - PUCRS/Escola Politécnica - 2026

Profs. Edson Ifarraguirre Moreno e Marcelo Cohen

---

### Breve Histórico do Unix e do Linux

A história dos sistemas operacionais modernos está diretamente ligada ao surgimento do **Unix** no final da década de 1960. Criado nos laboratórios *Bell Labs* (da AT&T) por cientistas da computação pioneiros como **Ken Thompson** e **Dennis Ritchie**, o Unix introduziu uma filosofia revolucionária de desenvolvimento: sistemas operacionais modulares, programas pequenos e especializados focados em fazer uma única tarefa muito bem, e a comunicação fluida entre programas por meio de texto e canais (*pipes*).

Em 1973, o Unix foi reescrito na recém-criada linguagem **C** (também concebida por Ritchie). Isso tornou o sistema extraordinariamente **portátil** — pela primeira vez, um sistema operacional não estava rigidamente amarrado a uma única arquitetura de processador. Conforme o Unix se espalhava pelas universidades e centros de pesquisa, surgiram variantes acadêmicas (como o **BSD**, da Universidade da Califórnia em Berkeley) e diversas versões comerciais proprietárias (Solaris, AIX, HP-UX).

Na década de 1980, motivado pela crescente restrição no compartilhamento de código-fonte de softwares proprietários, **Richard Stallman** fundou a *Free Software Foundation* (FSF) e lançou o **Projeto GNU** com a ambiciosa meta de construir um sistema operacional totalmente livre e compatível com Unix. No início dos anos 1990, o projeto já havia desenvolvido compiladores (GCC), utilitários de linha de comando, interpretadores e bibliotecas essenciais — mas faltava um componente central vital: o **kernel** (o núcleo do sistema).

É aí que entra **Linus Torvalds**, então estudante de 21 anos na Universidade de Helsinki (Finlândia). Em agosto de 1991, frustrado com as limitações do sistema educacional MINIX em seu PC com processador Intel 386, Linus anunciou em um grupo de discussão da Usenet que estava desenvolvendo seu próprio kernel por hobby. Pouco depois, ele disponibilizou o código-fonte na internet sob a licença livre **GNU GPL**. Ao unir as ferramentas do Projeto GNU com o novo kernel de Linus, nasceu o sistema completo comumente chamado de **GNU/Linux** (ou simplesmente **Linux**).

#### A Importância do Linux Hoje: Em Todo Lugar

Embora muitos usuários identifiquem sistemas operacionais pela interface gráfica do Windows ou macOS em computadores pessoais, o Linux é a verdadeira **espinha dorsal da tecnologia global contemporânea**:

- **Nuvem e Servidores da Internet:** A esmagadora maioria dos servidores que hospedam websites, serviços de streaming, redes sociais e sistemas bancários roda Linux. Os maiores provedores de computação em nuvem do mundo (como Amazon AWS, Google Cloud e Microsoft Azure) têm mais de 70% de suas instâncias virtuais operando sobre distribuições Linux.
- **Containers e Microsserviços:** Tecnologias indispensáveis para a engenharia de software atual, como **Docker** e **Kubernetes**, foram projetadas nativamente sobre recursos internos do kernel Linux (como *namespaces* e *cgroups*).
- **Dispositivos Móveis (Smartphones e Tablets):** O **Android**, mantido pelo Google e presente em mais de 70% dos smartphones do planeta (bilhões de aparelhos), utiliza o kernel Linux em sua base para gerenciar o hardware, a memória e a segurança.
- **Sistemas Embarcados e Internet das Coisas (IoT):** Por sua flexibilidade, estabilidade e capacidade de rodar em processadores com poucos recursos, o Linux equipa roteadores Wi-Fi, smart TVs, sistemas de bordo de automóveis (como Tesla e Android Automotive), drones, robôs industriais e equipamentos médicos.
- **Supercomputadores e Exploração Científica:** Desde 2017, **100% dos 500 supercomputadores mais velozes do mundo** (ranking *TOP500*) rodam Linux. Ele é também o sistema que operou veículos espaciais como o rover *Perseverance* e o helicóptero *Ingenuity* em Marte.
- **Desktops e Estações de Trabalho de Engenharia:** Adotado maciçamente por desenvolvedores, cientistas de dados e engenheiros de software, com distribuições como Ubuntu, Fedora, Debian e Arch Linux, além do subsistema WSL no próprio Windows.

#### Linha do Tempo: A Evolução do Unix e Linux

[![Linha do Tempo: A Evolução do Unix e Linux (clique para ampliar)](img/timeline-unix-linux.svg)](img/timeline-unix-linux.svg)

---

### O que é o Shell?

O **shell** (termo em inglês para "concha" ou "casca") é um programa que atua como intermediário entre o usuário e o núcleo (*kernel*) do sistema operacional. Trata-se de um **interpretador de comandos**: ele fornece uma interface em modo texto onde digitamos instruções, interpreta o que foi solicitado e aciona o sistema operacional para executar programas, manipular arquivos e gerenciar processos. Exemplos populares de shells incluem o **Bash**, o **Zsh** e o **Fish**.

### O Shell e os Terminais de Antigamente

Para entender o shell, vale a pena olhar para a história da computação:

1. **Os Terminais Físicos (Hardware):** Nas décadas de 1960 e 1970, os computadores (como os *mainframes* e minicomputadores) eram equipamentos volumosos, caros e compartilhados. Os usuários não se sentavam diretamente em frente ao computador. Em vez disso, conectavam-se a ele por meio de **terminais** — dispositivos físicos compostos apenas por um teclado e um mecanismo de saída (inicialmente teletipos com papel, como os *TTY*, e mais tarde telas com fósforo verde/âmbar, como o lendário DEC VT100). O terminal em si não realizava processamento pesado: sua função era apenas enviar os caracteres digitados e exibir as respostas enviadas pelo computador central.

   ![Terminal DEC VT100](img/vt100.jpg)

2. **O Papel do Shell:** No computador central, era necessário haver um programa rodando para receber os caracteres enviados pelo terminal, dar sentido às linhas digitadas e coordenar a execução das tarefas solicitadas: esse programa era o **shell**.

3. **O Cenário Atual:** Hoje em dia, quase não utilizamos mais terminais de hardware. Em seu lugar, usamos **emuladores de terminal** (softwares com janelas gráficas, como o *Terminal* do macOS/Linux, *Alacritty*, *iTerm2* ou *Windows Terminal*). O emulador recria virtualmente o comportamento do terminal físico de antigamente, enquanto o **shell** continua fazendo exatamente o mesmo trabalho de sempre por trás dos panos: interpretar e executar seus comandos.

---

### O Sistema de Arquivos do Linux

O sistema de arquivos do Linux organiza dados e programas em uma estrutura lógica bem definida. Diferentemente de outros sistemas operacionais, ele adota conceitos fundamentais herdados da tradição Unix:

#### Princípios Básicos

- **Raiz Única (`/`):** Não existem letras de unidades separadas (como `C:`, `D:` do Windows). No Linux, toda a hierarquia de armazenamento deriva de um único ponto de partida: a **raiz** ou **root**, representada por uma barra (`/`). Discos rígidos adicionais, partições, pendrives e compartilhamentos de rede são todos "montados" em galhos específicos dessa mesma árvore.
- **Sensibilidade a maiúsculas e minúsculas (*Case-sensitive*):** O Linux diferencia maiúsculas de minúsculas. Portanto, `Relatorio.txt`, `relatorio.txt` e `RELATORIO.TXT` são reconhecidos como três arquivos completamente diferentes dentro do mesmo diretório.
- **Separador de caminhos com barra inclinada (`/`):** Os caminhos são separados pela barra tradicional `/` (ex.: `/home/usuario/documentos`), ao contrário da barra invertida `\` usada em sistemas DOS/Windows.
- **"Tudo é um arquivo" (*Everything is a file*):** Um dos pilares do design Unix é que arquivos comuns, diretórios, conexões de rede e até dispositivos de hardware (teclados, discos, terminais) são representados e manipulados através da interface de arquivos.
- **Arquivos Ocultos:** Qualquer arquivo ou diretório cujo nome comece com um ponto (`.`) é considerado oculto (como arquivos de configuração `.bashrc` ou pastas `.git`).

[![Hierarquia padrão do sistema de arquivos no Linux/Unix (clique para ampliar)](img/linux-filesystem.svg)](img/linux-filesystem.svg)

#### Principais Diretórios do Sistema (FHS)

A organização das pastas no Linux segue a norma **FHS** (*Filesystem Hierarchy Standard*). A seguir estão os diretórios principais e seus respectivos propósitos:

- **`/` (Root):** A raiz de todo o sistema de arquivos. Qualquer outro diretório ou arquivo está contido abaixo dele.
- **`/bin` (User Binaries):** Contém os programas e comandos executáveis essenciais para todos os usuários (ex.: `ls`, `cp`, `rm`, `cat`, `bash`). Em muitas distribuições modernas, é um link para `/usr/bin`.
- **`/sbin` (System Binaries):** Utilitários e comandos vitais para a administração e manutenção do sistema, geralmente de uso exclusivo ou prioritário do superusuário (ex.: `fdisk`, `reboot`, `fsck`, `iptables`).
- **`/boot` (Boot Loader):** Arquivos essenciais para a inicialização da máquina, incluindo o gerenciador de boot (como o GRUB), as imagens do *kernel* Linux (`vmlinuz`) e o sistema de arquivos temporário de inicialização (`initramfs`).
- **`/etc` (Configuration Files):** Guarda os arquivos e subdiretórios de configuração globais de todo o sistema operacional e dos serviços instalados (ex.: `/etc/passwd`, `/etc/fstab`, `/etc/hosts`).
- **`/home` (User Homes):** Diretório que abriga as pastas pessoais de cada usuário comum (ex.: `/home/marcelo`), onde ficam armazenados documentos pessoais, projetos e arquivos de configuração do usuário (*dotfiles*).
- **`/root` (Home do Superusuário):** O diretório pessoal exclusivo do administrador do sistema (`root`). Fica separado de `/home` para permitir manutenção mesmo que a partição de usuários não possa ser montada.
- **`/dev` (Device Files):** Arquivos especiais que representam dispositivos de hardware físicos ou virtuais (ex.: `/dev/sda` para discos de armazenamento, `/dev/null` para descarte de dados e `/dev/random` para geração de números aleatórios).
- **`/proc` e `/sys` (Pseudo-sistemas de Arquivos Virtuais):** Sistemas de arquivos virtuais gerados dinamicamente na memória RAM pelo *kernel*. O `/proc` traz estatísticas e informações de processos e hardware em tempo real, enquanto o `/sys` expõe estruturas e configurações de dispositivos do *kernel*.
- **`/var` (Variable Data):** Contém dados variáveis que mudam frequentemente durante o uso do sistema, como registros de log (`/var/log`), filas de mensagens e e-mails (`/var/spool`) e dados transitórios de serviços.
- **`/tmp` (Temporary Files):** Espaço para arquivos temporários criados por aplicativos e pelo próprio sistema. Normalmente tem seu conteúdo limpo a cada reinicialização.
- **`/usr` (Unix System Resources):** Concentra a maior parte dos programas, bibliotecas e utilitários instalados para os usuários, contendo subpastas como `/usr/bin`, `/usr/lib`, `/usr/share` e `/usr/local`.
- **`/opt` (Optional Software):** Destinado à instalação manual de pacotes de softwares de terceiros e programas adicionais mantidos de forma isolada e independente.
- **`/media` e `/mnt` (Mount Points):** Locais usados para montagem de sistemas de arquivos. `/media` é tradicionalmente usado para pontos de montagem automáticos de mídias removíveis (pendrives, discos externos), enquanto `/mnt` serve para montagens manuais e temporárias feitas pelo administrador.

---

### Primeiros Passos no Shell: Comandos Essenciais

Para quem está acompanhando uma demonstração prática ou iniciando no terminal, alguns comandos funcionam como blocos de construção diários para navegar, inspecionar o sistema e entender o funcionamento do ambiente.

#### 1. `date` — Data e Hora do Sistema

O comando `date` exibe ou formata a data e hora do sistema operacional.

```bash
# Exibe data, horário e fuso horário atuais
$ date
Sat Oct 17 18:00:00 -03 2026

# Formatação personalizada (Ano-Mês-Dia e Hora:Minuto:Segundo)
$ date "+%Y-%m-%d %H:%M:%S"
2026-10-17 18:00:00

# Exibe o horário no padrão universal (UTC)
$ date -u
Sat Oct 17 21:00:00 UTC 2026
```

#### 2. `echo` — Impressão de Texto e Dados

O `echo` imprime argumentos na saída padrão (geralmente o terminal). É essencial para scripts, depuração e inspeção de variáveis.

```bash
# Imprime uma mensagem simples na tela
$ echo "Bem-vindo ao minicurso de Shell!"
Bem-vindo ao minicurso de Shell!

# Com a opção -e, interpreta caracteres de escape como quebra de linha (\n) ou tabulação (\t)
$ echo -e "Primeira linha\nSegunda linha\t(com tab)"
Primeira linha
Segunda linha	(com tab)

# Redireciona a saída para criar ou sobrescrever um arquivo texto
$ echo "Primeira anotação" > notas.txt
```

#### 3. `man` — Manual Oficial do Sistema

O `man` (*manual*) abre a documentação oficial e detalhada de utilitários, programas e arquivos do sistema Unix/Linux.

```bash
# Abre o manual de instruções do comando 'ls'
$ man ls

# Comandos de navegação dentro do visualizador (pager):
#   Setas ou Espaço : rolar o texto
#   /palavra        : pesquisar por um termo no texto
#   n               : avançar para a próxima ocorrência da busca
#   q               : sair (quit) e voltar ao terminal
```

> **Curiosidade:** O manual é dividido em seções numeradas. Por exemplo, `man 1 printf` consulta o comando de terminal do usuário, enquanto `man 3 printf` consulta a função da biblioteca padrão da linguagem C.

#### 4. `tldr` — Consulta Prática e Rápida

Enquanto as páginas do `man` são completas e exaustivas, a ferramenta comunitária **`tldr`** (*Too Long; Didn't Read*) foca exclusivamente nos exemplos mais comuns do dia a dia.

```bash
# Exibe os exemplos práticos mais frequentes de uso do 'ls'
$ tldr ls

# Exibe exemplos diretos de como compactar e descompactar arquivos com 'tar'
$ tldr tar
```

> Se o utilitário `tldr` não estiver pré-instalado em sua distribuição, ele pode ser instalado via gerenciador de pacotes (ex.: `sudo apt install tldr` ou `brew install tldr`).

#### 5. `ls` — Listagem de Conteúdo de Diretórios

O comando `ls` (*list*) lista os arquivos e subpastas do diretório informado (ou do diretório atual, se nenhum for passado).

```bash
# Listagem simples de arquivos e pastas visíveis
$ ls
Makefile  README.md  dist  docs  img  style.css

# -l : formato detalhado (permissões, links, proprietário, grupo, tamanho em bytes e data)
$ ls -l

# -a : inclui arquivos e diretórios ocultos (que iniciam com '.')
$ ls -a
.  ..  .git  .gitignore  Makefile  docs

# -lh : combina formato longo com tamanhos em unidades legíveis para humanos (K, M, G)
$ ls -lh
-rw-r--r--  1 marcelo  staff   2.1K Oct 17 17:00 Makefile
-rw-r--r--  1 marcelo  staff   3.8K Oct 17 17:39 style.css

# -lt : ordena os arquivos pela data da última modificação (mais recentes primeiro)
$ ls -lt
```

#### 6. `which` — Localização de Executáveis

O `which` mostra o caminho absoluto do executável que o shell executará quando você invocar um comando.

```bash
# Descobrir onde está instalado o binário do comando 'ls'
$ which ls
/bin/ls

# Descobrir qual interpretador Python está sendo invocado
$ which python3
/usr/bin/python3

# Descobrir a localização do shell Bash no sistema
$ which bash
/bin/bash
```

#### 7. Variáveis de Ambiente e a Variável `$PATH`

As **variáveis de ambiente** são valores dinâmicos globais mantidos pelo sistema e pelo shell para configurar parâmetros e caminhos compartilhados entre programas e processos.

Para inspecionar o valor de qualquer variável, basta anteceder seu nome com o símbolo de cifrão (`$`):

```bash
# Nome do usuário atualmente conectado
$ echo $USER
marcelo

# Caminho do diretório pessoal do usuário
$ echo $HOME
/home/marcelo

# Qual shell está configurado como padrão para o usuário
$ echo $SHELL
/bin/zsh
```

##### O que é a variável `$PATH` e como o Shell acha os comandos?

Quando você digita `date` ou `python3`, você não precisa digitar `/bin/date` ou `/usr/bin/python3`. Como o shell sabe em qual pasta procurar o executável?

A resposta é a variável **`$PATH`**:

```bash
$ echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

A variável `$PATH` contém uma sequência de caminhos de diretórios separados por dois pontos (`:`). A cada comando digitado:

1. O shell percorre a lista de diretórios do `$PATH` da esquerda para a direita.
2. Procura um arquivo executável com aquele nome em `/usr/local/bin`. Se não encontrar, tenta `/usr/bin`, depois `/bin`, etc.
3. Se encontrar, executa-o imediatamente.
4. Se percorrer todos os diretórios sem encontrar o executável, exibe a mensagem de erro clássica: `command not found`.

> É exatamente essa busca pelo `$PATH` que o comando `which` realiza para nos mostrar onde um programa está instalado!

##### Variáveis Locais vs. Variáveis de Ambiente: `set` e `export`

No shell, existem dois níveis distintos de variáveis:

1. **Variáveis Locais (do Shell):** Ficam restritas exclusivamente ao processo do shell atual onde foram criadas. Qualquer novo script, programa ou subshell executado a partir dele **não** terá acesso a essas variáveis.
2. **Variáveis de Ambiente:** São marcadas para exportação. Qualquer comando, script ou processo filho iniciado a partir do shell herda uma cópia dessas variáveis em sua própria tabela de ambiente.

###### O comando `set`

O comando embutido `set` (quando executado sem argumentos) exibe **todas** as variáveis e funções atualmente definidas no shell — incluindo tanto as variáveis locais quanto as variáveis de ambiente exportadas.

```bash
# Lista todas as variáveis e funções do shell atual (saída longa!)
$ set

# Filtrar para conferir se uma variável específica está definida no shell:
$ set | grep DISCIPLINA
```

> **Diferença importante:** Enquanto os comandos `env` e `printenv` listam **apenas** as variáveis de ambiente (exportadas), o comando `set` lista **todas** as variáveis do shell (locais + exportadas) e também funções definidas.

###### O comando `export` e sua relação com o `set`

O comando `export` funciona como um mecanismo de promoção: ele pega uma variável que existe localmente no shell e a promove a **variável de ambiente**, fazendo com que ela passe a ser automaticamente herdada por qualquer processo ou comando filho.

A demonstração prática abaixo ilustra essa diferença com clareza:

```bash
# 1. Definindo uma variável apenas LOCAL no shell:
$ DISCIPLINA="Sistemas Operacionais"
$ echo $DISCIPLINA
Sistemas Operacionais

# Ao disparar um novo processo (um subshell), a variável local NÃO existe lá dentro:
$ bash -c 'echo "No subshell: $DISCIPLINA"'
No subshell: 

# 2. Promovendo a variável a AMBIENTE com 'export':
$ export DISCIPLINA

# Agora qualquer comando ou script filho passa a enxergá-la:
$ bash -c 'echo "No subshell: $DISCIPLINA"'
No subshell: Sistemas Operacionais

# Você também pode criar e exportar em um único comando:
$ export PROFESSOR="Marcelo Cohen"
```

###### Resumo da Relação entre `set`, `export` e `env`

| Comando / Sintaxe | O que faz no ambiente | Quem tem acesso ao valor? |
| :--- | :--- | :--- |
| `VAR="valor"` | Cria ou altera uma **variável local** no shell | Somente a sessão atual do shell. |
| `set` | Lista **todas** as variáveis (locais e exportadas) e funções | Inspeciona o estado completo do interpretador atual. |
| `export VAR` | Promove uma variável local existente a **variável de ambiente** | O shell atual e todos os processos/scripts filhos criados por ele. |
| `export VAR="valor"` | Cria e já exporta a variável em uma única instrução | O shell atual e todos os processos/scripts filhos criados por ele. |
| `env` / `printenv` | Lista exclusivamente as **variáveis de ambiente** | Inspeciona apenas o que é herdado pelos programas filhos. |


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


