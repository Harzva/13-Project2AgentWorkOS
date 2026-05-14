# 项目失败经验复盘与 OPC 超级个体 Agent 工作流

生成日期：2026-05-14  
扫描根目录：`<product-workspace>`  
关联提示词：`PROJECT_FAILURE_REVIEW_OPC_AGENT_PROMPT.md`、`WORKSPACE_TO_OS_REVIEW_PROMPT.md`  
配套沉淀：`1.1agent/OPC_AGENT_ROLE_SYSTEM.md`、`1.2memory/OPC_LONG_TERM_MEMORY_RULES.md`

## 1. 扫描摘要

这次扫描覆盖了当前产品目录下的项目文件夹、README、计划文档、代码结构、Git 工作树、GitHub Actions、全局 Codex 记忆和历史 prompt 片段。重点不是证明“做了很多”，而是找出为什么很多项目会停滞、重复、跑偏、过度设计、没有发布或没有沉淀。

关键事实：

| 指标 | 扫描结果 | 暴露的问题 |
|---|---:|---|
| 可扫描项目文件 | 约 26,177 个 | 产出量很高，但信息分散 |
| Markdown 文档 | 2,115 个 | 方案、计划、README 很多，但缺统一状态入口 |
| Git 工作树 | 70 个 | 项目数量已经超过人工记忆容量 |
| GitHub workflow | 88 个 | 发布意识强，但质量闸门不统一 |
| Codex session jsonl | 54 个 / 约 343 MB | thread 记录数量已经很大，需要摘要索引而不是靠记忆找 |
| Codex 用户消息 | 346 条 | 需求主题高度集中在仓库发布、README、Pages、技能、移动端和复盘 |
| Codex Assistant 消息 | 2,415 条 | Agent 产出很多，但需要统一沉淀到仓库文件和长期规则 |
| `PROJECT_CARD.md` | 0 个 | 没有项目级状态卡片，导致反复“重新理解项目” |
| `01-skills/1.1agent` | 空 | 已意识到需要 Agent 体系，但没有落地角色库 |
| `01-skills/1.2memory` | 空 | 已意识到需要记忆规则，但经验没有沉淀为可复用规则 |
| Codex 全局记忆 | 仅有 Windows Node CLI shim 规则 | 真实踩坑很多，但进入长期记忆的很少 |

总体判断：

- 你不是缺项目、缺想法、缺执行热情，也不是缺 Agent 能力。
- 真正的漏洞是：项目启动快，闭环慢；文档产出快，状态沉淀慢；仓库创建快，发布、分发、复盘慢。
- 未来必须把工作流从“灵感驱动”改成“OPC 闭环驱动”：Observe 判断机会，Produce 做最小交付，Circulate 发布分发并沉淀记忆。

### Codex Thread 记录补扫说明

第一次扫描主要使用了 `.codex-global-state.json` 中的 prompt-history 和当前可见对话记忆。随后补扫了完整 Codex thread/session 记录：

```text
<codex-home>\sessions
<codex-home>\session_index.jsonl
```

补扫结果显示，Codex 线程不是零散聊天，而是已经形成了明确的项目群：

| Thread 主题 | 反复出现的需求 | 对复盘结论的影响 |
|---|---|---|
| `learn-cc` | 生产级优化、仿真器、GitHub Pages、每轮继续迭代 | 强化“全面优化必须有本轮边界” |
| `just-ddl` / `just-series` | 专题仓库矩阵、crawler、validator、link-check、期刊 CFP | 强化“先跑通真实数据链路再扩专题” |
| `catop` | LiteLLM 接入、cache hit 统计、README、Pages、跨平台包 | 强化“聚焦单一指标的项目最值得推进” |
| `RepoAtlas` | 多账号 GitHub、本地仓库、Issues/PR/Releases/Pages 详情 | 强化“本地-线上仓库协同是核心基础设施” |
| `gitmarket` | Release 市场、多端预览、Actions 构建、移动端预览 | 强化“多端路线要收敛主线” |
| `MobileCode` | 移动端 AI coding workspace、Flutter/Android/iOS 缺口 | 强化“愿景大时先选一个 MVP 平台” |
| `所有仓库分发` | GitHub push、账号 router、Actions、README、Pages | 强化“GitHub 发布需要专门技能和 SOP” |
| `screen` / README 展示 | 截图、GIF、README showcase skill | 强化“视觉证据是发布质量闸门” |
| `google-design` | DESIGN.md、design-md-flow、设计工作流 | 强化“设计规范应沉淀为 skill，而不是临时提示词” |
| `记忆` | Windows npx.cmd、Project2AgentWorkOS、本次复盘 | 强化“同类经验第二次出现必须进入 Memory” |

补扫后的结论没有推翻原文，反而更明确：你的 thread 记录里最大的问题不是缺行动，而是行动太多以后没有稳定进入 `PROJECT_CARD`、`Memory`、`Skill`、`Checklist` 和 `发布资产`。

## 2. 仓库新命名建议

`WORKSPACE_TO_OS_REVIEW` 的问题是太抽象，像内部操作名，不像一个能被开发者理解和搜索的仓库名。`ProjectLoopOS` 虽然强调了项目闭环，但还不够准确：我们真正要表达的不是“一个项目管理工具”，而是“从项目、对话、失败经验和半成品中沉淀、萃取、结丹出个人 Agent 工作操作系统”的过程。

因此这里要分清两层：

| 层级 | 推荐名称 | 含义 |
|---|---|---|
| 萃取过程 / 仓库名 | `Project2AgentWorkOS` | 从项目资产中提炼出 Agent、Memory、Skills、MCP、Workflow、Rules |
| 最终系统 / 产物名 | `AgentWorkOS` | 个人 AI 工友工作操作系统 |
| 子工作流模块 | `ProjectLoop` | 项目从启动、交付、发布、复盘到记忆沉淀的闭环 |

最推荐的新仓库名：

```text
Project2AgentWorkOS
```

中文名：

```text
项目炼成 Agent 工作操作系统
```

一句话定位：

```text
Project2AgentWorkOS 是一套把散乱项目、历史对话、失败经验和半成品，结丹为 Agent、Memory、Skills、MCP、Workflow 和 Rules 的个人 AI 工作系统生成方法。
```

推荐原因：

- `Project2` 直接表达输入：历史项目、半成品、README、代码、thread、output。
- `AgentWorkOS` 直接表达输出：不是普通复盘，而是形成可运行的 AI 工友系统。
- 名字强调“沉淀 / 萃取 / 结丹”的过程：先把混乱经验落盘，再提炼结构，最后炼成可复用的长期资产。
- `ProjectLoop` 可以保留为 Workflow 模块，但不再承担总仓库名。

备选名：

| 名称 | 适合度 | 说明 |
|---|---:|---|
| `Project2AgentWorkOS` | 最高 | 最能表达“从项目萃取出 Agent 工作系统” |
| `Project-to-AgentWorkOS` | 高 | 更正式，适合方法论文档标题 |
| `AgentWorkOS` | 高 | 适合最终系统名，但弱化萃取过程 |
| `ProjectAlchemyOS` | 中高 | 有“炼丹/萃取”意味，但工程搜索性弱一点 |
| `ProjectMemoryForge` | 中 | 强调把项目记忆锻造成规则和资产 |
| `ProjectLoopOS` | 中 | 强调闭环，但不够覆盖 Agent、Memory、Skills、MCP |

建议实际仓库描述：

```text
Distill scattered projects, AI conversations, failures, and half-finished ideas into a personal Agent Work OS: Agents, Memory, Skills, MCP tools, Workflows, and Rules.
```

## 3. 项目总览表

| 项目或项目族 | 项目定位 | 当前状态 | 主要问题 | 是否有继续价值 | 建议处理方式 |
|---|---|---|---|---|---|
| `01-skills` | 本地 Codex skills 中心 | 半成品资产库 | 技能项目多，但 Agent/Memory 两层为空 | 高 | 继续推进，升级为 Project2AgentWorkOS 的能力库 |
| `readme-showcase-screenshot` | README 截图、GIF、展示页流水线 | 可包装发布 | 很适合解决“没有视觉证明”，但需要变成默认质量闸门 | 高 | 固化为所有 GitHub 项目的发布前步骤 |
| `Appui-Design-Skill` | 移动 App UI 设计案例与源码技能 | 可发布 | 展示很完整，后续要避免继续堆案例而不进入真实项目 | 高 | 保留为 UI 能力模块 |
| `design-md-flow` | DESIGN.md 风格安装与视觉 QA 工作流 | 可发布 | 定位清楚，但应绑定真实项目验收流程 | 高 | 继续推进，作为前端设计标准工具 |
| `AppPreviewLab-Skill` | APK/IPA/桌面安装包预览实验室 | 可复用工具 | 易变成辅助工具孤岛，需要接入 README 展示流水线 | 中高 | 转为项目发布工具模块 |
| `android-release-emulator-qa-skill` | Android 模拟器 QA 工作流 | 新技能 | 价值明确，但需要 README、案例、安装闭环 | 中高 | 继续完善并发布 |
| `gh-repo-cartographer` | GitHub 远端与本地仓库映射技能 | 可发布 | 解决真实痛点，但应成为每周扫描自动化入口 | 高 | 继续推进，纳入 ProjectLoopOS 核心 |
| `RepoAtlas` | 多账号 GitHub 与本地仓库桌面地图 | 可发布产品 | 产物在 `output` 中，需确认主仓库与发布链路唯一 | 高 | 合并到正式仓库，保留 Pages 与 Release |
| `05-campus_qa` | Campus QA / HyperMemory 项目族 | 重复建设明显 | RAG、Agent、LLM Wiki、GBrain、Hierarchy、HyperMemory 多版本并存 | 高 | 保留 Collection，其他版本按教学阶段归档 |
| `CampusQA-Collection` | 从 RAG QA 到 HyperMemory 的教程型集合 | 可包装发布 | 有 Roadmap 和比较计划，但需要真正 Pages 对比站 | 高 | 继续推进，作为教程旗舰 |
| `saihao_compus_qa` | 六个独立 QA 版本 | 重复建设 | 与 Collection 重叠，适合实验但不适合长期主线 | 中 | 保留为实验样本，减少新分支 |
| `harzva_HyperMemory` | 记忆系统最终形态 | 方向有价值 | 容易被 CampusQA 名称限制，需要独立定位 | 高 | 独立为长期产品线 |
| `ChinaAI-Roadmaps` | 国内 AI 公司技术路线研究站 | 可发布内容产品 | 已合并两个版本，但后续需持续更新数据与分发 | 高 | 继续推进，按月更新 |
| `Agent-Job-Interview` | Agent 岗位面试题库与实战训练 | 可发布内容产品 | 已合并两个来源，需持续题库维护与文章分发 | 高 | 继续推进，作为内容资产 |
| `learn-likecc` | Claude Code 源码学习、仿真器、模型路由实验 | 旗舰但过宽 | 同时承载课程、复刻、仿真、LikeCode 实验，容易继续膨胀 | 高 | 每轮只推进一个专题，强制记录下一轮边界 |
| `WellAgentPets` / `claude-pets-svg` | Claude SVG 素材库 | 半成品资产 | 素材多，仓库包装与 Pages 展示需要统一 | 中 | 转为视觉资产库 |
| `GitMarket` / `ApkGit` | 开源 Release 发现、校验、下载助手 | 可发布产品 | 已有多端预览和 release，但 Android/iOS 路线过多 | 高 | 保留桌面 + Web preview 主线，移动端暂收敛 |
| `everything-in-github-main` | GitHub 教程与生态导航 | 重复/待收敛 | 与 GitMarket、GitHub 管理技能、RepoAtlas 主题重叠 | 中 | 合并为 GitHub 学习/生态内容库 |
| `github-official-svg-icons` | GitHub 官方 SVG 图标资产 | 可发布资产 | 需要持续确保官方来源与版权边界 | 中高 | 保留为素材仓库 |
| `MobileCode` | 移动端 AI coding workspace | 半成品 | 产品愿景大，真实移动端工程不完整，promo site 强于 app | 中高 | 先做 Web/PWA 或单平台 MVP |
| `Just-DDL` | DDL 专题网络和专题仓库矩阵 | 可发布产品 | 专题仓库多，后续抓取、校验、数据源维护压力大 | 高 | 继续推进，但先完成数据链路自动化 |
| `catop` | LLM prompt cache hit 监控 CLI | 聚焦且可发布 | 方向很尖锐，下一步是 LiteLLM 真实接入与 Pages 展示 | 高 | 作为高优先级产品继续推进 |
| `md2wechat-skill` | Markdown 到微信公众号草稿箱工具链 | 外部参考/可集成 | 能力强，但需明确是引用、fork、适配还是自研 | 中高 | 作为内容分发链路工具，不要混淆归属 |
| `Codex-Managed-Agent` | VS Code/Codex 多线程控制面板 | 大型产品 | Roadmap 完整，但项目巨大，易重开支线 | 高 | 按 task-plans 推进，不随意加新轨道 |
| `12-AgentCheaper` | Claude Code hooks/token 优化调研 | 研究资料 | 目前是单文档，不是工具 | 中 | 转为 Agent 成本优化 skill 或归档 |
| `10-3d-webview` | 3D/WebView 原型 HTML | 原型素材 | 无 README、无仓库结构、无发布目标 | 低中 | 归档为 demo 素材，除非定义产品 |
| `output` | 生成物、截图、安装包、报告中转站 | 混合堆场 | 很多成果没有回流到正式仓库 | 高但危险 | 建立“output 清空回流”规则 |
| `gitmarket-windows-x86_64.zip` | 发布压缩包 | 构建产物 | 根目录混放 release artifact | 低 | 移入 release/archive，不作为项目 |
| `新建文件夹` | 空目录 | 无效 | 无内容无定位 | 无 | 删除或归档 |

## 4. 项目状态分类

### 可继续做旗舰的项目

- `catop`：最聚焦，能用一句话讲清楚价值，“只做 LLM prompt cache hit 监控”。
- `Just-DDL`：网络结构清楚，适合长期数据产品，但必须先完成 crawler、validator、link-check。
- `CampusQA-Collection` / `HyperMemory`：技术体系有深度，适合做教程和产品双线。
- `learn-likecc`：内容和教学价值高，但必须用专题迭代控制膨胀。
- `GitMarket`：已经具备 Pages、Release、桌面包、多端预览，但需削减移动端路线复杂度。

### 应作为能力模块的项目

- `gh-repo-cartographer`
- `readme-showcase-screenshot`
- `design-md-flow`
- `Appui-Design-Skill`
- `AppPreviewLab-Skill`
- `android-release-emulator-qa-skill`

### 应作为内容资产的项目

- `ChinaAI-Roadmaps`
- `Agent-Job-Interview`
- `Everything in GitHub`
- `claude-code-hooks-github-repos.md`
- `output/文档与报告`

### 应合并或归档的重复项目

- `CampusQA` 多个同构版本：保留 Collection 和最终产品，其他作为教学阶段。
- `everything-in-github-main` 与 `GitMarket`、`RepoAtlas`、GitHub skills 的重叠内容要分层。
- `learn-likecc` 与 `learn-likecc-main` 要确认唯一主仓库。
- `claude-pets-svg` 与 `WellAgentPets` 要合并为一个素材仓库。

### 应暂停的新想法

- 没有 README、没有项目卡片、没有用户、没有发布目标的单 HTML 原型。
- 只有调研文档但没有明确下一步工具化计划的素材集合。

## 5. 失败经验分类

### A. 方向层失败：想做系统，没先做最小闭环

典型表现：

- `MobileCode` 想做移动 AI coding workspace，但 promo site、Flutter preview、打包条件、生产移动端之间没有最小可验证路径。
- `CampusQA` 同时拆出 RAG、Agent、LLM Wiki、GBrain、Hierarchy、HyperMemory，方法论完整，但早期版本过多。
- `GitMarket` 同时推进桌面、Android preview、Android native、iOS preview，交付面过宽。

根本原因：

- 容易把“最终系统图”当成“下一步任务”。
- 喜欢把项目做成平台，但没有先定义一个可运行、可展示、可维护的最小版本。

修复规则：

- 任何项目先写一句话用户、痛点、交付物。
- 一次迭代只能推进一个主路径，其他路线进入 `LATER.md`。
- 没有最小可访问 Demo 前，不新增第二平台。

### B. 执行层失败：有计划，有文件，但下一步不够硬

典型表现：

- 很多 README 和 plan 文档写得很完整，但没有统一 `PROJECT_CARD.md` 记录“当前状态、下一步、阻塞点”。
- `output` 中有大量截图、报告、项目目录、安装包，但不一定回流到主仓库。
- 历史 prompt 经常出现“继续优化、全面升级、再生成、再完善”，但缺少完成定义。

根本原因：

- 对“开始执行”很敏感，对“验收关闭”不够敏感。
- Agent 输出常被当成完成，但文件、发布、反馈没有全部落地。

修复规则：

- 每次任务结束必须更新项目卡片。
- 任何“继续优化”必须先指定本轮最多 3 个验收项。
- `output` 只允许做暂存，7 天内必须回流、归档或删除。

### C. 工作流失败：项目没有统一入口和状态系统

典型表现：

- 70 个 Git 工作树分散在多个层级。
- 有 88 个 workflow，但只有 0 个 `PROJECT_CARD.md`。
- `1.1agent`、`1.2memory` 已建目录却为空，说明方法论意识存在，但没有资产化。

根本原因：

- 缺少跨项目状态总线。
- 缺少每周固定盘点流程。

修复规则：

- 每个活跃项目必须有 `PROJECT_CARD.md`。
- 每周只允许 3 个 Active 项目，其他项目进入 Watch、Archive 或 Reference。
- 每个项目必须有唯一主仓库、唯一 Pages 地址、唯一下一步。

### D. Agent 协作失败：Agent 负责建议多，负责闭环少

典型表现：

- 历史对话中反复要求 Agent “优化 README、提交 GitHub、生成 Pages、做 skill”，但 Agent 角色没有分工。
- 缺少交付监督 Agent 检查 README、Demo、截图、Actions、Pages。
- 缺少记忆归档 Agent 把失败经验写入全局规则。

根本原因：

- 把 Agent 当万能助手，而不是可分工的工作系统。

修复规则：

- 每次任务必须指定主 Agent 和验收 Agent。
- Agent 不能只输出方案，必须输出文件、命令、清单或 PR 级结果。
- 复盘型任务必须同时更新 Memory 文件。

### E. 发布与分发失败：发布意识有，但传播资产不稳定

典型表现：

- 很多项目有 GitHub Pages 和 README，但截图、Demo、教程、社媒文案不是固定产物。
- `readme-showcase-screenshot` 正是为此诞生，但还没有变成所有项目的默认发布闸门。
- 公众号、小红书、Twitter、B站等分发方向被多次提起，但没有统一内容流水线。

根本原因：

- 把 GitHub push 当发布终点，而不是分发起点。

修复规则：

- 公开项目发布定义为：README + 截图/GIF + Pages/Release + 一篇可分发短文。
- 没有 README 首屏视觉证据的项目，不算完成发布。
- 每个工具项目发布时同时生成“开发者版”和“内容平台版”介绍。

### F. 文件与记忆管理失败：经验没有进入长期系统

典型表现：

- Windows `npx.ps1` 执行策略问题刚刚才进入全局记忆。
- 许多类似经验散落在历史对话中：不要本地强行构建、GitHub Actions 构建、账号路由、README 视觉、GitHub Pages 子路径等。
- `1.2memory` 空目录说明还没有稳定沉淀机制。

根本原因：

- 经验只存在于“这一轮对话里”，没有进入“下一轮默认规则里”。

修复规则：

- 凡是同类问题出现第二次，必须写入 Memory。
- 每个项目复盘必须产生 1 到 3 条硬规则。
- Memory 规则要短、硬、可检查，不写感想。

### G. 过度设计失败：视觉、主题、平台和版本扩张过快

典型表现：

- UI 项目容易从一个页面扩展到多主题、多界面、多端。
- `Just-DDL` 从黑客松、Agent 扩展到 CV、NLP、Academic、Journal、Holiday、Multimodal，数据链路压力迅速上升。
- `GitMarket` 多端预览很强，但正式主线需要收敛。

根本原因：

- 对“丰富度”的兴奋超过了对“维护成本”的估算。

修复规则：

- 新增主题、平台、专题前，必须先回答“谁维护数据、谁验证、谁发布”。
- 每个项目只允许一个 North Star 指标。
- 先跑通一条真实数据链路，再扩展展示层。

### H. 没有复利沉淀失败：项目成果没有变成资产网络

典型表现：

- 很多项目已经产出优秀 README、截图、Pages、workflow，但没有汇总成方法论。
- `RepoAtlas`、`gh-repo-cartographer`、`github-management-suite`、`gh-actions-release-builder` 等能力应该形成 GitHub 运维系统，而不是分散存在。
- `output` 里沉淀了大量可复用资料，但缺少“资产入库”流程。

根本原因：

- 每个项目都在解决一次性问题，没有被回收成模板、skill、checklist、playbook。

修复规则：

- 每个完成项目至少沉淀一个模板、一个检查清单或一条自动化规则。
- 每周复盘不是写总结，而是更新 Agent、Memory、Skill、Template 四类资产。

## 6. 高频错误模式 Top 10

### 错误 1：同时开太多版本，主线被稀释

- 典型表现：CampusQA 多版本、GitMarket 多端、Just-DDL 多专题。
- 出现项目：`05-campus_qa`、`GitMarket`、`Just-DDL`、`MobileCode`。
- 根本原因：用“体系完整”替代“本周闭环”。
- 后果：每个方向都有一点进展，但没有一个方向被持续打穿。
- 避免规则：每个项目只能有一个主线版本，其他版本进入实验区。
- 对应 Agent：产品收敛 Agent。

### 错误 2：把 README 写好当成项目完成

- 典型表现：README 很漂亮，但 Demo、Release、数据流、维护脚本不完整。
- 出现项目：`MobileCode`、部分 skills、素材库项目。
- 根本原因：GitHub 首屏反馈强，容易掩盖真实工程缺口。
- 后果：外观看起来完成，实际无法持续使用。
- 避免规则：README 只是发布清单的一项，必须同时有运行、截图、验证和下一步。
- 对应 Agent：交付监督 Agent。

### 错误 3：Agent 对话成果没有当天落盘

- 典型表现：历史 prompt 中有大量高质量工作流、方案、规则，但没有进入项目文件。
- 出现项目：`12-AgentCheaper`、`WORKSPACE_TO_OS_REVIEW_PROMPT`、多次 GitHub 发布经验。
- 根本原因：把对话当临时脑图，没有当成仓库资产。
- 后果：下一次重新问、重新整理、重新试错。
- 避免规则：对话产物不落盘，视为未完成。
- 对应 Agent：记忆归档 Agent。

### 错误 4：缺少项目卡片导致每次重启都要重新理解

- 典型表现：0 个 `PROJECT_CARD.md`，但项目数量达到 70 个 Git 工作树。
- 出现项目：全局。
- 根本原因：没有统一记录目标、状态、下一步、风险。
- 后果：上下文切换成本高，Agent 容易重复探索。
- 避免规则：活跃项目必须先补 `PROJECT_CARD.md`。
- 对应 Agent：项目侦察 Agent。

### 错误 5：`output` 变成成果黑洞

- 典型表现：截图、报告、安装包、项目目录都进入 `output`，但没有稳定回流机制。
- 出现项目：`output/项目目录`、`output/图片与截图`、`output/应用安装包`。
- 根本原因：暂存区没有清空规则。
- 后果：成果不可发现、不可复用、不可发布。
- 避免规则：`output` 中任何新产物 7 天内必须回流、归档或删除。
- 对应 Agent：资产归档 Agent。

### 错误 6：项目命名反复摇摆

- 典型表现：Compus/Campus、ChinaAI-Roadmp/Roadmaps、Workspace-to-OS、GitMarket/GitReleaseMarket。
- 出现项目：`05-campus_qa`、`02-chinaAI&JOB`、`01-skills`、`04-开源集`。
- 根本原因：未先定义搜索关键词、目标用户和传播场景。
- 后果：仓库识别弱，后续迁移成本高。
- 避免规则：建仓前必须确定英文仓库名、中文名、一句话定位、GitHub description。
- 对应 Agent：命名与定位 Agent。

### 错误 7：本地环境问题反复消耗注意力

- 典型表现：PowerShell 执行策略、`npx.ps1`、本地缺 Flutter/Xcode/Android/Rust 构建环境。
- 出现项目：`MobileCode`、`Just-DDL`、`GitMarket`、多前端项目。
- 根本原因：没有把环境约束写成默认执行规则。
- 后果：本该走 GitHub Actions 的构建，在本地反复尝试。
- 避免规则：本地无环境时，不强行构建；生产构建交给 Actions。
- 对应 Agent：环境与发布 Agent。

### 错误 8：参考项目大量进入仓库，主项目边界变模糊

- 典型表现：`agent_refs`、`reference`、`Everything_in_claude/projects/projects` 中嵌套大量参考仓库。
- 出现项目：`07-mobile-app`、`11-codex-managed-agent`、`02-chinaAI&JOB`。
- 根本原因：研究资料和主工程没有分层。
- 后果：扫描噪声变大，主线代码难以定位。
- 避免规则：参考仓库放 `reference/` 并写 `REFERENCE_INDEX.md`，不进入主构建路径。
- 对应 Agent：项目侦察 Agent。

### 错误 9：分发链路总在后面补

- 典型表现：项目先做完，再补 README、截图、Pages、公众号、小红书文案。
- 出现项目：几乎所有公开项目。
- 根本原因：把分发当包装，而不是产品定义的一部分。
- 后果：项目难以被看见，也难以获得反馈。
- 避免规则：项目启动时就写“发布渠道”和“首篇内容标题”。
- 对应 Agent：分发增长 Agent。

### 错误 10：每次都想“全面优化”，但没有本轮边界

- 典型表现：历史 prompt 高频出现“全面升级、继续优化、再完善”，但验收点不稳定。
- 出现项目：`learn-likecc`、`Appui-Design-Skill`、`catop`、`Just-DDL`。
- 根本原因：优化目标从质量变成情绪表达。
- 后果：Agent 容易扩大范围，交付不可控。
- 避免规则：任何“全面优化”必须拆成本轮 3 个可验收问题。
- 对应 Agent：交付监督 Agent。

## 7. 超级个体 OPC 工作流

### O：Observe / Opportunity

目标：判断一个想法是否值得做，避免伪需求和冲动建仓。

输入：

- 灵感、链接、竞品、历史对话、用户痛点、自己重复踩坑。

关键动作：

- 写 `PROJECT_CARD.md`。
- 回答用户是谁、痛点是什么、最小交付物是什么、发布渠道是什么。
- 查重：当前产品目录是否已有相似项目。
- 判定类型：产品、skill、内容资产、素材库、研究资料、参考项目。

输出：

- 项目卡片。
- 是否启动的结论。
- MVP 边界。
- 7 天内可完成的第一闭环。

检查标准：

- 30 分钟内说不清用户、痛点、交付物，就不建仓库。
- 已有相似项目时，优先合并，不新建。

### P：Produce / Package

目标：把想法变成最小可交付资产。

输入：

- 项目卡片、MVP 范围、现有代码/文档、相关 skill。

关键动作：

- 只做一个主路径。
- 补齐 README、运行方式、截图、验证方式、License、Roadmap。
- 前端项目用截图验证桌面和移动端。
- 软件构建优先交给 GitHub Actions。

输出：

- 可运行代码或可阅读内容。
- README 首屏。
- Demo / Pages / Release / 截图。
- 更新后的项目卡片。

检查标准：

- 没有 README、Demo 截图、运行方式，不算完成。
- 没有下一步，不算完成。

### C：Circulate / Compound

目标：把项目变成可被看见、可复用、可沉淀的资产。

输入：

- 已交付项目、截图、README、Demo、发布链接。

关键动作：

- 发布 GitHub 仓库、Pages、Release。
- 生成文章、图解、短视频脚本或社媒文案。
- 收集反馈或至少记录下一轮假设。
- 把踩坑写入 Memory，把流程写成 Skill，把格式写成 Template。

输出：

- 发布链接。
- 分发文案。
- 复盘记录。
- Memory 规则。
- 可复用模板或自动化脚本。

检查标准：

- 只 push 不算发布。
- 没有复盘和 Memory，不算闭环。

## 8. Agent 角色体系

### 项目侦察 Agent

一句话定义：扫描目录和仓库，判断项目状态、重复关系和混乱点。  
核心职责：生成项目地图、识别主仓库、标记重复/停滞/半成品。  
输入：产品目录、Git 仓库、README、workflow、历史 prompt。  
输出：项目总览表、重复项目建议、缺失项清单。  
什么时候调用：每周复盘、新建仓库前、接手旧项目时。  
避免错误：重复建仓、找不到主线、output 黑洞。  
记忆规则：没有项目卡片的项目默认不是 Active。

### 产品收敛 Agent

一句话定义：把大想法压缩成 7 天内能闭环的 MVP。  
核心职责：定义用户、痛点、MVP、非目标、验收标准。  
输入：项目想法、竞品、现有资料。  
输出：MVP 边界和本轮 3 个验收项。  
什么时候调用：任何“全面升级”“做一个平台”出现时。  
避免错误：过度设计、平台化过早、多端过早。  
记忆规则：没有 MVP 边界，不允许新增平台。

### 交付监督 Agent

一句话定义：检查项目是否真的可运行、可展示、可发布。  
核心职责：验收 README、Demo、截图、Actions、Pages、Release。  
输入：项目目录和发布目标。  
输出：交付检查清单和阻塞项。  
什么时候调用：任务结束前、准备 push 前、发布前。  
避免错误：README 漂亮但项目不可用。  
记忆规则：没有截图和运行方式，不算交付。

### GitHub 发布 Agent

一句话定义：把本地项目变成规范 GitHub 仓库和发布物。  
核心职责：账号路由、remote、CI、Pages、Release、README、Topics。  
输入：本地仓库、目标账号、发布类型。  
输出：GitHub 链接、Pages 链接、Release 链接、发布日志。  
什么时候调用：项目准备公开、迁移、重命名、修复 push 时。  
避免错误：账号错、远端错、构建失败、Pages 子路径错。  
记忆规则：生产构建优先放到 GitHub Actions。

### 内容转化 Agent

一句话定义：把项目变成文章、图解、教程、视频脚本和社媒文案。  
核心职责：提炼卖点、生成内容结构、适配公众号/小红书/GitHub。  
输入：README、截图、Demo、技术说明。  
输出：文章、短文案、封面提示词、发布节奏。  
什么时候调用：项目发布后 24 小时内。  
避免错误：项目做完没人知道。  
记忆规则：公开项目必须至少有一篇可分发内容。

### 视觉展示 Agent

一句话定义：生成 README 首屏截图、GIF、hero 和 gallery。  
核心职责：使用 `readme-showcase-screenshot` 等能力做视觉证据。  
输入：Web/App/CLI 项目和路由。  
输出：截图、GIF、README showcase block、gallery。  
什么时候调用：公开仓库 README 优化前。  
避免错误：纯文字 README 缺少信任感。  
记忆规则：截图必须来自真实产品状态。

### 记忆归档 Agent

一句话定义：把失败经验、环境坑、命名规则、发布规则写入长期 Memory。  
核心职责：从复盘中提取短、硬、可执行规则。  
输入：任务结果、失败路径、历史对话、项目卡片。  
输出：Memory 文件、规则更新、下一次默认约束。  
什么时候调用：同类问题第二次出现、每周复盘、任务失败后。  
避免错误：同一坑反复踩。  
记忆规则：经验不写入 Memory，等于没有学会。

### 分发增长 Agent

一句话定义：为项目设计传播节奏和反馈入口。  
核心职责：标题、封面、渠道、发布时间、反馈表、下一轮迭代。  
输入：项目定位、发布链接、目标用户。  
输出：发布计划和增长实验。  
什么时候调用：项目达到最小可用后。  
避免错误：只 push，不传播，不复盘。  
记忆规则：发布必须包含反馈入口。

### 环境与成本 Agent

一句话定义：把本地环境、构建平台、token 成本和执行策略变成默认规则。  
核心职责：识别本地不可构建环境、选择 Actions、沉淀 shell/Windows 规则。  
输入：构建日志、系统环境、CI 配置。  
输出：环境规则、CI 建议、成本优化清单。  
什么时候调用：构建失败、跨平台打包、CLI 调用失败时。  
避免错误：在错误环境里反复消耗时间。  
记忆规则：Windows PowerShell 下 Node CLI 优先 `.cmd` shim。

## 9. 长期记忆规则

### 项目启动规则

- 任何项目如果 30 分钟内说不清用户、痛点、交付物，就先不建仓库。
- 建仓前必须确定英文仓库名、中文名、一句话定位、GitHub description。
- 已有相似项目时，默认合并，不默认新建。
- 新项目必须先写 `PROJECT_CARD.md`，再写代码。

### 项目执行规则

- 每轮任务最多 3 个验收项。
- “全面优化”必须改写成具体范围。
- 参考仓库必须放在 `reference/` 并写来源说明。
- 本地没有构建环境时，不强行构建生产包，改用 GitHub Actions。

### 项目交付规则

- 没有 README、运行方式、截图或 Demo，不算交付。
- 公开项目必须有 License 或明确协议说明。
- 前端项目必须检查桌面、移动端、控制台错误和横向溢出。
- CLI 项目必须有安装命令、最小示例和 `--help` 截图或输出。

### 项目发布规则

- 只 push 不算发布，必须有 README 首屏、Pages 或 Release。
- 发布后 24 小时内必须生成一份内容分发文案。
- GitHub Pages 子路径必须显式验证。
- 每个公开项目必须有下一轮 Roadmap 或明确归档声明。

### Agent 协作规则

- Agent 不能只给建议，必须产出文件、命令、清单或可验证结果。
- 每次项目任务必须有执行 Agent 和验收 Agent。
- 同类失败第二次出现，必须调用记忆归档 Agent。
- 新技能必须有 README、SKILL、示例、安装方式、验证方式。

### 文件管理规则

- `output` 只能做暂存，7 天内必须回流、归档或删除。
- 根目录不放压缩包、安装包和临时截图。
- 每个项目只保留一个主 README，历史版本放 `docs/archive/`。
- 空目录必须删除或写明用途。

## 10. 一句话记忆收纳格

我的项目停滞通常不是因为想法少或能力弱，而是因为启动太快、版本太多、状态不落盘、发布不成闭环；未来每个想法都必须进入 Project2AgentWorkOS 的萃取流程：先用项目卡片判断机会，再做 7 天内可交付的最小版本，最后发布、分发、复盘，并把经验沉淀成 Agent、Memory、Skills、MCP、Workflow 和 Rules。

## 11. 未来 7 天行动清单

### Day 1：完成项目盘点和主线冻结

- [ ] 给前 12 个活跃项目补 `PROJECT_CARD.md`。
- [ ] 标记每个项目状态：Active、Watch、Archive、Reference。
- [ ] 删除或归档空目录和根目录 release artifact。
- [ ] 确认 `learn-likecc`、`WellAgentPets`、`RepoAtlas` 的唯一主仓库。

### Day 2：建立 Project2AgentWorkOS 仓库骨架

- [ ] 用 `Project2AgentWorkOS` 作为新仓库名。
- [ ] 写 README：项目如何炼成 AgentWorkOS、OPC、Agent/Memory/Skills/MCP/Workflow/Rules。
- [ ] 把本报告、Agent 角色、Memory 规则放入仓库。
- [ ] 加 `PROJECT_CARD.template.md`、`RELEASE_CHECKLIST.md`、`WEEKLY_REVIEW.md`。

### Day 3：合并重复项目

- [ ] CampusQA 保留 Collection 和 HyperMemory 主线，其他版本标为阶段样本。
- [ ] 合并 `claude-pets-svg` 和 `WellAgentPets`。
- [ ] 整理 `everything-in-github-main` 与 GitHub 工具产品的边界。
- [ ] 把 `output/项目目录` 中已经成型的项目回流到对应仓库。

### Day 4：拯救最有价值的烂尾项目

- [ ] `catop`：完成 LiteLLM 真实数据接入下一步说明和 Pages 截图补强。
- [ ] `Just-DDL`：把 crawler、validator、link-check 作为唯一主线。
- [ ] `MobileCode`：决定 Web/PWA、Android 或 Flutter 只保留一条 MVP 路线。
- [ ] `GitMarket`：冻结移动端扩张，先保证桌面 + Web preview 稳定。

### Day 5：补齐发布资产

- [ ] 对 `catop`、`gh-repo-cartographer`、`design-md-flow` 跑 README showcase。
- [ ] 对每个活跃公开项目补 Pages/Release/截图状态。
- [ ] 输出 3 篇项目介绍短文：catop、Just-DDL、Project2AgentWorkOS。
- [ ] 建立 `CONTENT_DISTRIBUTION_QUEUE.md`。

### Day 6：建立 Agent / Memory / Skill 库

- [ ] 完成 `1.1agent/OPC_AGENT_ROLE_SYSTEM.md`。
- [ ] 完成 `1.2memory/OPC_LONG_TERM_MEMORY_RULES.md`。
- [ ] 把 `readme-showcase-screenshot` 设为公开项目发布默认步骤。
- [ ] 把 Windows Node CLI shim 规则纳入环境规则索引。

### Day 7：完成一次公开复盘发布

- [ ] 发布 Project2AgentWorkOS 仓库。
- [ ] 在 README 中展示项目总览、失败 Top 10、OPC 工作流。
- [ ] 写一篇“我如何把混乱项目目录炼成个人 AI 工作操作系统”的文章。
- [ ] 设定下一周只推进 3 个 Active 项目。

## 12. Project2AgentWorkOS 最小仓库结构建议

```text
Project2AgentWorkOS/
  README.md
  PROJECT_CARD.template.md
  WEEKLY_REVIEW.template.md
  RELEASE_CHECKLIST.md
  agents/
    project-scout.md
    delivery-supervisor.md
    memory-archivist.md
  memory/
    project-start-rules.md
    delivery-rules.md
    windows-environment-rules.md
  playbooks/
    rescue-stalled-project.md
    merge-duplicate-projects.md
    publish-github-project.md
  scripts/
    scan-projects.*
    check-project-readiness.*
  examples/
    campusqa-project-card.md
    catop-project-card.md
```

## 13. 最硬的三条规则

1. 没有 `PROJECT_CARD.md` 的项目，不允许进入 Active。
2. 没有 README、Demo 截图、运行方式和下一步的项目，不算交付。
3. 没有发布、分发、复盘、Memory 的项目，不算闭环。
