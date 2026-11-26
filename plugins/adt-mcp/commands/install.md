---
description: Install or update the `adt` binary required by the `adt-mcp` server (SHA-256 verified)
argument-hint: "[<api_url>]"
---

Install or update the `adt` binary that backs the `adt-mcp` MCP server.

1. Determine the ADT-Control base URL:
   - If the user passed a URL in `$ARGUMENTS`, validate it starts with `http://` or `https://` and use it.
   - Otherwise check whether `ADT_API_URL` is set or `~/.config/adt/config.json` already provides `api_url`.
   - If no URL is available, ask the user for their ADT-Control URL (for example `https://adt.example.com`) before running the installer.
2. Run the checksum-verified installer:
   ```sh
   curl -fsSL "$URL/api/cli/install.sh" | ADT_API_URL="$URL" sh -s -- adt
   ```
   *(Installs into `/usr/local/bin` if writable, otherwise `~/.local/bin`; honors `ADT_INSTALL_DIR`.)*
3. Verify the installation with `adt version` and check whether `adt mcp --help` is supported by this build. If `mcp` is not yet included in the installed version, let the user know they can use `adt-cli` in the meantime.
4. Remind the user to run `/adt-mcp:login` next if they have not signed in yet.
