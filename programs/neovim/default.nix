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
      pkgs.derivations.nvim-next
      {
        plugin = neoscroll-nvim;
        config = ''
          lua << EOF
            require('neoscroll').setup()
            local t = {}
            t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '250'}}
            t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '250'}}
            t['zt']    = {'zt', {'250'}}
            t['zz']    = {'zz', {'250'}}
            t['zb']    = {'zb', {'250'}}
            require('neoscroll.config').set_mappings(t)
          EOF
        '';
      }
      neogit
      undotree
      diffview-nvim
      goto-preview
      nvim-dap
      pkgs.derivations.nvim-metals
      # pkgs.derivations.nvim-tmux-resize
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
      nvim-treesitter-context
      pkgs.derivations.nvim-actions-preview
      {
        plugin = pkgs.derivations.nvim-syntax-surfer;
        config = ''
          lua << EOF
          -- Syntax Tree Surfer
          require("syntax-tree-surfer").setup()
          local opts = {noremap = true, silent = true}
          -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
          vim.keymap.set("n", "<C-e>", function()
              vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
              return "g@l"
          end, { silent = true, expr = true, desc = "Swap TS node with one above", noremap = true })
          vim.keymap.set("n", "<C-n>", function()
              vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
              return "g@l"
          end, { silent = true, expr = true, desc = "Swap TS node with one below", noremap = true })

          -- Visual Selection from Normal Mode
          vim.keymap.set("n", "vx", '<cmd>STSSelectMasterNode<cr>', opts)
          vim.keymap.set("n", "vn", '<cmd>STSSelectCurrentNode<cr>', opts)

          -- Select Nodes in Visual Mode
          vim.keymap.set("x", "<S-Right>", '<cmd>STSSelectNextSiblingNode<cr>', opts)
          vim.keymap.set("x", "<S-Left>", '<cmd>STSSelectPrevSiblingNode<cr>', opts)
          vim.keymap.set("x", "<S-Up>", '<cmd>STSSelectParentNode<cr>', opts)
          vim.keymap.set("x", "<S-Down>", '<cmd>STSSelectChildNode<cr>', opts)

          -- Swapping Nodes in Visual Mode
          vim.keymap.set("x", "<S-A-Down>", '<cmd>STSSwapNextVisual<cr>', opts)
          vim.keymap.set("x", "<S-A-Up>", '<cmd>STSSwapPrevVisual<cr>', opts)
          EOF
        '';
      }
      {
        plugin = pkgs.derivations.nvim-portal;
        config = ''
          lua << EOF
            vim.keymap.set("n", "<leader>o", "<cmd>Portal jumplist backward<cr>")
            vim.keymap.set("n", "<leader>i", "<cmd>Portal jumplist forward<cr>")
          EOF
        '';
      }
      {
        plugin = pkgs.derivations.nvim-ssr;
        config = ''
          lua << EOF
            vim.keymap.set({ "n", "x" }, "<leader>sr", function() require("ssr").open() end)
          EOF
        '';
      }
      {
        plugin = smart-splits-nvim;
        config = ''
          lua << EOF
            vim.keymap.set('n', '<C-Left>', require('smart-splits').resize_left)
            vim.keymap.set('n', '<C-Down>', require('smart-splits').resize_down)
            vim.keymap.set('n', '<C-Up>', require('smart-splits').resize_up)
            vim.keymap.set('n', '<C-Right>', require('smart-splits').resize_right)
            -- moving between splits
            vim.keymap.set('n', '<A-Left>', require('smart-splits').move_cursor_left)
            vim.keymap.set('n', '<A-Down>', require('smart-splits').move_cursor_down)
            vim.keymap.set('n', '<A-Up>', require('smart-splits').move_cursor_up)
            vim.keymap.set('n', '<A-Right>', require('smart-splits').move_cursor_right)
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
      {
        plugin = ChatGPT-nvim;
        config = ''
          lua <<EOF
            require("chatgpt").setup({
                keymaps = {
                    close = { "<C-c>" },
                    submit = "<S-Enter>",
                    yank_last = "<C-y>",
                    yank_last_code = "<leader>y",
                    scroll_up = "<C-u>",
                    scroll_down = "<C-d>",
                    toggle_settings = "<C-o>",
                    new_session = "<leader>co",
                    cycle_windows = "<Tab>",
                    -- in the Sessions pane
                    select_session = "<Space>",
                    rename_session = "r",
                    delete_session = "d",
                  }
            })
          EOF
        '';
      }
      nvim-bqf
    ];
  };
}
