# ADT-Control Plugin for Claude

Official Claude Code plugin for **ADT-Control**. It lets Claude discover and run your organization's ADT-Control tools as you, the signed-in user, through the `adt` command-line client.

Claude can only run the tools your account is allowed to use. Every call is checked by the ADT-Control server.

## Quickstart

Setup takes three steps: install `adt`, sign in, and add the plugin to Claude. The commands below use `https://adt.andorean.com`; if your organization uses a different ADT-Control address, use that instead.

### 1. Install `adt` (macOS and Linux)

```sh
curl -fsSL https://adt.andorean.com/api/cli/install.sh | ADT_API_URL=https://adt.andorean.com sh
```

The installer checks the download's SHA-256 checksum, then installs `adt` into `/usr/local/bin` if it can write there, otherwise into `~/.local/bin`.

If it prints `note: /Users/<you>/.local/bin is not on PATH`, add that folder to your PATH (zsh shown; use `~/.bashrc` for bash):

```sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

### 2. Sign in

```sh
adt login --api-url https://adt.andorean.com
adt whoami
```

`adt login` opens your browser for single sign-on. Finish signing in there; the terminal continues by itself. Your organization is picked automatically; pass `--org <org_id>` or `--site <site_id>` to choose a different one.

### 3. Add the plugin to Claude

Pick the option that matches how you use Claude.

**Claude Code in a terminal**

```text
/plugin marketplace add andorean/adt-claude-plugin
/plugin install adt-cli@andorean-adt
```

Or from your shell:

```sh
claude plugin marketplace add andorean/adt-claude-plugin
claude plugin install adt-cli@andorean-adt
```

**Claude desktop app (Code tab)**

The desktop app's `/plugin` list only shows your organization's plugin catalog, so it cannot add this marketplace directly. Either ask your Claude organization admin to add `andorean/adt-claude-plugin` to the organization's plugin catalog, or add these lines to `~/.claude/settings.json` (create the file if it does not exist, and merge with anything already in it):

```json
{
  "extraKnownMarketplaces": {
    "andorean-adt": {
      "source": { "source": "github", "repo": "andorean/adt-claude-plugin" }
    }
  },
  "enabledPlugins": {
    "adt-cli@andorean-adt": true
  }
}
```

Then start a new session. Plugins load when a session starts.

### Check that it works

In a new Claude session, ask something like *"List my ADT tools"*. Claude should run `adt whoami` and `adt tools list`. Typing `/adt-cli:` shows the plugin's commands.

---

## Slash Commands

- `/adt-cli:install [<url>]`: install or update `adt`.
- `/adt-cli:login [flags]`: sign in with `adt login` and confirm with `adt whoami`.
- `/adt-cli:logout`: remove the saved token.

## Sign-in Options

`adt login` supports these flows via `--flow`:

| Flow | Command | When to use |
| :--- | :--- | :--- |
| Browser SSO *(default)* | `adt login --api-url https://adt.andorean.com` | Normal laptop or desktop sign-in |
| Device code | `adt login --api-url https://adt.andorean.com --flow device` | Headless or SSH sessions, if your server enables it |
| Existing token file | `adt login --api-url https://adt.andorean.com --keycloak-token-file <path>` | You already have an OIDC access token |
| Local dev (no SSO) | `adt login --api-url http://localhost:8000 --flow none` | A local development server without SSO |

Tokens are short-lived (about a day). When one expires, Claude asks you to sign in again; run `adt login` or `/adt-cli:login`. `adt logout` removes the token but keeps your settings.

## Troubleshooting

See [CLI Setup & Troubleshooting](docs/CLI_SETUP.md#6-common-problems) for fixes to common problems, such as a sign-in that times out or a missing build for your computer.

## For ADT-Control Administrators

Before sharing this plugin with users, check that the server is ready:

- `https://<your-server>/api/cli/dist/checksums.txt` lists builds for every platform your users have (`darwin-arm64`, `darwin-amd64`, `linux-amd64`, `linux-arm64`).
- `https://<your-server>/api/cli/auth-config` returns JSON with `"cli_enabled": true`.
- The Keycloak client named in `auth-config` allows `http://127.0.0.1/*` as a valid redirect URI. Without it, browser sign-in times out.
- Optional: set `ADT_CLI_PUBLIC_URL` on the backend so the install script works without `ADT_API_URL`.

## Security & Privacy

- **Server-side authorization:** every call is checked against your identity, organization, site, enabled applications, and role permissions.
- **Short-lived local tokens:** stored with `0600` permissions in `~/.config/adt/token`, scoped to one organization, and never placed in plugin or config files.
- **Checksum-verified installs:** the install script checks SHA-256 hashes before installing anything.
- **No secret exposure:** the plugin's skill and hook never read or print your token.

## MCP Support

An MCP version (`adt mcp`) is planned but not yet included in published `adt` builds. See [MCP clients](docs/MCP_CLIENTS.md).

## License

[MIT](LICENSE)
