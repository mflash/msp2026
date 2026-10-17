# 03. Gerenciamento de Processos e Monitoramento de Recursos

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
*Módulo 03 — Gerenciamento de Processos, Job Control, Sinais e Diagnóstico de Recursos*

---

### O que é um Processo no Linux?

Em sistemas operacionais, um **programa** é apenas um arquivo passivo armazenado no disco (como o binário `/bin/ls` ou um script Python `app.py`). Quando você solicita a execução desse programa, o sistema operacional aloca memória RAM, carrega suas instruções de máquina, atribui recursos de CPU e cria uma entidade viva: um **processo**.

O Linux é um sistema operacional **multitarefa preemptivo**, o que significa que ele executa centenas de processos simultaneamente, alternando rapidamente o tempo de CPU entre eles de forma que todos pareçam estar rodando em paralelo.

#### Identificadores e Propriedades Essenciais de um Processo:

| Propriedade | Significado | Exemplo |
| :--- | :--- | :--- |
| **`PID`** (*Process ID*) | Número inteiro exclusivo que identifica o processo no sistema operacional. | `1420` |
| **`PPID`** (*Parent Process ID*) | O PID do processo pai que o gerou (todo processo nasce a partir de outro). | `850` |
| **`UID / USER`** | O usuário proprietário que disparou o processo (determina suas permissões no sistema). | `marcelo` ou `root` |
| **`%CPU` e `%MEM`** | Percentual instantâneo de processador e memória RAM consumidos pelo processo. | `12.5%`, `2.1%` |
| **`STAT`** | O estado operacional atual do processo no escalonador do kernel (`R`, `S`, `Z`, `T`). | `S+` |

#### A Árvore de Processos e o `PID 1`:
Quando o computador liga e o kernel Linux termina de inicializar o hardware, ele dispara o primeiro processo em espaço de usuário: o **`systemd`** (ou `init` em sistemas antigos), que sempre recebe o **`PID 1`**. 

Todos os outros serviços, daemons de rede (como SSH), servidores gráficos e o próprio shell do terminal nascem como filhos ou descendentes diretos dessa raiz primordial.

Você pode inspecionar essa genealogia visualmente com o utilitário `pstree`:

```bash
# Exibe a árvore hierárquica de processos a partir do PID 1:
$ pstree -p | head -n 15
systemd(1)─┬─cron(420)
           ├─dbus-daemon(435)
           ├─sshd(512)───sshd(1204)───bash(1205)───pstree(3410)
           ├─systemd-journal(280)
           ├─systemd-logind(440)
           └─systemd-udevd(310)
```

[![Ciclo de Vida, Estados e Sinais de Processos no Linux (clique para ampliar)](img/linux-process-lifecycle.svg)](img/linux-process-lifecycle.svg)

---

### Inspecionando Processos: `ps`, `top` e `htop`

O Linux oferece comandos especializados para tirar "fotografias" instantâneas ou monitorar a atividade de processos de forma contínua em tempo real.

#### 1. O Comando `ps` (*Process Snapshot*)

O comando `ps` tira uma foto estática do estado dos processos naquele exato milissegundo:

```bash
# Execução simples: mostra apenas os processos vinculados ao terminal atual
$ ps
  PID TTY          TIME CMD
 1205 pts/0    00:00:00 bash
 3420 pts/0    00:00:00 ps
```

##### Os Dois Padrões Mais Usados no Dia a Dia:

```bash
# 1. Padrão BSD: 'ps aux' (o mais popular entre administradores e desenvolvedores)
# 'a' = todos os processos com terminal
# 'u' = formato detalhado com nome do usuário
# 'x' = inclui processos em background sem terminal associado (daemons e serviços)
$ ps aux | head -n 5
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1 168432 12480 ?        Ss   10:00   0:02 /sbin/init
root         2  0.0  0.0      0     0 ?        S    10:00   0:00 [kthreadd]
marcelo   1205  0.0  0.0  14520  5120 pts/0    Ss   10:15   0:00 -bash
marcelo   3425  0.0  0.0  19800  4200 pts/0    R+   11:30   0:00 ps aux

# 2. Padrão POSIX / System V: 'ps -ef'
# '-e' = todos os processos (every)
# '-f' = formato completo (full) exibindo a coluna PPID (pai do processo)
$ ps -ef | head -n 5
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 10:00 ?        00:00:02 /sbin/init
root         2     0  0 10:00 ?        00:00:00 [kthreadd]
marcelo   1205   512  0 10:15 pts/0    00:00:00 -bash
marcelo   3428  1205  0 11:30 pts/0    00:00:00 ps -ef
```

##### Como Filtrar Processos Específicos com `grep`:
Para descobrir o PID de um aplicativo rodando (por exemplo, um servidor Python):

```bash
# Filtra os processos procurando por 'python':
$ ps aux | grep python
marcelo   2840  1.2  2.5 125400 48200 pts/0    S+   11:00   0:04 python3 app.py
marcelo   3450  0.0  0.0   9120   880 pts/0    S+   11:32   0:00 grep --color=auto python
```

> **Dica Pro:** Note que o próprio comando `grep` aparece na lista acima! Para eliminá-lo sem precisar encadear `grep -v grep`, use o truque dos colchetes:
> ```bash
> $ ps aux | grep "[p]ython"
> marcelo   2840  1.2  2.5 125400 48200 pts/0    S+   11:00   0:04 python3 app.py
> ```
> O shell interpreta `[p]ython` como a letra "p" seguida de "ython", casando com o processo alvo, mas a linha de comando do grep vira literalmente `grep [p]ython`, que não casa consigo mesma!

---

##### Decodificando a Coluna `STAT` (Estados do Processo):

| Código | Significado | Descrição |
| :---: | :--- | :--- |
| **`R`** | *Running* | O processo está sendo executado na CPU ou pronto para rodar. |
| **`S`** | *Interruptible Sleep* | Dormindo / aguardando um evento (como resposta de rede ou tecla do usuário). Mais de 95% dos processos ficam aqui. |
| **`D`** | *Uninterruptible Sleep* | Dormindo aguardando I/O direto de disco/hardware. Não pode ser interrompido nem por `kill -9`. |
| **`T`** | *Stopped* | O processo foi pausado por um sinal de interrupção (ex.: pelo atalho `Ctrl + Z`). |
| **`Z`** | *Zombie* | Processo que já terminou, mas seu processo pai ainda não leu seu código de saída com a função `wait()`. Não consome CPU nem RAM, apenas uma entrada na tabela de processos. |
| **`+`** | *Foreground* | O processo está rodando em primeiro plano no grupo do terminal. |
| **`s`** | *Session Leader* | O processo é o líder da sessão (normalmente o seu shell). |

---

#### 2. Monitoramento em Tempo Real com `top`

Enquanto o `ps` mostra uma foto estática, o utilitário interativo **`top`** atualiza a tela a cada 3 segundos com as estatísticas ao vivo do sistema:

```bash
$ top
```

##### O que Observar no Cabeçalho do `top`:

```text
top - 18:55:10 up 3 days,  4:12,  2 users,  load average: 0.15, 0.25, 0.18
Tasks: 185 total,   1 running, 184 sleeping,   0 stopped,   0 zombie
%Cpu(s):  2.5 us,  1.0 sy,  0.0 ni, 96.0 id,  0.5 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :   7840.2 total,   2150.4 free,   3410.8 used,   2279.0 buff/cache
MiB Swap:   2048.0 total,   2048.0 free,      0.0 used.   4120.5 avail Mem
```

1. **`load average: 0.15, 0.25, 0.18`**:
   - A carga média do sistema nos últimos **1**, **5** e **15 minutos**.
   - Em uma máquina com 4 núcleos (CPUs), um *load average* até **4.0** significa 100% de ocupação saudável. Acima disso, há processos enfileirados aguardando CPU.
2. **Linha `%Cpu(s)`**:
   - **`us`** (*user*): tempo gasto rodando código do usuário (seus programas, navegador, scripts).
   - **`sy`** (*system*): tempo gasto dentro do kernel (chamadas de sistema, rede, memória).
   - **`id`** (*idle*): CPU ociosa (quanto maior, mais folgada a máquina está).
   - **`wa`** (*iowait*): **O indicador mais importante de lentidão!** Indica que a CPU está parada de braços cruzados esperando leitura/gravação lenta de disco (HD/SSD). Se passar de 20%, seu gargalo é o armazenamento.

##### Teclas de Atalho Mais Úteis no `top`:

| Tecla | Ação |
| :---: | :--- |
| **`P`** | Ordena a lista pelo uso de **CPU** (padrão). |
| **`M`** | Ordena a lista pelo uso de **Memória RAM** (ideal para achar vazamentos de memória). |
| **`T`** | Ordena pelo tempo acumulado de execução (**Time**). |
| **`k`** | Envia um sinal para matar um processo (*kill*). Digite o PID e depois tecle Enter. |
| **`1`** | Alterna entre exibir uma única linha de CPU combinada ou cada núcleo individualmente. |
| **`q`** | Sai (*quit*) do `top` e volta ao terminal. |

---

#### 3. A Alternativa Moderna: `htop`

O utilitário **`htop`** é uma versão evoluída do `top`, com interface colorida, medidores gráficos por núcleo de CPU, uso de mouse para clicar em colunas e pesquisa rápida com atalhos funcionais (`F1` a `F10`):

```bash
# Se não estiver instalado na sua distribuição:
# Debian/Ubuntu: sudo apt install htop
# Fedora/RHEL:   sudo dnf install htop
$ htop
```

---

### Controle de Tarefas no Terminal (*Job Control*)

Quando você dispara um comando demorado no terminal (como um backup ou uma compilação), por padrão ele roda em **primeiro plano** (*foreground*), prendendo seu prompt até que termine.

O shell oferece recursos de gerenciamento de tarefas (*jobs*) para controlar essa dinâmica sem precisar abrir outra janela de terminal:

#### 1. Iniciar em Segundo Plano com `&`

Basta adicionar um `&` ao final do comando para que ele seja executado imediatamente em segundo plano (*background*), liberando o terminal para você continuar trabalhando:

```bash
# Inicia um servidor web em segundo plano:
$ python3 -m http.server 8080 &
[1] 4510
```
O shell responde exibindo duas informações fundamentais:
- **`[1]`**: o **Job ID** (identificador da tarefa nesta sessão do shell).
- **`4510`**: o **PID** real do processo no sistema operacional.

---

#### 2. Consultar Tarefas Ativas com `jobs`

O comando `jobs` lista as tarefas vinculadas à sessão atual do shell:

```bash
# Lista os trabalhos gerenciados pelo shell atual:
$ jobs
[1]+  Running                 python3 -m http.server 8080 &

# Incluindo o PID correspondente (-l / list pids):
$ jobs -l
[1]+  4510 Running                 python3 -m http.server 8080 &
```

---

#### 3. Pausar e Alternar entre Foreground e Background

Se você já disparou um comando sem o `&` e ele travou o seu terminal, você não precisa cancelá-lo! Use os atalhos de controle:

```bash
# 1. Suponha que você iniciou um comando demorado em primeiro plano:
$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=118 time=18.2 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=118 time=17.9 ms

# 2. Pressione a combinação de teclas: Ctrl + Z
# O shell envia o sinal SIGTSTP, pausando o processo e liberando seu prompt:
^Z
[2]+  Stopped                 ping 8.8.8.8

# 3. Para fazer a tarefa pausada CONTINUAR rodando em segundo plano: use 'bg'
$ bg %2
[2]+ ping 8.8.8.8 &

# 4. Para trazer a tarefa de volta para o primeiro plano: use 'fg'
$ fg %2
ping 8.8.8.8
# (Agora o comando volta a controlar o terminal; pressione Ctrl + C para encerrá-lo)
^C
```

---

#### 4. Executando Tarefas Imunes ao Fechamento do Terminal: `nohup`

Quando você fecha a janela do emulador de terminal ou se desconecta de uma sessão SSH, o shell envia automaticamente o sinal `SIGHUP` (*Hangup*) para todos os processos filhos, encerrando-os imediatamente.

Para evitar que um script longo seja abortado ao fechar o terminal, use o prefixo **`nohup`** (*No Hangup*):

```bash
# Executa um treinamento ou migração em segundo plano imune a fechamento de conexão:
$ nohup python3 treinar_modelo.py > treino.log 2>&1 &
[1] 5120

# Pode fechar o terminal tranquilamente! Ao reconectar, você pode acompanhar o log:
$ tail -f treino.log
```

---

### Encerrando Processos: `kill`, `killall` e `pkill`

O comando `kill` na verdade não é apenas um "assassino" de processos: ele é um **emissor de sinais** (*signals*) do sistema operacional.

#### Principais Sinais do Linux:

| Sinal | Número | Descrição e Comportamento |
| :--- | :---: | :--- |
| **`SIGTERM`** | **`15`** | **Encerramento gracioso (padrão).** Pede educadamente para o programa encerrar. O programa tem a oportunidade de salvar arquivos, fechar conexões de banco de dados e limpar recursos antes de sair. |
| **`SIGKILL`** | **`9`** | **Encerramento forçado e incondicional.** Não conversa com o programa: o kernel descarta o processo da memória imediatamente. **Não pode ser capturado nem ignorado.** Use apenas se o processo travar e ignorar o `SIGTERM`. |
| **`SIGINT`** | **`2`** | **Interrupção via teclado.** É exatamente o sinal enviado quando você aperta `Ctrl + C`. |
| **`SIGHUP`** | **`1`** | **Hangup / Recarregar.** Originalmente disparado por perda de linha telefônica em terminais de modem. Hoje em dia, daemons como Nginx e Apache tratam o `SIGHUP` como uma instrução para **reler seus arquivos de configuração** sem derrubar conexões ativas! |

#### Exemplos Práticos de Uso:

```bash
# 1. Encerramento gracioso padrão (SIGTERM / 15):
$ kill 4510

# 2. Encerramento forçado caso o processo não responda (SIGKILL / 9):
$ kill -9 4510
# ou pelo nome mnemônico:
$ kill -SIGKILL 4510

# 3. Pedir para o Nginx recarregar configurações sem parar o serviço:
$ sudo kill -SIGHUP 850

# 4. Matar por nome exato do programa com killall:
# Encerra todas as instâncias de navegadores ou scripts com aquele nome
$ killall chrome
$ killall -9 python3

# 5. Localizar e matar por expressão regular usando pkill:
# Mata qualquer processo cuja linha de comando contenha 'app.py'
$ pkill -f "app.py"
```

---

### Prioridades de Execução: `nice` e `renice`

O escalonador de processos do Linux atribui uma pontuação de "gentileza" (*niceness*) a cada tarefa, que varia de **`-20` a `+19`** (o padrão é `0`):

- **Valores negativos (até `-20`):** Maior prioridade de CPU (o processo é "pouco educado", consome mais fatias de tempo). Requer privilégios de superusuário (`sudo`).
- **Valores positivos (até `+19`):** Menor prioridade de CPU (o processo é "muito educado", só consome CPU quando ninguém mais estiver precisando).

```bash
# 1. Disparar uma rotina pesada (como compactação de vídeo ou backup) com prioridade baixa (+15):
# Assim seu computador continua perfeitamente fluido para navegar e trabalhar!
$ nice -n 15 tar -czf backup_gigante.tar.gz /home/marcelo/

# 2. Alterar a prioridade de um processo que JÁ está rodando (renice):
# Aumenta a prioridade do processo 3410 para -5 (requer sudo):
$ sudo renice -n -5 -p 3410
```

---

### Diagnóstico de Recursos: Memória e Armazenamento

Controlar processos requer saber quanto de memória e disco a máquina possui disponível.

#### 1. Diagnóstico de Memória RAM: `free -h`

```bash
$ free -h
               total        used        free      shared  buff/cache   available
Mem:           7.7Gi       3.2Gi       1.8Gi       120Mi       2.7Gi       4.2Gi
Swap:          2.0Gi          0B       2.0Gi
```

> **O Mito da "Memória Livre" no Linux:**  
> Usuários vindos de outros sistemas costumam se assustar ao ver pouca memória `free`. No Linux, **memória RAM não utilizada é memória desperdiçada**! O kernel usa a memória ociosa como cache inteligente de disco (`buff/cache`) para acelerar a abertura de arquivos.  
> Se um aplicativo grande for aberto, o kernel descarta esse cache instantaneamente. Portanto, o valor real que você deve olhar para saber quanta memória ainda pode ser alocada é a coluna **`available`** (4.2 GiB no exemplo acima).

---

#### 2. Diagnóstico de Espaço em Disco: `df` e `du`

- **`df`** (*Disk Free*): Exibe a ocupação de cada partição de disco e sistema de arquivos montado:
  ```bash
  # -h para formato legível (G, M, K):
  $ df -h
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/sda1        48G   18G   28G  40% /
  /dev/sdb1       458G  120G  315G  28% /home
  ```

- **`du`** (*Disk Usage*): Calcula o tamanho consumido por arquivos e pastas específicas:
  ```bash
  # Resumo do tamanho total da pasta (-s / summary, -h / human):
  $ du -sh docs/
  12M    docs/

  # Descobrir quais são as 5 maiores subpastas dentro do seu diretório pessoal:
  $ du -h --max-depth=1 /home/marcelo | sort -rh | head -n 5
  42G    /home/marcelo
  18G    /home/marcelo/projetos
  12G    /home/marcelo/downloads
  6.5G   /home/marcelo/.cache
  2.1G   /home/marcelo/virtualenv
  ```

---

### Breve Introdução a Serviços do Sistema (*Daemons*): `systemctl`

Em servidores e ambientes de produção, processos de longa duração não são iniciados manualmente no shell com `&`, mas sim gerenciados pelo `systemd` como **serviços** (*daemons*):

```bash
# Verificar se o serviço de acesso remoto SSH está ativo e rodando:
$ systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
     Active: active (running) since Sat 2026-10-17 10:00:15 -03; 8h ago
   Main PID: 512 (sshd)

# Iniciar, parar ou reiniciar um serviço (requer sudo):
$ sudo systemctl start nginx
$ sudo systemctl restart nginx
$ sudo systemctl stop nginx

# Habilitar um serviço para inicializar automaticamente com o boot da máquina:
$ sudo systemctl enable docker
```

---

### Resumo dos Comandos de Processos e Recursos

| Comando | Para que serve | Exemplo |
| :--- | :--- | :--- |
| **`ps aux`** | Fotografia completa de todos os processos do sistema | `ps aux \| grep node` |
| **`top` / `htop`** | Painel interativo ao vivo de CPU e memória | `top` (tecle `M` para ordenar por RAM) |
| **`comando &`** | Executa o programa em segundo plano | `python3 app.py &` |
| **`jobs`** | Lista as tarefas vinculadas à sessão atual do shell | `jobs -l` |
| **`Ctrl + Z`** | Pausa o processo atual em primeiro plano | Pressione `Ctrl + Z` e use `bg` |
| **`fg` / `bg`** | Alterna processos entre foreground e background | `fg %1` ou `bg %1` |
| **`kill`** | Envia sinal de encerramento pelo PID | `kill 1234` ou `kill -9 1234` |
| **`killall`** | Mata todos os processos com determinado nome | `killall firefox` |
| **`pkill`** | Mata processos por busca textual na linha de comando | `pkill -f "servidor.py"` |
| **`free -h`** | Diagnóstico instantâneo de uso da memória RAM e Swap | `free -h` |
| **`df -h`** | Exibe o percentual de uso de cada partição de disco | `df -h` |
| **`du -sh`** | Calcula o espaço total em disco ocupado por uma pasta | `du -sh /var/log` |

---

<p class="nav-footer" style="display: flex; justify-content: space-between; align-items: center; max-width: 650px; margin: 3rem auto 1.5rem auto;">
  <a href="02_redirecionamento_pipes.html" class="module-btn secondary">← Módulo 02: Pipes e Filtros</a>
  <a href="index.html" class="module-btn secondary">Índice</a>
  <a href="04_automacao_shell_scripting.html" class="module-btn">Próximo: Módulo 04 (Scripting) →</a>
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
