import test from "node:test";
import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import { dirname, resolve } from "node:path";

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = resolve(__dirname, "..");

function runAutoRecall(scriptPath) {
  const result = spawnSync(
    process.execPath,
    [scriptPath],
    {
      cwd: repoRoot,
      input: JSON.stringify({ prompt: "recall this preference" }),
      encoding: "utf8",
      env: {
        ...process.env,
        OPENVIKING_URL: "http://127.0.0.1:1",
        OPENVIKING_API_KEY: "test-key",
        OPENVIKING_TIMEOUT_MS: "1000",
        OPENVIKING_AUTO_RECALL: "1",
      },
    },
  );

  assert.equal(result.status, 0, result.stderr || `expected ${scriptPath} to exit cleanly`);
  assert.equal(result.stderr, "");
  assert.ok(result.stdout.trim(), `expected ${scriptPath} to emit hook output`);
  return JSON.parse(result.stdout.trim());
}

for (const scriptPath of [
  "plugins/openviking-memory/scripts/auto-recall.mjs",
  "plugins/openviking-mcphub/scripts/auto-recall.mjs",
]) {
  test(`${scriptPath} emits schema-compliant no-op on health failures`, () => {
    const output = runAutoRecall(scriptPath);
    assert.deepEqual(output, {});
  });
}
