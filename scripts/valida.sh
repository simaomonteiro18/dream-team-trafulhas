#!/usr/bin/env bash
erros=0

for ficha in selecoes/*.md; do
  jogadores=$(grep -cE '^[0-9]+[[:space:]]+[A-Z]{2}[[:space:]]+.+' "$ficha")
  if [ "$jogadores" -ne 11 ]; then
    echo "::error file=$ficha::Tem $jogadores jogadores, devia ter 11"
    erros=1
  fi

  gr=$(grep -cE '^[0-9]+[[:space:]]+GR[[:space:]]+.+' "$ficha")
  if [ "$gr" -ne 1 ]; then
    echo "::error file=$ficha::Tem $gr guarda-redes, devia ter exatamente 1"
    erros=1
  fi

  for campo in Aluno Treinador Capitão; do
    if ! grep -qE "^${campo}:[[:space:]]*[^[:space:]]+" "$ficha"; then
      echo "::error file=$ficha::Campo '$campo' em falta ou vazio"
      erros=1
    fi
  done
done

if [ "$erros" -ne 0 ]; then
  exit 1
fi

echo "Todas as seleções estão válidas"
exit 0
