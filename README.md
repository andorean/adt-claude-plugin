# ADT-Control Plugin for Claude

Official Claude Code plugin for **ADT-Control**. It lets Claude discover and run your organization's ADT-Control tools as you, the signed-in user, through the `adt` command-line client.

Claude can only run the tools your account is allowed to use. Every call is checked by the ADT-Control server.

## Easiest Setup: Let Claude Do It

Paste this prompt into Claude Code, or the Code tab of the Claude desktop app, on macOS or Linux. Claude runs every step and asks your permission for each command; the only thing you do yourself is sign in in the browser.

```text
Set up ADT-Control tools for me on this computer. Run each step yourself, in order, and stop and tell me if any step fails.

1. Install the adt CLI:
   curl -fsSL https://adt.andorean.com/api/cli/install.sh | sh
   If the output says a folder "is not on PATH", run the exact `echo 'export PATH=...' >> ~/.zshrc` line it printed (use ~/.bashrc if my shell is bash). For the rest of this session, call adt by its full path, for example ~/.local/bin/adt.

2. Check it with: adt version

3. Sign me in: run `adt login` in the background, because it waits up to 5 minutes for me. Tell me to finish signing in in the browser tab that opens. When it finishes, run `adt whoami` and tell me my user and organization. Never read, print or copy ~/.config/adt/token.

4. Install the Claude plugin. Find the claude command: use `command -v claude`; if that finds nothing on macOS, use the newest match of
   ls -td "$HOME/Library/Application Support/Claude/claude-code"/*/*/claude.app/Contents/MacOS/claude | head -1
   Then run, with that path:
   <claude> plugin marketplace add andorean/adt-claude-plugin
   <claude> plugin install adt-cli@andorean-adt
   <claude> plugin list
   and confirm adt-cli@andorean-adt shows as enabled.

5. Finish by telling me to start a new Claude session. There, typing /adt-cli: shows the plugin's commands, and I can ask things like "list my ADT tools".
```

If your organization uses a different ADT-Control address, replace `https://adt.andorean.com` in step 1. To do the same steps by hand, follow the Quickstart below.

## Quickstart

Setup takes three steps: install `adt`, sign in, and add the plugin to Claude. The commands below use `https://adt.andorean.com`; if your organization uses a different ADT-Control address, put that in the install command instead.

### 1. Install `adt` (macOS and Linux)

```sh
curl -fsSL https://adt.andorean.com/api/cli/install.sh | sh
```

The installer checks the download's SHA-256 checksum, installs `adt` into `/usr/local/bin` if it can write there (otherwise `~/.local/bin`), and remembers the server address for `adt login`.

If it says the folder `is not on PATH`, run the one command it prints, then open a new terminal.

### 2. Sign in

```sh
adt login
adt whoami
```

`adt login` opens your browser for single sign-on and waits up to 5 minutes. Finish signing in there; the terminal continues by itself. If it says there is no ADT-Control address yet, run `adt login --api-url https://adt.andorean.com` once. Your organization is picked automatically; pass `--org <org_id>` or `--site <site_id>` to choose a different one.

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

The desktop app's `/plugin` list only shows your organization's plugin catalog, so it cannot add this marketplace. The app ships the `claude` command inside its own folder, though, so run the same commands with that path (macOS):

```sh
CLAUDE=$(ls -td "$HOME/Library/Application Support/Claude/claude-code"/*/*/claude.app/Contents/MacOS/claude | head -1)
"$CLAUDE" plugin marketplace add andorean/adt-claude-plugin
"$CLAUDE" plugin install adt-cli@andorean-adt
```

Then start a new session. Plugins load when a session starts. Alternatively, your Claude organization admin can add `andorean/adt-claude-plugin` to the organization's plugin catalog.

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

Tokens are short-lived (less than a day). When one expires, Claude asks you to sign in again; run `adt login` or `/adt-cli:login`. `adt logout` removes the token but keeps your settings.

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
