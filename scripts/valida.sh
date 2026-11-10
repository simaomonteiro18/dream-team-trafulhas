#!/usr/bin/env bash
# Valida as fichas de seleção do dream-team.
# Uso: bash scripts/valida.sh   (corre na raiz do repositório)

shopt -s nullglob
fichas=(selecoes/*.md)

if [ ${#fichas[@]} -eq 0 ]; then
  echo "::error::Não encontrei fichas em selecoes/*.md"
  exit 1
fi

erros=0
for f in "${fichas[@]}"; do
  # linha de jogador: número, posição com 2 letras maiúsculas e um nome
  jogadores=$(grep -cE '^[[:space:]]*[0-9]+[[:space:]]+[A-Z]{2}[[:space:]]+[^[:space:]]' "$f")
  gr=$(grep -cE '^[[:space:]]*[0-9]+[[:space:]]+GR[[:space:]]+[^[:space:]]' "$f")

  if [ "$jogadores" -ne 11 ]; then
    echo "::error file=$f::$f tem $jogadores jogadores (esperado: 11)"
    erros=$((erros + 1))
  fi

  if [ "$gr" -ne 1 ]; then
    echo "::error file=$f::$f tem $gr guarda-redes (esperado: 1)"
    erros=$((erros + 1))
  fi

  for campo in "Aluno:" "Treinador:" "Capitão:"; do
    if ! grep -qE "^[[:space:]]*$campo[[:space:]]*[^[:space:]]" "$f"; then
      echo "::error file=$f::$f não tem o campo $campo preenchido"
      erros=$((erros + 1))
    fi
  done

  echo "$f: $jogadores jogadores, $gr guarda-redes"
done

if [ "$erros" -gt 0 ]; then
  echo "Encontrei $erros erro(s)."
  exit 1
fi

echo "Todas as seleções estão válidas."
