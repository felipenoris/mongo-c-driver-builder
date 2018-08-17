
using BinaryBuilder

const version = v"1.12.0"
const URL_PREFIX = "https://github.com/felipenoris/mongo-c-driver-builder/releases/download/v$version"

download_info = Dict()

const platforms_whitelist = [ Windows(:i686), Windows(:x86_64) ]
const platforms = filter( x -> x ∉ platforms_whitelist, supported_platforms())

const artefact = "libmongoc"

@sync for platform in platforms
		filename = "$(artefact).v$version.$(triplet(platform)).tar.gz"
		url = "$URL_PREFIX/$filename"
		@async begin
			run(`wget $url`)
			sha = split(readstring(`shasum -a 256 $filename`), " ")[1]
			download_info[platform] = (url, sha)
			rm(filename)
		end
	end
end

println("==================")
println("download_info for $artefact")
println("")
println("download_info = Dict(")

for v in download_info
	println("    " * string(v[1]) * " => " * string(v[2]) * ",")
end

println(")")
println("")
