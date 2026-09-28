#!/usr/bin/env bash
# Infraestrutura: saídas de alerta (terminal, log e webhook opcional).

notificar() {
  local msg="$1" ts
  ts=$(date '+%Y-%m-%d %H:%M:%S')
  mkdir -p "$(dirname "$LOG_FILE")"
  printf '[%s] %s\n' "$ts" "$msg" | tee -a "$LOG_FILE"
  if [[ -n "${WEBHOOK_URL:-}" ]]; then
    curl -s -m 5 -X POST -H 'Content-Type: application/json' \
      -d "{\"text\": \"$(printf '%s' "$msg" | tr '\n' ' ')\"}" "$WEBHOOK_URL" >/dev/null || true
  fi
}