{ pkgs, config, ... }: {

  home.packages = [
    pkgs.nodePackages.bash-language-server
    pkgs.nodePackages.vim-language-server
    pkgs.nodePackages.yaml-language-server
    pkgs.rnix-lsp
    pkgs.sumneko-lua-language-server
    pkgs.stylua
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = "${builtins.readFile ./init.vim}" + ''
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
      telescope-nvim
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
        config = ''
          	runtime macros/sandwich/keymap/surround.vim
          	'';
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
    ];
  };
}
