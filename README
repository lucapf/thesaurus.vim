# Thesaurus

Simple offline Thesaurus support for neovim.

## Usage:
Use `<leader>ct` to open a popup displaying word definitions and antonyms. Scroll with `j` and `k`, and close with `q`.

## Dependencies

### WordNet:

| OS          | command             |
|-------------|---------------------|
|Linux debian | apt install wordnet |
|Mac OS       | brew install wordnet|

## Installation:

Copy the content below inside the `~/.config/nvim/lua/plugins/thesaurus.lua`

```
return {
  "lucapf/thesaurus.vim",
  lazy = false,
  cmd = "Thesaurus",
  init = function()
    vim.g.render_key = "<leader>ct"
  end,
  config = function()
    require("thesaurus").setup({ key = "<leader>ct" })
  end,
}
```
