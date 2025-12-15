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
-- Configurações de indentação de 4 espaços
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- Ativa a indentação automática
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
if not vim.loop.fs_stat(lazypath) then
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

  ------------------------------------------------
  -- THEME
  ------------------------------------------------
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  ------------------------------------------------
  -- FILE EXPLORER
  ------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local nvim_tree = require("nvim-tree")
      local api = require("nvim-tree.api")

      local function on_attach(bufnr)
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- mantém os mapeamentos padrão (útil)
        api.config.mappings.default_on_attach(bufnr)

        -- sobrescreve/ adiciona mapeamentos locais ao buffer da árvore:
        vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split")) -- horizontal
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))     -- vertical
        -- se quiser, reaproveite <CR> e outros:
        -- vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
      end

      nvim_tree.setup({
        on_attach = on_attach,
        -- você pode ajustar outras opções aqui
        actions = {
          open_file = {
            quit_on_open = false, -- por exemplo: manter a árvore aberta ao abrir arquivo
          },
        },
      })

      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
    end,
  },

  ------------------------------------------------
  -- FUZZY FINDER
  ------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local b = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", b.find_files)
      vim.keymap.set("n", "<leader>fg", b.live_grep)
      vim.keymap.set("n", "<leader>fb", b.buffers)

      -- 🔍 Busca apenas no arquivo atual
      vim.keymap.set(
        "n",
        "<leader>/",
        b.current_buffer_fuzzy_find,
        { desc = "Buscar no arquivo atual" }
      )
    end,
  },

  ------------------------------------------------
  -- TREE-SITTER
  ------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "javascript", "typescript", "tsx",
          "html", "css", "json", "yaml", "python",
          "java"
        },
        highlight = { enable = true },
      })
    end,
  },

  ------------------------------------------------
  -- LSP (NEOVIM 0.11+)
  ------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "mfussenegger/nvim-jdtls",
    },
    config = function()
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "html",
          "cssls",
          "jsonls",
          "yamlls",
          "pyright",
          "eslint",
          "jdtls"
        },
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

        if vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      vim.lsp.config("lua_ls", { capabilities = capabilities, on_attach = on_attach })

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {
          "javascript", "javascriptreact",
          "typescript", "typescriptreact",
          "java",
        },
      })

      vim.lsp.config("eslint", {
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })

      for _, s in ipairs({
        "lua_ls", "ts_ls", "html", "cssls",
        "jsonls", "yamlls", "pyright", "eslint", "jdtls"

      }) do
        vim.lsp.enable(s)
      end
    end,
  },

  ------------------------------------------------
  -- AUTOCOMPLETE
  ------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  ------------------------------------------------
  -- STATUSLINE
  ------------------------------------------------
  { "nvim-lualine/lualine.nvim", config = true },

  ------------------------------------------------
  -- DIAGNOSTICS PANEL
  ------------------------------------------------
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
      vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { silent = true })
    end,
  },

  ------------------------------------------------
  -- COMMENTS
  ------------------------------------------------
  { "numToStr/Comment.nvim",     config = true },

  ------------------------------------------------
  -- AUTOPAIRS
  ------------------------------------------------
  { "windwp/nvim-autopairs",     config = true },

  ------------------------------------------------
  -- FORMATTER
  ------------------------------------------------
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          lua = { "stylua" },
          python = { "black" },
        },
        format_on_save = { lsp_fallback = true },
      })
    end,
  },
  {
    'romgrk/barbar.nvim',
    -- Opcional: Adicione mapeamentos para navegação
    keys = {
      -- Ir para o próximo/anterior buffer
      { '<A-l>',      '<Cmd>BufferNext<CR>',     desc = 'Próximo Buffer' },
      { '<A-h>',      '<Cmd>BufferPrevious<CR>', desc = 'Buffer Anterior' },
      -- Fechar o buffer atual
      { '<Leader>bc', '<Cmd>BufferClose<CR>',    desc = 'Fechar Buffer' },
    },
  }

})

--------------------------------------------------
-- 🔍 SEARCH QUALITY OF LIFE
--------------------------------------------------

-- Limpar highlight da busca
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Centralizar resultados ao navegar
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
