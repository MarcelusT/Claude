# Repositório "Claude" da NANO Produtora

Fale com o Marcelus em português do Brasil, simples e curto.

- O contexto da NANO (pessoas, clientes, marca, NCC, decisões) está no **Segundo Cérebro**:
  Dropbox `/Claude/NCC/Segundo Cerebro` (comece pelo `CLAUDE.md` de lá).
- Este repositório é **público**: nada de dados de clientes, valores, cachês, telefones, links com chave
  ou senhas aqui. A voz da NANO e os números reais ficam no Segundo Cérebro.

## Skills de Instagram (`.claude/skills/ig-*`)

- Adaptação para português da instagram-agent-skill (MIT). Ver `README.md`.
- A memória do Instagram (voz, histórico, pesquisa, plano) fica no Segundo Cérebro, pasta `instagram/`.
- Depois de mexer em qualquer `.py` ou `.json` das skills: `bash scripts/testar-skills-instagram.sh`.
- Para o Cowork: `bash scripts/empacotar-plugin-instagram.sh` gera `dist/instagram-nano.plugin`.
- Nada é postado no Instagram pelas skills. Elas escrevem; a equipe posta.
