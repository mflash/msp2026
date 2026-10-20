import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * Exemplo prático para demonstração do JDK Flight Recorder (JFR)
 * e análise com JDK Mission Control (JMC).
 *
 * Simula três cenários comuns de diagnóstico de desempenho:
 *  1. CPU Hotspot: cálculo matemático intensivo em laço (Method Profiling).
 *  2. Pressão de Alocação e GC: geração contínua de objetos temporários (TLAB e Garbage Collection).
 *  3. Contenção de Locks (Thread Contention): múltiplas threads disputando um monitor sincronizado.
 */
public class ExemploJFR {

    private static final Object MONITOR_LOCK = new Object();
    private static long contadorCompartilhado = 0;

    public static void main(String[] args) throws InterruptedException {
        System.out.println("=== Iniciando ExemploJFR para Diagnóstico com Flight Recorder ===");
        System.out.println("PID do processo Java: " + ProcessHandle.current().pid());
        System.out.println("Simulação em andamento por 20 segundos. Pressione Ctrl+C se quiser interromper antes...\n");

        long tempoFim = System.currentTimeMillis() + 20_000; // 20 segundos
        ExecutorService executor = Executors.newFixedThreadPool(4);

        // Threads concorrentes para gerar contenção no lock sincronizado
        for (int i = 0; i < 3; i++) {
            executor.submit(() -> {
                while (System.currentTimeMillis() < tempoFim) {
                    simularContencaoDeLock();
                }
            });
        }

        // Loop principal: executa trabalho de CPU e alocação intensa de objetos
        int iteracao = 1;
        while (System.currentTimeMillis() < tempoFim) {
            System.out.printf("[Ciclo %02d] Processando CPU e alocando memória temporária...%n", iteracao++);

            // 1. Hotspot de CPU: laço numérico intensivo
            processamentoIntensivoCpu(200_000);

            // 2. Pressão de alocação de memória (ativa eventos de TLAB e coletas de GC)
            pressaoAlocacaoMemoria(100_000);

            Thread.sleep(50);
        }

        executor.shutdown();
        executor.awaitTermination(5, TimeUnit.SECONDS);

        System.out.println("\n=== Execução concluída! Gravação do JFR pronta para análise. ===");
    }

    /**
     * Hotspot de CPU: o JFR colherá amostras de pilha (Execution Profiling)
     * identificando este método no topo da lista "Hot Methods".
     */
    private static void processamentoIntensivoCpu(int n) {
        double total = 1.0;
        for (int i = 0; i < n; i++) {
            total += Math.sin(i) * Math.cos(total);
        }
    }

    /**
     * Pressão no Garbage Collector: cria listas e matrizes de curta duração.
     * No JMC, aparecerá na aba 'Memory' -> 'Allocation in new TLAB' e registrará eventos de GC.
     */
    private static void pressaoAlocacaoMemoria(int quantidade) {
        List<byte[]> listaTemporaria = new ArrayList<>();
        for (int i = 0; i < 50; i++) {
            // Blocos de 64 KB alocados e descartados rapidamente
            listaTemporaria.add(new byte[64 * 1024]);
        }
    }

    /**
     * Contenção de Threads: múltiplas threads disputam o mesmo monitor.
     * Como a seção crítica retém o lock por tempo mensurável (~15ms), o JFR
     * registra eventos 'jdk.JavaMonitorEnter' na aba 'Lock Instances' do JMC.
     */
    private static void simularContencaoDeLock() {
        synchronized (MONITOR_LOCK) {
            contadorCompartilhado++;
            try {
                // Simula latência dentro da seção crítica
                Thread.sleep(15);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
}
