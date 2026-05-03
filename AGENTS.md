# AGENTS.md

## Repository purpose

Personal NixOS + home-manager dotfiles flake. Single user (`kghost`), single host (`focus`, a Framework Laptop 16 / focus-m2-gen1), single platform (`x86_64-linux`). CI is Garnix.

## Common commands

- `nix flake check` — runs everything CI runs: builds every NixOS toplevel and runs treefmt. This is the canonical "did I break it" check.
- `nix fmt` — format the whole tree (deadnix + nixpkgs-fmt + stylua via `treefmt.nix`).
- `sudo nixos-rebuild switch --flake .#focus` — apply system + home-manager changes to the live machine.
- `nix build .#nixosConfigurations.focus.config.system.build.toplevel` — build the system without activating (use this to test changes before switching).
- `nix build .#homeConfigurations.focus.activationPackage` — build only the standalone home-manager output (note: on the `focus` host home-manager is already wired in via the NixOS module, so a `nixos-rebuild` covers it).
- Disk install (fresh machine, from README): the disko config takes `--arg disks '[ "/dev/nvme0n1" "/dev/nvme1n1" ]'`. Unmount first with `zpool export -fa`.
- `nix flake update <input>` — refresh a single input; `flake.lock` is committed.

## Architecture

The flake is wired with **flake-parts**. `flake.nix` declares inputs and imports two roots: `./machines` and `./modules`. There is no top-level `nixosConfigurations` block — those are produced by the imported modules.

### Three module trees

`modules/default.nix` imports three independent module groups, each of which only exposes things into `flake.*` (no side effects):

- **`modules/flake/`** — flake-level outputs and **the overlay**. `default.nix` defines `flake.overlays.default`, which:
  - Auto-builds every flake input named `p_nvim*` or `p_treesitter-*` into a vim plugin (see `nvimPlugins.nix` and `treesitter-grammars.nix`). **To add a Neovim plugin, just add a flake input with the `p_nvim` prefix** — the overlay picks it up by name. Same for tree-sitter grammars (`p_treesitter-*`).
  - Patches `slack` to enable Wayland screen-share.
  - Also sets `_module.args.pkgs` per-system so all modules see the overlaid `pkgs`.

- **`modules/nixos/`** — exposed as `flake.nixosModules.{android,gnome,games,cache,qmk,virtualisation,nix,hyprland,sound,bluetooth,ledger,rpiBuilder,...}`. These are **opt-in** — `default.nix` only registers them; a machine pulls in only what it needs.

- **`modules/hm/`** — exposed as `flake.homeModules.{base,nvim,git,zsh,tmux,alacritty,scala,foot}`. Same pattern: registration only, machines pick.

### Machines

`machines/default.nix` builds `flake.nixosConfigurations.focus` from `./focusM2`. It also injects every nixosConfiguration into `perSystem.checks` so `nix flake check` builds them.

`machines/focusM2/default.nix` is the only place where modules are actually composed: it imports the `disko` config, hardware, the chosen nixosModules, and uses `home-manager.nixosModules.home-manager` to inline the homeModules for user `kghost`. **`custom.nix` next to it holds host-specific extras** (kept separate from `default.nix` to keep the module list legible).

### Two nixpkgs channels

`nixpkgs-stable` (nixos-25.11) is the default (`nixpkgs.follows = "nixpkgs-stable"`). `nixpkgs-unstable` is also imported. Both are passed through `specialArgs`/`extraSpecialArgs` as `pkgs-stable` and `pkgs-unstable`, with `metals` and `smithy-lang-smithy-ls` merged in from their dedicated flakes (see `machines/default.nix` and `modules/hm/default.nix`). Modules can pick the channel per-package — e.g. `home.packages = [ pkgs-stable.slack ]`.

### Neovim config — the symlink trick

`modules/hm/neovim/default.nix` does **not** copy `lua/` into the Nix store. Instead:

```nix
xdg.configFile."nvim/lua".source = config.lib.file.mkOutOfStoreSymlink
  "${config.home.homeDirectory}/workspace/dot-files/modules/hm/neovim/lua";
```

This means edits to anything under `modules/hm/neovim/lua/` take effect immediately — **no rebuild needed**. The entry point `init.lua` is still inlined into the wrapped neovim, and it forwards a `binaries` table (LSP server paths, formatter paths, nodejs for copilot) to `local/main.setup(binaries)`. When adding a new LSP, thread its binary through that table rather than hard-coding store paths inside `lua/`.

`init.vim` is `builtins.readFile`'d and concatenated, so changes there **do** require a rebuild.

## Things to know before editing

- The overlay's plugin auto-import is name-driven (`p_nvim*`, `p_treesitter-*`). Renaming a flake input changes the overlay attribute name.
- `garnix.yaml` only builds `*.x86_64-linux.*`, matching the flake's single `systems` list. Don't add other systems without updating both.
- The `result` symlink and `.metals`, `.idea` are gitignored — leave them alone.
- The `nix-work` input is a local path (`/home/kghost/dev/nix-work`) — flakes will fail to evaluate if that directory is missing. If you're working on a different machine, this is the first thing to check.
