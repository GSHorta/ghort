#!/bin/sh
# Gera artifact.html: uma cópia self-contained do index.html com todos os
# arquivos de assets/ embutidos em base64. Uso: sh build.sh
set -e

cp index.html build.tmp

# embute só o que o index.html realmente referencia
for n in $(grep -o 'assets/[A-Za-z0-9._/-]*' index.html | sed 's|assets/||' | sort -u); do
  f="assets/$n"
  [ -f "$f" ] || { echo "faltando: $f"; exit 1; }
  case "$n" in
    *.mp4)  mime="video/mp4" ;;
    *.webm) mime="video/webm" ;;
    *.webp) mime="image/webp" ;;
    *.png)  mime="image/png" ;;
    *.jpg|*.jpeg) mime="image/jpeg" ;;
    *) mime="application/octet-stream" ;;
  esac
  printf '%s' "data:$mime;base64,$(base64 -w0 "$f")" > .uri.tmp
  awk -v name="assets/$n" -v urifile=".uri.tmp" '
    BEGIN{ while((getline line < urifile) > 0) uri = uri line }
    { gsub(name, uri); print }' build.tmp > build.tmp2
  mv build.tmp2 build.tmp
done
rm -f .uri.tmp

# num arquivo único o link relativo não resolve: aponta para o site publicado
sed -i 's|href="portfolio.html"|href="https://ghort.com.br/portfolio.html"|' build.tmp

# o artifact é injetado dentro de um body pronto: fora o esqueleto
awk '/<!doctype html>|<html lang|<\/html>|<head>|<\/head>|<meta charset|<meta name="viewport"|<body>|<\/body>/ {next} {print}' build.tmp > artifact.html
rm -f build.tmp

echo "artifact.html gerado ($(du -h artifact.html | cut -f1))"
