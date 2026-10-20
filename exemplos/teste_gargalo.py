import time

def processamento_rapido():
    return sum(i * 2 for i in range(100_000_000))

def processamento_lento():
    total = 0
    # Gargalo: concatenação lenta de strings em loop
    resultado = ""
    for i in range(20_000_000):
        resultado += str(i)
    return len(resultado)

def main():
    processamento_rapido()
    processamento_lento()

if __name__ == "__main__":
    main()
