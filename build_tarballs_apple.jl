using BinaryBuilder

name = "mongo-c-driver-builder"
version = v"1.14.0"

# Collection of sources required to build mongo-c-driver-builder
sources = [
    "https://github.com/mongodb/mongo-c-driver/releases/download/1.14.0/mongo-c-driver-1.14.0.tar.gz" =>
    "ebe9694f7fa6477e594f19507877bbaa0b72747682541cf0cf9a6c29187e97e8",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd mongo-c-driver-1.14.0/
mkdir cmake-build
cd cmake-build/
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DCMAKE_BUILD_TYPE=Release -DENABLE_SSL=AUTO -DENABLE_STATIC=ON -DENABLE_MONGOC=ON -DENABLE_BSON=ON -DENABLE_ZLIB=BUNDLED -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ..
make -j${nproc}
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    MacOS(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libmongoc", :libmongoc),
    LibraryProduct(prefix, "libbson", :libbson)
]

# Dependencies that must be installed before this package can be built
dependencies = [

]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)