#!/usr/bin/env bash

## Author: Abidán Brito
## This script builds GNU Emacs 30.1 with support for native elisp compilation,
## tree-sitter, libjansson (C JSON library), pure GTK and mailutils on Arch Linux
## for Wayland.

# Exit on error and print out commands before executing them.
set -euxo pipefail

# Let's set the number of jobs to something reasonable; keep 2 cores
# free to avoid choking the computer during compilation.
JOBS=$(nproc --ignore=2)

# Clone the repo locally (no blob checkout) and get into it.
#git clone --depth 1 --branch emacs-30 git://git.savannah.gnu.org/emacs.git
pushd emacs

# Get essential dependencies.
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
    ncurses \
    gtk3 \
    imagemagick \
    glib2 \
    libxml2 \
    cairo \

# Get Wayland-specific dependencies.
sudo pacman -S --needed \
    wayland \
    wayland-protocols \
    gtk-layer-shell

# Get dependencies for gcc-10 and the build process.
sudo pacman -S --needed \
    gcc \
    libgccjit \
    autoconf

# Get dependencies for fast JSON.
sudo pacman -S --needed jansson

# Get GNU Mailutils (protocol-independent mail framework).
sudo pacman -S --needed mailutils

# Get the tree-sitter syntax parsing engine.
sudo pacman -S --needed tree-sitter

# Get an OpenType font shaping engine (for ligatures).
sudo pacman -S --needed harfbuzz

# Use system GCC
# NOTE(abi): needed when compiling with libgccjit or we'll get cryptic error messages.
export CC=/usr/bin/gcc CXX=/usr/bin/g++

# Configure and run.
# NOTE(abi): binaries should go to /usr/local/bin by default.
#
# Options:
#    --prefix                   ->  where to install Emacs to
#    --with-native-compilation  ->  use libgccjit for native elisp AOT compilation
#    --with-pgtk                ->  pure GTK interface (no X11, better font rendering)
#    --with-wayland             ->  force Wayland backend
#    --with-tree-sitter         ->  better syntax highlighting/parsing
#    --with-json                ->  libjansson for JSON parsing
#    --with-imagemagick         ->  raster images backend
#    --with-cairo               ->  vector graphics backend
#    --with-mailutils           ->  mail client integration
#    --without-pop              ->  no POP3 (insecure channels)
#    --with-gnutls              ->  secure HTTPS connections (TLS/SSL)
#    --with-wide-int            ->  larger file size limit
#    --with-modules             ->  dynamic module support
#    --without-dbus             ->  skip D-Bus IPC
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
    --with-native-compilation=yes \
    --with-pgtk \
    --with-wayland \
    --with-tree-sitter \
    --with-json \
    --with-wide-int \
    --with-modules \
    --without-dbus \
    --with-gnutls \
    --with-mailutils \
    --without-pop \
    --with-cairo \
    --with-imagemagick \
    CFLAGS="-O2 -pipe -mtune=native -march=native -fomit-frame-pointer"

# Build.
make -j${JOBS} NATIVE_FULL_AOT=1 \
    && sudo make install

# Return to the original path.
popd
