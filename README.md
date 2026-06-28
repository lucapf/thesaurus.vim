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
  version = "*",
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
Restart `neovim`

![installation](images/thesaurus.gif)

## Check Updates

Inside neovim type: `:Lazy`. To open the **Update** section press `U`.

## Uninstall

* Remove the file  `~/.config/nvim/lua/plugins/thesaurus.lua`
* from neovim type: `:Lazy` then `X`
the system will remove the plugin.

To uninstall `WordNet` use `sudo apt uninstall wordnet && sudo apt autoremove` or `brew uninstall`
