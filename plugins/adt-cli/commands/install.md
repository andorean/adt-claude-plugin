---
description: Install or update the `adt` CLI binary from your ADT-Control server (SHA-256 verified)
argument-hint: "[<api_url>]"
---

Install or update the `adt` command-line binary.

1. Determine the ADT-Control base URL:
   - If the user passed a URL in `$ARGUMENTS`, validate it starts with `http://` or `https://` and use it.
   - Otherwise check whether `ADT_API_URL` is set or `~/.config/adt/config.json` already provides `api_url`.
   - If no URL is available, ask the user for their ADT-Control URL (for example `https://adt.example.com`) before running the installer.
2. If `adt` is already installed, check `adt version` (and `adt version --check` when `ADT_API_URL` or config is present) to see if it is already up to date.
3. Run the checksum-verified installer:
   ```sh
   curl -fsSL "$URL/api/cli/install.sh" | ADT_API_URL="$URL" sh -s -- adt
   ```
   *(Installs into `/usr/local/bin` if writable, otherwise `~/.local/bin`; honors `ADT_INSTALL_DIR`.)*
4. Verify the installation with `adt version` (or `~/.local/bin/adt version`). If `~/.local/bin` is not in `PATH`, show the user the exact export line for their shell profile.
5. Remind the user to run `/adt-cli:login` next if they have not signed in yet.
