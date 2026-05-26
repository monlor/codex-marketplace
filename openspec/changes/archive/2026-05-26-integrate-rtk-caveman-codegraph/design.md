## Context

`monlor-marketplace` 是一个新项目，目标不是重新实现 `rtk`、`caveman` 或 `codegraph` 本身，而是把它们封装成适合 Codex 安装和分发的插件资产。当前三者的接入方式并不统一：`caveman` 更接近纯 skill，`rtk` 主要通过指令和命令包装降低输出噪音，`codegraph` 则依赖 MCP server 和底层二进制。

约束如下：

- 优先项目级安装和启用，避免默认污染 `~/.codex` 根目录、全局 marketplace 和全局 PATH。
- 插件结构必须遵循 Codex 插件约定，使用 `.codex-plugin/plugin.json` 作为入口。
- `codegraph` 需要 MCP 配置，且可能仍依赖宿主机已有 `codegraph` 可执行文件，或由插件脚本负责下载/定位。
- 仓库需要同时支持“整仓作为 marketplace”与“单插件按路径安装”两种消费方式。

## Goals / Non-Goals

**Goals:**

- 提供 `rtk`、`caveman`、`codegraph` 三个独立但风格一致的 Codex 插件目录。
- 提供 repo-local marketplace 元数据，让项目可以作为一个可安装的插件源被 Codex 使用。
- 为每个插件定义清晰的能力边界、安装前提和启用方式。
- 尽可能把配置、skills、MCP 和包装脚本收敛在仓库内部，降低全局环境漂移。

**Non-Goals:**

- 不重写 `rtk`、`caveman` 或 `codegraph` 的上游核心逻辑。
- 不承诺完全消除所有宿主依赖，尤其不承诺在没有任何本地二进制或网络访问的情况下提供完整 `codegraph` 能力。
- 不在本次 change 中实现远程 marketplace 发布、公共托管或自动更新平台。

## Decisions

### 1. 使用多插件仓库结构，而不是单一“大而全”插件

仓库将采用 `plugins/<name>/` 结构，分别放置 `rtk`、`caveman`、`codegraph`。这样可以独立安装、独立演进，也更符合 Codex marketplace 的路径模型。

备选方案：

- 单一聚合插件：安装简单，但会强制用户一次性接受三类能力和依赖，不利于隔离和维护。
- 三个分散仓库：边界最清晰，但重复基础设施较多，也不利于统一文档和脚手架。

### 2. repo-local marketplace 作为默认消费入口

仓库根目录提供 `.agents/plugins/marketplace.json`，默认让使用者以项目级 marketplace 的方式加载和安装插件，而不是默认修改 `~/.codex/config.toml` 或 `~/.codex/plugins`。

备选方案：

- 仅提供手工复制插件目录的方式：过于原始，容易造成目录布局不一致。
- 仅支持全局 marketplace：安装简单，但与“避免环境污染”的目标相冲突。

### 3. 三个插件按能力类型拆分实现

- `caveman` 插件：以 `skills/` 为核心，必要时附带少量文档资源，不引入 MCP。
- `rtk` 插件：以 `skills/` 和辅助脚本为核心，默认指导 Codex 使用 `rtk <cmd>` 或插件内包装入口；不假定插件 hook 一定在当前 Codex 运行时可用。
- `codegraph` 插件：以 `.mcp.json` 和启动/探测脚本为核心，并附加 skill 指导何时使用 CodeGraph。

备选方案：

- 所有插件都统一成 MCP：会误用在 `caveman` 这类纯提示能力上。
- 所有插件都统一成 skill：无法覆盖 `codegraph` 的 MCP 能力。

### 4. 明确声明宿主依赖和降级行为

插件文档和实现需要区分“插件内容”与“宿主机依赖”。对于 `codegraph` 和部分 `rtk` 运行能力，如果宿主依赖缺失，插件必须提供可诊断的失败信息或降级路径，而不是静默失败。

备选方案：

- 隐藏宿主依赖：短期看起来更简单，但最终会让用户在安装后遇到不可解释的问题。

## Risks / Trade-offs

- [`codegraph` 仍依赖宿主机二进制] → 通过探测脚本、前置检查和文档明确说明；后续可再补插件内下载或远程 MCP 方案。
- [Codex 对插件 hooks 的支持可能不稳定] → `rtk` 不以 hook 作为唯一集成路径，先采用 skill 和命令包装的保守方案。
- [三插件目录结构可能出现重复文件] → 抽取共享脚本、模板或文档片段到仓库级 `shared/` 或 `scripts/`，但保持每个插件的入口自包含。
- [项目级安装仍需用户在 Codex 中显式安装/启用] → 文档提供最小步骤和验证命令，避免隐式修改用户全局环境。

## Migration Plan

1. 初始化仓库级 marketplace 和插件目录骨架。
2. 先落地 `caveman` 插件，因为依赖最少，可用于验证基础插件结构。
3. 落地 `rtk` 插件的 skill 和包装脚本，定义项目级使用方式。
4. 落地 `codegraph` 插件的 MCP 配置和前置检查脚本。
5. 编写统一 README，补充安装、验证、限制和故障排查。

## Open Questions

- `codegraph` 首版是否要求用户预装二进制，还是允许通过 `npx`/下载脚本延迟获取。
- `rtk` 首版是否只提供“提示使用 `rtk`”能力，还是同时提供更强的 wrapper 命令入口。
- 仓库是否需要额外提供一键脚本，把 marketplace 条目 vendoring 到调用方项目目录中。
