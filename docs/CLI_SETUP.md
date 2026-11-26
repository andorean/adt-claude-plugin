# `adt` CLI Setup & Troubleshooting

This guide covers installing, configuring, upgrading, and troubleshooting the `adt` CLI on macOS and Linux workstations.

## 1. Install `adt`

Replace `https://adt.example.com` with your ADT-Control URL:

```sh
export ADT_API_URL="https://adt.example.com"
curl -fsSL "$ADT_API_URL/api/cli/install.sh" | ADT_API_URL="$ADT_API_URL" sh -s -- adt
```

- Supported platforms: macOS (`darwin-arm64`, `darwin-amd64`) and Linux (`linux-amd64`, `linux-arm64`).
- The installer verifies the SHA-256 checksum against the server before installing.
- Default install location: `/usr/local/bin` if writable, otherwise `~/.local/bin`. Override with `ADT_INSTALL_DIR`:
  ```sh
  ADT_INSTALL_DIR="$HOME/bin" ADT_API_URL="https://adt.example.com" \
    curl -fsSL "https://adt.example.com/api/cli/install.sh" | sh -s -- adt
  ```

### Add `~/.local/bin` to `PATH`

If `adt` is installed in `~/.local/bin` and `command -v adt` does not find it, add this line to `~/.zshrc` or `~/.bashrc` and open a new shell:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

## 2. Sign In & Configuration

```sh
# Sign in to your default organization
adt login --api-url https://adt.example.com

# Or select a specific organization and default site
adt login --api-url https://adt.example.com --org <org_id> --site <site_id>

# Verify your active session and available sites
adt whoami
adt -o json whoami
```

`adt login` writes:
- `~/.config/adt/token` (mode `0600`) — your short-lived CLI token.
- `~/.config/adt/config.json`:
  ```json
  {
    "api_url": "https://adt.example.com",
    "token_file": "/Users/you/.config/adt/token"
  }
  ```

### Environment Variable Precedence

Environment variables override `config.json`:

| Variable | Purpose |
| :--- | :--- |
| `ADT_API_URL` | Base URL of your ADT-Control server |
| `ADT_CLI_TOKEN_FILE` | Path to the file holding the CLI token (preferred over `ADT_CLI_TOKEN`) |
| `ADT_CLI_TOKEN` | CLI token value when not reading from a file |
| `ADT_CONFIG` | Alternate path to `config.json` (default: `~/.config/adt/config.json`, then `/etc/adt/config.json`) |
| `ADT_INSTALL_DIR` | Target directory for `adt cli install` |

### Switching Organization or Site

Re-run `adt login` with `--org` and/or `--site` (no need to pass `--api-url` again once saved in `config.json`):

```sh
adt login --org <org_id> --site <site_id>
```

Use `adt -o json whoami` to inspect the `site_ids` configured for your active organization.

## 3. Common Commands

Global options (`-o text|json`, `--timeout <seconds>`) go **before** the subcommand:

```sh
adt whoami
adt -o json whoami
adt tools list
adt tools list --search <keyword>
adt tools list --app <app_id>
adt tools describe <tool_name>
adt call <tool_name> --arg value
adt call <tool_name> --json '{"site_id": "<site_id>", "limit": 20}'
adt cli list
adt cli install <name>
adt logout
```

## 4. Checking for Updates & Upgrading

Check whether your local `adt` matches the version published by your server:

```sh
adt version
adt version --check
```

`adt version --check` exits `0` when up to date and `1` when a newer build is available. Re-run the install script from Section 1 to upgrade.

## 5. Troubleshooting by Exit Code

| Exit code | Meaning | Resolution |
| :--- | :--- | :--- |
| `1` | Tool or server error (`CLI_DISABLED`, `TOOL_NOT_FOUND`, `INVALID_PARAMETERS`, `SITE_MISMATCH`) | Read the error message. Run `adt tools describe <tool_name>` for argument types, or `adt -o json whoami` for valid `site_ids`. If `CLI_DISABLED`, contact your ADT-Control administrator. |
| `2` | Bad flags or missing `api_url` | Pass `--api-url <url>` to `adt login`, check `ADT_API_URL`, or check `~/.config/adt/config.json`. Run `adt help` for syntax. |
| `3` | Token missing, invalid, or expired | Run `adt login` to obtain a fresh short-lived token. |
| `4` | Refused (`PERMISSION_DENIED`, `ORG_MISMATCH`, `APPLICATION_DISABLED`) | Your account lacks the required role, does not belong to the requested organization, or the application is disabled for the organization. |
| `5` | Server unreachable or request timed out | Check your network connection, VPN, and `api_url`, or increase `--timeout <seconds>`. |
