{ pkgs, config, ... }:
let
  leaderKey = "\\<Space>";
in
{
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
          nnoremap <Leader>tg <cmd>Telescope live_grep<cr>
          nnoremap <Leader>th <cmd>Telescope buffers<cr>
          nnoremap <Leader>gh <cmd>lua require('telescope.builtin').git_commits()<cr>
        '';
      }
      telescope-fzf-native-nvim
      {
        plugin = vim-tmux-navigator;
        config = ''
          nnoremap <silent> <A-Left> :TmuxNavigateLeft<cr>
          nnoremap <silent> <A-Down> :TmuxNavigateDown<cr>
          nnoremap <silent> <A-Up> :TmuxNavigateUp<cr>
          nnoremap <silent> <A-Right> :TmuxNavigateRight<cr>
        '';
      }
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
            (tree-sitter-scala.overrideAttrs
              (old: {
                version = "master";
                src = pkgs.tree-sitter-scala-master;
              })
            )
            tree-sitter-query # for the tree-sitter itself
            tree-sitter-python
            tree-sitter-go
            tree-sitter-hocon
            tree-sitter-sql
            tree-sitter-graphql
            tree-sitter-dockerfile
            tree-sitter-scheme
          ]
      ))
      playground
      pkgs.nvim-treesitter-textobjects

      nvim-web-devicons
      lualine-nvim
      nvim-gps
      comment-nvim

      # snippets
      luasnip
      lspkind-nvim
      friendly-snippets

      nvim-neoclip-lua
      indent-blankline-nvim
      nvim-tree-lua
      vim-tmux-clipboard
      symbols-outline-nvim
      telescope-ui-select-nvim
      noice-nvim
      nui-nvim
      fidget-nvim
      nvim-lightbulb
      pkgs.derivations.nvim-next
      neoscroll-nvim
      neogit
      undotree
      diffview-nvim
      goto-preview
      nvim-dap
      pkgs.derivations.nvim-metals
      pkgs.derivations.nvim-tmux-resize
      trouble-nvim
      lsp_lines-nvim
      vim-repeat # needed for leap
      pkgs.derivations.nvim-leap
      {
        plugin = vim-gh-line;
        config = ''
          let g:gh_line_map_default = 0
          let g:gh_line_blame_map_default = 0
          let g:gh_line_map = '<leader>gc'
          let g:gh_open_command = 'fn() { echo "$@" | xsel -b; }; fn '
        '';
      }
    ];
  };
}
