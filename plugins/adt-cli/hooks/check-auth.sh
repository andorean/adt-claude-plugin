#!/bin/sh
# Non-blocking, offline SessionStart check for the adt-cli plugin.
# Never makes network calls, never reads or prints token contents, and always exits 0.
set -u

if ! command -v adt >/dev/null 2>&1; then
  printf '%s\n' "adt CLI not found on PATH. Run /adt-cli:install to install it."
  exit 0
fi

if [ -n "${ADT_CLI_TOKEN:-}" ]; then
  exit 0
fi

if [ -n "${ADT_CLI_TOKEN_FILE:-}" ]; then
  if [ -s "$ADT_CLI_TOKEN_FILE" ]; then
    exit 0
  fi
  printf '%s\n' "ADT_CLI_TOKEN_FILE is missing or empty. Run /adt-cli:login (or 'adt login') to sign in."
  exit 0
fi

token_path=""
cfg_path="${ADT_CONFIG:-${HOME:-}/.config/adt/config.json}"
if [ -n "$cfg_path" ] && [ -r "$cfg_path" ]; then
  token_path=$(sed -n 's/.*"token_file"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$cfg_path" | head -n 1)
fi
if [ -z "$token_path" ] && [ -n "${HOME:-}" ]; then
  token_path="$HOME/.config/adt/token"
fi

if [ -n "$token_path" ] && [ -s "$token_path" ]; then
  exit 0
fi

printf '%s\n' "Not signed in to ADT-Control. Run /adt-cli:login (or 'adt login') to sign in."
exit 0
