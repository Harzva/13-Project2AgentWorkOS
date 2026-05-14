# 13-Project2AgentWorkOS: Transfer All Projects and Threads into AgentWorkOS

> Turn every project, Codex thread, failure review, half-finished idea, README, codebase, and output asset into a reusable personal AI co-worker work operating system.
>
> 中文定位：把所有项目、Codex 对话、失败复盘和半成品，沉淀、萃取、结丹为 `AgentWorkOS`。

<p align="center">
  <img src="./assets/project2agentworkos-map.png" alt="Project2AgentWorkOS concept map: projects and threads are distilled into AgentWorkOS" width="920" />
</p>

## What This Is

`13-Project2AgentWorkOS` is the repository name. `Project2AgentWorkOS` is the method inside it.

`Project2AgentWorkOS` is not a forced name for "another OS".

It is a method and repository for converting **all real work traces** into `AgentWorkOS`:

| Input | Transfer Process | Output |
|---|---|---|
| Projects | 沉淀 | Agent |
| Codex threads | 萃取 | Memory |
| Failure reviews | 结丹 | Skills |
| Half-finished ideas | OPC loop | MCP |
| README / code / docs | Project cards | Workflow |
| Output assets | Release reviews | Rules |

In one sentence:

```text
Project2AgentWorkOS transfers all projects, threads, failures, and unfinished work into AgentWorkOS: Agents, Memory, Skills, MCP, Workflow, and Rules.
```

## Why It Is Called AgentWorkOS

`AgentWorkOS` means **AI co-worker work operating system**.

It is not an Agent runtime, not a replacement for AgentOS frameworks, and not just a project management note. The `OS` here means a reusable work system with six layers:

| Layer | Meaning |
|---|---|
| Agent | Which AI co-workers should exist |
| Memory | Which experience rules must be remembered |
| Skills | Which repeatable capabilities should be packaged |
| MCP | Which tools and connectors each Agent needs |
| Workflow | How projects move from idea to release |
| Rules | Which mistakes must never repeat |

`Project2AgentWorkOS` is the refinery. `AgentWorkOS` is the operating system produced by that refinery.

## Is This Just Claude Files Or Harness Engineering?

Short answer: no. Claude/Codex files and harness engineering are important parts of the stack, but they are not the whole system.

| Layer | What it does | Example |
|---|---|---|
| Assistant files | Store instructions for one assistant or one repo | `CLAUDE.md`, `AGENTS.md`, Codex memories |
| Harness engineering | Runs agents and tools in a controlled execution environment | CLI, MCP, sandbox, browser, GitHub, shell |
| AgentWorkOS | Defines how all project experience becomes reusable work capability | Agent roles, memory rules, skills, workflows, release gates |

So the boundary is:

```text
Claude/Codex files = where some rules live
Harness engineering = how agents execute work
AgentWorkOS = what the human-AI work system remembers, repeats, forbids, and improves
```

This project uses assistant files and harness tools, but its goal is larger: transfer all projects and threads into a durable work system.

## Core Mission

Most personal AI projects do not fail because of weak ideas. They fail because work traces never become reusable assets:

- Projects start faster than they are closed.
- Threads contain decisions but do not become memory.
- README files improve, but release proof is missing.
- Similar projects repeat instead of merging.
- Agent roles stay implicit, so one AI assistant does everything.
- Failure reviews exist once, then disappear from the next project.

This project makes one rule explicit:

> Every meaningful project and thread must either be archived, published, or distilled into AgentWorkOS.

## Repository Map

| Path | Purpose |
|---|---|
| `README.md` | GitHub homepage and positioning |
| `assets/` | Visual diagrams and README images |
| `docs/` | Failure review, project scans, strategy documents |
| `agents/` | AI co-worker role system |
| `memory/` | Long-term operating rules |
| `templates/` | Repeatable project, thread, release, and weekly review templates |

## Current Artifacts

| Artifact | Status |
|---|---|
| Full workspace failure review | Drafted |
| Codex thread scan summary | Drafted |
| OPC Agent role system | Drafted |
| Long-term memory rules | Drafted |
| Concept map image | Added to README |
| Project card template | Added |
| Thread distillation template | Added |
| Release checklist | Added |
| Weekly review template | Added |

## How To Use

1. Pick one project, thread, or unfinished idea.
2. Fill `templates/PROJECT_CARD.template.md`.
3. Extract decisions with `templates/THREAD_DISTILLATION.template.md`.
4. Convert the output into one or more of the six AgentWorkOS layers.
5. Use `templates/RELEASE_CHECKLIST.md` before publishing.
6. End each week with `templates/WEEKLY_REVIEW.template.md`.

The goal is not to create more documents. The goal is to stop losing useful work.

## The Transfer Rule

```text
All projects + all threads + all failures + all half-finished assets
-> Project2AgentWorkOS
-> AgentWorkOS
-> future projects move faster and repeat fewer mistakes
```

## Near-Term Focus

- Freeze this repository as the main home for the personal AI work system.
- Move the current product workspace review into `docs/`.
- Convert high-frequency failures into `memory/`.
- Convert repeated assistant behaviors into `agents/`.
- Convert repeatable workflows into `templates/` and future `skills/`.
- Publish a clear GitHub README before adding more features.

## Related Documents

- [Workspace Failure Review](./docs/PROJECT_FAILURE_REVIEW_AND_OPC_AGENT_SYSTEM.md)
- [OPC Agent Role System](./agents/OPC_AGENT_ROLE_SYSTEM.md)
- [Long-Term Memory Rules](./memory/OPC_LONG_TERM_MEMORY_RULES.md)
