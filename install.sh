#!/usr/bin/env bash
set -e

echo "======= INSTALANDO E CONFIGURANDO RTK PARA CODEX ======="

# 1. Cria a pasta local de binários do usuário se não existir
mkdir -p "$HOME/.local/bin"

# 2. Baixa o binário oficial do RTK
curl -fsSL https://githubusercontent.com | sh

# 3. Adiciona o caminho ao PATH no .bashrc se já não estiver lá
if ! grep -q '\.local/bin' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

# Exporta imediatamente para a sessão atual do script de instalação conseguir usar
export PATH="$HOME/.local/bin:$PATH"

# 4. Inicializa o RTK especificamente com a flag do Codex (OpenAI) de forma automatizada
if command -v rtk >/dev/null 2>&1; then
    rtk init --global --agent codex --auto-patch
    echo "✔ RTK instalado e integrado ao Codex com sucesso!"
else
    echo "❌ Erro ao validar a instalação do RTK."
fi
