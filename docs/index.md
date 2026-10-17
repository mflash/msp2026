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

