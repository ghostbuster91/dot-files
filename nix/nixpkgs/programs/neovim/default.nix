{ pkgs, config, ... }:
let
  leaderKey = "/";
in
{
  home.packages = [
    pkgs.nodePackages.bash-language-server
    pkgs.nodePackages.vim-language-server
    pkgs.nodePackages.yaml-language-server
    pkgs.rnix-lsp
    pkgs.sumneko-lua-language-server
    pkgs.stylua
    pkgs.shfmt
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      	let mapleader = "${leaderKey}"
    '' +
    "${builtins.readFile ./init.vim}" + ''
      lua << EOF
      ${builtins.readFile ./init.lua}
      EOF
    '';
    plugins = with pkgs.vimPlugins; [
      rec {
        plugin = onedark-vim;
        config = ''
          packadd! ${plugin.pname}
          colorscheme onedark
        '';
      }
      {
        plugin = telescope-nvim;
        config = ''
          nnoremap ${leaderKey}tf <cmd>Telescope find_files<cr>
          nnoremap ${leaderKey}tg <cmd>Telescope live_grep<cr>
          nnoremap ${leaderKey}tb <cmd>Telescope buffers<cr>
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
      lightspeed-nvim
      which-key-nvim
      nvim-autopairs
      {
        plugin = vim-sandwich;
        #config = ''
        #  runtime macros/sandwich/keymap/surround.vim
        #'';
      }
      gitsigns-nvim

      # lsp stuff
      nvim-cmp
      cmp-nvim-lsp
      nvim-lspconfig
      null-ls-nvim

      (nvim-treesitter.withPlugins (
        # https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/development/tools/parsing/tree-sitter/grammars
        plugins:
          with plugins; [
            tree-sitter-lua
            tree-sitter-nix
            tree-sitter-vim
            tree-sitter-html
            tree-sitter-yaml
            tree-sitter-comment
            tree-sitter-bash
          ]
      ))
      nvim-web-devicons
      {
        plugin = trouble-nvim;
        config = ''
          nnoremap ${leaderKey}xx <cmd>TroubleToggle<cr>
          nnoremap ${leaderKey}xw <cmd>TroubleToggle workspace_diagnostics<cr>
          nnoremap ${leaderKey}xd <cmd>TroubleToggle document_diagnostics<cr>
          nnoremap ${leaderKey}xq <cmd>TroubleToggle quickfix<cr>
          nnoremap ${leaderKey}xl <cmd>TroubleToggle loclist<cr>
          nnoremap gR <cmd>TroubleToggle lsp_references<cr>         	
        '';
      }
    ];
  };
}
