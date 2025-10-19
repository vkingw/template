-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Three-column layout initialization
local function setup_three_column_layout()
  -- Auto-open Neo-tree on startup
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      -- Wait a bit for plugins to load
      vim.defer_fn(function()
        -- Open Neo-tree if no file was specified
        if vim.fn.argc() == 0 then
          vim.cmd("Neotree filesystem reveal left")
        end
      end, 100)
    end,
  })

  -- Smart Aerial auto-open logic
  local function should_open_aerial(bufnr)
    -- Skip if aerial is already open
    local aerial_info = require("aerial").get_location(0)
    if aerial_info then return false end

    -- Check if this file type supports symbols
    local filetype = vim.bo[bufnr].filetype
    local supported_filetypes = {
      "lua", "python", "javascript", "typescript", "java", "go", "rust",
      "cpp", "c", "php", "ruby", "sh", "bash", "zsh", "json", "yaml",
      "markdown", "vim", "help"
    }

    if not vim.tbl_contains(supported_filetypes, filetype) then
      return false
    end

    -- Check if we have LSP support or treesitter symbols
    local has_lsp = false
    local clients = vim.lsp.get_active_clients { bufnr = bufnr }
    for _, client in ipairs(clients) do
      if client.supports_method("textDocument/documentSymbol") then
        has_lsp = true
        break
      end
    end

    return has_lsp or vim.treesitter.highlighter.active[bufnr]
  end

  -- Auto-open Aerial when file is opened
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
      local bufnr = args.buf

      -- Only open for normal buffers, not special buffers
      if vim.bo[bufnr].buftype ~= "" then return end

      if should_open_aerial(bufnr) then
        vim.defer_fn(function()
          if should_open_aerial(bufnr) then
            vim.cmd("AerialOpen!")
          end
        end, 500)
      end
    end,
  })

  -- Also open when LSP attaches to ensure coverage
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      if client and client.supports_method("textDocument/documentSymbol") then
        vim.defer_fn(function()
          if should_open_aerial(bufnr) then
            vim.cmd("AerialOpen!")
          end
        end, 300)
      end
    end,
  })

  -- Key mappings for layout management
  vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
  vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial" })

  -- Balance windows after layout changes
  vim.keymap.set("n", "<leader>w=", "<cmd>wincmd =<CR>", { desc = "Balance windows" })
end

-- Initialize the layout
setup_three_column_layout()
