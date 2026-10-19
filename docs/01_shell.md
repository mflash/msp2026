# 01. Introdução ao Shell e Comandos Básicos

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
  <a href="index.html" class="nav-link">← Voltar ao Índice Principal</a> | 
  <a href="slides_introducao.html" class="nav-link" target="_blank" rel="noopener noreferrer">📊 Ver Slides da Introdução →</a>
</p>

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

---

### Navegação e Manipulação no Sistema de Arquivos

Além de consultar variáveis e inspecionar o sistema, a rotina essencial no terminal envolve mover-se entre pastas, criar, copiar, renomear, visualizar e editar arquivos.

#### 1. Navegação Básica: `pwd` e `cd`

Antes de manipular arquivos, é fundamental saber onde você está e como transitar pela árvore de diretórios:

- **`pwd`** (*Print Working Directory*): Exibe o caminho absoluto do diretório atual.
- **`cd`** (*Change Directory*): Altera o diretório de trabalho corrente.

```bash
# Onde estou agora?
$ pwd
/home/marcelo/msp2026

# Entrar em um subdiretório (caminho relativo)
$ cd docs
$ pwd
/home/marcelo/msp2026/docs

# Subir um nível na hierarquia (para o diretório pai: '..')
$ cd ..
$ pwd
/home/marcelo/msp2026

# Ir diretamente para a sua pasta pessoal (home) usando '~' ou apenas 'cd'
$ cd ~
$ pwd
/home/marcelo

# Voltar rapidamente para o último diretório onde você estava ('-')
$ cd -
/home/marcelo/msp2026
```

#### 2. `cp` — Copiando Arquivos e Pastas

O comando `cp` (*copy*) cria uma cópia de arquivos ou diretórios de uma origem para um destino:

```bash
# Copia 'Makefile' criando uma cópia com novo nome no mesmo diretório
$ cp Makefile Makefile.backup

# Copia um arquivo para dentro de outro diretório existente
$ cp style.css docs/

# Modo interativo (-i): solicita confirmação antes de sobrescrever se o arquivo de destino já existir
$ cp -i style.css docs/
overwrite docs/style.css? (y/n [n]) y

# Copiar uma pasta inteira e todo seu conteúdo recursivamente (-r ou -R)
$ cp -r img/ img_backup/
```

> **Atenção:** Para copiar diretórios, a flag `-r` (recursivo) é **obrigatória**; caso contrário, o comando retornará um erro avisando que o item é um diretório.

#### 3. `mv` — Movendo e Renomeando

O `mv` (*move*) serve para duas funções idênticas no nível do sistema de arquivos: **renomear** itens ou **movê-los** entre diretórios.

```bash
# Renomear um arquivo (origem e destino no mesmo diretório)
$ mv rascunho.txt relatorio_final.txt

# Mover um arquivo para outro diretório existente
$ mv relatorio_final.txt docs/

# Mover e renomear ao mesmo tempo
$ mv notas.txt docs/anotacoes_aula.txt

# Mover uma pasta inteira (o mv não requer flag -r para diretórios)
$ mv img_backup/ arquivos_antigos/

# Evitar sobrescrever acidentalmente com a flag interativa (-i)
$ mv -i novo.txt docs/relatorio_final.txt
overwrite docs/relatorio_final.txt? (y/n [n]) n
```

#### 4. `rm` — Removendo Arquivos e Diretórios

O comando `rm` (*remove*) apaga arquivos e diretórios permanentemente do disco.

```bash
# Remove um único arquivo
$ rm Makefile.backup

# Remove múltiplos arquivos de uma só vez
$ rm teste1.txt teste2.txt

# Modo interativo (-i): pede confirmação antes de cada exclusão (muito recomendado!)
$ rm -i documento.pdf
remove documento.pdf? y

# Remover uma pasta e todo o seu conteúdo recursivamente (-r)
$ rm -r arquivos_antigos/

# Forçar remoção sem pedir confirmações nem alertar sobre arquivos inexistentes (-f)
$ rm -rf cache_temporario/
```

> **Cuidado Crítico no Linux:** No terminal, **não existe Lixeira**. Um arquivo removido com `rm` é desvinculado imediatamente do sistema de arquivos e não pode ser facilmente recuperado. Tenha atenção redobrada ao usar comandos como `rm -rf`.

#### 5. `cat` — Exibição Rápida e Concatenação

O `cat` (*concatenate*) lê arquivos sequencialmente e imprime todo o seu conteúdo diretamente no terminal. É ideal para arquivos pequenos e médios.

```bash
# Exibe todo o conteúdo de um arquivo texto
$ cat Makefile

# Exibe o conteúdo numerando todas as linhas (-n), ótimo para códigos e scripts
$ cat -n Makefile
     1  # Executables
     2  PANDOC      := pandoc
     3  PYTHON      := python3

# Concatenar dois arquivos gerando um terceiro combinado:
$ cat intro.txt conclusao.txt > documento_completo.txt
```

#### 6. `less` — Visualização Paginada de Arquivos Longos

Quando um arquivo tem centenas de linhas (como logs de sistema ou códigos extensos), o `cat` rola tudo de uma vez, tornando impossível a leitura. O utilitário **`less`** abre o arquivo em um visualizador interativo em tela cheia (*pager*), sem carregar todo o arquivo na memória de uma só vez.

```bash
# Abre o arquivo no visualizador paginado
$ less style.css
```

##### Comandos de Teclado Essenciais no `less`:

| Tecla / Atalho | Ação de Navegação |
| :--- | :--- |
| **`Espaço`** ou **`f`** | Avançar uma tela inteira para frente (*page down*). |
| **`b`** | Voltar uma tela inteira para trás (*page up*). |
| **`↓`** ou **`j`** | Descer uma linha. |
| **`↑`** ou **`k`** | Subir uma linha. |
| **`/texto`** | Pesquisar por uma palavra para frente a partir do ponto atual. |
| **`?texto`** | Pesquisar por uma palavra para trás. |
| **`n`** | Ir para o próximo resultado da pesquisa. |
| **`N`** | Ir para o resultado anterior da pesquisa. |
| **`g`** | Pular para o início do arquivo (linha 1). |
| **`G`** | Pular para o final do arquivo. |
| **`q`** | Sair do visualizador (*quit*) e voltar ao prompt do terminal. |

#### 7. Edição Simples no Terminal: `nano` / `pico`

Muitas vezes precisamos fazer alterações rápidas em arquivos de configuração (`.conf`), notas ou scripts diretamente no terminal, sem abrir uma IDE pesada. O **`nano`** (evolução em software livre do clássico editor **`pico`**) é o editor em modo texto mais intuitivo e amigável para iniciantes, pois exibe um guia permanente de atalhos no rodapé da tela.

```bash
# Abre um arquivo existente para edição (ou cria um novo com esse nome caso não exista)
$ nano notas_aula.txt
```

##### Como Usar o `nano`:

Ao abrir o `nano`, você pode digitar o texto normalmente como em um bloco de notas. Na parte inferior da tela, os comandos utilizam o símbolo de circunflexo (`^`), que representa a tecla **`Ctrl`**:

| Atalho | Nome do Comando | O que faz no editor |
| :--- | :--- | :--- |
| **`Ctrl + O`** | *WriteOut* | **Salva** o arquivo no disco (pressione Enter para confirmar o nome). |
| **`Ctrl + X`** | *Exit* | **Sai** do editor. Se houver alterações não salvas, pergunta se deseja gravar (`Y`/`N`). |
| **`Ctrl + W`** | *Where Is* | **Pesquisa** por uma palavra ou expressão no texto. |
| **`Ctrl + K`** | *Cut Text* | **Corta** a linha inteira onde o cursor está posicionado. |
| **`Ctrl + U`** | *Uncut Text* | **Cola** a linha que foi cortada com `Ctrl + K`. |
| **`Ctrl + C`** | *Cur Pos* | Mostra a posição atual do cursor (número da linha e coluna). |
| **`Ctrl + G`** | *Get Help* | Abre o painel completo de ajuda do editor. |

##### Dica de Fluxo de Trabalho no `nano`:
1. Abra o arquivo com `nano script.sh`.
2. Escreva ou edite o texto desejado.
3. Pressione **`Ctrl + O`** e depois tecle **`Enter`** para salvar.
4. Pressione **`Ctrl + X`** para fechar o editor e voltar ao shell.

#### 8. Permissões de Arquivos e o Comando `chmod`

No Linux, a segurança e o controle de acesso são estruturados no nível do próprio sistema de arquivos. Cada arquivo e pasta possui permissões explícitas que determinam **quem** pode ler, alterar ou executar seu conteúdo.

Ao executar `ls -l`, a primeira coluna exibe 10 caracteres que descrevem essas permissões (por exemplo, `-rwxr-xr-x`):

[![Anatomia das Permissões no Linux e o Comando chmod (clique para ampliar)](img/linux-permissions.svg)](img/linux-permissions.svg)

##### Como as Permissões se Dividem:

1. **Tipo de Arquivo (1º caractere):**
   - `-` : Arquivo comum (texto, imagem, código, binário).
   - `d` : Diretório (pasta).
   - `l` : Link simbólico (*atalho* apontando para outro arquivo).
2. **Os Três Grupos de Usuários (3 caracteres cada):**
   - **`u` (User / Dono):** O usuário proprietário que criou o arquivo.
   - **`g` (Group / Grupo):** Usuários que pertencem ao grupo associado ao arquivo.
   - **`o` (Others / Outros):** Todos os demais usuários do sistema ("o mundo").
   - **`a` (All / Todos):** Representa os três grupos simultaneamente (`u + g + o`).
3. **Os Três Tipos Básicos de Permissão:**
   - **`r` (Read / Leitura - valor 4):** Permite abrir e ler o arquivo. Em pastas, permite listar seu conteúdo com `ls`.
   - **`w` (Write / Escrita - valor 2):** Permite alterar ou gravar o arquivo. Em pastas, permite criar, renomear ou excluir arquivos internos.
   - **`x` (Execute / Execução - valor 1):** Permite executar o arquivo como programa ou script. Em pastas, **é indispensável para entrar na pasta** usando `cd` ou acessar seus arquivos!

---

##### O Comando `chmod`: Alterando Permissões

O comando `chmod` (*Change Mode*) permite modificar as permissões de arquivos e diretórios de duas maneiras: **Modo Simbólico** ou **Modo Octal (Numérico)**.

###### A. Modo Simbólico (Letras e Operadores)

Neste formato, você especifica **para quem** (`u`, `g`, `o`, `a`), um **operador** (`+`, `-`, `=`) e a **permissão** (`r`, `w`, `x`):

```bash
# Adiciona permissão de execução (+x) para todos os usuários (caso mais comum para scripts!)
$ chmod +x script.sh

# Adiciona execução (+x) apenas para o dono (u)
$ chmod u+x deploy.sh

# Remove permissão de escrita (-w) do grupo (g) e de outros (o)
$ chmod go-w documento_importante.txt

# Define exatamente as permissões: dono lê e escreve; grupo e outros apenas leem
$ chmod u=rw,go=r config.json
```

###### B. Modo Octal / Numérico (Soma de Valores)

No modo numérico, calculamos uma soma de dígitos de 0 a 7 para cada um dos 3 grupos (Dono, Grupo, Outros), usando os valores:

> **Leitura (`r`) = 4** &nbsp;|&nbsp; **Escrita (`w`) = 2** &nbsp;|&nbsp; **Execução (`x`) = 1** &nbsp;|&nbsp; **Sem permissão (`-`) = 0**

| Dígito | Permissão Simbólica | Significado |
| :---: | :---: | :--- |
| **7** | `rwx` | Leitura (4) + Escrita (2) + Execução (1) = Acesso Total |
| **6** | `rw-` | Leitura (4) + Escrita (2) = Ler e Gravar (sem executar) |
| **5** | `r-x` | Leitura (4) + Execução (1) = Ler e Executar / Entrar na pasta |
| **4** | `r--` | Leitura (4) = Apenas leitura |
| **0** | `---` | Nenhuma permissão de acesso |

###### Exemplos Práticos Mais Usados no Dia a Dia:

```bash
# 755 (rwxr-xr-x): Dono faz tudo; grupo e outros apenas leem e executam
# Padrão recomendado para scripts executáveis, binários e pastas públicas
$ chmod 755 script.sh
$ ls -l script.sh
-rwxr-xr-x  1 marcelo  staff  420 Oct 17 18:20 script.sh

# 644 (rw-r--r--): Dono lê e grava; grupo e outros apenas leem
# Padrão seguro recomendado para a grande maioria de arquivos de texto, código e documentos
$ chmod 644 index.html
$ ls -l index.html
-rw-r--r--  1 marcelo  staff  1024 Oct 17 18:20 index.html

# 700 (rwx------): Acesso total exclusivo do dono; ninguém mais acessa
# Padrão obrigatório para pastas privadas de alta segurança (como ~/.ssh)
$ chmod 700 ~/.ssh

# 600 (rw-------): Leitura e gravação exclusivas do dono
# Padrão obrigatório para chaves privadas SSH e certificados sensíveis
$ chmod 600 ~/.ssh/id_rsa

# Aplicar permissões recursivamente a uma pasta e todos os seus subarquivos (-R)
$ chmod -R 755 public_html/
```

---

<p class="nav-footer" style="display: flex; justify-content: space-between; align-items: center; max-width: 600px; margin: 3rem auto 1.5rem auto;">
  <a href="index.html" class="module-btn secondary">← Voltar ao Índice Principal</a>
  <a href="02_redirecionamento_pipes.html" class="module-btn">Próximo Módulo: Redirecionamento e Pipes →</a>
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


