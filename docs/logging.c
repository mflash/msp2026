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
