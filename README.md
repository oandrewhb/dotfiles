# ⚙️ Dotfiles — Ambiente de desenvolvimento no GitHub Codespaces

Este repositório reúne minhas configurações pessoais para preparar automaticamente novos ambientes de desenvolvimento no **GitHub Codespaces**.

O arquivo [`install.sh`](./install.sh) instala ferramentas de programação assistida por IA e configura o **RTK (Rust Token Killer)** para trabalhar com os agentes. Assim, não preciso repetir manualmente a preparação a cada Codespace criado.

## 🚀 O que é configurado?

O script executa as etapas **nesta ordem**:

| Etapa | Ação | Resultado esperado |
| --- | --- | --- |
| 1 | Instalar **OpenAI Codex CLI** | Disponibiliza o comando `codex` |
| 2 | Instalar **Google Antigravity CLI** | Disponibiliza o comando `agy` |
| 3 | Instalar **RTK (Rust Token Killer)** | Disponibiliza o comando `rtk` |
| 4 | Integrar RTK ao **Codex** | Aplica a configuração global do RTK para o Codex |
| 5 | Integrar RTK ao **Antigravity** | Aplica a configuração global do RTK para o Antigravity |

### Ferramentas

- **[OpenAI Codex](https://github.com/openai/codex):** agente de programação que pode ser utilizado pelo terminal.
- **[Google Antigravity](https://antigravity.google/):** ferramenta de desenvolvimento com IA. O script foi escrito para instalar sua **interface de linha de comando**, em vez de um aplicativo gráfico, por se tratar de um ambiente Codespaces.
- **[RTK (Rust Token Killer)](https://github.com/rtk-ai/rtk):** ferramenta que reduz o volume de texto retornado por comandos de desenvolvimento, ajudando a diminuir o consumo de tokens dos agentes quando eles utilizam os comandos compatíveis.

> **Nota:** a economia de tokens varia conforme os comandos executados e suas saídas; não existe um percentual fixo garantido.

## 🛠️ Ativando no GitHub Codespaces

1. Acesse as [configurações de Codespaces do GitHub](https://github.com/settings/codespaces).
2. Localize a seção **Dotfiles**.
3. Ative **Automatically install dotfiles**.
4. Selecione este repositório `dotfiles` como fonte das configurações.
5. Crie um **novo Codespace** para aplicar a configuração.

O GitHub Codespaces procura e executa o `install.sh` do repositório de dotfiles durante a preparação do ambiente. A execução é feita no contexto do usuário do Codespace.

> **Atenção:** habilitar dotfiles não significa que Codespaces já existentes serão reconfigurados automaticamente. Para reaplicar as configurações, execute o script manualmente no ambiente desejado.

## 💻 Execução manual

Se quiser executar o script sem criar um novo Codespace, abra o terminal na pasta do repositório e rode:

```bash
# Verifica a sintaxe do Bash, sem executar instalações.
bash -n install.sh

# Executa a configuração completa.
bash install.sh
```

Execute como **usuário normal**, sem `sudo`. O script pressupõe um ambiente Linux com Bash e `curl` disponíveis e acesso à internet para obter os instaladores.

### O que o script faz além das instalações?

- Ativa `set -Eeuo pipefail` para interromper a execução em situações de erro.
- Mostra mensagens de progresso e a linha em que uma falha ocorrer.
- Usa diretório temporário para baixar instaladores antes de executá-los e o remove ao finalizar.
- Adiciona `~/.local/bin` e `~/.cargo/bin` ao `PATH` atual e ao `~/.bashrc`, evitando repetir a mesma linha.
- Verifica se os executáveis já estão disponíveis antes de tentar instalá-los novamente.
- Configura as integrações do RTK **globalmente**, para o usuário do Codespace, e não apenas para um projeto.

> **Segurança:** o script baixa e executa instaladores remotos. Antes de executá-lo, revise as URLs e o conteúdo do [`install.sh`](./install.sh). Como os instaladores são externos, sua disponibilidade e seu comportamento podem mudar.

## 🔐 Primeiro acesso aos agentes

A instalação **não autentica automaticamente** suas contas. Na primeira utilização, execute:

```bash
# Inicia o Codex e permite seguir seu fluxo de autenticação.
codex

# Inicia o Antigravity CLI, se disponível, para autenticação/configuração.
agy
```

Siga as instruções exibidas por cada ferramenta. Depois de instalar ou alterar os hooks do RTK, reinicie os agentes para que as configurações sejam carregadas.

## 🔍 Verificando a instalação

Confira se os executáveis estão no `PATH`:

```bash
command -v codex
command -v agy
command -v rtk
```

Confira as versões instaladas:

```bash
codex --version
agy --version
rtk --version
```

Consulte as informações de inicialização do RTK e suas estatísticas de economia de tokens:

```bash
rtk init --show
rtk gain
```

As integrações são configuradas pelo script com estes comandos:

```bash
# Integração global com Codex.
rtk init --global --codex

# Integração global com Antigravity.
rtk init --global --agent antigravity
```

**Importante:** encontrar os três executáveis confirma sua instalação, mas não prova, por si só, que os hooks estão funcionando. Para verificar a integração de ponta a ponta, abra cada agente, execute uma tarefa que utilize comandos de terminal compatíveis e examine o comportamento e as estatísticas do RTK.

## 🧩 Solução de problemas

| Problema | O que verificar |
| --- | --- |
| `command not found` | Abra um novo terminal ou execute `source ~/.bashrc` para atualizar o `PATH`. |
| Instalação interrompida | Consulte a mensagem `[ERRO]` e a linha indicada no terminal; confira conectividade e URLs dos instaladores. |
| O agente solicita login | Execute `codex` ou `agy` e conclua a autenticação. |
| RTK não parece atuar no agente | Reinicie o agente após a configuração; verifique os comandos de integração e consulte `rtk gain`. |
| O script não rodou ao criar o Codespace | Confirme que o repositório está selecionado nas configurações de dotfiles e que `install.sh` está na raiz. |

## 📁 Estrutura do repositório

```text
dotfiles/
├── install.sh   # Instala as ferramentas e configura suas integrações.
└── README.md    # Documenta a configuração e a utilização.
```

## 📚 Referências

- [GitHub Docs — Personalizando o Codespaces com dotfiles](https://docs.github.com/pt/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles)
- [OpenAI Codex — Repositório oficial](https://github.com/openai/codex)
- [Google Antigravity — Site oficial](https://antigravity.google/)
- [RTK — Repositório oficial](https://github.com/rtk-ai/rtk)
