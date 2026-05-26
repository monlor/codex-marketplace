#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";
import process from "node:process";
import { spawnSync } from "node:child_process";

function usage() {
  console.error(
    "Usage: scripts/check-external-cli.mjs <config-path> [--json]",
  );
}

function fail(message) {
  console.error(message);
  process.exit(2);
}

function parseArgs(argv) {
  let json = false;
  let configPath = null;

  for (const arg of argv) {
    if (arg === "--json") {
      json = true;
      continue;
    }
    if (!configPath) {
      configPath = arg;
      continue;
    }
    fail(`Unexpected argument: ${arg}`);
  }

  if (!configPath) {
    usage();
    process.exit(2);
  }

  return { json, configPath: path.resolve(configPath) };
}

function readConfig(configPath) {
  let raw;
  try {
    raw = fs.readFileSync(configPath, "utf8");
  } catch (error) {
    fail(`Could not read config at ${configPath}: ${error.message}`);
  }

  let config;
  try {
    config = JSON.parse(raw);
  } catch (error) {
    fail(`Invalid JSON in ${configPath}: ${error.message}`);
  }

  if (!config || typeof config !== "object") {
    fail(`Config at ${configPath} must be a JSON object.`);
  }
  if (typeof config.command !== "string" || config.command.length === 0) {
    fail(`Config at ${configPath} must include a non-empty "command".`);
  }

  return config;
}

function getPlatformInstallHint(installHints) {
  if (!installHints || typeof installHints !== "object") return null;
  return installHints[process.platform] ?? installHints.default ?? null;
}

function resolveOnPath(command) {
  const pathValue = process.env.PATH ?? "";
  const pathEntries = pathValue.split(path.delimiter).filter(Boolean);
  const extensions =
    process.platform === "win32"
      ? (process.env.PATHEXT ?? ".EXE;.CMD;.BAT;.COM")
          .split(";")
          .filter(Boolean)
      : [""];

  for (const entry of pathEntries) {
    for (const ext of extensions) {
      const candidate = path.join(entry, `${command}${ext}`);
      if (!fs.existsSync(candidate)) continue;
      try {
        fs.accessSync(candidate, fs.constants.X_OK);
      } catch {
        continue;
      }
      return candidate;
    }
  }

  return null;
}

function parseVersion(text) {
  const match = text.match(/\b(\d+)\.(\d+)(?:\.(\d+))?(?:-([0-9A-Za-z.-]+))?\b/);
  if (!match) return null;
  return {
    raw: match[0],
    major: Number(match[1]),
    minor: Number(match[2]),
    patch: Number(match[3] ?? "0"),
    prerelease: match[4] ?? null,
  };
}

function compareIdentifiers(left, right) {
  const leftNumeric = /^\d+$/.test(left);
  const rightNumeric = /^\d+$/.test(right);

  if (leftNumeric && rightNumeric) return Number(left) - Number(right);
  if (leftNumeric) return -1;
  if (rightNumeric) return 1;
  return left.localeCompare(right);
}

function compareVersions(left, right) {
  for (const key of ["major", "minor", "patch"]) {
    if (left[key] !== right[key]) return left[key] - right[key];
  }

  if (!left.prerelease && !right.prerelease) return 0;
  if (!left.prerelease) return 1;
  if (!right.prerelease) return -1;

  const leftParts = left.prerelease.split(".");
  const rightParts = right.prerelease.split(".");
  const maxLength = Math.max(leftParts.length, rightParts.length);

  for (let index = 0; index < maxLength; index += 1) {
    const leftPart = leftParts[index];
    const rightPart = rightParts[index];
    if (leftPart == null) return -1;
    if (rightPart == null) return 1;

    const diff = compareIdentifiers(leftPart, rightPart);
    if (diff !== 0) return diff;
  }

  return 0;
}

function checkVersion(commandPath, config) {
  const versionArgs = Array.isArray(config.versionArgs)
    ? config.versionArgs
    : ["--version"];

  const result = spawnSync(commandPath, versionArgs, {
    encoding: "utf8",
    env: process.env,
  });

  const output = `${result.stdout ?? ""}\n${result.stderr ?? ""}`.trim();

  if (result.error) {
    return {
      ok: false,
      reason: "version_check_failed",
      details: result.error.message,
      version: null,
      output,
    };
  }

  if (result.status !== 0) {
    return {
      ok: false,
      reason: "version_check_failed",
      details: `Version command exited with status ${result.status}.`,
      version: null,
      output,
    };
  }

  const detected = parseVersion(output);
  if (!detected) {
    return {
      ok: false,
      reason: "version_parse_failed",
      details: "Could not parse a version from command output.",
      version: null,
      output,
    };
  }

  if (config.minVersion) {
    const minimum = parseVersion(String(config.minVersion));
    if (!minimum) {
      fail(`Invalid minVersion in config: ${config.minVersion}`);
    }

    if (compareVersions(detected, minimum) < 0) {
      return {
        ok: false,
        reason: "version_too_low",
        details: `Found ${detected.raw}, need at least ${config.minVersion}.`,
        version: detected.raw,
        output,
      };
    }
  }

  return {
    ok: true,
    reason: "ok",
    details: null,
    version: detected.raw,
    output,
  };
}

function buildResult(config, resolvedPath, versionCheck) {
  const installHint = getPlatformInstallHint(config.installHints);

  if (!resolvedPath) {
    return {
      ok: false,
      installed: false,
      reason: "missing",
      name: config.name ?? config.command,
      command: config.command,
      path: null,
      version: null,
      installHint,
      missingMessage:
        config.missingMessage ?? `${config.command} host runtime not found on PATH.`,
      degradedMessage: config.degradedMessage ?? null,
      details: null,
      versionOutput: null,
    };
  }

  if (!versionCheck) {
    return {
      ok: true,
      installed: true,
      reason: "ok",
      name: config.name ?? config.command,
      command: config.command,
      path: resolvedPath,
      version: null,
      installHint,
      missingMessage: null,
      degradedMessage: null,
      details: null,
      versionOutput: null,
    };
  }

  return {
    ok: versionCheck.ok,
    installed: true,
    reason: versionCheck.reason,
    name: config.name ?? config.command,
    command: config.command,
    path: resolvedPath,
    version: versionCheck.version,
    installHint,
    missingMessage: null,
    degradedMessage: versionCheck.ok ? null : config.degradedMessage ?? null,
    details: versionCheck.details,
    versionOutput: versionCheck.output || null,
  };
}

function printHuman(result) {
  if (result.ok) {
    console.log(`${result.command} runtime found: ${result.path}`);
    if (result.version) console.log(result.version);
    return;
  }

  if (result.reason === "missing" && result.missingMessage) {
    console.error(result.missingMessage);
  } else if (result.details) {
    console.error(`${result.command} check failed: ${result.details}`);
  } else {
    console.error(`${result.command} check failed: ${result.reason}`);
  }

  if (result.degradedMessage) {
    console.error(result.degradedMessage);
  }

  if (result.installHint) {
    console.error(`Install hint: ${result.installHint}`);
  }
}

const { json, configPath } = parseArgs(process.argv.slice(2));
const config = readConfig(configPath);
const resolvedPath = resolveOnPath(config.command);
const versionCheck = resolvedPath ? checkVersion(resolvedPath, config) : null;
const result = buildResult(config, resolvedPath, versionCheck);

if (json) {
  console.log(JSON.stringify(result, null, 2));
} else {
  printHuman(result);
}

process.exit(result.ok ? 0 : 1);
