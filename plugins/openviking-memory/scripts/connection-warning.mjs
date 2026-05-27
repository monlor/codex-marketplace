function hasExplicitConnectionConfig(cfg) {
  return Boolean(
    process.env.OPENVIKING_URL
    || process.env.OPENVIKING_BASE_URL
    || process.env.OPENVIKING_API_KEY
    || process.env.OPENVIKING_BEARER_TOKEN
    || cfg?.cliConfigPath
    || cfg?.ovConfigPath,
  );
}

export function openVikingConnectionWarning(cfg, detail = {}) {
  const target = cfg?.baseUrl || "OpenViking";

  if (detail.status === 401 || detail.status === 403) {
    return `OpenViking rejected authentication at ${target}. Check OPENVIKING_API_KEY and OPENVIKING_URL, then restart Codex.`;
  }

  if (detail.type === "network" && !hasExplicitConnectionConfig(cfg)) {
    return `OpenViking unavailable at ${target}. Configure OPENVIKING_URL and OPENVIKING_API_KEY, then restart Codex.`;
  }

  if (detail.type === "network") {
    return `OpenViking unavailable at ${target}. Check OPENVIKING_URL, OPENVIKING_API_KEY, and network reachability, then restart Codex.`;
  }

  return `OpenViking returned an unexpected response at ${target}. Check OPENVIKING_URL and OPENVIKING_API_KEY, then restart Codex.`;
}
