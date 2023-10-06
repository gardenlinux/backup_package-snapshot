#!/usr/bin/env -S awk -f

BEGIN {
	FS=": "
}

NF == 0 {
	directory = "pool/" pkg["Package"] "/" pkg["Version"]
	lines = lines "Directory" FS directory RS
	pkg_id = pkg["Package"] " " pkg["Version"]
	pkgs[pkg_id] = lines
	source_directories[pkg_id] = pkg["Directory"]
	target_directories[pkg_id] = directory
	sha256sums[pkg_id] = files
	delete pkg
	lines = ""
	next
}

!/^ / {
	pkg[$1] = $2
	checksums_flag = 0
}

$1 !~ /Directory/ {
	lines = lines $0 RS
}

$1 ~ /Checksums-Sha256/ {
	checksums_flag = 1
	files = ""
}

checksums_flag && /^ / {
	split($0, checksum_file, " ")
	files = ((files != "") ? files " " : "") checksum_file[1] ":" checksum_file[3]
}

END {
	asorti(pkgs, sorted_pkgs)
	for (i in sorted_pkgs) {
		pkg_id = sorted_pkgs[i]
		print pkgs[pkg_id]
		file_set = file_set_prefix ((i - 1) % num_file_sets)
		print source_directories[pkg_id], target_directories[pkg_id], sha256sums[pkg_id] > file_set
	}
}
