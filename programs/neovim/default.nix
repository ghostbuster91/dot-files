{ pkgs, config, ... }:
let
  leaderKey = ";";
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
      	${builtins.readFile ./init.lua}
      	local capabilitiesWithoutFomatting = vim.lsp.protocol.make_client_capabilities()
      	capabilitiesWithoutFomatting.textDocument.formatting = false
      	capabilitiesWithoutFomatting.textDocument.rangeFormatting = false
      	capabilitiesWithoutFomatting.textDocument.range_formatting = false
      		
      	require("lspconfig")["tsserver"].setup({
      			on_attach = function (client, buffer)
      				client.resolved_capabilities.document_formatting = false
      				client.resolved_capabilities.document_range_formatting = false
      				on_attach(client, buffer)
      			end,
      			capabilities = capabilitiesWithoutFormatting,
      			cmd = { 
      				"${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", 
      				"--stdio", 
      				"--tsserver-path", 
      				"${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib/" 
      			}
      		})
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
    ];
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
          nnoremap ${leaderKey}th <cmd>Telescope buffers<cr>
          nnoremap ${leaderKey}gh <cmd>lua require('telescope.builtin').git_commits()<cr>
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
      plenary-nvim

      # lsp stuff
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
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
            tree-sitter-comment
            tree-sitter-bash
            tree-sitter-javascript
            tree-sitter-nix
            tree-sitter-typescript
          ]
      ))
      nvim-treesitter-textobjects
      nvim-web-devicons
      lualine-nvim
      nvim-gps
      comment-nvim
      luasnip
      lspkind-nvim
      pkgs.derivations.nvim-neoclip
      cmp-tmux
      indent-blankline-nvim
      nvim-tree-lua
      vim-tmux-clipboard
      symbols-outline-nvim
      telescope-ui-select-nvim
      pkgs.derivations.nvim-noice
      nui-nvim
      nvim-notify
      fidget-nvim
      nvim-lightbulb
      pkgs.derivations.nvim-eyeliner
      neoscroll-nvim
      pkgs.derivations.nvim-neogit
      undotree
      diffview-nvim
    ];
  };
}
