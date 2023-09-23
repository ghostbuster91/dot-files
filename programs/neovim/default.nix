{ pkgs, config, pkgs-unstable, ... }:
let
  leaderKey = "\\<Space>";
in
{
  home.file."./.config/nvim/" = {
    source = ./config;
    recursive = true;
  };
  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    extraConfig = ''
      	let mapleader = "${leaderKey}"
    '' +
    "${builtins.readFile ./init.vim}" +
    ''
      lua << EOF
        local binaries = {
          tsserver_path = "${pkgs-unstable.nodePackages.typescript-language-server}/bin/typescript-language-server",
          typescript_path = "${pkgs-unstable.nodePackages.typescript}/lib/node_modules/typescript/lib",
          metals_binary_path = "${pkgs-unstable.metals}/bin/metals",
          smithy_ls_path = "${pkgs-unstable.disney-smithy-ls}/bin/smithy_ls",
          lua_language_server = "${pkgs-unstable.sumneko-lua-language-server}/bin/lua-language-server",
        }
        
        ${builtins.readFile ./init.lua}
      EOF
    '';
    extraPackages = with pkgs-unstable; [
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      nodePackages.vim-language-server
      nodePackages.yaml-language-server
      rnix-lsp
      sumneko-lua-language-server
      stylua
      shfmt
      nodePackages.eslint
      nodePackages.prettier
      nodePackages.cspell
      rust-analyzer
      rustfmt
    ];
    plugins = with pkgs-unstable.vimPlugins; [
      rec {
        plugin = kanagawa-nvim;
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
      null-ls-nvim

      (nvim-treesitter.withPlugins (
        # https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/development/tools/parsing/tree-sitter/grammars
        plugins:
          with plugins; [
            tree-sitter-lua
            tree-sitter-vim
            tree-sitter-html
            tree-sitter-yaml
            tree-sitter-json
            tree-sitter-markdown
            tree-sitter-comment
            tree-sitter-bash
            tree-sitter-javascript
            tree-sitter-nix
            tree-sitter-typescript
            tree-sitter-c
            tree-sitter-java
            tree-sitter-kotlin
            pkgs-unstable.p_treesitter-scala
            pkgs-unstable.p_treesitter-devicetree
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
      playground
      nvim-treesitter-textobjects

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
      p_nvim-neotree
      vim-tmux-clipboard
      telescope-ui-select-nvim
      noice-nvim
      nui-nvim
      fidget-nvim
      nvim-lightbulb
      p_nvim-next
      neoscroll-nvim
      p_nvim-neogit
      undotree
      # diffview-nvim
      goto-preview
      nvim-dap
      {
        plugin = nvim-dap-ui;
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
      p_nvim-metals
      trouble-nvim
      vim-repeat # needed for leap
      p_nvim-leap
      gitlinker-nvim
      p_nvim-actions-preview
      {
        plugin = p_nvim-portal;
        config = ''
          lua << EOF
            vim.keymap.set("n", "<leader>o", "<cmd>Portal jumplist backward<cr>")
            vim.keymap.set("n", "<leader>i", "<cmd>Portal jumplist forward<cr>")
          EOF
        '';
      }
      {
        plugin = nvim-dap-virtual-text;
        config = ''
          lua <<EOF
            require("nvim-dap-virtual-text").setup()
          EOF
        '';
      }
      nvim-bqf
      telescope-undo-nvim
      dial-nvim
      p_nvim-smart-splits-nvim
      neodev-nvim
      hydra-nvim
      p_nvim-telescope-livegrep-args
      p_nvim-substitute
    ];
  };
}
