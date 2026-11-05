# ⚙️ Dotfiles - Automação de Ambiente (GitHub Codespaces)

Este repositório contém minhas configurações e scripts de automação pessoal para o desenvolvimento em nuvem. Ele é detectado nativamente pelo **GitHub Codespaces** para preparar meu terminal automaticamente assim que a máquina virtual é criada.

## 🚀 O que está incluído?

*   **Instalação do RTK (Rust Token Killer):** Baixa o binário oficial localmente.
*   **Integração com Codex (OpenAI):** Configura e injeta o gancho (*hook*) de forma automatizada no Codex para economizar até 90% de tokens nas chamadas de terminal.
*   **Configuração de PATH:** Garante que os binários locais (`~/.local/bin`) fiquem disponíveis globalmente no shell Bash.

---

## 🛠️ Como ativar na sua conta do GitHub

Para fazer com que o GitHub aplique estas configurações em **todo novo Codespace** que você abrir, siga os passos abaixo:

1. Acesse as [Configurações de Codespaces do GitHub](https://github.com).
2. Role a página até encontrar a seção **"Dotfiles"**.
3. Ative a opção **"Automatically install dotfiles"**.
4. No menu de seleção de repositórios, escolha este repositório (`dotfiles`).

Pronto! Na próxima vez que você criar uma instância do Codespaces, o script `install.sh` rodará em segundo plano logo no início da inicialização.

---

## 🔍 Verificando o funcionamento no terminal

Após abrir o seu Codespace, você pode testar se a integração com o Codex foi bem-sucedida rodando o comando:

```bash
rtk init --show
```

Se quiser verificar o histórico de tokens poupados na sessão atual, utilize:

```bash
rtk gain
```
