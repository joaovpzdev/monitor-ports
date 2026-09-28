#!/usr/bin/env bash
# Infraestrutura: lê as portas em escuta do sistema.
# Saída normalizada: proto|porta|processo

coletar_portas() {
  ss -H -tulnp 2>/dev/null | awk '
    {
      proto = $1
      porta = $5; sub(/.*:/, "", porta)
      proc = "-"
      if (match($0, /\(\("[^"]+"/)) proc = substr($0, RSTART + 3, RLENGTH - 4)
      print proto "|" porta "|" proc
    }' | sort -u
}