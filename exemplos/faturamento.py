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
