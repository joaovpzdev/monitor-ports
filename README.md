# Monitor de Portas Abertas

![Bash Script](https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

Compara as portas em escuta (`ss -tulnp`) com uma baseline e alerta sobre portas **novas**. Bash organizado em camadas (clean architecture aplicada a shell script).

## Estrutura

```
monitor_ports/
├── monitor.sh          # Entrypoint (orquestra os módulos)
├── config.conf         # Caminhos e webhook opcional
└── lib/
    ├── comparador.sh   # DOMÍNIO: regra pura de comparação (sem I/O)
    ├── coleta.sh       # INFRA: lê portas via ss e normaliza (proto|porta|processo)
    ├── baseline.sh     # INFRA: persistência da baseline em arquivo
    └── notificador.sh  # INFRA: alerta em terminal, log e webhook (Slack)
```

## Uso

```bash
./monitor.sh --init   # cria a baseline com o estado atual (faça num momento "limpo")
./monitor.sh          # compara o estado atual com a baseline
sudo ./monitor.sh     # com sudo o ss mostra o nome dos processos de todos os usuários
```

Exit code: `0` sem mudanças · `1` portas novas · `2` sem baseline (útil para cron/automação).

## Exemplo de saída

```
[2026-09-28 12:51:11] ALERTA: novas portas em escuta (proto|porta|processo):
tcp|4444|nc
```

## Rodando periodicamente (cron)

```bash
*/5 * * * * /caminho/para/monitor_portas/monitor.sh >/dev/null 2>&1
```

Os alertas ficam em `data/monitor.log`. Para receber no Slack, preencha `WEBHOOK_URL` no `config.conf`.

## Notas

- A comparação usa `proto|porta`; IPv4 e IPv6 da mesma porta contam como uma só.
- Após mudanças legítimas (novo serviço instalado), rode `--init` para atualizar a baseline.
- Use apenas em máquinas que você administra.