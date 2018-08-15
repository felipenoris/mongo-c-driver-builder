
using BinaryBuilder

version = v"1.0.0"

let
	sources = [
	    "http://github.com/mongodb/libbson/releases/download/$(version)/libbson-$(version).tar.gz" =>
	        "6c11100d699e0aacb3acb1ae13b4992a2890da3b0ea77b4f93b59649e336c386",
	]

	script = raw"""
	cd ${WORKSPACE}/srcdir/libbson-*
	./configure --prefix=${prefix} --host=${target}
	make -j${nproc} install
	"""

	products(prefix) = [
	    LibraryProduct(prefix, "libbson", :libbson)
	]

	platforms = supported_platforms()

	dependencies = []

	build_tarballs(ARGS, "libbson", version, sources, script, platforms, products, dependencies)
end

let
	sources = [
	    "http://github.com/mongodb/mongo-c-driver/releases/download/$(version)/mongo-c-driver-$(version).tar.gz" =>
	        "c8f441611e0f6317f6c4e5b610675c417b192bdecf6208615a585ca088f5dadb",
	]

	script = raw"""
	cd ${WORKSPACE}/srcdir/mongo-c-driver-*
	./configure --prefix=${prefix} --host=${target}
	make -j${nproc} install
	"""

	products(prefix) = [
	    LibraryProduct(prefix, "libmongoc", :libmongoc)
	]

	platforms = supported_platforms()

	dependencies = []

	build_tarballs(ARGS, "libmongoc", version, sources, script, platforms, products, dependencies)
end
