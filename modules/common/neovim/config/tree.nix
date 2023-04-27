{ pkgs, dsl, ... }: {

  plugins = [ pkgs.vimPlugins.nvim-tree-lua pkgs.vimPlugins.nvim-web-devicons ];

  # Disable netrw eagerly
  # https://github.com/kyazdani42/nvim-tree.lua/commit/fb8735e96cecf004fbefb086ce85371d003c5129
  vim.g = {
    loaded = 1;
    loaded_netrwPlugin = 1;
  };

  setup.nvim-tree = {
    disable_netrw = true;
    hijack_netrw = true;
    sync_root_with_cwd = true;
    respect_buf_cwd = true;
    update_focused_file = {
      enable = true;
      update_root = true;
      ignore_list = { };
    };
    diagnostics = {
      enable = true;
      icons = {
        hint = "";
        info = "";
        warning = "";
        error = "";
      };
    };
    renderer = {
      icons = {
        glyphs = {
          git = {
            unstaged = "~";
            staged = "+";
            unmerged = "";
            renamed = "➜";
            deleted = "";
            untracked = "?";
            ignored = "◌";
          };
        };
      };
    };
    on_attach = dsl.rawLua ''
      function (bufnr)
        local api = require('nvim-tree.api')
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
      end
    '';
    view = {
      width = 30;
      hide_root_folder = false;
      side = "left";
      number = false;
      relativenumber = false;
    };
  };

  lua = ''
    vim.keymap.set("n", "<Leader>e", ":NvimTreeFindFileToggle<CR>", { silent = true })
  '';

}
