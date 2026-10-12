#!/usr/bin/env bash

## Author: Abidán Brito
## This script builds GNU Emacs 31.x with support for native elisp compilation,
## tree-sitter, pure GTK and mailutils on Arch Linux for Wayland.

# Exit on error and print out commands before executing them
set -euxo pipefail

# Let's set the number of jobs to something reasonable
# NOTE(abi): we keep 2 cores free to avoid choking the computer during compilation.
JOBS=$(nproc --ignore=2)

# Clone the repo locally (no blob checkout) if it doesn't already exist, get into
# it and pull the latest changes
[ -d emacs ] || git clone --depth 1 --branch emacs-31 git://git.savannah.gnu.org/emacs.git
pushd emacs
git pull

# Get essential dependencies
sudo pacman -S --needed \
     base-devel \
     texinfo \
     gnutls \
     libjpeg-turbo \
     libpng \
     libtiff \
     libwebp \
     giflib \
     libxpm \
     librsvg \
     ncurses \
     gtk3 \
     imagemagick \
     glib2 \
     libxml2 \
     sqlite \
     cairo

# Get Wayland-specific dependencies
sudo pacman -S --needed \
     wayland \
     wayland-protocols \
     gtk-layer-shell

# Get dependencies for gcc and the build process
sudo pacman -S --needed \
     gcc \
     libgccjit \
     autoconf

# Get GNU Mailutils (protocol-independent mail framework)
sudo pacman -S --needed mailutils

# Get the tree-sitter syntax parsing engine
sudo pacman -S --needed tree-sitter

# Get an OpenType font shaping engine (for ligatures)
sudo pacman -S --needed harfbuzz

# Use system GCC
# NOTE(abi): needed when compiling with libgccjit or we'll get cryptic error messages.
export CC=/usr/bin/gcc CXX=/usr/bin/g++

# Configure and run
# NOTE(abi): binaries should go to /usr/local/bin by default.
#
# Options:
#    --prefix                    ->  where to install Emacs to
#    --with-native-compilation   ->  use libgccjit for native elisp AOT compilation
#    --without-compress-install  ->  install uncompressed .el/.eln files (faster load at the cost of more disk space)
#    --with-pgtk                 ->  pure GTK interface (no X11, better font rendering)
#    --with-wayland              ->  force Wayland backend
#    --with-tree-sitter          ->  better syntax highlighting/parsing
#    --with-harfbuzz             ->  OpenType text shaping (ligatures, complex scripts)
#    --with-gnutls               ->  secure HTTPS connections (TLS/SSL)
#    --with-mailutils            ->  mail client integration
#    --without-pop               ->  no POP3 (insecure channels)
#    --with-wide-int             ->  larger file size limit
#    --with-modules              ->  dynamic module support
#    --with-dbus                 ->  enable D-Bus IPC (desktop notifications, sleep/wake hooks, battery status)
#    --with-sqlite3              ->  built-in SQLite database support
#    --with-xml2                 ->  libxml2 for parsing HTML/XML (used by shr, eww, etc.)
#    --with-cairo                ->  vector graphics backend
#    --with-imagemagick          ->  raster images backend
#    --with-jpeg                 ->  JPEG image support
#    --with-png                  ->  PNG image support
#    --with-tiff                 ->  TIFF image support
#    --with-gif                  ->  GIF image support
#    --with-webp                 ->  WebP image support
#    --with-rsvg                 ->  SVG image support
#
# Flags:
#    -O2                   ->  Turn on a bunch of optimization flags. There's also -O3, but it increases
#                              the instruction cache footprint, which may end up reducing performance.
#    -pipe                 ->  Reduce temporary files to the minimum.
#    -mtune=native         ->  Optimize code for the local machine (under ISA constraints).
#    -march=native         ->  Enable all instruction subsets supported by the local machine.
#    -fomit-frame-pointer  ->  Small functions don't need a frame pointer (optimization).
#
# https://lemire.me/blog/2018/07/25/it-is-more-complicated-than-i-thought-mtune-march-in-gcc/
./autogen.sh \
    && ./configure \
	   --with-native-compilation \
	   --without-compress-install \
	   --with-pgtk \
	   --with-wayland \
	   --with-tree-sitter \
	   --with-harfbuzz \
	   --with-gnutls \
	   --with-mailutils \
	   --without-pop \
	   --with-wide-int \
	   --with-modules \
	   --with-dbus \
	   --with-sqlite3 \
	   --with-xml2 \
	   --with-cairo \
	   --with-imagemagick \
	   --with-jpeg \
	   --with-png \
	   --with-tiff \
	   --with-gif \
	   --with-webp \
	   --with-rsvg \
	   CFLAGS="-O2 -pipe -mtune=native -march=native -fomit-frame-pointer"

# Build
make -j${JOBS} NATIVE_FULL_AOT=1 \
    && sudo make install

# Return to the original path
popd
