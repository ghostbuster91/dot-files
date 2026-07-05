{ config, pkgs, pkgs-stable, lib, ... }:
let
  leaderKey = "\\<Space>";
in
{
  home.packages = (with pkgs; [
    go
  ]);
  xdg.configFile."nvim/lua" = {
    recursive = true;
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dot-files/modules/hm/neovim/lua";
  };
  # home.file."./.config/nvim/lua/" = {
  #   source = ./lua;
  #   recursive = true;
  # };
  programs.neovim = {
    enable = true;
    # package = pkgs-unstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;
    extraConfig = ''
      	let mapleader = "${leaderKey}"
    '' +
    "${builtins.readFile ./init.vim}" +
    ''
      lua << EOF
        local binaries = {
          tsserver_path = "${pkgs.typescript-language-server}/bin/typescript-language-server",
          typescript_path = "${pkgs.typescript}/lib/node_modules/typescript/lib",
          metals_binary_path = "${pkgs-stable.metals}/bin/metals",
          smithy_ls_path = "${pkgs-stable.smithy-lang-smithy-ls}/bin/smithy_ls",
          lua_language_server = "${pkgs.lua-language-server}/bin/lua-language-server",
          nodejs = "${lib.getExe pkgs.nodejs}", -- required for copilot
          nix_fmt = "${lib.getExe pkgs.nixpkgs-fmt}",
          nix = "${lib.getExe pkgs.nix}"
        }
        
        ${builtins.readFile ./init.lua}
      EOF
    '';
    # TODO: language server binaries should be passed explicitly to nvim lua configuration
    extraPackages = with pkgs; [
      bash-language-server
      vim-language-server
      yaml-language-server
      nil
      lua-language-server
      stylua
      shfmt
      eslint
      prettier
      cspell
      rust-analyzer
      rustfmt
      gopls
      go # for gopls
    ];
    plugins = with pkgs-stable.vimPlugins; [
      rec {
        plugin = kanagawa-nvim;
        type = "viml";
        config = ''
          packadd! ${plugin.pname}
          colorscheme kanagawa
        '';
      }
      telescope-nvim
      telescope-fzf-native-nvim
      which-key-nvim
      nvim-autopairs
      vim-sandwich
      gitsigns-nvim
      plenary-nvim

      # completions
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip

      # lsp stuff
      nvim-lspconfig

      (nvim-treesitter.withPlugins (
        # https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/development/tools/parsing/tree-sitter/grammars
        plugins:
          with plugins; [
            tree-sitter-lua
            tree-sitter-vim
            tree-sitter-vimdoc
            tree-sitter-html
            tree-sitter-yaml
            tree-sitter-json
            tree-sitter-markdown
            tree-sitter-markdown-inline
            tree-sitter-comment
            tree-sitter-bash
            tree-sitter-javascript
            tree-sitter-nix
            tree-sitter-typescript
            tree-sitter-tsx
            tree-sitter-c
            tree-sitter-java
            tree-sitter-kotlin
            tree-sitter-scala
            pkgs-stable.p_treesitter-devicetree
            pkgs-stable.p_treesitter-hocon
            pkgs-stable.p_treesitter-xml
            tree-sitter-query # for the tree-sitter itself
            tree-sitter-python
            tree-sitter-go
            tree-sitter-hocon
            tree-sitter-sql
            tree-sitter-graphql
            tree-sitter-dockerfile
            tree-sitter-scheme
            tree-sitter-rust
            tree-sitter-smithy
          ]
      ))
      # TODO
      # (nvim-treesitter-textobjects.overrideAttrs { doCheck = false; })
      # (nvim-treesitter-refactor.overrideAttrs { doCheck = false; })

      nvim-web-devicons
      lualine-nvim
      nvim-navic
      comment-nvim

      # snippets
      luasnip
      lspkind-nvim
      friendly-snippets

      nvim-neoclip-lua
      indent-blankline-nvim
      # (p_nvim-tree-lua.overrideAttrs { doCheck = false; })
      (p_nvim-tree-lsp.overrideAttrs { doCheck = false; })
      vim-tmux-clipboard
      telescope-ui-select-nvim
      noice-nvim
      nui-nvim
      fidget-nvim
      nvim-lightbulb
      p_nvim-next
      neoscroll-nvim
      neogit
      undotree
      diffview-nvim
      goto-preview
      nvim-dap
      {
        plugin = nvim-dap-ui;
        type = "viml";
        config = ''
          lua << EOF
            require("dapui").setup()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.event_terminated["dapui_config"] = function()
              dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
              dapui.close()
            end
          EOF
        '';
      }
      telescope-dap-nvim
      nvim-metals
      trouble-nvim
      vim-repeat
      flash-nvim
      gitlinker-nvim
      actions-preview-nvim
      p_nvim-portal
      {
        plugin = nvim-dap-virtual-text;
        type = "viml";
        config = ''
          lua <<EOF
            require("nvim-dap-virtual-text").setup()
          EOF
        '';
      }
      telescope-undo-nvim
      dial-nvim
      smart-splits-nvim
      neodev-nvim
      hydra-nvim
      (p_nvim-telescope-livegrep-args.overrideAttrs {
        doCheck = false;
      })
      substitute-nvim
      baleia-nvim
      p_nvim-scratch
      hover-nvim
      ssr-nvim
      vim-go
    ];
  };
}
