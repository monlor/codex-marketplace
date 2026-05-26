## Why

`rtk`、`caveman` 和 `codegraph` 目前在 Codex 中的接入方式分散在全局说明文件、全局配置和宿主机可执行依赖上，复用成本高，也容易造成用户环境漂移。现在需要一个新的 `monlor-marketplace` 项目，把这三类能力收敛成可分发、可安装、可项目级启用的插件资产，作为后续扩展更多 Codex 插件的基础。

## What Changes

- 新建一个 `monlor-marketplace` 项目，作为 Codex 插件仓库和分发入口。
- 为 `rtk`、`caveman`、`codegraph` 各自提供标准 Codex 插件封装，使用 `.codex-plugin/plugin.json` 作为统一入口。
- 提供仓库级 marketplace 元数据，使用户可以按插件或按整仓安装，而不是手工散落地修改 `~/.codex` 根目录。
- 约定项目级安装和启用流程，优先使用 repo-local 插件目录、skills、MCP 配置和脚本包装层，减少全局 PATH、全局说明文件和全局配置污染。
- 为 `codegraph` 提供插件内 MCP 接入方式；为 `rtk` 和 `caveman` 提供插件内 skill/脚本封装与使用说明。
- 提供统一文档，说明三个插件的作用边界、安装方式、启用方式、以及无法完全隔离的宿主依赖。

## Capabilities

### New Capabilities
- `codex-tooling-plugin-bundles`: 在一个仓库内发布 `rtk`、`caveman`、`codegraph` 三个可安装的 Codex 插件，并提供一致的元数据与目录结构。
- `project-scoped-plugin-installation`: 支持通过 repo-local marketplace 和安装说明在项目范围内启用插件，避免默认写入全局 Codex 配置和说明文件。

### Modified Capabilities

## Impact

- 新增仓库级插件目录、marketplace 元数据、插件 manifest、skills、MCP 配置和辅助脚本。
- 影响 Codex 插件安装流程、仓库结构约定、以及 `codegraph` 的 MCP 启动方式。
- 需要验证第三方依赖边界，尤其是 `codegraph` 和 `rtk` 是否仍要求宿主机二进制，或是否可通过插件内脚本包装降低污染。
