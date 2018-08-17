
using BinaryBuilder

# Collection of sources required to build libmongoc
sources = [
    "https://github.com/mongodb/mongo-c-driver/releases/download/1.12.0/mongo-c-driver-1.12.0.tar.gz" =>
    "e5924207f6ccbdf74a9b95305b150e96b3296a71f2aafbb21e647dc28d580c68",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd mongo-c-driver-1.12.0/
mkdir cmake-build
cd cmake-build/
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ..
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    FreeBSD(:x86_64),
    MacOS(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libbson", :libbson),
    LibraryProduct(prefix, "libmongoc", :libmongoc),
    ExecutableProduct(prefix, "", :mongoc_stat)
]

# Dependencies that must be installed before this package can be built
dependencies = []

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "libmongoc", v"1.12.0", sources, script, platforms, products, dependencies)
