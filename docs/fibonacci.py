import time

def fibonacci(n: int):
    if n <= 0:
        return 0
    elif n == 1:
        return 1
    else:
        return fibonacci(n-1) + fibonacci(n-2)

def main():

    for n in range(2,40):
        start_time = time.time()
        result = fibonacci(n)
        end_time = time.time()
        print(f"Resultado de Fibonacci: {result}")
        print(f"Tempo: {end_time - start_time:.2f} segundos")

if __name__ == "__main__":
    main()
