--------------------------------------------------
-- BASIC OPTIONS
--------------------------------------------------
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.highlight.priorities.semantic_tokens = 95

--------------------------------------------------
-- LAZY.NVIM BOOTSTRAP
--------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------
-- PLUGINS
--------------------------------------------------
require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local nvim_tree = require("nvim-tree")
      local api = require("nvim-tree.api")

      local function on_attach(bufnr)
        api.config.mappings.default_on_attach(bufnr)
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
      end

      nvim_tree.setup({
        on_attach = on_attach,
        actions = { open_file = { quit_on_open = false } },
      })
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local b = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", b.find_files)
      vim.keymap.set("n", "<leader>fg", b.live_grep)
      vim.keymap.set("n", "<leader>fb", b.buffers)
      vim.keymap.set("n", "<leader>/", b.current_buffer_fuzzy_find, { desc = "Buscar no arquivo atual" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "javascript", "typescript", "tsx", "html", "css", "json", "yaml", "python", "java" },
        highlight = { enable = true },
      })
    end,
  },

  ------------------------------------------------
  -- LSP CONFIGURATION
  ------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "html", "cssls", "jsonls", "yamlls", "pyright", "eslint", "jdtls" },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local o = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, o)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, o)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, o)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, o)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, o)
      end

      -- Lua
      vim.lsp.config("lua_ls", { capabilities = capabilities, on_attach = on_attach })

      -- TypeScript / JavaScript
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      })

      -- ESLint (CORREÇÃO AQUI)
      vim.lsp.config("eslint", {
        capabilities = capabilities,
        on_attach = function(_, bufnr)
          on_attach(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              if vim.fn.exists(":EslintFixAll") > 0 then
                vim.cmd("EslintFixAll")
              end
            end,
          })
        end,
      })

      -- Ativando todos os servidores
      local servers = { "lua_ls", "ts_ls", "html", "cssls", "jsonls", "yamlls", "pyright", "eslint", "jdtls" }
      for _, s in ipairs(servers) do
        vim.lsp.enable(s)
      end
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = { { name = "nvim_lsp" }, { name = "buffer" }, { name = "path" } },
      })
    end,
  },

  { "nvim-lualine/lualine.nvim", config = true },

  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
      vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { silent = true })
    end,
  },

  { "numToStr/Comment.nvim",     config = true },
  { "windwp/nvim-autopairs",     config = true },

  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          lua = { "stylua" },
          python = { "black" },
        },
        format_on_save = { lsp_fallback = true, timeout_ms = 500 },
      })
    end,
  },

  {
    'romgrk/barbar.nvim',
    keys = {
      { '<A-l>',      '<Cmd>BufferNext<CR>',     desc = 'Próximo Buffer' },
      { '<A-h>',      '<Cmd>BufferPrevious<CR>', desc = 'Buffer Anterior' },
      { '<Leader>bc', '<Cmd>BufferClose<CR>',    desc = 'Fechar Buffer' },
    },
  },
})

--------------------------------------------------
-- QoL & KEYMAPS
--------------------------------------------------
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- Removi o mapping de :e para :tabe pois ele pode quebrar comandos de escrita
