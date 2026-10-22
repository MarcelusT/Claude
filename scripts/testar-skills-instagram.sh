#!/usr/bin/env bash
# Confere as ferramentas das skills de Instagram (ig-*) em português e em inglês.
# Uso: bash scripts/testar-skills-instagram.sh
set -u

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
SK="$RAIZ/.claude/skills"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
falhas=0

confere() {   # confere "descrição" "texto esperado" "saída"
  if printf '%s' "$3" | grep -qF -- "$2"; then
    echo "ok    $1"
  else
    echo "FALHA $1 (esperava: $2)"
    falhas=$((falhas + 1))
  fi
}

nota() {      # nota "gancho" -> nota do hookscore
  python3 -I "$SK/ig-reel/hookscore.py" --hook "$1" --json \
    | python3 -c 'import json,sys; print(json.load(sys.stdin)["score"])'
}

# Ganchos: o português tem de pontuar como o inglês equivalente.
confere "gancho PT 'Ninguém te conta' é forte" "85.6" \
  "$(nota 'Ninguém te conta que o evento começa três dias antes da festa.')"
confere "gancho EN 'Nobody tells you' segue igual" "85.6" \
  "$(nota 'Nobody tells you that your first 30 reels are supposed to flop')"
confere "saudação 'Oi gente' é barrada" "Greeting" \
  "$(python3 -I "$SK/ig-reel/hookscore.py" --hook 'Oi gente, hoje vou falar de eventos')"
confere "'Para de rolar' é barrado" "para de rolar" \
  "$(python3 -I "$SK/ig-reel/hookscore.py" --hook 'Para de rolar o feed se você é do marketing')"

# Folha de tempos: acento não quebra a palavra.
printf 'Ninguém te conta que o evento começa três dias antes.\nÀs 20h, setecentas pessoas entraram.\n' > "$TMP/roteiro.txt"
confere "beats conta 'começa' como uma palavra" "15 words" \
  "$(python3 -I "$SK/ig-reel/beats.py" "$TMP/roteiro.txt")"

# Legenda: pedido em português e hashtag com acento.
printf 'Às 7h o salão estava vazio. Às 20h, 700 pessoas.\n\nComenta BASTIDOR que eu te mando o checklist.\n\n#produçãodeeventos\n' > "$TMP/legenda.txt"
saida="$(python3 -I "$SK/ig-caption/caption.py" "$TMP/legenda.txt")"
confere "legenda reconhece 'Comenta BASTIDOR'" "comment a keyword" "$saida"
confere "legenda lê hashtag com acento" "#produçãodeeventos" "$saida"
printf 'Dois eventos na mesma casa.\n\nSe o seu evento tem duas salas, chama a gente no direct.\n' > "$TMP/legenda2.txt"
confere "legenda reconhece 'chama a gente no direct'" "DM me" \
  "$(python3 -I "$SK/ig-caption/caption.py" "$TMP/legenda2.txt")"

# Humanizador: troca em português, sem inglês no meio, sem pontuação solta.
printf 'Para de rolar o feed! É crucial elevar o nível do seu evento. Marca alguém que precisa ver isso!\n' > "$TMP/ruim.txt"
limpo="$(python3 -I "$SK/ig-human/humanize.py" "$TMP/ruim.txt")"
confere "humaniza 'crucial' em português" "importante" "$limpo"
confere "humaniza 'elevar o nível do'" "melhorar o seu evento" "$limpo"
if printf '%s' "$limpo" | grep -qE '^[!?]|\.!'; then
  echo "FALHA humanizador deixou pontuação solta: $limpo"; falhas=$((falhas + 1))
else
  echo "ok    humanizador sem pontuação solta"
fi
printf 'It is crucial to leverage this hack.\n' > "$TMP/en.txt"
confere "humanizador em inglês segue em inglês" "important to use this trick" \
  "$(python3 -I "$SK/ig-human/humanize.py" "$TMP/en.txt")"

# Fórmulas: todo exemplo em português cai na própria fórmula.
confere "26 exemplos em português classificados" "0 erros" "$(python3 -I - "$SK/ig-reel/hooks.json" <<'PY'
import json, re, sys
d = json.load(open(sys.argv[1], encoding="utf-8"))
by = {h["id"]: h for h in d["hooks"]}
erros = 0
for h in d["hooks"]:
    got = next((i for i in d["classify_order"]
                if re.search(by[i]["match"], h["example_pt"], re.I)), None)
    erros += got != h["id"]
print(f"{erros} erros")
PY
)"

echo
if [ "$falhas" -eq 0 ]; then echo "Tudo certo."; else echo "$falhas falha(s)."; fi
exit "$falhas"
