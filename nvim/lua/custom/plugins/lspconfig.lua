return {
  {
      "ray-x/go.nvim",
      dependencies = {  -- optional packages
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("go").setup()

        -- Autocommand to run `go fmt` on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = "*.go",
          callback = function()
            vim.cmd("GoFmt")
          end,
        })
      end,
      event = {"CmdlineEnter"},
      ft = {"go", 'gomod'},
      build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  {
      "neovim/nvim-lspconfig",  -- Ensure lspconfig is included
      config = function()
        require("lspconfig").graphql.setup{}
      end,
      ft = {"graphql"},
  }
}
