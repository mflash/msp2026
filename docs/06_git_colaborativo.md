# 06. Git e Controle de Versão: Filosofia, Fundamentos e Trabalho Colaborativo

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
*Módulo 06 — Sistemas de Controle de Versão Distribuídos, os Três Estados, Branches e Fluxos em Equipe*

---

### Origem e Filosofia do Git

Em 2005, a comunidade de desenvolvedores do kernel Linux enfrentou uma crise: a ferramenta proprietária que utilizavam para versionar o código (BitKeeper) revogou o acesso gratuito. Insatisfeito com as alternativas centralizadas existentes na época (como CVS e SVN), **Linus Torvalds** decidiu tirar duas semanas de férias para programar seu próprio sistema de controle de versão: nascia o **Git**.

O Git foi desenhado a partir de princípios fundamentais que revolucionaram a engenharia de software:

#### 1. Totalmente Distribuído (*DVCS*):
Em sistemas centralizados tradicionais (como o SVN), existe um servidor central único onde fica o histórico. Se a rede cair ou o servidor queimar, ninguém consegue commitar ou consultar versões passadas.  
No Git, **todo clone é um repositório completo e independente**. Você possui o histórico integral de todos os arquivos e branches da história do projeto diretamente no seu computador local, podendo commitar, criar branches e inspecionar logs offline no avião ou sem internet.

#### 2. Snapshots, Não Listas de Diferenças (*Deltas*):
Sistemas antigos gravavam versões como um arquivo base seguido por uma lista de alterações incrementais linha por linha (*deltas*). O Git enxerga seus dados como um conjunto de **fotografias instantâneas (*snapshots*)** de todo o projeto a cada commit. Se um arquivo não foi modificado em um novo commit, o Git não gasta espaço duplicado: ele simplesmente armazena um ponteiro ultrarrápido para a versão idêntica já guardada anteriormente.

#### 3. Integridade Criptográfica com Hashes SHA:
Tudo no Git é identificado por uma assinatura criptográfica exclusiva (originalmente SHA-1 com 40 caracteres hexadecimais, evoluindo para SHA-256). É matematicamente impossível alterar o conteúdo de um arquivo antigo ou a mensagem de um commit passado sem que o hash de todos os commits subsequentes se rompa.

#### 4. O Diretório Mágico `.git`:
Toda a base de dados, objetos, configurações e histórico do projeto ficam armazenados dentro de uma única pasta oculta chamada **`.git/`** na raiz do seu projeto. Se você quiser desvincular um projeto do Git, basta deletar a pasta `.git/`; nenhum arquivo de configuração invasivo fica espalhado pelo seu sistema operacional.

[![As Quatro Áreas do Git e o Fluxo de Trabalho Colaborativo (clique para ampliar)](img/linux-git-workflow.svg)](img/linux-git-workflow.svg)

---

### As Quatro Áreas do Git e os Três Estados do Arquivo

Para dominar o Git, você precisa compreender a jornada que um arquivo percorre entre o seu teclado e o repositório compartilhado:

1. **Diretório de Trabalho (*Working Directory*):** A pasta física no seu computador onde você abre arquivos no VS Code ou nano, escreve código e testa compilações.
2. **Área de Preparação (*Staging Area / Index*):** Uma área intermediária onde você seleciona cirurgicamente quais modificações farão parte do próximo commit (usando `git add`). Permite quebrar grandes edições em commits atômicos e bem explicados.
3. **Repositório Local (*.git directory*):** O banco de dados local onde os commits confirmados (snapshots permanentes) ficam gravados para sempre no disco.
4. **Repositório Remoto (*Remote Repository*):** Servidores na nuvem ou rede interna (como GitHub, GitLab ou Bitbucket) onde a equipe sincroniza seus repositórios locais usando `push` e `pull`.

#### Os Três Estados Fundamentais de um Arquivo:
- **`Modified` (Modificado):** O arquivo foi alterado no Working Directory, mas suas mudanças ainda não foram marcadas para entrar no próximo commit.
- **`Staged` (Preparado):** O arquivo modificado foi adicionado à Staging Area com `git add`.
- **`Committed` (Consolidado):** O snapshot foi gravado com segurança no banco de dados local do Git com `git commit`.

---

### Configuração Inicial Essencial

Antes de criar seu primeiro commit, você deve configurar sua identidade para que os autores dos commits fiquem devidamente identificados:

```bash
# 1. Definir seu nome e e-mail público de desenvolvedor:
$ git config --global user.name "Marcelo Cohen"
$ git config --global user.email "marcelo.cohen@pucrs.br"

# 2. Definir o nome padrão do branch principal como 'main' (padrão moderno):
$ git config --global init.defaultBranch main

# 3. Conferir todas as configurações ativas:
$ git config --list
user.name=Marcelo Cohen
user.email=marcelo.cohen@pucrs.br
init.defaultBranch=main
```

---

### O Ciclo de Vida Básico no Dia a Dia

Abaixo está o fluxo fundamental executado repetidamente por todo desenvolvedor:

#### 1. Criando ou Obtendo um Repositório

```bash
# Opção A: Iniciar um novo repositório a partir de uma pasta existente:
$ mkdir meu_projeto
$ cd meu_projeto
$ git init
Initialized empty Git repository in /home/marcelo/meu_projeto/.git/

# Opção B: Baixar (clonar) um repositório existente do GitHub/GitLab:
$ git clone https://github.com/usuario/repositorio.git
```

---

#### 2. Consultando o Estado com `git status`

O comando `git status` é a bússola do Git. Use-o constantemente para saber em qual branch você está e quais arquivos foram modificados:

```bash
$ git status
On branch main
No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	main.c
	README.md

nothing added to commit but untracked files present (use "git add" to track)
```

---

#### 3. Inspecionando Diferenças com `git diff`

Antes de salvar, verifique exatamente quais linhas foram adicionadas ou removidas:

```bash
# Mostra alterações no Working Directory que ainda NÃO foram preparadas (não estão em Staging):
$ git diff

# Mostra o que JÁ está preparado na Staging Area pronto para ser commitado:
$ git diff --staged
```

---

#### 4. Preparando Alterações com `git add`

```bash
# Adiciona um arquivo específico à Staging Area:
$ git add main.c

# Adiciona todos os arquivos novos e modificados da pasta atual:
$ git add .

# Desfazer a preparação de um arquivo sem perder o código escrito:
$ git restore --staged main.c

# Descartar alterações do disco voltando ao último commit (cuidado: irreversível!):
$ git restore main.c
```

---

#### 5. Confirmando o Snapshot com `git commit`

O commit grava permanentemente na história do Git o conjunto de alterações que estavam na Staging Area:

```bash
# Grava o commit com uma mensagem concisa e explicativa:
$ git commit -m "feat: implementa rotina de calculo da funcao principal"
[main (root-commit) 4a82f1b] feat: implementa rotina de calculo da funcao principal
 2 files changed, 45 insertions(+)
 create mode 100644 README.md
 create mode 100644 main.c
```

---

#### 6. Inspecionando o Histórico com `git log`

```bash
# Histórico completo com autor, data e descrição:
$ git log

# Histórico resumido em uma linha por commit, visual e colorido:
$ git log --oneline --graph --decorate -n 10
* 4a82f1b (HEAD -> main) feat: implementa rotina de calculo da funcao principal
* 9b12c04 docs: adiciona instrucoes de compilacao no README
```

---

#### 7. O Arquivo `.gitignore`: O que NUNCA Deve Ir para o Repositório

Arquivos compilados, dependências pesadas, arquivos temporários de IDEs e senhas jamais devem ser versionados. Crie um arquivo chamado **`.gitignore`** na raiz do projeto:

```text
# Dependências e bibliotecas
node_modules/
venv/
target/

# Binários e arquivos compilados
*.o
*.class
*.exe
meu_programa

# Logs e arquivos de sistema
*.log
.DS_Store
Thumbs.db

# Credenciais e segredos (NUNCA versione senhas ou chaves privadas!)
.env
*.pem
*.key
```

---

### Ramificações (*Branches*): O Superpoder do Git

Em ferramentas antigas, criar um branch significava copiar fisicamente todos os arquivos do projeto para outra pasta no servidor (uma operação lenta e pesada).

No Git, **um branch é apenas um pequeno ponteiro móvel de 41 bytes** contendo o hash do último commit. Criar, alternar ou mesclar branches é uma operação instantânea que leva menos de 5 milissegundos!

Isso possibilita trabalhar com o padrão da indústria: **cada nova funcionalidade ou correção de bug é desenvolvida em um branch isolado**, mantendo o branch principal (`main`) sempre estável e pronto para produção.

```bash
# 1. Criar e mudar imediatamente para um novo branch de funcionalidade:
# (Sintaxe moderna com 'git switch -c'; antigamente usava-se 'git checkout -b')
$ git switch -c feature/autenticacao-jwt
Switched to a new branch 'feature/autenticacao-jwt'

# 2. Trabalhe normalmente, altere arquivos e commite:
$ git add auth.c
$ git commit -m "feat: adiciona validacao de tokens JWT"

# 3. Listar todos os branches (o asterisco * indica onde você está no momento):
$ git branch
* feature/autenticacao-jwt
  main

# 4. Voltar com segurança para a branch principal 'main':
$ git switch main
Switched to branch 'main'
```

---

### Trabalho Colaborativo: Sincronização e Resolução de Conflitos

Quando você trabalha em equipe, seu repositório local precisa se comunicar com servidores remotos (GitHub, GitLab).

#### 1. Conectando a um Repositório Remoto

```bash
# Listar os servidores remotos configurados:
$ git remote -v

# Adicionar um servidor remoto com o apelido padrão 'origin':
$ git remote add origin git@github.com:seu-usuario/meu-projeto.git
```

---

#### 2. Enviando Commits com `git push`

```bash
# Envia seu branch para o servidor remoto configurando o vínculo de rastreamento (-u):
$ git push -u origin feature/autenticacao-jwt
```

---

#### 3. Baixando Atualizações: `git fetch` vs. `git pull`

Muitos iniciantes confundem esses dois comandos cruciais:

- **`git fetch`:** Conecta ao servidor e baixa todos os novos commits e branches que seus colegas enviaram, mas **NÃO altera nem toca nos seus arquivos locais**. É 100% seguro para inspecionar o que mudou sem risco de quebrar seu código.
- **`git pull`:** É um atalho que executa `git fetch` e, imediatamente a seguir, tenta fazer um `git merge` para mesclar o código dos seus colegas dentro do seu branch atual.

```bash
# Baixar e integrar as novidades do branch 'main' remoto:
$ git pull origin main
```

---

#### 4. Integrando Alterações com `git merge`

Quando uma funcionalidade em `feature/autenticacao-jwt` é concluída e testada, você a integra à `main`:

```bash
# 1. Vá para a branch de destino:
$ git switch main

# 2. Mescle as alterações da branch da funcionalidade para dentro da main:
$ git merge feature/autenticacao-jwt
Updating 4a82f1b..f23c91a
Fast-forward
 auth.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 auth.c

# 3. Opcional: após o merge com sucesso, você pode excluir a branch local:
$ git branch -d feature/autenticacao-jwt
```

---

#### 5. O que Fazer Diante de um Conflito de Merge (*Merge Conflict*)?

Um conflito acontece quando **duas pessoas alteram as mesmas linhas do mesmo arquivo** de formas diferentes em branches distintas. O Git não pode adivinhar qual versão está correta e pausa o merge para que um ser humano decida:

```bash
$ git merge feature/login
Auto-merging config.h
CONFLICT (content): Merge conflict in config.h
Automatic merge failed; fix conflicts and then commit the result.
```

Ao abrir o arquivo conflitante (`config.h`), o Git insere marcadores visuais explícitos:

```c
<<<<<<< HEAD
// Versão que estava na branch atual (main):
#define PORTA_SERVIDOR 8080
=======
// Versão que veio da branch feature/login:
#define PORTA_SERVIDOR 9000
>>>>>>> feature/login
```

##### Como Resolver o Conflito Passo a Passo:

1. **Abra o arquivo no editor** e converse com a equipe para decidir qual código manter (ou una ambos se fizer sentido).
2. **Apague os marcadores** `<<<<<<< HEAD`, `=======` e `>>>>>>> feature/login`, deixando apenas o código final desejado:
   ```c
   #define PORTA_SERVIDOR 8080
   ```
3. **Marque o conflito como resolvido** adicionando o arquivo à Staging Area:
   ```bash
   $ git add config.h
   ```
4. **Finalize o merge commit:**
   ```bash
   $ git commit -m "merge: resolve conflito de configuracao de porta do servidor"
   ```

---

### Boas Práticas para Equipes de Alto Desempenho

1. **Commits Pequenos e Atômicos:** Não passe duas semanas programando para commitar 5.000 linhas de uma só vez. Faça commits frequentes que resolvam uma única coisa por vez.
2. **Mensagens Padronizadas (*Conventional Commits*):**
   - `feat:` Nova funcionalidade (`feat: adiciona endpoint de busca`);
   - `fix:` Correção de bug (`fix: corrige divisao por zero no relatorio`);
   - `docs:` Alterações puramente em documentação (`docs: atualiza README`);
   - `refactor:` Mudança no código que não altera comportamento externo;
   - `test:` Adição ou correção de testes automatizados.
3. **Sincronize Frequentemente:** Antes de começar a programar e antes de abrir um Pull Request, execute `git pull` na branch `main` para manter seu código sempre alinhado com o restante da equipe.
4. **Nunca Use `git push --force` na `main`:** Forçar sobrescrita em branches compartilhadas apaga commits dos colegas e pode causar perda definitiva de trabalho em equipe. Se precisar forçar em sua própria branch de funcionalidade, use `--force-with-lease`.

---

### Resumo dos Comandos Git Mais Usados

| Comando | Para que serve | Exemplo |
| :--- | :--- | :--- |
| **`git init`** | Inicializa um novo repositório Git local | `git init` |
| **`git clone <url>`** | Baixa uma cópia integral de um repositório remoto | `git clone https://...` |
| **`git status`** | Mostra o estado dos arquivos (modificados, preparados, untracked) | `git status` |
| **`git diff`** | Compara as alterações linha a linha no código | `git diff` ou `git diff --staged` |
| **`git add <arq>`** | Move alterações para a Staging Area | `git add main.c` ou `git add .` |
| **`git commit -m`** | Grava o snapshot com mensagem descritiva | `git commit -m "feat: login"` |
| **`git log --oneline`** | Histórico compacto e cronológico de commits | `git log --oneline --graph` |
| **`git switch -c <nome>`** | Cria e entra em uma nova branch | `git switch -c feature/nova` |
| **`git switch <nome>`** | Alterna entre branches existentes | `git switch main` |
| **`git merge <branch>`** | Mescla outra branch para dentro da branch atual | `git merge feature/nova` |
| **`git fetch`** | Baixa novidades do servidor remoto sem alterar o código local | `git fetch origin` |
| **`git pull`** | Baixa e mescla as alterações remotas na branch local | `git pull origin main` |
| **`git push`** | Envia seus commits locais para o repositório remoto | `git push -u origin main` |

---

<p class="nav-footer" style="display: flex; justify-content: space-between; align-items: center; max-width: 650px; margin: 3rem auto 1.5rem auto;">
  <a href="05_depuracao_profiling.html" class="module-btn secondary">← Módulo 05: Depuração e Profiling</a>
  <a href="index.html" class="module-btn">Voltar ao Índice Principal</a>
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
