#!/usr/bin/env bash
# Monta o plugin "instagram-nano" (as 13 skills ig-*) num arquivo .plugin
# para instalar no Cowork / app do Claude.
# Uso: bash scripts/empacotar-plugin-instagram.sh [saida.plugin]
set -eu

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
SAIDA="${1:-$RAIZ/dist/instagram-nano.plugin}"
case "$SAIDA" in /*) ;; *) SAIDA="$PWD/$SAIDA" ;; esac
VERSAO="$(date +%Y.%m.%d)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

bash "$RAIZ/scripts/testar-skills-instagram.sh" > /dev/null || {
  echo "Os testes falharam. Rode: bash scripts/testar-skills-instagram.sh"; exit 1; }

PLUGIN="$TMP/instagram-nano"
mkdir -p "$PLUGIN/.claude-plugin" "$PLUGIN/skills"
cp -R "$RAIZ"/.claude/skills/ig-* "$PLUGIN/skills/"
find "$PLUGIN" -name '__pycache__' -type d -prune -exec rm -rf {} +
cp "$RAIZ/licencas/instagram-agent-skill-MIT.txt" "$PLUGIN/LICENSE"

cat > "$PLUGIN/.claude-plugin/plugin.json" <<EOF
{
  "name": "instagram-nano",
  "version": "${VERSAO}",
  "description": "As 13 skills de Instagram (Reels, legenda, carrossel, stories, perfil, plano da semana, comentários, respostas, direct, reaproveitamento, auditoria, pesquisa de virais e humanizador), adaptadas para português e para a NANO Produtora. Base: instagram-agent-skill de Jake Schincariol (MIT).",
  "author": { "name": "NANO Produtora" },
  "license": "MIT",
  "keywords": ["instagram", "reels", "legenda", "nano", "portugues"]
}
EOF

cat > "$PLUGIN/README.md" <<'EOF'
# instagram-nano

As 13 skills de Instagram em português, para a NANO Produtora.
Comece por: "faz um reel sobre <ideia>" ou "planeja minha semana no Instagram".
A voz da NANO e o histórico ficam no Segundo Cérebro, pasta `instagram/`.
Nada é postado: as skills escrevem, a equipe posta.

Base: https://github.com/Jakeschincariol/instagram-agent-skill (MIT, ver LICENSE).
EOF

mkdir -p "$(dirname "$SAIDA")"
rm -f "$SAIDA"
(cd "$PLUGIN" && zip -qr "$SAIDA" . -x '*.DS_Store')
echo "Plugin pronto: $SAIDA"
