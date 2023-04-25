{ pkgs, config, ... }:
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
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      	let mapleader = "${leaderKey}"
    '' +
    "${builtins.readFile ./init.vim}" +
    ''
      lua << EOF
        local tsserver_path = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server"
        local typescript_path = "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib"
        local metals_binary_path = "${pkgs.metals}/bin/metals"
        ${builtins.readFile ./init.lua}
      EOF
    '';
    extraPackages = [
      pkgs.nodePackages.typescript
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages.bash-language-server
      pkgs.nodePackages.vim-language-server
      pkgs.nodePackages.yaml-language-server
      pkgs.rnix-lsp
      pkgs.sumneko-lua-language-server
      pkgs.stylua
      pkgs.shfmt
      pkgs.nodePackages.eslint
      pkgs.nodePackages.prettier
      pkgs.nodePackages.cspell
      pkgs.rust-analyzer
      pkgs.rustfmt
    ];
    plugins = with pkgs.vimPlugins; [
      rec {
        plugin = kanagawa-nvim;
        config = ''
          packadd! ${plugin.pname}
          colorscheme kanagawa
        '';
      }
      {
        plugin = telescope-nvim;
        config = ''
          "It has to be set in the first plugin's config as plugins get sourced before any other configuration and the leader customization doesn't work otherwise
          let mapleader = "${leaderKey}" 
          nnoremap <Leader>tf <cmd>Telescope find_files<cr>
          nnoremap <Leader>th <cmd>Telescope buffers<cr>
          nnoremap <Leader>gh <cmd>lua require('telescope.builtin').git_commits()<cr>

          lua << EOF
              vim.keymap.set("n", "<leader>hc", function()
                require("telescope.builtin").git_bcommits()
              end, { desc = "Buffer commites"})
              vim.keymap.set("n", "<leader>tg", function()
                require("telescope.builtin").live_grep({ layout_strategy = "vertical" })
              end, { desc = "Live grep"})
          EOF
        '';
      }
      telescope-fzf-native-nvim
      which-key-nvim
      nvim-autopairs
      {
        plugin = vim-sandwich;
        #config = ''
        #  runtime macros/sandwich/keymap/surround.vim
        #'';
      }
      gitsigns-nvim
      plenary-nvim

      # completions
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-tmux
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
            pkgs.tree-sitter-scala-master
            tree-sitter-query # for the tree-sitter itself
            tree-sitter-python
            tree-sitter-go
            tree-sitter-hocon
            tree-sitter-sql
            tree-sitter-graphql
            tree-sitter-dockerfile
            tree-sitter-scheme
            tree-sitter-rust
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
      nvim-tree-lua
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
      {
        plugin = telescope-undo-nvim;
        config = ''
          lua <<EOF
            require("telescope").load_extension("undo")
            vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
          EOF
        '';
      }
      dial-nvim
      p_nvim-lsp-inlayhints
      p_nvim-smart-splits-nvim
      neodev-nvim
    ];
  };
}
