
using BinaryBuilder

const version = v"1.9.5"

platforms = [
    Linux(:x86_64, :glibc),
    MacOS(:x86_64)
]

let
    sources = [
        "http://github.com/mongodb/libbson/releases/download/$(version)/libbson-$(version).tar.gz" =>
            "6bb51b863a4641d6d7729e4b55df8f4389ed534c34eb3a1cda906a53df11072c",
    ]

    script = raw"""
    cd ${WORKSPACE}/srcdir/libbson-*
    ./configure --prefix=${prefix} --host=${target}
    make -j${nproc} install
    """

    products(prefix) = [
        LibraryProduct(prefix, "libbson", :libbson)
    ]

    dependencies = []

    build_tarballs(ARGS, "libbson", version, sources, script, platforms, products, dependencies)
end

let
    sources = [
        "http://github.com/mongodb/mongo-c-driver/releases/download/$(version)/mongo-c-driver-$(version).tar.gz" =>
            "4a4bd0b0375450250a3da50c050b84b9ba8950ce32e16555714e75ebae0b8019",
    ]

    script = raw"""
    cd ${WORKSPACE}/srcdir/mongo-c-driver-*
    ./configure --prefix=${prefix} --host=${target}
    make -j${nproc} install
    """

    products(prefix) = [
        LibraryProduct(prefix, "libmongoc", :libmongoc)
    ]

    dependencies = []

    build_tarballs(ARGS, "libmongoc", version, sources, script, platforms, products, dependencies)
end
