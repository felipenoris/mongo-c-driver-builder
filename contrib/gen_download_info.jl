
using BinaryBuilder

const VER = v"1.0.0"
const URL_PREFIX = "https://github.com/felipenoris/mongo-c-driver-builder/releases/download/v$VER"

artefacts_list = [ "libbson", "libmongoc" ]
download_info_list = [ Dict(), Dict() ]

@sync for (artefact_index, artefact) in enumerate(artefacts_list)
	for platform in supported_platforms()
		filename = "$(artefact).v$VER.$(triplet(platform)).tar.gz"
		url = "$URL_PREFIX/$filename"
		@async begin
			run(`wget $url`)
			sha = split(readstring(`shasum -a 256 $filename`), " ")[1]
			download_info_list[artefact_index][platform] = (url, sha)
			rm(filename)
		end
	end
end

for i in 1:length(artefacts_list)
	println("==================")
	println("download_info for $(artefacts_list[i])")
	println("")
	println("download_info = Dict(")
	dict = download_info_list[i]

	for v in dict
		println("    " * string(v[1]) * " => " * string(v[2]) * ",")
	end

	println(")")
	println("")
end
