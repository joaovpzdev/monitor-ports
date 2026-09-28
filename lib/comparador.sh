#!/usr/bin/env bash
# Domínio: regra pura de comparação (sem I/O externo).
# Chave de comparação = proto|porta (o nome do processo pode variar).

_chaves() { cut -d'|' -f1,2 | sort -u; }

# portas_novas <baseline> <atual> → linhas completas do "atual" ausentes na baseline
portas_novas() {
  local base="$1" atual="$2" chaves
  chaves=$(comm -13 <(_chaves <<<"$base") <(_chaves <<<"$atual"))
  [[ -z "$chaves" ]] && return 0
  grep -F -f <(printf '%s\n' "$chaves" | sed 's/$/|/') <<<"$atual" || true
}

# portas_fechadas <baseline> <atual> → chaves presentes na baseline e ausentes agora
portas_fechadas() {
  comm -23 <(_chaves <<<"$1") <(_chaves <<<"$2")
}