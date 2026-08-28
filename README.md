 # plugins
 - [ ] hotkeys: f ; **,** t
 - [ ] Trigger marks list with remapped jump keys (' and '`')
    - https://github.com/folke/which-key.nvim/issues/166
 - [ ] flash.nvim
    - [ ] two char jump to line
    - [ ] target include punctuation `[]{}<>'",;#`
  - [x] convenient copy/paste
    - set clipboard+=unnamedplus
 - [x] kill buf
    - bdelete
 - [x] https://github.com/empat94/nvim-rss
 - [-] https://github.com/chipsenkbeil/distant.nvim
 - [ ] tui-csiu
 - [x] surround: visual mode map -- 'S'
 - [x] neotree: exit rename with <C-;> (discard using <C-;> as ESC)
 - [ ] possession close terminal without job
    - lua/plugins/possession.lua#55

# extension
 - [x] run without git
 - [x] vcs_root or cwd
 - [x] <space><space> pick window
 - [x] packer ==> lazy
    - [x] packer lazy load by key, desc for which-key
       https://github.com/wbthomason/packer.nvim/issues/925
    - [x] clone --depth=1
 - [-] feed
 - [-] email
 - [x] neovide
 - [x] hop target include punctuation `[]{}<>'",;#`
 - [-] lualine: hide tabline when number of tabs is lower than two
 - [x] neotree: copy path
 - [x] [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects/pull/317)
 - [x] OverseerRun use telescope
    - [x] telescope.themes.dropdown height


 # taberm (migrate from tmux)
 > term based on tabs (different with 'akinsho/nvim-toggleterm.lua')

 - [x] C-w x/C-w C-x (swap window)
 - [x] M-hjkl (resize)
 - [x] M-# (switch tab)

 - [x] <c-t> toggle term
 - [x] quit term when tabclose
 - [ ] fold term prompt
 - [ ] term num in status line(openterm('nu', {name = ...}))
 - [ ] change to insert mode when enter term and cursor at last line
    term get actual line (vim.fn.line('$') get buffer line)
 - [x] handle duplicated tabname (`lua/addons/lualine.lua:106`)
    chaos when switch tabs because nvim emit `DirChanged`
 - [x] default 1 term each tab (count arg for multiple)
    - [x] data struct { [tab]: {term...} }
    - [x] new_term -> get_term
      if current tab already has term and not v:count, use first term
      else create new term
    - [x] possession
 - [x] stdout > output to buffer
 - [x] bind `<C-r>` to terminal mode
    - [x] lua
    - [x] shell: C-s for `history_menu`
    - [x] use registers
 - [x] `new_term`
    - [x] specify shell
    - [x] open term with cmd :X echo hello word
    - [-] description
    - [x] close window when term exit
    - [-] possession adapt
 - [x] rename tab (lualine)
    - [x] beautify path
    - [x] keybindings (M-r)
 - [x] nushell
    - [x] send '\n'
    - [x] auto tcd
       - [-] do not `tcd` when multiple term in one tab
       - [x] pin tabname manually
       - [x] smart tcd (HookPwdChanged: is git or not under git)
    - [x] open file in cli
       - [x] open file not in cwd
    - [x] opposite pwd
 - [x] disable redundant plugins
    - [x] osc52
    - [x] registres.nvim
    - [x] yabs -> overseer
    - [x] nvim-goggleterm.lua
 - [x] default [No Name] buffer -> terminal (possession.lua)
 - [-] clean quited buffer
 - [x] $env.EDITOR
    - [ ] `git_COMMIT` (remote-wait)

