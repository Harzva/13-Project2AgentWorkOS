# Hooks And AgentWorkOS

Hook is not "more standard than Skill" in an absolute sense. They live at different layers.

```text
Skill = knowledge standard
Hook = execution standard
```

Skill tells an agent what to do for a class of tasks. Hook tells the system what must happen at a lifecycle point.

## Why Hooks Belong In AgentWorkOS

AgentWorkOS should not only preserve what the agent knows. It should also preserve what the agent reliably does.

That is why the model is now:

```text
AgentWorkOS = Agents + Memory + Skills + MCP + Workflow + Rules + Hooks
```

In one sentence:

> Hook is the key layer that moves AgentWorkOS from a knowledge system toward an execution system.

## Layer Boundary

| Layer | What it standardizes | Example |
| --- | --- | --- |
| Agent | Who owns the work | `release-manager` owns GitHub publish proof |
| Memory | What experience must survive | Windows Node commands should prefer `.cmd` shims when `.ps1` is blocked |
| Skills | How to perform a professional task | Generate README screenshots and GIFs |
| MCP | Which tools are connected | GitHub, browser, calendar, filesystem tools |
| Workflow | How work moves across stages | Project card -> implementation -> release checklist -> review |
| Rules | What must not be violated | Do not publish private Codex raw state |
| Hooks | What must run automatically at lifecycle points | Before stop, check whether modified tutorials updated `index.md` and `log.md` |

## Hook Candidates

These are hook-ready rules discovered from this workspace. They may live first as docs/rules, then become real hooks when the local runtime supports them safely.

| Lifecycle point | Hook candidate | Why it matters |
| --- | --- | --- |
| PreToolUse | Block or warn on destructive git/file commands without explicit target verification | Prevent accidental loss of user work |
| PreToolUse | On Windows, prefer `npx.cmd` / `npm.cmd` when PowerShell `.ps1` launchers are likely to be blocked | Avoid recurring execution-policy failures |
| PostToolUse | After README edits, verify referenced images/GIFs exist | Prevent broken GitHub presentation |
| PostToolUse | After tutorial edits, verify `index.md` and `log.md` were updated when needed | Keep the knowledgebase navigable |
| Stop | If a git repo has a remote and user asked to publish, check commit/push status | Close the release loop |
| Stop | If a repeated failure or useful process appeared, prompt extraction into Memory, Skill, Workflow, Rule, or Hook | Prevent lessons from staying only in the thread |

## What Should Not Become A Hook

Hooks are powerful and broad. Do not put everything into them.

- Do not put long domain teaching inside hooks. Use Skills.
- Do not put vague opinions inside hooks. Use Rules or Memory first.
- Do not run high-risk shell commands from hooks without review.
- Do not create hooks that silently modify unrelated repositories.
- Do not use hooks as a replacement for clear workflow docs.

## Promotion Rule

A rule is ready to become a Hook when all are true:

1. It applies across many tasks, not one project.
2. Forgetting it repeatedly causes real failure or rework.
3. It can be checked or executed with low ambiguity.
4. It has a safe failure mode, such as warning, blocking, or asking for confirmation.
5. It can be documented in public without exposing secrets.

## Relationship To Skills

The healthy split is:

```text
Skill makes the agent capable.
Hook makes the agent disciplined.
```

For example:

- `readme-showcase-screenshot` is a Skill: it knows how to capture screenshots, GIFs, and README visual proof.
- A README asset verification Hook is execution discipline: it checks every README change for missing image paths before the task ends.

AgentWorkOS needs both.
