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

Em 2005, a comunidade de desenvolvedores do kernel Linux enfrentou uma crise: a ferramenta proprietária que utilizavam para versionar o código (BitKeeper) revogou o acesso gratuito. Insatisfeito com as alternativas centralizadas existentes na época (como CVS e SVN), **Linus Torvalds** interrompeu temporariamente o trabalho no kernel para escrever seu próprio sistema de controle de versão: nascia o **Git**. O desenvolvimento foi tão rápido que, poucos dias depois de iniciado (em abril de 2005), o Git já era usado para versionar o seu próprio código-fonte, e em poucos meses passou a gerenciar o kernel Linux.

O Git foi desenhado a partir de princípios fundamentais que revolucionaram a engenharia de software:

#### 1. Totalmente Distribuído (*DVCS*):
Em sistemas centralizados tradicionais (como o SVN), existe um servidor central único onde fica o histórico. Se a rede cair ou o servidor queimar, ninguém consegue commitar ou consultar versões passadas.  
No Git, **todo clone é um repositório completo e independente**. Você possui o histórico integral de todos os arquivos e branches da história do projeto diretamente no seu computador local, podendo commitar, criar branches e inspecionar logs offline no avião ou sem internet.

#### 2. Snapshots, Não Listas de Diferenças (*Deltas*):
Sistemas antigos gravavam versões como um arquivo base seguido por uma lista de alterações incrementais linha por linha (*deltas*). O Git enxerga seus dados como um conjunto de **fotografias instantâneas (*snapshots*)** de todo o projeto a cada commit. Se um arquivo não foi modificado em um novo commit, o Git não gasta espaço duplicado: ele simplesmente armazena um ponteiro ultrarrápido para a versão idêntica já guardada anteriormente.

> **Nota técnica:** o *snapshot* é o **modelo conceitual** com que o Git trabalha. Para economizar espaço em disco e na rede, ele também compacta os objetos periodicamente em arquivos chamados *packfiles*, nos quais versões parecidas de um arquivo são guardadas como diferenças (*deltas*) entre si. Essa otimização é interna e invisível para o usuário: cada commit continua representando o estado completo do projeto.

#### 3. Integridade Criptográfica com Hashes SHA:
Tudo no Git é identificado por uma assinatura criptográfica exclusiva (originalmente SHA-1 com 40 caracteres hexadecimais, evoluindo para SHA-256). Como cada commit inclui o hash do commit anterior, alterar o conteúdo de um arquivo antigo ou a mensagem de um commit passado **muda o hash daquele commit e de todos os commits seguintes**, tornando qualquer adulteração imediatamente visível. Forjar uma alteração que mantenha os mesmos hashes é **computacionalmente inviável** na prática (embora já se tenha demonstrado uma colisão artificial no SHA-1, em 2017, um dos motivos da migração para o SHA-256).

#### 4. O Diretório Mágico `.git`:
Toda a base de dados, objetos, configurações e histórico **do projeto** ficam armazenados dentro de uma única pasta oculta chamada **`.git/`** na raiz do seu projeto. Não há banco de dados ou servidor instalado no sistema: as únicas configurações fora do projeto são as **preferências pessoais** do usuário (nome, e-mail, editor), gravadas no arquivo `~/.gitconfig` pelo comando `git config --global`, que veremos adiante.

> **Cuidado:** apagar a pasta `.git/` desvincula o projeto do Git, mas também **destrói todo o histórico de versões** daquela cópia. Os arquivos atuais permanecem, mas commits, branches e versões anteriores se perdem (a menos que existam em um repositório remoto ou em outro clone).

[![As Quatro Áreas do Git e o Fluxo de Trabalho Colaborativo (clique para ampliar)](img/linux-git-workflow.svg)](img/linux-git-workflow.svg)

---

### As Quatro Áreas do Git e os Três Estados do Arquivo

Para dominar o Git, você precisa compreender a jornada que um arquivo percorre entre o seu teclado e o repositório compartilhado:

1. **Diretório de Trabalho (*Working Directory*):** A pasta física no seu computador onde você abre arquivos no VS Code ou nano, escreve código e testa compilações.
2. **Área de Preparação (*Staging Area / Index*):** Uma área intermediária onde você seleciona cirurgicamente quais modificações farão parte do próximo commit (usando `git add`). Permite quebrar grandes edições em commits atômicos e bem explicados.
3. **Repositório Local (*.git directory*):** O banco de dados local onde os commits confirmados (snapshots permanentes) ficam gravados para sempre no disco.
4. **Repositório Remoto (*Remote Repository*):** Servidores na nuvem ou rede interna (como GitHub, GitLab ou Bitbucket) onde a equipe sincroniza seus repositórios locais usando `push` e `pull`.

#### Os Três Estados Fundamentais de um Arquivo:
Antes de tudo, um arquivo novo começa como **`Untracked` (Não rastreado)**: o Git vê que ele existe na pasta, mas não o acompanha, e ele fica de fora dos commits até ser adicionado pela primeira vez com `git add`. A partir daí o arquivo passa a ser **rastreado** (*tracked*) e circula entre os três estados:

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
	README.md
	main.c

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
# (aqui, após um segundo commit; o mais recente aparece no topo)
$ git log --oneline --graph --decorate -n 10
* 9b12c04 (HEAD -> main) docs: adiciona instrucoes de compilacao no README
* 4a82f1b feat: implementa rotina de calculo da funcao principal
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

##### Não Comece do Zero: Modelos Prontos de `.gitignore`

Você não precisa descobrir sozinho o que ignorar em cada linguagem. O próprio GitHub mantém o repositório oficial **[github/gitignore](https://github.com/github/gitignore)**, com modelos prontos e revisados pela comunidade para dezenas de linguagens, frameworks e ferramentas (`C.gitignore`, `Python.gitignore`, `Java.gitignore`, `Node.gitignore`...). Há três formas práticas de usá-los:

1. **Ao criar um repositório no GitHub:** a página de criação tem a opção **"Add .gitignore"**, com uma lista desses modelos. O arquivo já nasce no repositório.
2. **Baixando direto pelo terminal**, a partir da versão "crua" (*raw*) do modelo:
   ```bash
   $ curl -o .gitignore https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore
   ```
3. **Combinando vários modelos de uma vez** com o gerador [gitignore.io](https://www.toptal.com/developers/gitignore), útil quando o projeto mistura linguagens, sistemas operacionais e editores (ex.: `python,java,windows,vscode`).

**Dica:** use o modelo como ponto de partida e acrescente ao final as regras específicas do seu projeto (como o nome do executável gerado ou uma pasta de dados local).

:::: destaque
::: destaque-titulo
📌 Importante: o `.gitignore` não age sobre o passado
:::

Ele só impede que arquivos **ainda não rastreados** entrem no repositório. Se um arquivo **já foi commitado** antes de entrar no `.gitignore`, o Git continua acompanhando suas alterações normalmente. Para parar de rastreá-lo (sem apagá-lo do disco):

```bash
$ git rm --cached app.log
$ git commit -m "chore: remove app.log do controle de versao"
```

**E se uma senha ou chave foi commitada por engano?** Removê-la em um novo commit **não basta**: ela continua visível nos commits antigos do histórico, e qualquer pessoa com acesso ao repositório pode recuperá-la. A medida correta é considerar a credencial comprometida e **trocá-la** (gerar uma nova senha, token ou chave e revogar a antiga). Por isso vale configurar o `.gitignore` logo no início do projeto, antes do primeiro commit.
::::

---

### Ramificações (*Branches*): O Superpoder do Git

Em ferramentas antigas, criar um branch significava copiar fisicamente todos os arquivos do projeto para outra pasta no servidor (uma operação lenta e pesada).

No Git, **um branch é apenas um pequeno ponteiro móvel de 41 bytes** contendo o hash do último commit. Por isso, **criar um branch é instantâneo**, independentemente do tamanho do projeto: nenhum arquivo é copiado. Alternar entre branches e mesclá-los também é rápido, pois o Git só reescreve no disco os arquivos que realmente diferem entre as versões.

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

#### Boas Práticas para Nomear Branches

Em um projeto com várias pessoas, a lista de branches cresce rápido. Nomes padronizados permitem saber, só de olhar, **o tipo de trabalho** e **do que se trata** cada branch. A convenção mais difundida é o formato **`tipo/descricao-curta`**:

| Prefixo | Quando usar | Exemplo |
| :--- | :--- | :--- |
| **`feature/`** | Nova funcionalidade | `feature/autenticacao-jwt` |
| **`fix/`** | Correção de bug em desenvolvimento | `fix/divisao-por-zero` |
| **`hotfix/`** | Correção urgente de algo que já está em produção | `hotfix/falha-no-login` |
| **`docs/`** | Alterações apenas na documentação | `docs/instrucoes-de-instalacao` |
| **`refactor/`** | Reorganização do código sem mudar o comportamento | `refactor/modulo-de-pagamento` |
| **`test/`** | Criação ou ajuste de testes automatizados | `test/cobertura-do-parser` |
| **`chore/`** | Manutenção (dependências, configurações, build) | `chore/atualiza-dependencias` |

Repare que os prefixos são os mesmos das mensagens de commit no padrão *Conventional Commits*, apresentado nas Boas Práticas ao final deste módulo. Assim, branch e commits "falam a mesma língua".

##### Regras de Ouro:
- **Letras minúsculas e palavras separadas por hífen** (`feature/busca-por-nome`), sem espaços.
- **Evite acentos e caracteres especiais** (`ç`, `ã`, `é`...). O Git até aceita, mas eles costumam causar problemas em terminais, scripts e ferramentas de integração.
- **Seja curto, mas descritivo:** `fix/timeout-no-upload` diz muito mais que `fix/bug` ou `teste2`.
- **Não use o seu nome como nome da branch** (`branch-do-joao`): o nome deve descrever **o trabalho**, não quem o faz.
- **Inclua o número da tarefa, se a equipe usar um sistema de *issues*:** `feature/42-login-com-google` deixa claro a qual tarefa a branch se refere (aqui, a *issue* 42 do GitHub ou do GitLab).
- **Apague a branch depois do merge** (`git branch -d nome`). Branches antigas acumuladas só confundem.

> **Nomes que o Git recusa:** espaços (`minha branch`), dois pontos seguidos (`fix/erro..divisao`), os caracteres `~ ^ : ? * [ \`, nomes terminados em `/` ou em `.lock`. Na dúvida, o próprio Git confere: `git check-ref-format --branch "nome-da-branch"` imprime o nome se ele for válido e acusa erro caso contrário.

---

### Trabalho Colaborativo: Sincronização e Resolução de Conflitos

Quando você trabalha em equipe, seu repositório local precisa se comunicar com servidores remotos (GitHub, GitLab).

#### 1. Autenticando-se no GitHub com uma Chave SSH

Para **enviar** commits (`git push`), o GitHub precisa saber quem você é. Desde 2021, ele **não aceita mais a senha da conta** em operações do Git via HTTPS: quem tenta recebe um erro de autenticação no primeiro `push`. A forma mais prática de resolver isso é usar uma **chave SSH**, um par de arquivos em que a parte **privada** fica só no seu computador e a parte **pública** é cadastrada no GitHub.

```bash
# 1. Gerar o par de chaves (tecle Enter para aceitar o local padrão;
#    a frase-senha é opcional, mas recomendada):
$ ssh-keygen -t ed25519 -C "seu.email@exemplo.com"

# 2. Exibir a chave PÚBLICA (o arquivo terminado em .pub) para copiá-la:
$ cat ~/.ssh/id_ed25519.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... seu.email@exemplo.com
```

3. No GitHub, acesse **Settings → SSH and GPG keys → New SSH key**, cole o conteúdo exibido e salve.
4. Teste a conexão:

```bash
$ ssh -T git@github.com
Hi seu-usuario! You've successfully authenticated, but GitHub does not provide shell access.
```

> **Importante:** use sempre as URLs no formato SSH (`git@github.com:usuario/repo.git`) para os repositórios em que você vai fazer `push`. A chave **privada** (`~/.ssh/id_ed25519`, sem `.pub`) nunca deve ser compartilhada nem versionada. Alternativas ao SSH são um *Personal Access Token* (usado no lugar da senha em URLs HTTPS) ou a ferramenta oficial `gh auth login`.

---

#### 2. Conectando a um Repositório Remoto

```bash
# Listar os servidores remotos configurados:
$ git remote -v

# Adicionar um servidor remoto com o apelido padrão 'origin':
$ git remote add origin git@github.com:seu-usuario/meu-projeto.git
```

---

#### 3. Enviando Commits com `git push`

```bash
# Envia seu branch para o servidor remoto configurando o vínculo de rastreamento (-u):
$ git push -u origin feature/autenticacao-jwt
```

---

#### 4. Baixando Atualizações: `git fetch` vs. `git pull`

Muitos iniciantes confundem esses dois comandos cruciais:

- **`git fetch`:** Conecta ao servidor e baixa todos os novos commits e branches que seus colegas enviaram, mas **NÃO altera nem toca nos seus arquivos locais**. É 100% seguro para inspecionar o que mudou sem risco de quebrar seu código.
- **`git pull`:** É um atalho que executa `git fetch` e, imediatamente a seguir, tenta fazer um `git merge` para mesclar o código dos seus colegas dentro do seu branch atual.

```bash
# Baixar e integrar as novidades do branch 'main' remoto:
$ git pull origin main
```

##### O Erro "*divergent branches*" no `git pull`
Se você fez commits locais **e** seus colegas também enviaram commits ao servidor, os dois históricos **divergiram**. Nessa situação, as versões atuais do Git se recusam a decidir sozinhas como juntá-los:

```text
hint: You have divergent branches and need to specify how to reconcile them.
hint: You can do so by running one of the following commands sometime before
hint: your next pull:
hint:
hint:   git config pull.rebase false  # merge
hint:   git config pull.rebase true   # rebase
hint:   git config pull.ff only       # fast-forward only
...
fatal: Need to specify how to reconcile divergent branches.
```

A solução é escolher uma estratégia padrão **uma única vez**. Para quem está começando, a mais simples é o **merge** (o `pull` cria um commit que junta os dois históricos):

```bash
$ git config --global pull.rebase false
$ git pull origin main      # agora o pull funciona, fazendo merge quando necessário
```

---

#### 5. Integrando Alterações com `git merge`

Quando uma funcionalidade em `feature/autenticacao-jwt` é concluída e testada, você a integra à `main`:

```bash
# 1. Vá para a branch de destino:
$ git switch main

# 2. Mescle as alterações da branch da funcionalidade para dentro da main:
$ git merge feature/autenticacao-jwt
Updating 9b12c04..f23c91a
Fast-forward
 auth.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 auth.c

# 3. Opcional: após o merge com sucesso, você pode excluir a branch local:
$ git branch -d feature/autenticacao-jwt
```

##### *Fast-forward* vs. *Merge Commit*: os Dois Tipos de Merge
Repare na palavra **`Fast-forward`** na saída acima. O Git escolhe automaticamente entre duas situações:

- **Fast-forward (avanço rápido):** a `main` **não recebeu nenhum commit novo** desde que a branch da funcionalidade foi criada. Basta então "avançar" o ponteiro da `main` até o último commit da funcionalidade. Nenhum commit novo é criado e o histórico continua uma linha reta.
- **Merge commit (commit de mesclagem):** a `main` **também avançou** enquanto você trabalhava (alguém integrou outras mudanças). Os históricos se separaram, e o Git cria um **commit especial com dois "pais"** que une as duas linhas. É o caso do commit **M1** na figura do início do módulo: a `main` recebeu o C3 enquanto a `feature/login` recebia F1 e F2. A saída indica a estratégia usada:

```bash
$ git merge feature/login
Merge made by the 'ort' strategy.
```

É somente nesse segundo caso, em que os dois lados mudaram, que podem surgir **conflitos**. Mas atenção: históricos divergentes **não** significam conflito na maioria das vezes. Se as duas branches alteraram partes diferentes dos arquivos, o Git combina tudo sozinho:

[![Merge sem conflito: as duas branches alteraram linhas diferentes (clique para ampliar)](img/linux-git-merge-sem-conflito.svg)](img/linux-git-merge-sem-conflito.svg)

---

#### 6. O que Fazer Diante de um Conflito de Merge (*Merge Conflict*)?

Um conflito acontece quando **duas pessoas alteram as mesmas linhas do mesmo arquivo** (ou linhas vizinhas) de formas diferentes em branches distintas. O Git não pode adivinhar qual versão está correta e pausa o merge para que um ser humano decida. Compare com a figura anterior: o histórico é o mesmo, e só muda o que cada commit alterou:

[![Merge com conflito: as duas branches alteraram a mesma linha (clique para ampliar)](img/linux-git-merge-com-conflito.svg)](img/linux-git-merge-com-conflito.svg)

No terminal, o conflito se apresenta assim:

```bash
$ git merge feature/login
Auto-merging config.h
CONFLICT (content): Merge conflict in config.h
Automatic merge failed; fix conflicts and then commit the result.
```

Durante o conflito, o `git status` mostra exatamente quais arquivos precisam de atenção (marcados como **`both modified`**) e lembra as saídas possíveis:

```bash
$ git status
On branch main
You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
  (use "git add <file>..." to mark resolution)
	both modified:   config.h
```

> **Saída de emergência:** se o conflito parecer complicado demais ou você quiser conversar com a equipe antes, execute **`git merge --abort`**. O Git desfaz a tentativa de merge e devolve o branch exatamente ao estado anterior, sem perder nada.

Ao abrir o arquivo conflitante (`config.h`), você encontra os marcadores que o Git inseriu no meio do código:

```c
<<<<<<< HEAD
#define PORTA_SERVIDOR 8080
=======
#define PORTA_SERVIDOR 9000
>>>>>>> feature/login
```

- Entre **`<<<<<<< HEAD`** e **`=======`** está a versão da branch atual (aqui, a `main`, onde você está fazendo o merge).
- Entre **`=======`** e **`>>>>>>> feature/login`** está a versão que veio da branch que está sendo mesclada.

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

#### 7. Pull Requests: Revisão de Código Antes do Merge

Em equipes, ninguém faz `git merge` diretamente na `main` do servidor. O fluxo padrão em plataformas como GitHub e GitLab é o **Pull Request** (*PR*, chamado de *Merge Request* no GitLab): um pedido formal para que as alterações de uma branch sejam integradas à `main`, **depois** de revisadas pelos colegas.

1. **Crie uma branch** para a tarefa e faça seus commits nela:
   ```bash
   $ git switch -c feature/busca
   $ git add busca.c
   $ git commit -m "feat: adiciona busca por nome"
   ```
2. **Envie a branch** para o servidor:
   ```bash
   $ git push -u origin feature/busca
   ```
3. **Abra o Pull Request** no site do GitHub. Logo após o `push`, aparece um botão **"Compare & pull request"**. Descreva o que foi feito e por quê.
4. **Revisão:** os colegas leem o código pela interface, comentam linhas específicas e pedem ajustes. Para atender aos pedidos, basta fazer novos commits na mesma branch e um novo `git push`: o PR se atualiza sozinho.
5. **Merge:** com a aprovação (e os testes automáticos passando, quando houver), alguém clica em **"Merge pull request"**. A integração acontece no servidor.
6. **Atualize sua cópia local** e apague a branch que já foi integrada:
   ```bash
   $ git switch main
   $ git pull origin main
   $ git branch -d feature/busca
   ```

> **Por que não fazer merge direto?** O PR cria um ponto de verificação: outra pessoa sempre olha o código antes que ele chegue à `main`, o que pega bugs cedo, espalha o conhecimento pela equipe e deixa registrada a discussão de cada mudança.

---

### Desfazendo Erros: `--amend`, `revert` e `reflog`

Todo mundo erra: uma mensagem de commit com erro de digitação, um arquivo esquecido, um commit que introduziu um bug. O Git oferece ferramentas diferentes para cada situação, e a escolha depende de uma pergunta-chave: **o commit já foi enviado (`push`) para o servidor?**

#### 1. Corrigindo o Último Commit com `git commit --amend` (ainda não enviado)

Esqueceu um arquivo ou escreveu a mensagem errada no commit que acabou de fazer? O `--amend` **substitui** o último commit por uma versão corrigida:

```bash
# Inclui no último commit um arquivo que tinha ficado de fora e corrige a mensagem:
$ git add README.md
$ git commit --amend -m "fix: corrige calculo da media"
[main 3725056] fix: corrige calculo da media
```

> **Atenção:** o commit corrigido ganha um **hash novo**, ou seja, é um commit diferente do original. Por isso, use o `--amend` **apenas em commits que ainda não foram enviados**. Se o commit original já estiver no servidor, reescrevê-lo obriga a um `push --force` e atrapalha os colegas (veja as Boas Práticas a seguir).

#### 2. Desfazendo um Commit com Segurança com `git revert` (já enviado)

Se um commit **já foi compartilhado** e precisa ser desfeito, a forma segura é o `git revert`: ele **não apaga** nada do histórico, e sim cria um **novo commit que faz exatamente o inverso** do commit indicado:

```bash
$ git revert 3725056
[main db809a3] Revert "fix: corrige calculo da media"
 2 files changed, 2 deletions(-)

$ git log --oneline
db809a3 Revert "fix: corrige calculo da media"
3725056 fix: corrige calculo da media
dd43e97 feat: primeira versao
```

Como o histórico só cresce (nenhum commit é reescrito), basta um `git push` normal, e os colegas recebem a reversão como qualquer outra alteração.

#### 3. A Rede de Segurança: `git reflog`

O Git registra no **reflog** cada movimento do `HEAD` no seu repositório local: commits, trocas de branch, merges, `--amend` e até comandos destrutivos como `git reset --hard`. Mesmo um commit que "sumiu" do `git log` continua recuperável por algum tempo (por padrão, ao menos 30 dias para commits que não pertencem mais a nenhum branch):

```bash
# Ops! Um 'reset --hard' descartou os dois últimos commits:
$ git reset --hard HEAD~2
HEAD is now at dd43e97 feat: primeira versao

# O reflog mostra todos os estados pelos quais o repositório passou:
$ git reflog
dd43e97 HEAD@{0}: reset: moving to HEAD~2
db809a3 HEAD@{1}: revert: Revert "fix: corrige calculo da media"
3725056 HEAD@{2}: commit (amend): fix: corrige calculo da media
152864c HEAD@{3}: commit: fix: corrije calculo
dd43e97 HEAD@{4}: commit (initial): feat: primeira versao

# Basta voltar ao estado desejado (aqui, o de antes do reset):
$ git reset --hard db809a3
```

> **Limite importante:** o reflog só protege o que **foi commitado** e é **local** (não vai para o servidor). Alterações que nunca entraram em um commit e foram descartadas com `git restore` ou `git reset --hard` não podem ser recuperadas por ele. Mais um motivo para fazer commits pequenos e frequentes!

#### Resumo: Qual Ferramenta Usar?

| Situação | Comando | Reescreve o histórico? |
| :--- | :--- | :---: |
| Corrigir mensagem ou incluir arquivo no **último** commit, **ainda não enviado** | `git commit --amend` | Sim |
| Desfazer um commit que **já foi enviado** para o servidor | `git revert <hash>` | Não (cria um commit novo) |
| Recuperar commits "perdidos" após um reset, amend ou exclusão de branch | `git reflog` + `git reset --hard <hash>` | Restaura um estado anterior |

---

### Boas Práticas para Equipes de Alto Desempenho

1. **Commits Pequenos e Atômicos:** Não passe duas semanas programando para commitar 5.000 linhas de uma só vez. Faça commits frequentes que resolvam uma única coisa por vez.
2. **Mensagens Padronizadas (*Conventional Commits*):**
   - `feat:` Nova funcionalidade (`feat: adiciona endpoint de busca`);
   - `fix:` Correção de bug (`fix: corrige divisao por zero no relatorio`);
   - `docs:` Alterações puramente em documentação (`docs: atualiza README`);
   - `refactor:` Mudança no código que não altera comportamento externo;
   - `test:` Adição ou correção de testes automatizados;
   - `style:` Ajustes de formatação que não alteram a lógica (indentação, espaços, ponto e vírgula);
   - `chore:` Tarefas de manutenção do projeto (dependências, configurações, scripts de build, `.gitignore`).
3. **Sincronize Frequentemente:** Antes de começar a programar e antes de abrir um Pull Request, atualize a `main` e traga as novidades para a sua branch de funcionalidade. Assim, eventuais conflitos aparecem cedo, na sua máquina, e não no PR:
   ```bash
   $ git switch main
   $ git pull origin main
   $ git switch feature/minha-tarefa
   $ git merge main          # incorpora à sua branch o que a equipe já integrou
   ```
4. **Nunca Use `git push --force` na `main`:** O `--force` faz o servidor aceitar um histórico que **reescreve** o anterior, apagando commits dos colegas, o que pode causar perda definitiva de trabalho em equipe. A necessidade de forçar só surge quando você reescreve commits que já tinham sido enviados (por exemplo, com `git commit --amend` ou `git rebase`, uma alternativa ao merge que reorganiza os commits da sua branch sobre a `main` atualizada). Se isso acontecer em uma branch **só sua**, use **`--force-with-lease`**: ele recusa o envio caso alguém tenha enviado commits que você ainda não baixou.

---

### Resumo dos Comandos Git Mais Usados

| Comando | Para que serve | Exemplo |
| :--- | :--- | :--- |
| **`git init`** | Inicializa um novo repositório Git local | `git init` |
| **`git clone <url>`** | Baixa uma cópia integral de um repositório remoto | `git clone https://...` |
| **`git status`** | Mostra o estado dos arquivos (modificados, preparados, untracked) | `git status` |
| **`git diff`** | Compara as alterações linha a linha no código | `git diff` ou `git diff --staged` |
| **`git add <arq>`** | Move alterações para a Staging Area | `git add main.c` ou `git add .` |
| **`git restore`** | Retira da Staging Area (`--staged`) ou descarta alterações não commitadas | `git restore --staged main.c` |
| **`git commit -m`** | Grava o snapshot com mensagem descritiva | `git commit -m "feat: login"` |
| **`git log --oneline`** | Histórico compacto de commits, do mais recente para o mais antigo | `git log --oneline --graph` |
| **`git switch -c <nome>`** | Cria e entra em uma nova branch | `git switch -c feature/nova` |
| **`git switch <nome>`** | Alterna entre branches existentes | `git switch main` |
| **`git merge <branch>`** | Mescla outra branch para dentro da branch atual | `git merge feature/nova` |
| **`git remote`** | Lista ou adiciona servidores remotos | `git remote add origin git@github.com:...` |
| **`git fetch`** | Baixa novidades do servidor remoto sem alterar o código local | `git fetch origin` |
| **`git pull`** | Baixa e mescla as alterações remotas na branch local | `git pull origin main` |
| **`git push`** | Envia seus commits locais para o repositório remoto | `git push -u origin main` |
| **`git commit --amend`** | Corrige o último commit (somente se ainda não foi enviado) | `git commit --amend -m "fix: ..."` |
| **`git revert <hash>`** | Desfaz um commit criando um novo commit inverso | `git revert 3725056` |
| **`git reflog`** | Lista os estados anteriores do repositório para recuperar commits | `git reflog` |

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
