# work-dotfiles

Dotfiles for my work desktop (Debian + i3wm), managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

```sh
cd ~/.dotfiles
stow <package>      # symlink a single package
stow */             # symlink everything
```

## Packages

| Package | Contents |
|---------|----------|
| alacritty | Terminal emulator config |
| bash | `.bashrc`, `.bash_logout`, `.profile` |
| dunst | Notification daemon |
| feh | `.fehbg` wallpaper setter |
| git | `.gitconfig` |
| gtk | GTK 2/3/4 themes and settings |
| i3 | Window manager config, autostart, workspaces |
| polybar | Status bar config and launch script |
| ranger | File manager with devicons |
| rofi | Application launcher |
| scripts | Utility scripts (wallpapers, displays, bookmarks, etc.) |
| sxhkd | Hotkey daemon |
| Thunar | File manager custom actions |
| volumeicon | Volume tray icon |
| wallpapers | Desktop wallpapers |
| xsettingsd | X settings daemon config |

## Structure

Each package mirrors the home directory layout so stow can symlink it in place:

```
~/.dotfiles/
  i3/.config/i3/config      ->  ~/.config/i3/config
  bash/.bashrc               ->  ~/.bashrc
  gtk/.gtkrc-2.0             ->  ~/.gtkrc-2.0
```
