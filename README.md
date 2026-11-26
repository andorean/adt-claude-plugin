# ADT-Control Plugins for Claude

Official Claude Code plugin marketplace for **ADT-Control**. Connect Claude to your ADT-Control organization's tools as the signed-in user using either the **CLI workflow (`adt-cli`)** or the **MCP workflow (`adt-mcp`)**.

## Choosing a Plugin

Install **one** of the two plugins below (avoid enabling both at once so Claude does not see duplicate tool paths):

| Feature | `adt-cli` | `adt-mcp` |
| :--- | :--- | :--- |
| **How Claude runs tools** | Shell commands (`adt tools list`, `adt call ...`) | Native structured MCP tool calls (`adt mcp`) |
| **Context footprint** | Minimal (tools discovered on demand) | Compact (`--mode meta`) or full schemas (`--mode direct`) |
| **Tool call UX** | Uses Claude Code Bash permission | Native MCP tool approval (no Bash prompt per call) |
| **Works in other clients** | Any shell-capable coding agent | Claude Code, Claude Desktop, Cursor, Windsurf |
| **CLI build requirement** | Works with any `adt` build supporting `adt login` | Requires an `adt` build that includes the `mcp` subcommand |

---

## Quickstart

### 1. Install the `adt` binary (macOS & Linux)

Replace `https://adt.example.com` with your ADT-Control URL:

```sh
export ADT_API_URL="https://adt.example.com"
curl -fsSL "$ADT_API_URL/api/cli/install.sh" | ADT_API_URL="$ADT_API_URL" sh -s -- adt
```

The installer verifies the binary's SHA-256 checksum before installing into `/usr/local/bin` (if writable) or `~/.local/bin`.

### 2. Sign in

```sh
adt login --api-url https://adt.example.com --org <org_id> --site <site_id>
adt whoami
```

`adt login` opens your browser for SSO login, saves a short-lived token (`0600`) to `~/.config/adt/token`, and writes `~/.config/adt/config.json`. The raw token is never printed.

### 3. Add the marketplace and install a plugin in Claude Code

Inside Claude Code:

```text
/plugin marketplace add andorean/adt-claude-plugin

# Install ONE of the two plugins:
/plugin install adt-cli@andorean-adt
# or
/plugin install adt-mcp@andorean-adt
```

Once installed, Claude automatically discovers and invokes the tools your user account is authorized to run.

---

## Authentication Flows

`adt login` supports four flows via `--flow`:

| Flow | Command | When to use |
| :--- | :--- | :--- |
| Browser SSO *(default)* | `adt login --api-url https://adt.example.com` | Standard desktop/laptop login with browser PKCE callback |
| Device code | `adt login --api-url https://adt.example.com --flow device` | Headless terminal or SSH session |
| Existing OIDC token file | `adt login --api-url https://adt.example.com --keycloak-token-file <path>` | Exchange an existing OIDC access token file |
| Local dev (no SSO) | `adt login --api-url http://localhost:8000 --flow none` | Local development server running without SSO |

Run `adt logout` at any time to remove the local token file while keeping `~/.config/adt/config.json`.

---

## Included Slash Commands

Both plugins provide convenience slash commands inside Claude Code:

- `/adt-cli:install` or `/adt-mcp:install` — Install or update the `adt` binary via `install.sh`.
- `/adt-cli:login` or `/adt-mcp:login` — Run `adt login` and verify your session with `adt whoami`.
- `/adt-cli:logout` or `/adt-mcp:logout` — Remove the saved local token file.

---

## Security & Privacy

- **Backend-enforced authorization:** Every call is checked server-side against your signed-in identity, organization, site, enabled applications, and role permissions.
- **Short-lived, isolated tokens:** Local tokens are stored with `0600` permissions in `~/.config/adt/token`, scoped to one organization, and never embedded in plugin or config files.
- **Checksum-verified installs:** The official install script checks SHA-256 hashes before installing any binary.
- **No secret exposure:** The included skills and hooks never read or print your token file.

---

## Further Documentation

- [CLI Setup & Troubleshooting](docs/CLI_SETUP.md)
- [Using `adt mcp` in Claude Desktop, Cursor, and Windsurf](docs/MCP_CLIENTS.md)

## License

[MIT](LICENSE)
