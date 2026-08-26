# ghort

Site one page do Ghort Estúdio Criativo.

A página é um quadro só: a abertura animada do estúdio em loop, com o logotipo,
o personagem 3D e a assinatura. Nav e ícones sociais são interativos por cima do filme.

**No ar:** https://ghort.com.br

## Estrutura

```
index.html          a página inteira (HTML, CSS e JS num arquivo só)
assets/
  hero.webm         filme em WebM/VP9 1080p — formato principal
  hero.mp4          mesmo filme em H.264 720p — reserva para navegadores sem VP9
  hero-poster.webp  quadro parado, exibido antes do vídeo carregar
  favicon-32.png    ícone da aba (o "g" branco, fundo transparente)
  favicon-512.png   ícone em alta
  favicon-180.png   atalho do iOS (fundo preto: o iOS ignora transparência)
build.sh            gera artifact.html, cópia self-contained com tudo embutido
```

Não há build step. É HTML estático — a Vercel serve a pasta como está.

## Como o filme foi preparado

O master é `SITE_01.mp4` (1920×1080, 24fps, 13,7 MB). Dele saiu o `hero.webm`:

1. **Blob de cor e ícones sociais apagados.** Estavam queimados no vídeo. Antes de
   apagar, os 436 frames foram varridos para confirmar que nada mais passa por
   aquelas regiões. Os ícones voltaram como SVG no `index.html`, o que permitiu
   incluir o terceiro (Behance) com o mesmo peso e espaçamento dos outros.
2. **Fade-out removido.** O master escurece a partir do frame 424; em loop isso
   piscaria a cada volta.
3. **Espera de 4s no início.** A página abre com o logotipo parado; a animação
   começa depois. O quadro parado saiu do frame 0 com a região do personagem apagada.
4. **Loop fechado.** Os últimos 0,6s fazem crossfade de volta ao mesmo quadro
   parado do início, então a volta do loop é contínua.
5. **Codificação.** VP9 a CRF 36 preservou a microtextura do render melhor que o
   AV1 no mesmo peso. 13,7 MB → 1,0 MB.

## Coordenadas

Nav, ícones e áreas clicáveis são posicionados em porcentagem sobre um palco de
proporção 16:9, com os valores medidos no quadro original de 1920×1080. Mexer no
enquadramento do filme exige refazer essas medidas.

Em telas estreitas o texto queimado no filme ficaria ilegível: ele é coberto por
faixas pretas e reescrito em HTML (Poppins), ancorado no topo e na base da tela.

## Editar

Mexa em `index.html` e nos arquivos de `assets/`. Para gerar a versão de arquivo
único, com imagens e vídeo embutidos em base64:

```sh
sh build.sh
```

`artifact.html` é derivado e fica fora do controle de versão.

## Pendências

- Destino dos links **Portifólio** e **Sobre** (hoje `href="#"`).
