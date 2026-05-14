---
name: project2agentworkos
description: Use when converting projects, Codex threads, failure reviews, half-finished ideas, README/code/output assets, or repeated workflow problems into AgentWorkOS assets: Agent roles, Memory rules, Skills, MCP/tool needs, Workflows, and hard Rules. Also use when selecting an Agent role before a task or integrating distilled content into local Codex.
---

# Project2AgentWorkOS

Project2AgentWorkOS turns real work traces into a reusable AgentWorkOS.

## Core Rule

Do not only summarize. Extract future operating capability.

```text
projects + threads + failures + half-finished work
-> Project2AgentWorkOS
-> AgentWorkOS
-> Agent + Memory + Skills + MCP + Workflow + Rules
```

## Workflow

1. Select a primary role from the Agent role library before executing.
2. If risk is high, select a verifier role.
3. Inspect the project/thread/file evidence.
4. Classify the work: Active / Watch / Archive / Reference.
5. Extract into the six AgentWorkOS layers.
6. Create or update a durable artifact: role card, memory, skill, checklist, template, release proof, or rule.
7. Avoid raw private exports. Publish distilled content only.

## Role Selection

Use this default mapping:

| Task | Primary role | Verifier |
|---|---|---|
| Workspace scan | Project Scout | Quality Auditor |
| Thread to memory | Memory Curator | Product Alchemist |
| Codex integration | Codex Integrator | Quality Auditor |
| GitHub release | Release Captain | Quality Auditor |
| Agent role design | Agent Architect | Product Alchemist |

## Completion Gate

A Project2AgentWorkOS task is incomplete until at least one of these exists:

- a role card
- a memory rule
- a reusable skill
- an MCP/tool requirement
- a workflow/checklist/template
- a hard rule
- public release evidence
- an explicit archive decision

## References

- Read `references/agent-selection.md` when role choice is non-obvious.
- Read `references/codex-substrate.md` when the task involves local `.codex` usage or privacy boundaries.

