# ManageSkills Workflow

Install, remove, list, and search skills from ClawHub for OpenClaw agents.

## Voice Notification

```bash
curl -s -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message": "Running the ManageSkills workflow in the OpenClaw skill to manage ClawHub skills"}' \
  > /dev/null 2>&1 &
```

Running the **ManageSkills** workflow in the **OpenClaw** skill to manage ClawHub skills...

## Operations

### List Installed Skills
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh skills-list
```

### Search ClawHub
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh skills-search <query>
```

### Install Skill
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh skills-install <skill-name>
```

### Remove Skill
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh skills-remove <skill-name>
```

## Known Available Skills

| Skill | Description |
|-------|-------------|
| `skill-creator` | Create custom skills (may be pre-installed) |
| `clawhub` | Install community skills on the fly |
| `github` | Manage repos, issues, PRs from Discord |
| `coding-agent` | Run code tasks in background |
| `blogwatcher` | Monitor RSS feeds, get notified in Discord |
| `bird` | X/Twitter social media monitoring |
| `gemini` | Second model for specific tasks |
| `1password` | Secure credential access |

## Skill Architecture

Each skill is a markdown file that teaches the agent how to use a specific CLI tool or capability. Skills are:
- Self-contained and reusable
- Independently invokable by agents
- Stored in `/home/openclaw/.openclaw/skills/`

## After Installing

Some skills may require:
1. Additional API keys in `/opt/openclaw.env`
2. Service restart for activation
3. Agent configuration to enable the skill
