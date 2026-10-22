# Claude da NANO

Ferramentas do Claude para a NANO Produtora. Por enquanto, um pacote: **as 13 skills de Instagram em português**.

## Skills de Instagram (`instagram-nano`)

Base: [instagram-agent-skill](https://github.com/Jakeschincariol/instagram-agent-skill), de Jake Schincariol (licença MIT, cópia em `licencas/`).
Adaptadas para português e para a NANO.

| Peça | O que faz | Como pedir |
|------|-----------|------------|
| `ig-reel` | Roteiro de Reels: 3 ganchos com nota, roteiro, texto na tela e tempo de cada trecho | "faz um reel sobre…" |
| `ig-caption` | Legenda: mostra o que aparece antes do "… mais", confere pedido, hashtags (máx. 5) e termos de busca | "escreve a legenda" |
| `ig-carousel` | Carrossel: capa, um slide por ideia, resumo e pedido final | "faz um carrossel" |
| `ig-story` | Sequência de stories do dia e qual figurinha usar | "stories de hoje" |
| `ig-plan` | Plano da semana: o que postar, formato, horário e com quem interagir | "planeja minha semana no Instagram" |
| `ig-viral` | Pesquisa o que está funcionando no nicho e monta um arquivo de referências | "o que está funcionando no nicho" |
| `ig-audit` | Analisa o que já foi postado e diz o que repetir e o que parar | "analisa meus posts" |
| `ig-profile` | Nota do perfil de 0 a 100 e reescrita da bio, destaques e fixados | "melhora meu perfil" |
| `ig-comment` | Comentários em posts de outras contas | "o que eu comento aqui" |
| `ig-reply` | Respostas aos comentários dos nossos posts | "responde esses comentários" |
| `ig-dm` | Mensagens no direct e os dois follow-ups | "o que eu mando pra ele" |
| `ig-repurpose` | Transforma um vídeo, palestra ou cobertura em uma semana de posts | "reaproveita esse conteúdo" |
| `ig-human` | Tira a cara de IA do texto e dá uma nota de "humano" | "humaniza esse texto" |

**Nada é postado.** As skills escrevem; a equipe posta.

### O que mudou em relação ao original

- As ferramentas Python agora entendem português: acentos ("começa" é uma palavra), "R$ 18 mil", números por extenso ("três", "setecentas"), "Oi gente" e "para de rolar o feed" barrados, "Comenta EVENTO" como pedido, hashtags com acento.
- O humanizador ganhou uma lista de expressões "de IA" em português e sinaliza clichês de evento ("momentos inesquecíveis", "experiência única"). Em texto em português ele não troca nada por palavras em inglês.
- As 26 fórmulas de gancho reconhecem ganchos em português e têm exemplos de evento.
- Cada skill sabe que a voz da NANO e o histórico ficam no Segundo Cérebro (pasta `instagram/`).
- Em inglês tudo continua dando o mesmo resultado do original.

### Onde instalar

- **Neste repositório (Claude Code):** já está instalado em `.claude/skills/`.
- **Nos Macs (Claude Code):** `/plugin marketplace add MarcelusT/Claude` e depois `/plugin install instagram-nano@nano`.
- **No Cowork / app do Claude:** gere o arquivo com `bash scripts/empacotar-plugin-instagram.sh` e abra o `dist/instagram-nano.plugin` no Cowork.

### Conferir depois de mexer

```bash
bash scripts/testar-skills-instagram.sh
```

Este repositório é **público**. Voz, cases de clientes e números ficam no Segundo Cérebro (Dropbox), nunca aqui.
