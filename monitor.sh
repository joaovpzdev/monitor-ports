#!/usr/bin/env bash
# Uso: ./monitor.sh --init   → cria/atualiza a baseline com o estado atual
#      ./monitor.sh          → compara o estado atual com a baseline
# Exit code: 0 = sem mudanças | 1 = portas novas | 2 = sem baseline
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"
source config.conf
source lib/coleta.sh
source lib/baseline.sh
source lib/comparador.sh
source lib/notificador.sh

atual=$(coletar_portas)

if [[ "${1:-}" == "--init" ]]; then
  salvar_baseline <<<"$atual"
  echo "Baseline salva em $BASELINE_FILE ($(wc -l <<<"$atual") portas)."
  exit 0
fi

if ! existe_baseline; then
  echo "Sem baseline. Rode: $0 --init" >&2
  exit 2
fi

base=$(ler_baseline)
novas=$(portas_novas "$base" "$atual")
fechadas=$(portas_fechadas "$base" "$atual")

[[ -n "$fechadas" ]] && echo "Portas fechadas desde a baseline (proto|porta):" && echo "$fechadas"

if [[ -n "$novas" ]]; then
  notificar "ALERTA: novas portas em escuta (proto|porta|processo):"$'\n'"$novas"
  exit 1
fi

echo "OK: nenhuma porta nova em relação à baseline."