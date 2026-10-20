import json
import hashlib
import re
import time
import random

# 1. Simulação: gera registros brutos em JSON
def gerar_dados_brutos(qtd=20000):
    ips = [f"192.168.1.{i}" for i in range(1, 255)]
    metodos = ["GET", "POST", "PUT", "DELETE"]
    rotas = ["/api/login", "/api/checkout", "/home", "/static/css"]
    
    logs = []
    for _ in range(qtd):
        registro = {
            "ip": random.choice(ips),
            "metodo": random.choice(metodos),
            "url": random.choice(rotas),
            "status": random.choice([200, 201, 400, 403, 500]),
            "timestamp": time.time()
        }
        logs.append(json.dumps(registro))
    return logs

# Ramo 1: Ingestão, Desserialização e Regex
def parse_e_validacao(logs_raw):
    padrao_ip = re.compile(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$")
    registros = []
    for raw in logs_raw:
        item = json.loads(raw)
        if padrao_ip.match(item["ip"]):
            registros.append(item)
    return registros

# Ramo 2: Criptografia e Hashing SHA-256
def auditoria_hashes(registros):
    hashes = []
    for reg in registros:
        conteudo = f"{reg['timestamp']}:{reg['ip']}:{reg['url']}".encode('utf-8')
        hashes.append(hashlib.sha256(conteudo).hexdigest())
    return hashes

# Ramo 3: GARGALO DIDÁTICO (Busca linear em Lista O(N))
def verificar_blacklist(registros):
    # Propositalmente mantido como lista para gerar gargalo de busca linear
    ips_bloqueados = [f"192.168.1.{i}" for i in range(100, 160)]
    suspeitos = []
    for reg in registros:
        if reg["ip"] in ips_bloqueados:  # Custo O(N) repetido a cada registro!
            suspeitos.append(reg)
    return suspeitos

# Ramo 4: Ordenação e Agregações Estatísticas
def gerar_estatisticas(registros):
    ordenados = sorted(registros, key=lambda x: (x["status"], x["url"]))
    contadores = {}
    for r in ordenados:
        s = r["status"]
        contadores[s] = contadores.get(s, 0) + 1
    return contadores

def main():
    print("Iniciando pipeline de análise de logs...")
    for _ in range(3):
        dados_brutos = gerar_dados_brutos(15000)
        registros = parse_e_validacao(dados_brutos)
        hashes = auditoria_hashes(registros)
        bloqueados = verificar_blacklist(registros)
        stats = gerar_estatisticas(registros)
    print("Pipeline finalizado com sucesso!")

if __name__ == "__main__":
    main()
