#!/usr/bin/env bash
# Configuração automática de ferramentas de IA para GitHub Codespaces.
# Ordem: Codex -> Antigravity CLI -> RTK -> RTK/Codex -> RTK/Antigravity.
# Execute como usuário normal (não como root): bash install.sh

set -Eeuo pipefail

# -E: propaga o trap ERR para funções.
# -e: interrompe quando um comando falha.
# -u: rejeita variáveis não definidas.
# -o pipefail: detecta falhas em qualquer etapa de um pipeline.

log()   { printf '\n[INFO] %s\n' "$*"; }
ok()    { printf '[OK] %s\n' "$*"; }
error() { printf '[ERRO] %s\n' "$*" >&2; }

# Indica a linha que falhou, facilitando o diagnóstico nos logs do Codespaces.
trap 'error "Falha na linha $LINENO (código de saída: $?)."' ERR

# Diretório temporário exclusivo, removido inclusive quando ocorre um erro.
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Instaladores oficiais usam ~/.local/bin para seus executáveis.
# O PATH é atualizado agora, pois alterações no .bashrc não afetam este processo.
mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Garante que terminais Bash futuros também encontrem os executáveis.
# A linha exata é usada para evitar múltiplas inserções ao executar novamente.
PATH_LINE='export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"'
touch "$HOME/.bashrc"
if ! grep -Fqx "$PATH_LINE" "$HOME/.bashrc"; then
  printf '\n# Ferramentas instaladas pelos dotfiles (Codex, Antigravity e RTK)\n%s\n' "$PATH_LINE" >> "$HOME/.bashrc"
fi

# Todas as instalações dependem de curl para baixar os scripts oficiais.
command -v curl >/dev/null 2>&1 || { error 'curl não está instalado.'; exit 1; }

# Baixa primeiro para um arquivo temporário: se o download falhar,
# nenhum script incompleto será executado. O HTTPS é validado pelo curl.
run_official_installer() {
  local url="$1"
  local file="$TMP_DIR/installer.sh"
  curl --fail --silent --show-error --location --retry 3 "$url" --output "$file"
  bash "$file"
}

# -----------------------------------------------------------------------------
# 1/5 - Instalar OpenAI Codex CLI
# -----------------------------------------------------------------------------
# Codex é o agente de programação da OpenAI acessível pelo comando "codex".
# Evita baixar novamente caso o executável já esteja disponível.
log '[1/5] Instalando OpenAI Codex CLI...'
if command -v codex >/dev/null 2>&1; then
  log 'Codex já instalado; instalação ignorada.'
else
  run_official_installer 'https://chatgpt.com/codex/install.sh'
fi
command -v codex >/dev/null 2>&1 || { error 'Codex não foi encontrado no PATH.'; exit 1; }
ok "Codex: $(codex --version)"

# -----------------------------------------------------------------------------
# 2/5 - Instalar Google Antigravity CLI
# -----------------------------------------------------------------------------
# No Codespaces, que é um ambiente Linux normalmente sem desktop gráfico,
# usamos a versão de terminal (comando "agy"), não o aplicativo gráfico.
log '[2/5] Instalando Google Antigravity CLI...'
if command -v agy >/dev/null 2>&1; then
  log 'Antigravity CLI já instalado; instalação ignorada.'
else
  run_official_installer 'https://antigravity.google/cli/install.sh'
fi
command -v agy >/dev/null 2>&1 || { error 'Antigravity CLI (agy) não foi encontrado no PATH.'; exit 1; }
ok "Antigravity: $(agy --version)"

# -----------------------------------------------------------------------------
# 3/5 - Instalar RTK (Rust Token Killer)
# -----------------------------------------------------------------------------
# RTK compacta a saída de comandos de desenvolvimento para economizar tokens.
# Há outro programa chamado "rtk"; "rtk gain" identifica o projeto correto.
log '[3/5] Instalando RTK (Rust Token Killer)...'
if command -v rtk >/dev/null 2>&1 && rtk gain >/dev/null 2>&1; then
  log 'RTK correto já instalado; instalação ignorada.'
else
  # Se houver outro "rtk" no PATH, o instalador oficial ainda instala
  # o Rust Token Killer em ~/.local/bin, que tem prioridade no PATH.
  run_official_installer 'https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh'
fi
command -v rtk >/dev/null 2>&1 || { error 'RTK não foi encontrado no PATH.'; exit 1; }
rtk gain >/dev/null || { error 'O executável rtk não é o Rust Token Killer esperado.'; exit 1; }
ok "RTK: $(rtk --version)"

# -----------------------------------------------------------------------------
# 4/5 - Vincular RTK ao Codex
# -----------------------------------------------------------------------------
# --global: configura o usuário inteiro, não apenas o repositório atual.
# --codex: instala as instruções e os hooks compatíveis com Codex.
# Isso permite reescrever automaticamente comandos suportados para "rtk ...".
log '[4/5] Configurando integração global RTK + Codex...'
rtk init --global --codex
ok 'Integração RTK + Codex configurada.'

# -----------------------------------------------------------------------------
# 5/5 - Vincular RTK ao Antigravity
# -----------------------------------------------------------------------------
# O plugin global fica em ~/.gemini/config/plugins/rtk/.
# Seus hooks interceptam comandos suportados executados pelo Antigravity.
log '[5/5] Configurando integração global RTK + Antigravity...'
rtk init --global --agent antigravity
ok 'Integração RTK + Antigravity configurada.'

printf '\n============================================\n'
printf ' Configuração do Codespaces concluída!\n'
printf '============================================\n'
printf 'Codex:       %s\n' "$(command -v codex)"
printf 'Antigravity: %s\n' "$(command -v agy)"
printf 'RTK:         %s\n' "$(command -v rtk)"
printf '\nPara usar os agentes, autentique-se na primeira execução:\n'
printf '  codex\n  agy\n'
printf 'Reinicie os agentes após configurar os hooks do RTK.\n'
