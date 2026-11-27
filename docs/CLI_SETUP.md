# `adt` CLI Setup & Troubleshooting

This guide covers installing, configuring, upgrading, and troubleshooting the `adt` CLI on macOS and Linux workstations.

## 1. Install `adt`

The commands in this guide use `https://adt.andorean.com`. If your organization uses a different ADT-Control address, use that instead.

```sh
curl -fsSL https://adt.andorean.com/api/cli/install.sh | ADT_API_URL=https://adt.andorean.com sh
```

- Supported platforms: macOS (`darwin-arm64`, `darwin-amd64`) and Linux (`linux-amd64`, `linux-arm64`).
- The installer verifies the SHA-256 checksum against the server before installing.
- Default install location: `/usr/local/bin` if writable, otherwise `~/.local/bin`. Override with `ADT_INSTALL_DIR`:
  ```sh
  curl -fsSL https://adt.andorean.com/api/cli/install.sh | ADT_INSTALL_DIR="$HOME/bin" ADT_API_URL=https://adt.andorean.com sh
  ```

### Add `~/.local/bin` to `PATH`

If `adt` is installed in `~/.local/bin` and `command -v adt` does not find it, add it to your PATH (zsh shown; use `~/.bashrc` for bash):

```sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

## 2. Sign In & Configuration

```sh
# Sign in to your default organization
adt login --api-url https://adt.andorean.com

# Or select a specific organization and default site
adt login --api-url https://adt.andorean.com --org <org_id> --site <site_id>

# Verify your active session and available sites
adt whoami
adt -o json whoami
```

`adt login` writes:
- `~/.config/adt/token` (mode `0600`): your short-lived CLI token (valid for less than a day).
- `~/.config/adt/config.json`:
  ```json
  {
    "api_url": "https://adt.andorean.com",
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

## 6. Common Problems

| Problem | Cause | Fix |
| :--- | :--- | :--- |
| Installer says `this backend does not offer adt for darwin-arm64` (or another platform) | The server has no `adt` build for your computer | Contact your ADT-Control administrator. Check what the server offers at `https://adt.andorean.com/api/cli/dist/checksums.txt`. |
| `curl: (60) SSL certificate problem` | The address does not have a valid certificate, often because it is the wrong hostname | Check the address with your administrator. Do not bypass the check with `curl -k`: the checksum would no longer protect you. |
| `command not found: adt` right after installing | `~/.local/bin` is not on your PATH | Run the PATH command in [Section 1](#add-localbin-to-path). |
| `adt login` says `browser login timed out waiting for callback` | You did not finish signing in, or the sign-in page showed `Invalid parameter: redirect_uri` | Run `adt login` again and finish signing in in the browser tab it opens. If the page shows the `redirect_uri` error, your administrator must add `http://127.0.0.1/*` to the Keycloak client's valid redirect URIs. |
| `adt login --flow device` fails with `unauthorized_client` | Device sign-in is not enabled on the server | Use the default browser sign-in, or ask your administrator to enable the device authorization grant. |
| `adt login` fails with `Not Found` | The server does not support local CLI sign-in yet | Check that `https://adt.andorean.com/api/cli/auth-config` returns JSON, and ask your administrator to update the server. |
| Claude says the token is missing or expired (exit code `3`) | Tokens last less than a day | Run `adt login` or `/adt-cli:login` again. |
| The desktop app's `/plugin` list does not show `adt-cli` | The desktop app lists only your organization's plugin catalog | Use the `~/.claude/settings.json` setup in the [README](../README.md#3-add-the-plugin-to-claude), then start a new session. |
