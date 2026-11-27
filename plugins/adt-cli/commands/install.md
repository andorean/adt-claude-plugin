---
description: Install or update the `adt` CLI binary from your ADT-Control server (SHA-256 verified)
argument-hint: "[<api_url>]"
---

Install or update the `adt` command-line binary.

1. Determine the ADT-Control base URL, in this order:
   - A URL the user passed in `$ARGUMENTS` (it must start with `http://` or `https://`).
   - `ADT_API_URL`, or `api_url` in `~/.config/adt/config.json`.
   - Otherwise use the default, `https://adt.andorean.com`. Tell the user which URL you are using, and that they can pass a different one (for example `/adt-cli:install https://adt-staging.andorean.com`).
2. If `adt` is already installed, run `adt version` and `ADT_API_URL="$URL" adt version --check`. If it is up to date, say so and stop.
3. Run the checksum-verified installer:
   ```sh
   curl -fsSL "$URL/api/cli/install.sh" | ADT_API_URL="$URL" sh -s -- adt
   ```
   It installs into `/usr/local/bin` if writable, otherwise `~/.local/bin`, and honors `ADT_INSTALL_DIR`.
4. If the installer reports `this backend does not offer adt for <platform>`, the server has no build for this computer. Tell the user to contact their ADT-Control administrator; do not try other servers.
5. Verify with `adt version` (or `~/.local/bin/adt version`). If the installer printed `note: ... is not on PATH`, give the user the exact line for their shell profile, for zsh:
   ```sh
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
   ```
6. Remind the user to run `/adt-cli:login` next if they have not signed in yet.
