# 05. Depuração e Profiling: Análise de Desempenho e Diagnóstico

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
*Módulo 05 — Técnicas de Profiling, Análise de Gargalos e Ferramentas Gratuitas para C, Python e Java*

---

### Introdução: Depuração vs. Profiling

No desenvolvimento de software, encontramos dois tipos fundamentais de desafios após o código compilar:

1. **Depuração (*Debugging*):** O programa apresenta um comportamento funcional incorreto — gera cálculos errados, lança exceções não tratadas ou sofre falhas catastróficas (*segmentation faults / crashes*). O objetivo da depuração é responder: ***"Por que o programa falhou?"***
2. **Profiling (Análise de Desempenho):** O programa funciona corretamente e produz o resultado esperado, mas é **lento**, consome **memória RAM excessiva**, sobrecarrega a **CPU** ou sofre com gargalos de I/O de disco e rede. O objetivo do profiling é responder: ***"Onde exatamente o programa gasta seus recursos de tempo e memória?"***  
   Para isso usamos um **profiler**: uma ferramenta que observa o programa em execução e mede, para cada função (ou linha), quantas vezes ela foi chamada, quanto tempo de CPU consumiu e quanta memória alocou, produzindo um relatório que aponta os gargalos.

> *"A otimização prematura é a raiz de todos os males na programação."*  
> — **Donald E. Knuth**

Tentar adivinhar onde um programa está lento sem medições quase sempre leva a otimizações inúteis em trechos que respondem por menos de 1% do tempo total. A regra de ouro é: **meça primeiro, profile sempre, otimize somente o que faz diferença.**

#### Por que medir antes de otimizar? A Regra 80/20 e a Lei de Amdahl

Dois conceitos complementares justificam o uso de profilers:

##### 1. A Regra 80/20 (Princípio de Pareto): *onde* está o tempo?
É uma **observação empírica**, e não uma lei matemática: na maioria dos programas, **uma pequena parte do código responde pela maior parte do tempo de execução** (algo como 80% do tempo gasto em 20% do código, e muitas vezes a concentração é ainda maior, como 90/10). Esses trechos são chamados de *hotspots* ou gargalos.

O problema é que **a intuição do programador costuma errar ao apontar onde eles estão**. Por isso precisamos de um profiler para encontrá-los.

##### 2. A Lei de Amdahl: *quanto* vale a pena otimizar?
Formulada por Gene Amdahl em 1967 (originalmente para processamento paralelo), ela calcula o **ganho total (*speedup*)** obtido ao acelerar apenas **uma parte** do programa:

```text
Speedup total = 1 / ( (1 − p) + p / k )
```

- `p` = fração do tempo total gasta no trecho otimizado (ex.: 0,80 = 80%)
- `k` = quantas vezes esse trecho ficou mais rápido

**Exemplo A: otimizar o gargalo.** Uma função consome 80% do tempo e você a deixa 4× mais rápida:  
`1 / (0,20 + 0,80/4) = 1 / 0,40` → **2,5× mais rápido no total**.

**Exemplo B: otimizar o trecho errado.** Uma função consome 5% do tempo e você a deixa *infinitamente* rápida (`k → ∞`):  
`1 / 0,95 ≈ 1,05` → **apenas 5% de ganho**, por mais esforço que tenha sido investido.

> **Moral:** o ganho máximo possível é limitado pela parte que você **não** otimizou. A regra de Pareto diz que os gargalos existem e são poucos; a Lei de Amdahl mostra que só otimizá-los traz resultado. **O profiler revela o valor de `p` de cada função.** No exemplo `processamento.c` da Seção 3, `funcao_lenta_gargalo` responde por mais de 95% do tempo: otimizar `funcao_rapida` seria praticamente inútil.

---

### 1. Técnicas de Depuração: Do "Print Debugging" ao Logging Estruturado

Antes de analisar o desempenho, o primeiro dever de todo desenvolvedor é garantir que o software funcione de forma correta e confiável. Quando o programa apresenta comportamentos inesperados ou falhas, precisamos investigar o estado interno das variáveis e o fluxo de execução.

#### A. O "Print Debugging" e suas Limitações

A técnica mais instintiva e difundida no início da jornada de programação é espalhar instruções de saída no código para inspecionar variáveis:
- Em C: `printf("Valor de x = %d\n", x);`
- Em Python: `print(f"DEBUG: entrou na funcao com {parametro}")`
- Em Java: `System.out.println("DEBUG: resultado = " + resultado);`

Embora seja uma abordagem rápida para pequenos testes locais, o **"Print Debugging" traz problemas graves** em projetos reais:

1. **Poluição do Código:** É comum esquecer mensagens de debug no código, que acabam indo para produção e poluindo os terminais e logs dos usuários.
2. **Falta de Controle Centralizado:** Para silenciar os prints quando a funcionalidade estiver pronta, você é obrigado a comentar ou apagar cada linha manualmente no código-fonte.
3. **Ausência de Metadados Cruciais:** O `print` comum não registra data/hora (*timestamp*), nível de gravidade, identificador de thread, nem o nome do arquivo e linha de onde partiu a mensagem.
4. **O Perigo do Buffer de I/O em C (`stdout` vs. `stderr`):**  
   Por padrão, a saída padrão (`stdout`) do C é bufferizada em memória para otimizar desempenho. Se o seu programa sofrer uma falha catastrófica (*Segmentation Fault*) logo após um `printf()`, **o buffer pode ser destruído antes de descarregar na tela!** Isso causa a falsa ilusão de que o programa travou *antes* de chegar naquele print, enganando completamente o desenvolvedor.  
   > **Regra em C:** Se precisar usar print para depuração rápida, direcione sempre para `stderr` com `fprintf(stderr, ...)` ou force a descarga imediata do buffer com `fflush(stdout)`.

---

#### B. Logging Estruturado e Níveis de Severidade

A forma profissional de monitorar e depurar aplicações é através de um **framework de Logging**. Um sistema de log permite emitir mensagens categorizadas por **Níveis de Severidade (*Log Levels*)**:

| Nível de Log | Gravidade | Quando Utilizar? | Exemplo Típico |
| :---: | :---: | :--- | :--- |
| **`TRACE`** | Mínima | Detalhes microscópicos do fluxo; loops internos passo a passo. | `Entrando no loop com i=4, ponteiro=0x7fff` |
| **`DEBUG`** | Baixa | Informações úteis para o desenvolvedor diagnosticar bugs em ambiente de testes. | `Payload JSON recebido: { "id": 42 }` |
| **`INFO`** | Média | Eventos normais e marcos saudáveis do ciclo de vida da aplicação. | `Servidor iniciado com sucesso na porta 8080` |
| **`WARN` / `WARNING`** | Atenção | Situações inesperadas que não impediram a execução, mas merecem vigilância. | `Conexão lenta; usando rota alternativa (tentativa 2/5)` |
| **`ERROR`** | Alta | Falha que impediu uma operação específica de ser concluída, mas o app continua vivo. | `Falha ao salvar pedido #124: timeout no banco` |
| **`FATAL` / `CRITICAL`** | Máxima | Erro catastrófico irrecuperável que força a interrupção imediata do programa. | `Arquivo de configuração corrompido. Encerrando processo.` |

##### O Poder do Filtro Global:
Em ambiente de desenvolvimento, configuramos o nível mínimo como **`DEBUG`** (vemos tudo). Ao enviar o código para o servidor de produção, alteramos apenas uma variável de ambiente ou arquivo de configuração para **`INFO`** ou **`WARN`**: **todas as mensagens de debug passam a ser ignoradas silenciosamente**, sem necessidade de alterar ou recompilar uma única linha de código!

---

#### C. Práticas e Ferramentas de Logging por Linguagem

##### 1. Logging em C: Macros com Metadados do Compilador
Em C, podemos criar macros elegantes no pré-processador aproveitando as constantes mágicas fornecidas pelo compilador (`__FILE__`, `__LINE__` e `__func__`), com saída formatada e colorida enviada para `stderr`:

```c
#include <stdio.h>
#include <time.h>

// Cores ANSI para o terminal
#define ANSI_CYAN   "\033[36m"
#define ANSI_YELLOW "\033[33m"
#define ANSI_RED    "\033[31m"
#define ANSI_RESET  "\033[0m"

// Macro de log estruturado para stderr
#define LOG_DEBUG(fmt, ...) \
    fprintf(stderr, ANSI_CYAN "[DEBUG] " ANSI_RESET "[%s:%d in %s()] " fmt "\n", \
            __FILE__, __LINE__, __func__, ##__VA_ARGS__)

#define LOG_WARN(fmt, ...) \
    fprintf(stderr, ANSI_YELLOW "[WARN]  " ANSI_RESET "[%s:%d in %s()] " fmt "\n", \
            __FILE__, __LINE__, __func__, ##__VA_ARGS__)

#define LOG_ERROR(fmt, ...) \
    fprintf(stderr, ANSI_RED "[ERROR] " ANSI_RESET "[%s:%d in %s()] " fmt "\n", \
            __FILE__, __LINE__, __func__, ##__VA_ARGS__)

int dividir(int a, int b) {
    LOG_DEBUG("Iniciando divisao de %d por %d", a, b);
    if (b == 0) {
        LOG_ERROR("Tentativa de divisao por zero!");
        return -1;
    }
    return a / b;
}

int main(void) {
    LOG_DEBUG("Iniciando aplicacao");
    dividir(10, 2);
    dividir(10, 0);
    return 0;
}
```

> **Bibliotecas C Populares:** Para projetos maiores, bibliotecas gratuitas como [`log.c`](https://github.com/rxi/log.c) (leve, arquivo único) ou [`zlog`](https://github.com/HardySimpson/zlog) (alta performance com rotação de arquivos) são amplamente adotadas.

---

##### 2. Logging em Python: O Módulo Nativo `logging`
O Python inclui um subsistema completo e poderoso de logging diretamente na biblioteca padrão (não requer `pip install`). Considere o script `faturamento.py`:

```python
import logging

# Configuração global inicial do formato e nível mínimo:
logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s [%(levelname)-7s] (%(filename)s:%(lineno)d): %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)

# Criação de um logger nomeado para o módulo:
logger = logging.getLogger("ModServico")

def calcular_desconto(preco: float, percentual: float) -> float:
    logger.debug("Calculando desconto: preco=%.2f, perc=%.2f", preco, percentual)
    if percentual > 50:
        logger.warning("Desconto atipicamente alto aplicado: %.2f%%", percentual)
    if percentual < 0:
        logger.error("Percentual negativo invalido: %.2f", percentual)
        raise ValueError("Percentual invalido")
    return preco * (1 - percentual / 100)

if __name__ == "__main__":
    logger.info("Sistema de faturamento inicializado.")
    calcular_desconto(100.0, 15.0)
    calcular_desconto(200.0, 60.0)
```

> **Biblioteca Moderna em Python:** A biblioteca [`loguru`](https://github.com/Delgan/loguru) (`pip install loguru`) é famosa pela simplicidade com "configuração zero", suporte nativo a cores no terminal, rotação automática de arquivos de log (`rotation="10 MB"`) e captura de rastreamento completo de exceções com valores de variáveis locais (*pretty tracebacks*).

---

##### 3. Logging em Java: SLF4J e Logback
No ecossistema Java moderno, adota-se o padrão de separar a **Interface (*Façade*)** do **Mecanismo de Execução (*Engine*)**:
- **`SLF4J` (*Simple Logging Facade for Java*):** É a interface universal que suas classes importam. Permite escrever código sem amarrá-lo a uma biblioteca de log proprietária.
- **`Logback` (ou `Log4j2`):** É a engine que recebe as mensagens do SLF4J, formata com datas/threads e grava no console ou arquivos com rotação (o Logback é o padrão oficial do ecossistema Spring Boot).

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PedidoController {
    // Instancia o logger vinculado à classe atual:
    private static final Logger logger = LoggerFactory.getLogger(PedidoController.class);

    public void processarPedido(String idCliente, double total) {
        // O SLF4J utiliza marcadores '{}' parametrizados:
        // VANTAGEM: Não gasta CPU concatenando strings se o nível DEBUG estiver desligado!
        logger.debug("Recebido pedido do cliente {} no valor de R${}", idCliente, total);

        if (total <= 0) {
            logger.warn("Tentativa de pedido com valor zerado/negativo para cliente: {}", idCliente);
            return;
        }

        try {
            // Lógica de persistência e pagamento...
            logger.info("Pedido para cliente {} confirmado com sucesso.", idCliente);
        } catch (Exception e) {
            // Ao passar a exceção 'e' no final, o SLF4J imprime automaticamente o Stack Trace completo:
            logger.error("Falha critica ao registrar pedido para cliente {}: {}", idCliente, e.getMessage(), e);
        }
    }
}
```

> **Vantagem de Performance em Java:** Ao usar `logger.debug("Valor: {}", x)`, a string só é construída se o nível `DEBUG` estiver realmente ativo no `logback.xml`. Usar concatenação direta (`"Valor: " + x`) força a criação de objetos na memória RAM mesmo quando o log está desligado!

---

#### D. Consumindo os Logs: Da Inspeção Visual às Ferramentas de Análise

Gerar logs é só metade do trabalho. O valor aparece quando conseguimos **encontrar rapidamente a informação certa** no meio de milhares de linhas. Na prática, o profissional usa estratégias diferentes conforme o tamanho do sistema:

##### 1. Linha de comando: o kit básico (projetos locais e servidores únicos)
Como os logs são texto, as ferramentas dos Módulos 01 e 02 já resolvem boa parte dos casos. Usando o exemplo em Python acima (o `logging` escreve em `stderr` por padrão):

```bash
# Redireciona os logs (stderr) para um arquivo:
$ python3 faturamento.py 2> app.log

# Acompanha o arquivo em tempo real enquanto a aplicação roda:
$ tail -f app.log

# Filtra apenas avisos e erros:
$ grep -E "WARNING|ERROR" app.log

# Conta quantas mensagens existem de cada nível:
$ grep -oE "\[(DEBUG|INFO|WARNING|ERROR|CRITICAL)" app.log | sort | uniq -c

# Serviços do sistema (systemd): logs de um serviço, só de nível warning ou mais grave:
$ journalctl -u nginx -p warning -f
```

##### 2. Logs estruturados em JSON + `jq`
Em vez de texto livre, cada linha de log pode ser um objeto JSON. Assim, os logs são lidos por programas sem precisar de expressões regulares frágeis:

```json
{"ts": "2026-10-18T14:02:11", "level": "ERROR", "logger": "ModServico", "msg": "Percentual negativo invalido", "percentual": -5}
```

- **Python:** `loguru` com `serialize=True`, ou a biblioteca `python-json-logger`.
- **Java:** `logstash-logback-encoder` no `logback.xml`.

Com a ferramenta [`jq`](https://jqlang.github.io/jq/), consultamos esses logs como se fossem um banco de dados:

```bash
# Somente os erros, mostrando data e mensagem:
$ jq -r 'select(.level == "ERROR") | "\(.ts) \(.msg)"' app.json
```

##### 3. Visualizadores de log no terminal: `lnav`
O [`lnav`](https://lnav.org) (*Log File Navigator*, gratuito) detecta automaticamente o formato dos logs, colore os níveis, junta vários arquivos em ordem cronológica, permite pular de erro em erro e até aceita consultas SQL sobre as linhas:

```bash
$ sudo apt install lnav
$ lnav app.log /var/log/syslog
```

##### 4. Centralização em produção: sistemas distribuídos
Quando há dezenas de servidores ou contêineres, entrar em cada máquina para dar `grep` se torna inviável. Os logs passam a ser **enviados para um servidor central**, que indexa, permite buscas e gera painéis e alertas:

| Solução (gratuita / open source) | Componentes | Destaque |
| :--- | :--- | :--- |
| **Elastic Stack (ELK)** / **OpenSearch** | Elasticsearch + Logstash/Beats + Kibana | Busca textual poderosa e painéis ricos; o padrão de mercado por muitos anos. |
| **Grafana Loki** | Loki + Promtail/Alloy + Grafana | Mais leve: indexa só os metadados (rótulos), e não o texto completo. |
| **Graylog** | Graylog + OpenSearch | Interface pronta, focada em logs, com alertas simples de configurar. |

> **Dica profissional, o ID de correlação:** em sistemas com várias etapas (API → serviço → banco), inclua em **todas** as mensagens um identificador único da requisição (`request_id`). Quando um usuário relatar um erro, uma busca por esse ID mostra toda a história daquela requisição, mesmo que ela tenha passado por vários servidores.

---

### 2. Abordagens de Profiling e o que são Flame Graphs

Existem duas metodologias principais para medir o comportamento de um programa, além de uma terceira, mais especializada:

1. **Instrumentação (*Tracing*):** Modifica o código-fonte ou binário inserindo ganchos (*hooks*) no início e fim de cada função para contar chamadas e medir tempos.  
   - *Vantagem:* Medição exata de 100% das chamadas de função.  
   - *Desvantagem:* **Alto overhead** (pode desacelerar o programa em 5x a 50x), distorcendo as medições de tempo real.
2. **Amostragem (*Sampling*):** O profiler interrompe o programa centenas de vezes por segundo (ex.: a cada 10 milissegundos), anota qual função e linha estavam rodando naquele instante (*stack trace*) e retoma a execução imediatamente.  
   - *Vantagem:* **Overhead quase nulo** (< 1% a 2%), sendo seguro para rodar até mesmo em servidores de produção.
3. **Instrumentação Dinâmica de Binário (*Emulação*):** o programa não é recompilado nem modificado. Em vez disso, roda sobre um processador virtual que traduz cada instrução de máquina em tempo de execução e insere verificações nela. É o que o **Valgrind** faz.  
   - *Vantagem:* enxerga **cada acesso à memória** e cada instrução executada. Detecta vazamentos, leituras de memória não inicializada e acessos fora dos limites, e conta instruções de forma determinística (o resultado é o mesmo a cada execução).  
   - *Desvantagem:* **overhead muito alto** (de 10× a 50× mais lento, ou mais), o que restringe o uso a ambientes de desenvolvimento e teste.

#### O que é um Flame Graph (Gráfico de Chama)?
Criado pelo especialista em desempenho Brendan Gregg, o **Flame Graph** tornou-se o padrão mundial da indústria para visualizar perfis de execução:

- **Eixo X (Largura):** Representa a proporção do tempo de CPU em que a função estava na pilha, ou seja, o tempo *inclusivo* (a própria função somada a tudo o que ela chama). A ordem horizontal é alfabética (não cronológica).
- **Eixo Y (Altura):** Representa a profundidade da pilha de chamadas (*call stack*). A função `main()` fica na base; conforme funções chamam subfunções, os blocos sobem.
- **Onde está o gargalo?** Não basta procurar o bloco mais largo (a `main()` sempre ocupa 100%!). O gargalo está nos **"platôs" do topo**: blocos largos **sem nenhuma outra função empilhada acima deles**. Essa faixa livre é o tempo gasto na própria função (*self time*). Na figura abaixo, `parse_json()` ocupa 45% da largura, mas quase tudo isso é tempo de `regex_match()`, que está acima dela: o verdadeiro gargalo é `regex_match()`.  
  > Essa distinção reaparece no `cProfile` (Seção 4): a largura total corresponde à coluna `cumtime`, e o platô do topo corresponde à coluna `tottime`.

[![Ecossistema de Profiling e Anatomia de um Flame Graph (clique para ampliar)](img/linux-profiling-flamegraph.svg)](img/linux-profiling-flamegraph.svg)

---

### 3. Profiling e Análise de Desempenho em C / C++

Programas compilados em C e C++ rodam diretamente sobre a CPU e gerenciam memória manualmente, exigindo ferramentas que conversem diretamente com o kernel e a arquitetura do processador.

#### A. `perf` (Linux Performance Events)
O **`perf`** é o profiler oficial embutido no próprio kernel do Linux. Ele utiliza os contadores de desempenho de hardware do processador (*Hardware PMU*), permitindo investigar ciclos de CPU, instruções executadas, falhas de cache (*cache misses*) e previsões de desvio (*branch misses*).

##### Código de Exemplo (`processamento.c`):

Para ilustrar o profiling com o `perf`, utilizaremos o seguinte programa em C composto por duas rotinas: uma leve (`funcao_rapida`) e outra deliberadamente computacionalmente intensiva com laço aninhado e funções trigonométricas (`funcao_lenta_gargalo`), que se tornará o gargalo evidente:

```c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Função rápida: executa poucas iterações simples (baixo consumo de CPU)
void funcao_rapida(int n) {
    volatile double soma = 0.0;
    for (int i = 0; i < n; i++) {
        soma += i * 0.5;
    }
}

// Função lenta: contém operações matemáticas intensivas e laço aninhado.
// Este será o hotspot (> 95% do tempo de CPU) que o profiler irá apontar!
void funcao_lenta_gargalo(int n) {
    volatile double soma = 0.0;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < 2000; j++) {
            soma += sin((double)i) * cos((double)j);
        }
    }
}

int main(void) {
    printf("Iniciando processamento para análise de profiling...\n");

    // Executando ambas as funções:
    funcao_rapida(100000);
    funcao_lenta_gargalo(20000);

    printf("Processamento concluído com sucesso!\n");
    return 0;
}
```

> **Nota técnica:** A palavra-chave `volatile` é utilizada na variável `soma` para garantir que o otimizador do compilador GCC (`-O2`) não descarte o laço matemático da versão final compilada.

##### Passo a Passo com `perf`:

```bash
# 1. Compile o código com otimizações (-O2), símbolos de debug (-g),
# ponteiros de frame explícitos e ligando a biblioteca matemática (-lm):
$ gcc -O2 -g -fno-omit-frame-pointer processamento.c -lm -o processamento

# 2. Estatísticas rápidas de hardware com 'perf stat':
$ perf stat ./processamento
 Performance counter stats for './processamento':

          2.415,82 msec task-clock                       #    0,998 CPUs utilized
                35      context-switches                 #   14,488 /sec
                 2      cpu-migrations                   #    0,828 /sec
             1.250      page-faults                      #  517,422 /sec
     8.420.150.320      cycles                           #    3,485 GHz
    12.630.225.480      instructions                     #    1,50  insn per cycle
       850.120.400      branches                         #  351,897 M/sec
        12.450.100      branch-misses                    #    1,46% of all branches

       2,420155021 seconds time elapsed

# 3. Gravar a amostragem de chamadas a 99 Hz com 'perf record':
$ perf record -F 99 -g ./processamento
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.420 MB perf.data (5120 samples) ]

# 4. Inspecionar o relatório interativo de CPU com 'perf report':
$ perf report
```
Na tela interativa do `perf report`, você verá as funções ranqueadas pela porcentagem de tempo na CPU, podendo teclar Enter para inspecionar o código assembly com as instruções mais quentes destacadas.

---

#### B. `Valgrind` (Memcheck & Callgrind)
O **`Valgrind`** executa seu programa dentro de um processador virtual simulado, interceptando todas as alocações de memória (`malloc`, `free`, `new`, `delete`).

##### 1. Caçando Vazamentos de Memória (*Memory Leaks*) com `Memcheck`:

Considere o código com erro comum em C (`vazamento.c`):
```c
#include <stdlib.h>

void funcao_com_vazamento() {
    int *array = malloc(1000 * sizeof(int)); // Alocou 4000 bytes
    array[0] = 42;
    // Esqueceu de chamar free(array)!
}

int main() {
    funcao_com_vazamento();
    return 0;
}
```

Ao compilar com `gcc -g vazamento.c -o vazamento` e rodar sob o Valgrind:

```bash
$ valgrind --leak-check=full --show-leak-kinds=all ./vazamento
==35120== Memcheck, a memory error detector
==35120== Command: ./vazamento
==35120== 
==35120== HEAP SUMMARY:
==35120==     in use at exit: 4,000 bytes in 1 blocks
==35120==   total heap usage: 1 allocs, 0 frees, 4,000 bytes allocated
==35120== 
==35120== 4,000 bytes in 1 blocks are definitely lost in loss record 1 of 1
==35120==    at 0x4848899: malloc (vg_replace_malloc.c:431)
==35120==    by 0x10915E: funcao_com_vazamento (vazamento.c:4)
==35120==    by 0x10917D: main (vazamento.c:10)
==35120== 
==35120== LEAK SUMMARY:
==35120==    definitely lost: 4,000 bytes in 1 blocks
```
O Valgrind indica exatamente **qual função e qual linha** (`vazamento.c:4`) alocou a memória esquecida!

##### 2. Mapeamento de Chamadas com `Callgrind`:

O **Callgrind** é a ferramenta do Valgrind que conta **quantas instruções de máquina** cada função executou (evento `Ir`, de *Instructions read*) e registra **quem chamou quem**. Como o programa roda no processador virtual do Valgrind, a medição é **determinística**: a mesma entrada produz exatamente os mesmos números em todas as execuções, o que torna o Callgrind ótimo para comparar o "antes e depois" de uma otimização.

```bash
# Grava a contagem de instruções por função (muito mais lento que a execução normal!):
$ valgrind --tool=callgrind ./processamento
==1692== Events    : Ir
==1692== Collected : 4383710533
==1692==
==1692== I   refs:      4,383,710,533
```

> **Atenção ao overhead:** nesta medição, o `processamento` levou **0,67 s** rodando normalmente e cerca de **1 min 30 s** sob o Callgrind, **mais de 100× mais lento**. Para experimentos em sala, reduza o tamanho da entrada.

O resultado é gravado no arquivo `callgrind.out.<PID>` (aqui, `callgrind.out.1692`), que pode ser analisado de duas formas.

**A. No terminal, com `callgrind_annotate`** (vem junto com o Valgrind e dispensa interface gráfica):

```bash
$ callgrind_annotate callgrind.out.1692
--------------------------------------------------------------------------------
Ir                      file:function
--------------------------------------------------------------------------------
3,540,920,000 (80.77%)  ./math/../sysdeps/ieee754/dbl-64/s_sin.c:__cos_fma [/usr/lib/x86_64-linux-gnu/libm.so.6]
  440,060,020 (10.04%)  processamento.c:funcao_lenta_gargalo [/tmp/cg/processamento]
  399,800,000 ( 9.12%)  ./math/../sysdeps/x86/fpu/fenv_private.h:__cos_fma
```

Por padrão, a lista é ordenada pelo custo **próprio** (*Self*) de cada função. A opção `--auto=yes` mostra também o custo **linha a linha** do código-fonte, incluindo as chamadas feitas em cada linha:

```text
119,980,000 ( 2.74%)          for (int j = 0; j < 2000; j++) {
320,020,002 ( 7.30%)              soma += sin((double)i) * cos((double)j);
3,940,720,000 (89.89%)  => ./math/../sysdeps/ieee754/dbl-64/s_sin.c:__cos_fma (39,980,000x)
  1,889,803 ( 0.04%)  => ./math/../sysdeps/ieee754/dbl-64/s_sin.c:__sin_fma (19,999x)
```

**B. Graficamente, com o KCachegrind** (`sudo apt install kcachegrind`; no Windows e no macOS existe a versão **QCachegrind**):

```bash
$ kcachegrind callgrind.out.1692
```

[![KCachegrind: lendo o perfil do processamento.c (clique para ampliar)](img/linux-kcachegrind.svg)](img/linux-kcachegrind.svg)

##### Interpretando o resultado:

1. **Incl. alto, Self baixo = o custo está nas funções chamadas.** `funcao_lenta_gargalo` responde por 99,98% das instruções (inclusivo), mas apenas 10,04% são do código dela mesma (o laço e a multiplicação). É a mesma distinção entre largura e platô do flame graph (Seção 2).
2. **O gargalo real é `cos()`:** a função da biblioteca matemática (`__cos_fma`, da `libm`) concentra **89,89%** de todas as instruções, em **39.980.000 chamadas**. Mas `cos((double)j)` só depende de `j`, que assume apenas **2.000 valores distintos**: o programa recalcula os mesmos 2.000 cossenos 20 mil vezes!
3. **Uma surpresa revelada pelo profiler: `sin()` quase não custa.** `sin((double)i)` também está no laço interno, mas foi chamada só 19.999 vezes, e não 40 milhões. Como o valor não muda dentro do laço em `j`, o próprio GCC (`-O2`) **moveu o cálculo para fora do laço interno**. As contagens também mostram que o compilador resolveu sozinho os casos triviais `sin(0)` e `cos(0)`, por isso aparecem 19.999 e 39.980.000, e não 20.000 e 40.000.000. *Moral: o código-fonte nem sempre é o que executa; só a medição revela o que realmente acontece.*

##### Do diagnóstico à otimização:

Com o diagnóstico em mãos, a correção é direta: calcular os 2.000 cossenos **uma única vez**, em uma tabela, antes dos laços:

```c
void funcao_lenta_otimizada(int n) {
    volatile double soma = 0.0;
    double tab_cos[2000];
    for (int j = 0; j < 2000; j++)          // 2.000 chamadas a cos(), em vez de ~40 milhões
        tab_cos[j] = cos((double)j);
    for (int i = 0; i < n; i++) {
        double s = sin((double)i);
        for (int j = 0; j < 2000; j++)
            soma += s * tab_cos[j];
    }
}
```

Na mesma máquina, o tempo caiu de **0,63 s para 0,13 s** (cerca de **5× mais rápido**), com uma mudança de poucas linhas, exatamente no ponto que o profiler apontou.

---

### 4. Profiling e Diagnóstico em Python

Por ser uma linguagem interpretada e de tipagem dinâmica, o Python possui ferramentas especializadas para medir chamadas, consumo de CPU e alocação de objetos.

#### A. `cProfile` (Biblioteca Padrão)
O `cProfile` vem pré-instalado em qualquer instalação do Python. Ele é ideal para uma primeira análise sem precisar baixar nenhum pacote externo:

Considere o script `teste_gargalo.py`:
```python
import time

def processamento_rapido():
    return sum(i * 2 for i in range(100_000))

def processamento_lento():
    total = 0
    # Gargalo: concatenação lenta de strings em loop
    resultado = ""
    for i in range(20_000):
        resultado += str(i)
    return len(resultado)

def main():
    processamento_rapido()
    processamento_lento()

if __name__ == "__main__":
    main()
```

Rode o script através do módulo `cProfile`, ordenando pelo tempo gasto exclusivamente na função (`tottime`):

```bash
$ python3 -m cProfile -s tottime teste_gargalo.py | head -n 15
   Ordered by: internal time

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
        1    0.142    0.142    0.142    0.142 teste_gargalo.py:6(processamento_lento)
        1    0.015    0.015    0.015    0.015 teste_gargalo.py:3(processamento_rapido)
    20000    0.008    0.000    0.008    0.000 {built-in method builtins.len}
        1    0.000    0.000    0.157    0.157 teste_gargalo.py:14(main)
        1    0.000    0.000    0.157    0.157 teste_gargalo.py:1(<module>)
```

##### Decodificando as Colunas do `cProfile`:
- **`ncalls`**: Quantas vezes a função foi chamada.
- **`tottime`**: Tempo total gasto exclusivamente no corpo dessa função (sem contar chamadas a subfunções).
- **`cumtime`**: Tempo acumulado (incluindo todas as funções filhas chamadas por ela).
- O relatório mostra imediatamente que `processamento_lento` responde por mais de 90% do tempo!

---

#### B. `py-spy` (Sampling Profiler com Flame Graphs)
O **`py-spy`** é um profiler moderno escrito em Rust. Sua grande vantagem é ler o estado da pilha de execução da memória do processo Python externamente, **sem modificar o interpretador e sem desacelerar o código**.

```bash
# Instalação:
$ pip install py-spy

# 1. Visualização ao vivo tipo 'top' de um script ou processo Python ativo:
$ py-spy top -- python3 meu_app.py
# Ou monitorando um processo já rodando pelo PID:
$ py-spy top --pid 4520

# 2. Gerar diretamente um Flame Graph interativo em SVG:
$ py-spy record -o perfil_execucao.svg -- python3 meu_app.py
```
O arquivo `perfil_execucao.svg` gerado pode ser aberto em qualquer navegador, permitindo clicar nos blocos para dar zoom nas funções mais lentas!

---

#### C. `line_profiler` (Análise Linha a Linha)
Quando você já identificou qual função é lenta e precisa saber exatamente **qual linha dentro dela** é a culpada:

```bash
$ pip install line_profiler
```
Basta colocar o decorador `@profile` sobre a função desejada e rodar com `kernprof`:
```bash
$ kernprof -l -v script.py
```
O relatório exibirá a porcentagem exata de tempo consumida por cada linha do código.

---

### 5. Profiling e Diagnóstico em Java (JVM)

A Máquina Virtual Java (JVM) gerencia compilação JIT (*Just-In-Time*), alocação dinâmica e coleta de lixo (*Garbage Collection*). Por isso, as ferramentas de diagnóstico Java analisam tanto o código da aplicação quanto o comportamento da própria JVM.

#### A. `JDK Flight Recorder (JFR)` e `JDK Mission Control (JMC)`
Antigo recurso proprietário da Oracle, o **JFR** foi aberto e integrado diretamente ao OpenJDK moderno. Trata-se do profiler mais avançado do ecossistema Java, projetado para operar continuamente com **menos de 1% de overhead**:

```bash
# Iniciar a aplicação gravando 60 segundos de telemetria completa em um arquivo .jfr:
$ java -XX:StartFlightRecording=duration=60s,filename=diagnostico.jfr,settings=profile -jar minha_aplicacao.jar
```

O arquivo `diagnostico.jfr` armazena:
- Métricas detalhadas de CPU por método Java;
- Todas as pausas e coletas do Garbage Collector;
- Contenção de locks e threads bloqueadas aguardando sincronização;
- Estatísticas de I/O de rede e arquivos.

Para visualizar, basta baixar a ferramenta gráfica gratuita **JDK Mission Control (JMC)** (disponível pelo pacote `openjdk-jmc` ou pelo site oficial).

---

#### B. `VisualVM` (Interface Gráfica Completa)
O **`VisualVM`** é o canivete suíço visual da comunidade Java. Ele detecta automaticamente qualquer processo Java rodando na máquina:

```bash
# Debian/Ubuntu: sudo apt install visualvm
$ visualvm
```

##### Principais Recursos do VisualVM:
- **Painel Monitor:** Gráficos em tempo real de uso de CPU, Heap de memória RAM, número de Classes carregadas e contagem de Threads vivas.
- **Sampler / Profiler:** Medição estatística de tempo de CPU por método e análise de memória alocada por tipo de objeto.
- **Heap Dump:** Fotografia da memória RAM para caçar *Memory Leaks* em Java (objetos que deveriam ter sido coletados pelo GC mas continuam retidos por referências estáticas).

---

#### C. `async-profiler` (O Profiler de Amostragem Preferido da Indústria)
Profilers tradicionais de Java sofrem de um problema chamado *Safepoint Bias* (a JVM só consegue inspecionar threads quando elas atingem pontos seguros, gerando relatórios distorcidos).

O **`async-profiler`** (código aberto, mantido pela comunidade e adotado por empresas como Netflix e Google) contorna essa limitação usando `AsyncGetCallTrace` e contadores de hardware do Linux `perf`:

```bash
# Baixe a versão compilada do async-profiler:
# https://github.com/async-profiler/async-profiler

# Descubra o PID da aplicação Java:
$ jps -v

# Dispara a amostragem durante 30 segundos e gera diretamente um Flame Graph em HTML:
$ ./asprof -d 30 -f flamegraph_java.html 34120
```

Abra o arquivo `flamegraph_java.html` no navegador para interagir com a árvore de chamadas da sua aplicação Java em alta resolução.

---

#### D. Ferramentas de Linha de Comando Nativas do JDK
Mesmo sem interface gráfica em servidores de nuvem, o JDK disponibiliza utilitários de diagnóstico rápidos via terminal:

```bash
# 1. 'jps': Listar processos Java ativos e seus PIDs
$ jps -l
12400 org.apache.catalina.startup.Bootstrap
34120 com.minhaempresa.AppSpring

# 2. 'jstack': Capturar um Thread Dump instantâneo
# Essencial para descobrir se uma aplicação travou por Deadlock!
$ jstack 34120 > threads.tdump

# 3. 'jstat': Acompanhar o comportamento do Garbage Collector a cada 1 segundo (1000ms):
$ jstat -gcutil 34120 1000
  S0     S1     E      O      M     CCS    YGC     YGCT    FGC    FGCT    CGC    CGCT     GCT   
  0.00 100.00  42.50  68.10  95.40  92.10     14    0.120     1    0.080     4    0.020    0.220

# 4. 'jcmd': Executar comandos de diagnóstico internos na JVM
$ jcmd 34120 GC.heap_info
```

---

### 6. Resumo Comparativo: Qual Ferramenta Escolher?

| Linguagem | Ferramenta | Tipo | Overhead | Caso de Uso Principal |
| :--- | :--- | :---: | :---: | :--- |
| **C / C++** | **`perf`** | Amostragem | Quase nulo (<1%) | Gargalos de CPU, ciclos de clock, falhas de cache de hardware no Linux. |
| **C / C++** | **`Valgrind (Memcheck)`** | Emulação | Alto (~10x a 50x) | Detecção cirúrgica de vazamentos de memória (*memory leaks*) e corrupção de ponteiros. |
| **C / C++** | **`Valgrind (Callgrind)`** | Emulação | Muito alto (~100x ou mais) | Contagem exata de instruções por função, visualizada no KCachegrind. |
| **Python** | **`cProfile`** | Tracing | Baixo a médio | Profiler rápido embutido na biblioteca padrão; dispensa instalações extras. |
| **Python** | **`py-spy`** | Amostragem | Quase nulo (<1%) | Seguro em produção; gera Flame Graphs interativos em SVG e tem modo `top` ao vivo. |
| **Python** | **`line_profiler`** | Tracing (linha a linha) | Médio | Diagnóstico linha a linha quando o método gargalo já foi localizado. |
| **Java** | **`JFR + JMC`** | Amostragem | Mínimo (<1%) | Profiler oficial do OpenJDK para CPU, Garbage Collector, I/O e contenção de threads. |
| **Java** | **`VisualVM`** | Amostragem / Tracing | Baixo a médio | Ambiente de desenvolvimento local com monitor de Heap, GC e inspeção de Threads. |
| **Java** | **`async-profiler`** | Amostragem | Quase nulo (<1%) | Geração de Flame Graphs de alta fidelidade sem viés de safepoints. |

---

<p class="nav-footer" style="display: flex; justify-content: space-between; align-items: center; max-width: 650px; margin: 3rem auto 1.5rem auto;">
  <a href="04_automacao_shell_scripting.html" class="module-btn secondary">← Módulo 04: Shell Scripting</a>
  <a href="index.html" class="module-btn secondary">Índice</a>
  <a href="06_git_colaborativo.html" class="module-btn">Próximo: Módulo 06 (Git) →</a>
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
