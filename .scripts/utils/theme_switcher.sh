#!/usr/bin/env bash

## Author: Abidán Brito
## This script switches the Catppuccin flavour across the whole system, by
## rewriting the theme in each app's config and reloading running apps.
#
# Usage
#   theme_switcher.sh            print the current flavour
#   theme_switcher.sh <flavour>  switch to mocha | macchiato

set -euo pipefail

# --- locate the repo (resolve through the stow symlink) ---------------------
SELF="$(readlink -f "${BASH_SOURCE[0]}")"
REPO="$(dirname "$(dirname "$(dirname "$SELF")")")"
RC="$REPO/.config"            # repo config (source of truth)
LC="${XDG_CONFIG_HOME:-$HOME/.config}"   # live config

SUPPORTED=(mocha macchiato)   # flavours with a full set of ports in-repo

# --- per-flavour bits that aren't just the flavour name ---------------------
title()  { local f=$1; echo "${f^}"; }               # mocha -> Mocha
yellow() { case $1 in                                 # waybar calendar "today"
  mocha) echo f9e2af;; macchiato) echo eed49f;;
  frappe) echo e5c890;; latte) echo df8e1d;; esac; }

ANY='(mocha|macchiato|frappe|latte)'                  # matches any known flavour

ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
warn() { printf '  \033[33m⚠\033[0m %s\n' "$1"; }
info() { printf '  \033[34mⓘ\033[0m %s\n' "$1"; }

current() {
  grep -oE "@import \"themes/$ANY\.css\"" "$RC/waybar/style.css" 2>/dev/null \
    | grep -oE "$ANY" | head -1
}

# sed -E in place only if the file exists
sub() { local f=$1 expr=$2; [ -e "$f" ] && sed -i -E "$expr" "$f"; }

usage() { echo "usage: ${0##*/} [${SUPPORTED[*]// /|}]"; }

# --- parse args -------------------------------------------------------------
if [ $# -eq 0 ]; then
  echo "current flavour: $(current || echo unknown)"
  exit 0
fi

F=$1
case " ${SUPPORTED[*]} " in
  *" $F "*) ;;
  *) echo "unsupported flavour: $F"; usage
     echo "(adding one needs its palette files for waybar/hypr/rofi/kitty)"; exit 1;;
esac

T=$(title "$F"); Y=$(yellow "$F")
echo "Switching system theme → Catppuccin $T"

# === Group B: vendored palette references ===================================
sub "$RC/waybar/style.css"   "s/@import \"themes\/$ANY\.css\"/@import \"themes\/$F.css\"/"
sub "$RC/hypr/hyprland.lua"  "s/require\(\"themes\.$ANY\"\)/require(\"themes.$F\")/"
sub "$RC/hypr/hyprlock.conf" "s#/hypr/themes/$ANY\.conf#/hypr/themes/$F.conf#"
sub "$RC/rofi/config.rasi"   "s#@import \"themes/$ANY\"#@import \"themes/$F\"#"
sub "$RC/swaync/style.css"  "s#@import \"themes/$ANY\.css\"#@import \"themes/$F.css\"#"
sub "$RC/kitty/kitty.conf"   "s#themes/$ANY\.conf#themes/$F.conf#; s/# Catppuccin-$ANY/# Catppuccin-$T/I"
ok "waybar · hypr · hyprlock · rofi · kitty · swaync (palette files)"

# waybar calendar "today" highlight (hardcoded hex)
sub "$RC/waybar/config.jsonc" "s/#(f9e2af|eed49f|e5c890|df8e1d)/#$Y/I"
ok "waybar calendar accent → #$Y"

# === Group A: native flavour tokens =========================================
sub "$RC/wezterm/wezterm.lua" "s/Catppuccin $ANY/Catppuccin $T/"
sub "$RC/nvim/init.lua"       "s/flavour = \"$ANY\"/flavour = \"$F\"/"
# emacs: active flavour + the :dark variant in abi/theme-variants (light stays latte)
sub "$RC/emacs/config.org"    "s/catppuccin-flavor '$ANY/catppuccin-flavor '$F/; s/:dark $ANY/:dark $F/"
ok "wezterm · nvim · emacs"

# qt (guard on the color scheme existing)
for q in qt5ct qt6ct; do
  if [ -e "$RC/$q/colors/catppuccin-$F.conf" ]; then
    sub "$RC/$q/$q.conf" "s#catppuccin-$ANY\.conf#catppuccin-$F.conf#"
    ok "$q"
  else
    warn "$q: no catppuccin-$F.conf port, left unchanged"
  fi
done

# gtk 3/4 + hypr dconf (theme name)
sub "$RC/gtk-3.0/settings.ini"      "s/catppuccin-$ANY-peach/catppuccin-$F-peach/"
sub "$RC/gtk-4.0/settings.ini"      "s/catppuccin-$ANY-peach/catppuccin-$F-peach/"
sub "$RC/hypr/gtk-settings.dconf"   "s/catppuccin-$ANY-peach/catppuccin-$F-peach/"
ok "gtk 3/4 (theme name)"

# === kicad: live tool configs (not stowed), guard on color file ============
if [ -e "$LC/kicad/10.0/colors/catppuccin-$F.json" ]; then
  n=0
  for t in eeschema pcbnew gerbview symbol_editor fpedit pl_editor; do
    f="$LC/kicad/10.0/$t.json"
    [ -e "$f" ] && sed -i -E "s/\"catppuccin-$ANY\"/\"catppuccin-$F\"/g" "$f" && n=$((n+1))
  done
  [ $n -gt 0 ] && ok "kicad ($n tools; close kicad before switching)" \
               || info "kicad: no tool configs yet (pick theme once in Preferences → Colors)"
else
  warn "kicad: no catppuccin-$F.json color scheme, left unchanged"
fi

# === Zen: deploy userChrome/userContent into active profiles ================
if [ -e "$RC/zen/$F/userChrome.css" ]; then
  z=0
  for p in "$HOME/.zen"/*/; do
    [ -e "$p/prefs.js" ] || continue        # only real, used profiles
    mkdir -p "$p/chrome"
    cp "$RC/zen/$F/userChrome.css"   "$p/chrome/userChrome.css"
    cp "$RC/zen/$F/userContent.css"  "$p/chrome/userContent.css"
    pref='user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
    grep -qF "$pref" "$p/user.js" 2>/dev/null || echo "$pref" >> "$p/user.js"
    z=$((z+1))
  done
  [ $z -gt 0 ] && ok "zen ($z profiles; restart Zen to apply)" \
               || info "zen: no active profiles found"
else
  warn "zen: no $F userChrome, left unchanged"
fi

# === Reload the live apps ===================================================
echo "Reloading…"
pkill -SIGUSR2 waybar 2>/dev/null && ok "waybar" || info "waybar not running"
command -v hyprctl >/dev/null && hyprctl reload >/dev/null 2>&1 && ok "hyprland" || true
pkill -SIGUSR1 kitty 2>/dev/null && ok "kitty" || info "kitty not running"
{ pkill swaync 2>/dev/null || true; } && { sleep 0.2; swaync &>/dev/null & ok "swaync"; }
if command -v gsettings >/dev/null; then
  gsettings set org.gnome.desktop.interface gtk-theme \
    "catppuccin-$F-peach-standard+default" 2>/dev/null && ok "gtk (gsettings)" || true
fi

echo
info "Restart to pick up: nvim · emacs · qt apps · zen · kicad"
echo "Done → Catppuccin $T"
