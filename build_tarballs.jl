
using BinaryBuilder

# Collection of sources required to build libmongoc
sources = [
    "https://github.com/mongodb/mongo-c-driver/releases/download/1.13.0/mongo-c-driver-1.13.0.tar.gz" =>
    "25164e03b08baf9f2dd88317f1a36ba36b09f563291a7cf241f0af8676155b8d",
]

# Bash recipe for building across all platforms
script = raw"""
apk update
apk add openssl-dev
cd $WORKSPACE/srcdir
cd mongo-c-driver-1.13.0/
mkdir cmake-build
cd cmake-build/
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DCMAKE_BUILD_TYPE=Release -DENABLE_SSL=AUTO -DENABLE_STATIC=ON -DENABLE_MONGOC=ON -DENABLE_BSON=ON -DENABLE_ZLIB=BUNDLED -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ..
cat CMakeCache.txt
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, :glibc),
    MacOS(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libbson", :libbson),
    LibraryProduct(prefix, "libmongoc", :libmongoc)
]

# Dependencies that must be installed before this package can be built
dependencies = []

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "libmongoc", v"1.13.0", sources, script, platforms, products, dependencies)
