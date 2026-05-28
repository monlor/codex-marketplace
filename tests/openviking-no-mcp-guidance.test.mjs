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

test("openviking-memory-no-mcp skill describes self-managed MCP", () => {
  const skill = read("plugins/openviking-memory-no-mcp/skills/openviking-memory-no-mcp-usage/SKILL.md");

  assert.match(skill, /install and configure OpenViking MCP yourself/i);
  assert.match(skill, /OpenViking MCP/i);
  assert.match(skill, /\.mcp\.json/i);
  assert.doesNotMatch(skill, /current agent/i);
});

test("openviking-memory-no-mcp plugin metadata describes MCP as user-managed", () => {
  const plugin = JSON.parse(read("plugins/openviking-memory-no-mcp/.codex-plugin/plugin.json"));

  assert.match(plugin.description, /without bundled MCP wiring/i);
  assert.match(plugin.interface.longDescription, /install and configure OpenViking's native MCP endpoint yourself/i);
  assert.equal(plugin.hooks, "./hooks/hooks.json");
  assert.equal("mcpServers" in plugin, false);
});

test("openviking-memory-no-mcp README keeps MCP manual and no longer assumes session-provided MCP", () => {
  const readme = read("plugins/openviking-memory-no-mcp/README.md");

  assert.match(readme, /same OpenViking memory hooks as the full plugin/i);
  assert.match(readme, /add and maintain OpenViking MCP config yourself/i);
  assert.match(readme, /\.mcp\.json/i);
  assert.doesNotMatch(readme, /current agent/i);
});
