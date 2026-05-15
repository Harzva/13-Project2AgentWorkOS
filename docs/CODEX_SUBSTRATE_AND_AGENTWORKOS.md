# Codex Substrate And AgentWorkOS

## Short Answer

`.codex` is not `AgentWorkOS`.

`.codex` is the local Codex substrate: it stores configuration, sessions, memories, skills, rules, plugins, caches, generated images, auth state, and local databases.

`AgentWorkOS` is the operating layer above it: it decides which Agent roles exist, what memories survive, which skills become reusable, which tools connect, what workflow every project follows, which rules prevent repeated failures, and which hooks enforce execution discipline.

## Local `.codex` Map

| `.codex` area | What it is | Can be open-sourced? | AgentWorkOS relation |
|---|---|---:|---|
| `config.toml` | Local Codex config, trusted projects, plugin marketplace config | No, publish only redacted examples | Runtime configuration |
| `sessions/` and `session_index.jsonl` | Raw conversation/session records | No raw export | Distill into thread summaries and memory rules |
| `memories/` | Durable memory notes | Yes, after removing private paths/secrets | One host for AgentWorkOS Memory |
| `skills/` | Local Codex skills | Yes, when written as portable skills | One host for AgentWorkOS Skills |
| `rules/` | Local allow/deny or execution rules | Yes, when generic and safe | One host for AgentWorkOS Rules |
| `hooks/` or hook config | Lifecycle automation around tool use, permissions, and stop conditions | Yes, only generic audited hooks | One host for AgentWorkOS Hooks |
| `plugins/` and `cache/` | Installed plugin/marketplace code and metadata | Usually no | Tool/runtime substrate |
| `generated_images/` | Generated bitmap assets | Yes, selected outputs only | Visual proof and Agent role identity assets |
| `auth.json`, `accounts/`, sqlite DBs | Credentials and local state | Never | Private runtime state |

## Why This Is More Than `.codex`

`.codex` can store pieces of the system, but it does not answer the higher-level operating questions:

- Which AI co-worker should lead this task?
- Which previous project failure is relevant now?
- Should this thread become memory, a skill, a template, or an archived note?
- Which MCP/tool connections are required for this role?
- What release evidence must exist before calling the project done?
- Which mistakes are hard rules, not optional suggestions?
- Which checks should run automatically before tools, after tools, or before stopping?

Those decisions live in `AgentWorkOS`.

## Practical Boundary

```text
.codex = local substrate
Project2AgentWorkOS = distillation method
AgentWorkOS = reusable human-AI work operating layer
```

## Open-Source Rule

This repository should open-source crystallized content, not private raw state.

Publish:

- distilled Agent role cards
- Memory rules after privacy cleanup
- portable Codex skills
- reusable project/thread/release templates
- hook candidates and audited hook rules
- workflow diagrams and public docs

Do not publish:

- raw session logs
- auth files
- local sqlite databases
- private account config
- absolute machine paths
- token or credential material
