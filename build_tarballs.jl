
using BinaryBuilder

# Collection of sources required to build libmongoc
sources = [
    "https://github.com/mongodb/mongo-c-driver/releases/download/1.13.0/mongo-c-driver-1.13.0.tar.gz" =>
    "25164e03b08baf9f2dd88317f1a36ba36b09f563291a7cf241f0af8676155b8d",

    "https://zlib.net/zlib-1.2.11.tar.gz" =>
    "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",

    "https://www.openssl.org/source/openssl-1.1.1.tar.gz" =>
    "2836875a0f89c03d0fdf483941512613a50cfb421d6fd94b9f41d7279d586a3d",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd zlib-1.2.11/
./configure
make -j${nproc}
make install
cd ..
cd openssl-1.1.1/
./config
make -j${nproc}
make install
cd ..
cd mongo-c-driver-1.13.0/
mkdir cmake-build
cd cmake-build/
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DCMAKE_BUILD_TYPE=Release -DENABLE_SSL=AUTO -DENABLE_STATIC=ON -DENABLE_MONGOC=ON -DENABLE_BSON=ON -DENABLE_ZLIB=BUNDLED -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ..
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, :glibc),
    MacOS(:x86_64)
]

#=
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf)
]
=#

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libbson", :libbson),
    LibraryProduct(prefix, "libmongoc", :libmongoc)
]

# Dependencies that must be installed before this package can be built
dependencies = []

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "libmongoc", v"1.13.0", sources, script, platforms, products, dependencies)
