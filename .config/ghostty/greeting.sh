#!/bin/bash

# ── Banner ──────────────────────────────────────────
figlet -f slant "yafte" | lolcat
echo ""

# ── Fecha ───────────────────────────────────────────
echo "  📅  $(date '+%A, %d %b %Y — %H:%M')" | lolcat
echo ""

# ── Frase aleatoria ─────────────────────────────────
FRASES="$HOME/.config/ghostty/frases.txt"
if [[ -f "$FRASES" ]]; then
    echo "  💬  $(shuf -n 1 "$FRASES")" | lolcat
fi
echo ""

# ── Linear issues ───────────────────────────────────
LINEAR_KEY="${LINEAR_API_KEY}"

QUERY='{"query":"{ issues(filter: { assignee: { isMe: { eq: true } }, state: { type: { nin: [\"completed\",\"cancelled\"] } } }) { nodes { title priority state { name } } } }"}'

RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d "$QUERY")

echo "  📋  Linear — issues abiertos" | lolcat
echo "  ─────────────────────────────" | lolcat

echo "$RESPONSE" | python3 -c "
import sys, json

raw = sys.stdin.read()
data = json.loads(raw)
issues = data.get('data', {}).get('issues', {}).get('nodes', [])

skip = {'Cancelled', 'Canceled', 'Duplicate', 'Done'}
issues = [i for i in issues if i['state']['name'] not in skip]

if not issues:
    print('  ✅  Sin issues pendientes')
else:
    for i in issues:
        p_icons = {0: '  ', 1: '🔴', 2: '🟠', 3: '🟡', 4: '🔵'}
        s_icons = {'In Progress': '🔄', 'To-do': '⬜', 'Backlog': '🗂 '}
        p_icon = p_icons.get(i['priority'], '  ')
        s_icon = s_icons.get(i['state']['name'], '❓')
        print(f\"  {p_icon}  {s_icon}  {i['title'].strip()}\")
"

echo ""
