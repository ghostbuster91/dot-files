{ pkgs, config, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set mouse=a
      syntax on
      augroup fmt
        autocmd!
        autocmd BufWritePre * undojoin | Neoformat
      augroup END

      set relativenumber
      set number

      nnoremap <silent> <A-Left> :TmuxNavigateLeft<cr>
      nnoremap <silent> <A-Down> :TmuxNavigateDown<cr>
      nnoremap <silent> <A-Up> :TmuxNavigateUp<cr>
      nnoremap <silent> <A-Right> :TmuxNavigateRight<cr>
    '';
    plugins = with pkgs.vimPlugins; [
      vim-nix
      rec {
        plugin = onedark-vim;
        config = ''
          packadd! ${plugin.pname}
          colorscheme onedark
        '';
      }
      neoformat
      fzf-vim
      vim-tmux-navigator
      lightspeed-nvim
      which-key-nvim
    ];
  };
}
