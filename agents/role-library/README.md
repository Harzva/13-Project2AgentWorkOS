# Agent Role Library

This library turns AgentWorkOS from a document collection into a task-time role selection system.

Before a task starts, pick the role or role pair that best matches the work. The selected role defines the stance, evidence standard, output shape, and tools to prefer.

## Selection Protocol

1. Read the user request and identify the main job type.
2. Select one primary role from the library.
3. Select one verifier role when the work has public, financial, architectural, or release risk.
4. State the selected role briefly before execution.
5. Execute the task using that role's standards.
6. End by extracting any new Agent, Memory, Skill, MCP, Workflow, Rule, or Hook.

## Role Library

| Avatar | Role ID | Chinese name | Best for | Visual identity |
|---|---|---|---|---|
| <img src="../../assets/agent-portraits/project-inventory.svg" width="48" /> | `project-inventory` | 项目盘点员 | Workspace scans, project inventory, status discovery | Inventory and status table |
| <img src="../../assets/agent-portraits/project-alchemist.svg" width="48" /> | `project-alchemist` | 项目结丹师 | Project summary, review, reflection, and automatic upgrade into AgentWorkOS assets | Scientist / seven-layer crystallization |
| <img src="../../assets/agent-portraits/role-planner.svg" width="48" /> | `role-planner` | 角色规划员 | Designing role responsibilities and collaboration rules | Role table and routing rules |
| <img src="../../assets/agent-portraits/memory-rule-manager.svg" width="48" /> | `memory-rule-manager` | 记忆规则整理员 | Extracting durable rules from failures and threads | Memory rule card |
| <img src="../../assets/agent-portraits/codex-setup.svg" width="48" /> | `codex-setup` | Codex 配置员 | Installing skills, memories, rules into `.codex` | Install path and privacy check |
| <img src="../../assets/agent-portraits/release-manager.svg" width="48" /> | `release-manager` | 发布负责人 | GitHub publish, README proof, release gates | Release checklist |
| <img src="../../assets/agent-portraits/quality-reviewer.svg" width="48" /> | `quality-reviewer` | 质量检查员 | Fighting hype, checking proof, finding gaps | Evidence checklist |

## Default Role Pairings

| Task | Primary role | Verifier role |
|---|---|---|
| Scan all projects | `project-inventory` | `quality-reviewer` |
| Convert a thread into memory | `memory-rule-manager` | `project-alchemist` |
| Build a reusable skill | `codex-setup` | `quality-reviewer` |
| Publish a GitHub repo | `release-manager` | `quality-reviewer` |
| Define new Agent roles | `role-planner` | `project-alchemist` |
| Run Project2AgentWorkOS on a project | `project-alchemist` | `memory-rule-manager` |

## Important Rule

The role library is not decoration. A role must change how the agent works: what it asks first, what evidence it checks, what output it produces, and what it refuses to call done.
