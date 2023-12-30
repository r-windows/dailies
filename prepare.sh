#!/bin/sh
set -e
set -x

# Some prereqs
pacman -S --needed --noconfirm wget git make perl curl texinfo texinfo-tex rsync unzip diffutils

if [ "$MSYSTEM_CARCH" = "aarch64" ]; then
	toolchain="https://github.com/r-windows/bundles/releases/download/rtools43-5863/llvm17_ucrt3_base_aarch64_5863.tar.zst"
	tcltk="https://github.com/r-windows/bundles/releases/download/rtools43-5863/Tcl-aarch64-5863-5787.zip"
elif [ "$MSYSTEM_CARCH" = "x86_64" ]; then
	toolchain="https://github.com/r-windows/bundles/releases/download/rtools43-5863/rtools43-toolchain-libs-base-5863.tar.zst"
	tcltk="https://github.com/r-windows/bundles/releases/download/rtools43-5863/tcltk-5863-5787.zip"
else
	echo "Failed to guess architecture from MSYSTEM_CARCH ($MSYSTEM_CARCH)"
	exit 1
fi

# Download and extract toolchain and tcltk
wget -q -O toolchain.tar.zst "$toolchain"
tar xf toolchain.tar.zst
rm toolchain.tar.zst

wget -q -O tcl.zip "$tcltk"
unzip tcl.zip
rm tcl.zip
