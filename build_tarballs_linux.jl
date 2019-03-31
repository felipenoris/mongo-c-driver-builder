
using BinaryBuilder

name = "mongo-c-driver-builder"
version = v"1.14.0"

# Collection of sources required to build mongo-c-driver-builder
sources = [
    "https://zlib.net/zlib-1.2.11.tar.gz" =>
    "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",

    "https://www.openssl.org/source/openssl-1.1.1b.tar.gz" =>
    "5c557b023230413dfb0756f3137a13e6d726838ccd1430888ad15bfb2b43ea4b",

    "https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.27/cyrus-sasl-2.1.27.tar.gz" =>
    "26866b1549b00ffd020f188a43c258017fa1c382b3ddadd8201536f72efb05d5",

    "https://github.com/mongodb/mongo-c-driver/releases/download/1.14.0/mongo-c-driver-1.14.0.tar.gz" =>
    "ebe9694f7fa6477e594f19507877bbaa0b72747682541cf0cf9a6c29187e97e8",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd zlib-1.2.11/
./configure --prefix=$prefix
make -j${nproc}
make install
cd ..
cd openssl-1.1.1b/
./config --prefix=$prefix
make -j${nproc}
make install_sw
cd ..
cd cyrus-sasl-2.1.27/
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install
cd ..
cd mongo-c-driver-1.14.0/
mkdir cmake-build
cd cmake-build/
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DCMAKE_BUILD_TYPE=Release -DENABLE_SSL=OPENSSL -DENABLE_STATIC=ON -DENABLE_MONGOC=ON -DENABLE_BSON=ON -DENABLE_ZLIB=BUNDLED -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ..
make -j${nproc}
make install
exit
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "padlock", :padlock),
    LibraryProduct(prefix, "libssl", :libssl),
    LibraryProduct(prefix, "afalg", :afalg),
    LibraryProduct(prefix, "capi", :capi),
    LibraryProduct(prefix, "libz", :libz),
    LibraryProduct(prefix, "libsasl2", :libsasl2),
    LibraryProduct(prefix, "libcrypto", :libcrypto),
    LibraryProduct(prefix, "libbson", :libbson),
    LibraryProduct(prefix, "libmongoc", :libmongoc),
    LibraryProduct(prefix, "libcrammd5", :libcrammd5),
    LibraryProduct(prefix, "libdigestmd5", :libdigestmd5),
    LibraryProduct(prefix, "libplain", :libplain),
    LibraryProduct(prefix, "libanonymous", :libanonymous)
]

# Dependencies that must be installed before this package can be built
dependencies = []

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
