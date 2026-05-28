import test from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, resolve } from "node:path";

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = resolve(__dirname, "..");

function read(relativePath) {
  return readFileSync(resolve(repoRoot, relativePath), "utf8");
}

test("openviking-mcphub skill describes session-provided MCPHub usage", () => {
  const skill = read("plugins/openviking-mcphub/skills/openviking-mcphub-usage/SKILL.md");

  assert.match(skill, /current session'?s OpenViking MCP/i);
  assert.match(skill, /MCPHub/i);
  assert.doesNotMatch(skill, /install and configure OpenViking MCP yourself/i);
  assert.doesNotMatch(skill, /user or project Codex config/i);
});

test("openviking-mcphub plugin metadata describes MCP as session-provided", () => {
  const plugin = JSON.parse(read("plugins/openviking-mcphub/.codex-plugin/plugin.json"));

  assert.match(plugin.description, /mcphub/i);
  assert.match(plugin.interface.longDescription, /current runtime session/i);
  assert.match(plugin.interface.longDescription, /MCPHub/i);
  assert.equal(plugin.hooks, "./hooks/hooks.json");
  assert.equal("mcpServers" in plugin, false);
});

test("openviking-mcphub README documents hook fallback without manual Codex MCP setup", () => {
  const readme = read("plugins/openviking-mcphub/README.md");

  assert.match(readme, /hook-driven recall and capture/i);
  assert.match(readme, /current runtime.*OpenViking.*MCPHub/i);
  assert.doesNotMatch(readme, /add and maintain OpenViking MCP config yourself/i);
  assert.doesNotMatch(readme, /user or project Codex config/i);
});
