#!/bin/sh
set -e
export R_CRAN_WEB="https://cran.rstudio.com"
export CRAN_RSYNC='mirrors.nic.cz::CRAN'

# Add toolchain to the path
export PATH="${PWD}/${MSYSTEM_CARCH}-w64-mingw32.static.posix/bin:$PATH"

# Download an R source bundle (the name and contents can change)
rootdir="$PWD"
wget -q -O r-base.tar.gz https://cran.r-project.org/src/base-prerelease/R-devel.tar.gz
rm -Rf r-base && mkdir -p r-base
MSYS="winsymlinks:lnk" tar -xf r-base.tar.gz -C r-base --strip-components=1
rm -f r-base.tar.gz
cp -Rf Tcl r-base/
cd r-base/src/gnuwin32

# Some settings
echo "WIN =" > MkRules.local
if [ "$MSYSTEM_CARCH" = "aarch64" ]; then
	echo "USE_LLVM = 1" >> MkRules.local
	which clang
	clang --version
else
	which gcc
	gcc --version
fi

# Test all other tools
export PATH="$PATH:$(cygpath $LOCALAPPDATA)/Programs/MiKTeX/miktex/bin/x64:/c/progra~1/MiKTeX/miktex/bin/x64"
echo "PATH: $PATH"
pdflatex --version
texindex --version
texi2any --version
make --version
perl --version

# Builds the installer
make distribution

# Copy to home dir
cp -v installer/*.exe $rootdir/
cd $rootdir

# Rename installer to include architecture
dist=$(ls *.exe)
installer="${dist%.*}-${MSYSTEM_CARCH}.exe"
mv $dist $installer

echo "installer=$installer" >> "${GITHUB_OUTPUT:-/dev/stdout}"
echo "arch=$MSYSTEM_CARCH" >> "${GITHUB_OUTPUT:-/dev/stdout}"
echo "today=$(date '+%Y-%m-%d')" >> "${GITHUB_OUTPUT:-/dev/stdout}"
