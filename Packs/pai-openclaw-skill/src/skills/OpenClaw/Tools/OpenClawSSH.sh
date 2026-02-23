#!/bin/bash
# OpenClaw SSH helper for PAI
# Usage: ./OpenClawSSH.sh <command> [args...]
#
# Commands:
#   status                  - Quick service status
#   status-deep             - Deep health check (service + Caddy + agents + Discord)
#   doctor                  - Run diagnostic checks
#   restart                 - Restart service and verify health
#   agents-list             - List configured agents
#   agents-add <id>         - Add new agent
#   agents-delete <id>      - Delete agent
#   config-get [path]       - Get config value (or full config)
#   config-set <key> <val>  - Set config value
#   config-backup           - Create timestamped config backup
#   skills-list             - List installed skills
#   skills-install <name>   - Install skill from ClawHub
#   skills-remove <name>    - Remove installed skill
#   skills-search <query>   - Search ClawHub for skills
#   logs [--tail N]         - Tail recent logs (default 50)
#   logs-errors [--tail N]  - Show only error-level logs
#   journal [timeframe]     - Query journalctl (e.g. "1h", "today")
#   devices-list            - List pending device pairing requests
#   devices-approve <id>    - Approve device pairing request
#   devices-revoke <id>     - Revoke device pairing
#   file-read <path>        - Read remote file contents
#   file-write <path>       - Write stdin to remote file
#   raw <command>           - Run arbitrary SSH command

set -e

HOST="root@24.144.82.75"
CLI="/opt/openclaw-cli.sh"
CONFIG="/home/openclaw/.openclaw/openclaw.json"
AGENTS_DIR="/home/openclaw/.openclaw/agents"

ssh_cmd() {
    ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new "$HOST" "$@"
}

case "$1" in
    status)
        ssh_cmd "systemctl is-active openclaw && echo 'Service: RUNNING' || echo 'Service: STOPPED'"
        ;;
    status-deep)
        ssh_cmd "
            echo '=== OpenClaw Service ==='
            systemctl status openclaw --no-pager -l 2>/dev/null | head -20
            echo ''
            echo '=== Caddy Proxy ==='
            systemctl is-active caddy && echo 'Caddy: RUNNING' || echo 'Caddy: STOPPED'
            echo ''
            echo '=== Dashboard ==='
            curl -s -o /dev/null -w 'Dashboard HTTP %{http_code}' http://127.0.0.1:18789/ 2>/dev/null || echo 'Dashboard: UNREACHABLE'
            echo ''
            echo ''
            echo '=== Config Summary ==='
            if command -v jq &>/dev/null; then
                jq -r '
                    \"Default Model: \" + (.agents.defaults.model.primary // \"not set\"),
                    \"Discord Accounts: \" + ([.channels.discord.accounts // {} | keys[]] | join(\", \")),
                    \"Bindings: \" + ([.routing.bindings[]? | .account + \"→\" + .agent] | join(\", \")),
                    \"Trusted Proxies: \" + ([.gateway.trustedProxies[]?] | join(\", \"))
                ' $CONFIG 2>/dev/null
            else
                cat $CONFIG
            fi
            echo ''
            echo '=== Recent Errors (last 5min) ==='
            journalctl -u openclaw --since '5 min ago' -p err --no-pager -q 2>/dev/null | tail -5 || echo 'No recent errors'
        "
        ;;
    doctor)
        ssh_cmd "
            echo '=== System ==='
            echo \"Uptime: \$(uptime -p)\"
            echo \"Disk: \$(df -h / | tail -1 | awk '{print \$5 \" used\"}')\"
            echo \"Memory: \$(free -h | awk '/Mem:/{print \$3 \"/\" \$2}')\"
            echo ''
            echo '=== Services ==='
            for svc in openclaw caddy; do
                status=\$(systemctl is-active \$svc 2>/dev/null)
                echo \"\$svc: \$status\"
            done
            echo ''
            echo '=== Network ==='
            curl -s -o /dev/null -w 'Dashboard: HTTP %{http_code}\n' http://127.0.0.1:18789/ 2>/dev/null || echo 'Dashboard: UNREACHABLE'
            curl -s -o /dev/null -w 'Public HTTPS: HTTP %{http_code}\n' https://24.144.82.75/ 2>/dev/null || echo 'Public HTTPS: UNREACHABLE'
            echo ''
            echo '=== Config Validation ==='
            if command -v jq &>/dev/null; then
                jq empty $CONFIG 2>&1 && echo 'Config: VALID JSON' || echo 'Config: INVALID JSON'
            fi
            echo ''
            echo '=== Agent Workspaces ==='
            for dir in $AGENTS_DIR/*/; do
                agent=\$(basename \"\$dir\")
                echo -n \"\$agent: \"
                ls \"\$dir\" 2>/dev/null | tr '\n' ' '
                echo ''
            done
        "
        ;;
    restart)
        ssh_cmd "
            systemctl restart openclaw
            sleep 3
            if systemctl is-active openclaw &>/dev/null; then
                echo 'Restart: SUCCESS'
                journalctl -u openclaw --since '10 sec ago' --no-pager -q | tail -5
            else
                echo 'Restart: FAILED'
                journalctl -u openclaw --since '30 sec ago' --no-pager -q | tail -20
            fi
        "
        ;;
    agents-list)
        ssh_cmd "
            echo '=== Configured Agents ==='
            if command -v jq &>/dev/null; then
                jq -r '.routing.bindings[]? | \"Agent: \" + .agent + \" | Channel: \" + .channel + \" | Account: \" + .account' $CONFIG 2>/dev/null
                echo ''
                echo 'Default model: '
                jq -r '.agents.defaults.model.primary // \"not set\"' $CONFIG 2>/dev/null
            fi
            echo ''
            echo '=== Agent Workspaces ==='
            ls -la $AGENTS_DIR/ 2>/dev/null || echo 'No agent workspaces found'
        "
        ;;
    agents-add)
        [[ -z "$2" ]] && echo "Usage: $0 agents-add <agent-id>" && exit 1
        ssh_cmd "mkdir -p $AGENTS_DIR/$2 && echo 'Created workspace: $AGENTS_DIR/$2'"
        ;;
    agents-delete)
        [[ -z "$2" ]] && echo "Usage: $0 agents-delete <agent-id>" && exit 1
        echo "WARNING: This will delete agent workspace $AGENTS_DIR/$2"
        ssh_cmd "rm -rf $AGENTS_DIR/$2 && echo 'Deleted agent workspace: $2'"
        ;;
    config-get)
        if [[ -n "$2" ]]; then
            ssh_cmd "jq '.$2' $CONFIG 2>/dev/null || cat $CONFIG"
        else
            ssh_cmd "cat $CONFIG"
        fi
        ;;
    config-set)
        [[ -z "$2" || -z "$3" ]] && echo "Usage: $0 config-set <key.path> <value>" && exit 1
        ssh_cmd "$CLI config set $2 \"$3\""
        ;;
    config-backup)
        ssh_cmd "
            BACKUP=\"${CONFIG}.backup.\$(date +%Y%m%d-%H%M%S)\"
            cp $CONFIG \"\$BACKUP\"
            echo \"Backup created: \$BACKUP\"
        "
        ;;
    skills-list)
        ssh_cmd "$CLI skills list 2>/dev/null || ls /home/openclaw/.openclaw/skills/ 2>/dev/null || echo 'No skills found'"
        ;;
    skills-install)
        [[ -z "$2" ]] && echo "Usage: $0 skills-install <skill-name>" && exit 1
        ssh_cmd "$CLI skills install $2"
        ;;
    skills-remove)
        [[ -z "$2" ]] && echo "Usage: $0 skills-remove <skill-name>" && exit 1
        ssh_cmd "$CLI skills remove $2"
        ;;
    skills-search)
        [[ -z "$2" ]] && echo "Usage: $0 skills-search <query>" && exit 1
        ssh_cmd "$CLI skills search $2"
        ;;
    logs)
        LINES="${2:---tail 50}"
        if [[ "$2" == "--tail" && -n "$3" ]]; then
            LINES="--tail $3"
        fi
        ssh_cmd "journalctl -u openclaw --no-pager $LINES"
        ;;
    logs-errors)
        LINES="${2:---tail 20}"
        if [[ "$2" == "--tail" && -n "$3" ]]; then
            LINES="--tail $3"
        fi
        ssh_cmd "journalctl -u openclaw -p err --no-pager $LINES"
        ;;
    journal)
        TIMEFRAME="${2:-1h}"
        ssh_cmd "journalctl -u openclaw --since '$TIMEFRAME ago' --no-pager -q"
        ;;
    devices-list)
        ssh_cmd "$CLI devices list"
        ;;
    devices-approve)
        [[ -z "$2" ]] && echo "Usage: $0 devices-approve <request-id>" && exit 1
        ssh_cmd "$CLI devices approve $2"
        ;;
    devices-revoke)
        [[ -z "$2" ]] && echo "Usage: $0 devices-revoke <request-id>" && exit 1
        ssh_cmd "$CLI devices revoke $2"
        ;;
    pairing-approve)
        [[ -z "$2" || -z "$3" ]] && echo "Usage: $0 pairing-approve <channel> <code>" && exit 1
        ssh_cmd "$CLI pairing approve $2 $3"
        ;;
    file-read)
        [[ -z "$2" ]] && echo "Usage: $0 file-read <remote-path>" && exit 1
        ssh_cmd "cat '$2'"
        ;;
    file-write)
        [[ -z "$2" ]] && echo "Usage: $0 file-write <remote-path>" && exit 1
        ssh -o ConnectTimeout=10 "$HOST" "cat > '$2'" < /dev/stdin
        echo "Written to $2"
        ;;
    raw)
        shift
        [[ -z "$1" ]] && echo "Usage: $0 raw <command>" && exit 1
        ssh_cmd "$*"
        ;;
    *)
        echo "OpenClaw SSH Helper for PAI"
        echo ""
        echo "Usage: $0 <command> [args...]"
        echo ""
        echo "Health & Status:"
        echo "  status                  - Quick service status"
        echo "  status-deep             - Deep health check"
        echo "  doctor                  - Full diagnostic"
        echo "  restart                 - Restart and verify"
        echo ""
        echo "Agents:"
        echo "  agents-list             - List agents"
        echo "  agents-add <id>         - Create agent workspace"
        echo "  agents-delete <id>      - Delete agent workspace"
        echo ""
        echo "Configuration:"
        echo "  config-get [path]       - Read config (optional jq path)"
        echo "  config-set <key> <val>  - Set config via CLI"
        echo "  config-backup           - Timestamped backup"
        echo ""
        echo "Skills (ClawHub):"
        echo "  skills-list             - List installed skills"
        echo "  skills-install <name>   - Install skill"
        echo "  skills-remove <name>    - Remove skill"
        echo "  skills-search <query>   - Search ClawHub"
        echo ""
        echo "Logs:"
        echo "  logs [--tail N]         - Recent logs (default 50)"
        echo "  logs-errors [--tail N]  - Error-level only"
        echo "  journal [timeframe]     - Query by timeframe (1h, today)"
        echo ""
        echo "Devices & Pairing:"
        echo "  devices-list            - List pairing requests"
        echo "  devices-approve <id>    - Approve device"
        echo "  devices-revoke <id>     - Revoke device"
        echo "  pairing-approve <ch> <code> - Approve Discord/channel pairing"
        echo ""
        echo "Files:"
        echo "  file-read <path>        - Read remote file"
        echo "  file-write <path>       - Write stdin to remote file"
        echo "  raw <command>           - Run arbitrary SSH command"
        ;;
esac
