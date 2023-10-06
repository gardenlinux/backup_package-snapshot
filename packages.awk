#!/usr/bin/env -S awk -f

BEGIN {
	FS=": "
}

NF == 0 {
	if (!("Source" in pkg)) { pkg["Source"] = pkg["Package"] }
	split(pkg["Source"], source, " ")
	filename = "pool/" source[1] "/" pkg["Version"] "/" pkg["Package"] "_" pkg["Version"] "_" pkg["Architecture"] ".deb"
	lines = lines "Filename" FS filename RS "Size" FS pkg["Size"] RS "SHA256" FS pkg["SHA256"] RS
	pkg_id = pkg["Package"] " " pkg["Version"] " " pkg["Architecture"]
	pkgs[pkg_id] = lines
	source_files[pkg_id] = pkg["Filename"]
	target_files[pkg_id] = filename
	sha256sums[pkg_id] = pkg["SHA256"]
	delete pkg
	lines = ""
	next
}

!/^ / {
	pkg[$1] = $2
}

$1 !~ /Filename|Size|MD5sum|SHA256/ {
	lines = lines $0 RS
}

END {
	asorti(pkgs, sorted_pkgs)
	for (i in sorted_pkgs) {
		pkg_id = sorted_pkgs[i]
		print pkgs[pkg_id]
		file_set = file_set_prefix ((i - 1) % num_file_sets)
		print source_files[pkg_id], target_files[pkg_id], sha256sums[pkg_id] > file_set
	}
}
