# ⌨️ Atalhos do Neovim (Plugins Instalados)

Este documento lista todos os atalhos configurados no setup atual do Neovim.

---

## 🗂️ nvim-tree.lua (File Explorer)

| Atalho | Ação |
|------|------|
| `<leader>e` | Abrir / Fechar o explorador de arquivos |

> Atalhos internos do NvimTree (quando o foco está na árvore):

| Tecla | Ação |
|----|----|
| `Enter` / `l` | Abrir arquivo ou pasta |
| `h` | Fechar pasta |
| `a` | Criar arquivo |
| `d` | Deletar |
| `r` | Renomear |
| `y` | Copiar |
| `p` | Colar |
| `q` | Fechar o NvimTree |

---

## 🔍 Telescope.nvim (Busca)

| Atalho | Ação |
|------|------|
| `<leader>ff` | Buscar arquivos |
| `<leader>fg` | Buscar texto (Live Grep) |
| `<leader>fb` | Listar buffers abertos |

### Dentro do Telescope

| Tecla | Ação |
|----|----|
| `<CR>` | Abrir seleção |
| `<C-j>` | Próximo item |
| `<C-k>` | Item anterior |
| `<Esc>` | Fechar |

---

## 🌳 Treesitter

> Não possui atalhos diretos configurados  
> Atua automaticamente no highlight e parsing de código.

---

## 🧠 LSP (Language Server Protocol)

### Navegação

| Atalho | Ação |
|------|------|
| `gd` | Ir para definição |
| `K` | Hover / Documentação |
| `<leader>rn` | Renomear símbolo |
| `<leader>ca` | Code actions |
| `[d` | Diagnóstico anterior |
| `]d` | Próximo diagnóstico |

---

## 🚨 Diagnostics (Trouble.nvim)

| Atalho | Ação |
|------|------|
| `<leader>xx` | Abrir / Fechar painel de diagnósticos |

---

## ✍️ Comment.nvim (Comentários)

| Atalho | Ação |
|------|------|
| `gcc` | Comentar / Descomentar linha |
| `gc` + movimento | Comentar seleção |
| `gc` (visual) | Comentar bloco selecionado |

✅ Funciona em JS, TS, JSX e TSX

---

## 🔁 nvim-autopairs

> Automático – sem atalhos manuais

| Ação | Resultado |
|----|----|
| `{` | `{}` |
| `(` | `()` |
| `[` | `[]` |
| `"` | `""` |
| `<Component` | `<Component />` (JSX/TSX) |

---

## 🧩 nvim-cmp (Autocomplete)

| Atalho | Ação |
|------|------|
| `<C-Space>` | Abrir autocomplete |
| `<CR>` | Confirmar sugestão |
| `<Up>/<Down>` | Navegar nas sugestões |

---

## 📊 Lualine (Statusline)

> Informativo – sem atalhos configurados

Mostra:
- Modo
- Arquivo
- Branch Git
- Diagnósticos LSP

---

## 🎨 Tema (Tokyonight)

> Tema aplicado automaticamente  
> Nenhum atalho configurado

---

## 🧹 Conform.nvim (Formatter)

> Formatação automática ao salvar

| Ação | Resultado |
|----|----|
| `:w` | Formata o arquivo (Prettier, Black, Stylua etc) |

---

## ✅ Leader Key


Todos os atalhos `<leader>` usam a **barra de espaço**.

---

## 📌 Resumo rápido

| Categoria | Principal Atalho |
|--------|-----------------|
| Arquivos | `<leader>e` |
| Buscar arquivos | `<leader>ff` |
| Buscar texto | `<leader>fg` |
| LSP definição | `gd` |
| Rename | `<leader>rn` |
| Comentários | `gcc` |
| Diagnósticos | `<leader>xx` |

---


