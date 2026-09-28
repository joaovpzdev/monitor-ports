#!/usr/bin/env bash
# Infraestrutura: persistência da baseline em arquivo.

salvar_baseline() { mkdir -p "$(dirname "$BASELINE_FILE")"; cat > "$BASELINE_FILE"; }
ler_baseline()    { cat "$BASELINE_FILE"; }
existe_baseline() { [[ -f "$BASELINE_FILE" ]]; }