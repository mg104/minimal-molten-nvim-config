Minimal nvim config for installing molten.nvim plugin nvim-config for jupyter like experience inside neovim.

Steps to install:

1. Follow instructions (end-to-end) to create a python pip virtual env (https://github.com/benlubas/molten-nvim/blob/main/docs/Virtual-Environments.md)
2. Install kitty for linux or wezterm if you're using windows (molten works best with these terminals)
3. Install packages needed for lua-5.1:
  4. sudo pacman -S yay
  5. yay -S readline6 ncurses5-compat-libs
6. Install lua and related packages:
  7. Install for arch linux (there must be similar packages for Ubuntu/Debian/other linux distros; pip/conda/mamba/hererocks/other package managers didn't work well for me for installing these packages): sudo pacman -S lua51 luajit luarocks imagemagick
  8. echo 'export LUA_VERSION=5.1' >> ~/.bashrc
  9. echo 'export LUA_PATH="$HOME/.local/share/nvim/lazy-rocks/hererocks/share/lua/5.1/?.lua;$HOME/.local/share/nvim/lazy-rocks/hererocks/share/lua/5.1/?/init.lua;;"' >> ~/.bashrc
  10. echo 'export LUA_CPATH="$HOME/.local/share/nvim/lazy-rocks/hererocks/lib/lua/5.1/?.so;;"' >> ~/.bashrc
  11. source ~/.bashrc
  12. luarocks --lua-version=5.1 install magick
13. If you have ~/.config/nvim then back it up and delete it. If you don't have it, proceed
14. Install this config: git clone https://github.com/mg104/minimal-jupynium-and-molten-nvim-config.git
15. Move this config to your nvim config folder: mv minimal-jupynium-and-molten-nvim-config.git ~/.config/nvim
16. Run: nvim (things will get set up automatically)
