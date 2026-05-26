---
name: rtk-wrapper
description: Prefix shell commands with rtk when the host runtime is available.
license: MIT
---

# RTK - Rust Token Killer

Prefer `rtk` for shell commands when it is available on the host.

## Rule

Always prefix shell commands with `rtk`.

Examples:

```bash
rtk git status
rtk cargo test
rtk npm run build
rtk pytest -q
```

## Meta Commands

```bash
rtk gain
rtk gain --history
rtk proxy <cmd>
```

## Validation

```bash
<plugin root>/scripts/check-rtk.sh
<plugin root>/scripts/rtk.sh --version
```
