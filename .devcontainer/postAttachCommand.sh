#!/bin/bash
set -euo pipefail

echo "Running post attach commands..."
# Generate CKANR_TEST_KEY via the host Docker daemon shared into the
# devcontainer by the docker-outside-of-docker feature.
# DOCKER_HOST is already set by devcontainer.json remoteEnv; keep an explicit
# fallback for shells attached outside VS Code.
export DOCKER_HOST="${DOCKER_HOST:-unix:///var/run/docker-host.sock}"

# Same parse as CI (.github/workflows/R-check.yaml): the token follows
# the 'API Token created:' marker. No pinned DOCKER_API_VERSION.
CKANR_TEST_KEY="$(docker exec ckan ckan user token add ckan_admin dev_token 2>/dev/null | sed 's/API Token created://' | tr -d '\n\t ')"
if [ -z "${CKANR_TEST_KEY}" ]; then
  echo "WARNING: could not mint a CKAN token (is the ckan container running?). Skipping env persistence." >&2
  exit 0
fi

# This is the public facing URL which only works for users of the codespace.
# Access is protected by GitHub authentication.
# R scripts can only access CKAN via localhost port forwarding.
CKANR_TEST_URL=http://localhost:5000
CODESPACE_PUBLIC_URL=http://localhost:5000
CODESPACE_NAME="${CODESPACE_NAME:-}"

persist_shell_var() {
  local var="$1" val="$2" file="$3"
  # Idempotent: drop any earlier managed line, then append once.
  grep -v "export ${var}=" "${file}" 2>/dev/null > "${file}.tmp" || true
  printf "export %s='%s'\n" "${var}" "${val}" >> "${file}.tmp"
  mv "${file}.tmp" "${file}"
}

persist_renv_var() {
  local var="$1" val="$2" file="$3"
  grep -v "^${var}=" "${file}" 2>/dev/null > "${file}.tmp" || true
  printf "%s=%s\n" "${var}" "${val}" >> "${file}.tmp"
  mv "${file}.tmp" "${file}"
}

# Persist environment variables to shell profile for all future terminal sessions
touch ~/.bashrc
persist_shell_var "CKANR_TEST_KEY" "${CKANR_TEST_KEY}" ~/.bashrc
persist_shell_var "CKANR_DEFAULT_KEY" "${CKANR_TEST_KEY}" ~/.bashrc
persist_shell_var "CKANR_TEST_URL" "${CKANR_TEST_URL}" ~/.bashrc
persist_shell_var "CKANR_DEFAULT_URL" "${CKANR_TEST_URL}" ~/.bashrc
persist_shell_var "CKANR_BROWSER_URL" "${CODESPACE_PUBLIC_URL}" ~/.bashrc
echo "Environment variables persisted to ~/.bashrc"

# Provide GITHUB_TOKEN for pak (higher GitHub API rate limit) and gh usage.
# In Codespaces it arrives via remoteEnv above; otherwise read it from the
# user's GitHub CLI authentication when available.
if [ -z "${GITHUB_TOKEN:-}" ] && command -v gh >/dev/null 2>&1; then
  GITHUB_TOKEN="$(gh auth token 2>/dev/null || true)"
fi
if [ -n "${GITHUB_TOKEN:-}" ]; then
  touch ~/.bashrc ~/.Renviron
  persist_shell_var "GITHUB_TOKEN" "${GITHUB_TOKEN}" ~/.bashrc
  persist_renv_var "GITHUB_TOKEN" "${GITHUB_TOKEN}" ~/.Renviron
  echo "GITHUB_TOKEN persisted to ~/.bashrc and ~/.Renviron"
else
  echo "NOTE: GITHUB_TOKEN is not set (no remoteEnv value, gh CLI missing or logged out). Run 'gh auth login' and re-attach; pak falls back to unauthenticated GitHub API calls." >&2
fi

# Persist environment variables to R environment for R sessions
touch ~/.Renviron
persist_renv_var "CKANR_DEFAULT_URL" "${CKANR_TEST_URL}" ~/.Renviron
persist_renv_var "CKANR_DEFAULT_KEY" "${CKANR_TEST_KEY}" ~/.Renviron
persist_renv_var "CKANR_TEST_URL" "${CKANR_TEST_URL}" ~/.Renviron
persist_renv_var "CKANR_TEST_KEY" "${CKANR_TEST_KEY}" ~/.Renviron
persist_renv_var "CODESPACE_NAME" "${CODESPACE_NAME}" ~/.Renviron
persist_renv_var "CKANR_ALLOW_PURGE_TESTS" "TRUE" ~/.Renviron
persist_renv_var "CKANR_BROWSER_URL" "${CODESPACE_PUBLIC_URL}" ~/.Renviron
echo "Environment variables persisted to ~/.Renviron for R sessions"

# Seed OpenCode Go credentials so fresh devspaces skip /connect.
# OPENCODE_GO_API_KEY is injected via devcontainer.json remoteEnv from a
# Codespaces / repository secret of the same name. Auth file format:
# {"opencode-go": {"type": "api", "key": "<token>"}}
if [ -n "${OPENCODE_GO_API_KEY:-}" ]; then
  mkdir -p ~/.local/share/opencode
  OPENCODE_AUTH_FILE=~/.local/share/opencode/auth.json \
    OPENCODE_GO_API_KEY="${OPENCODE_GO_API_KEY}" \
    python3 -c '
import json, os
path = os.path.expandvars("$OPENCODE_AUTH_FILE")
key = os.environ["OPENCODE_GO_API_KEY"]
try:
    with open(path) as f:
        auth = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    auth = {}
auth["opencode-go"] = {"type": "api", "key": key}
with open(path, "w") as f:
    json.dump(auth, f, indent=2)
    f.write("\n")
os.chmod(path, 0o600)
'
  persist_shell_var "OPENCODE_API_KEY" "${OPENCODE_GO_API_KEY}" ~/.bashrc
  echo "OpenCode Go credentials seeded in ~/.local/share/opencode/auth.json"
else
  echo "NOTE: OPENCODE_GO_API_KEY is not set. Run 'opencode /connect', select 'OpenCode Go', and paste your key; or set the OPENCODE_GO_API_KEY Codespaces secret and re-attach." >&2
fi
