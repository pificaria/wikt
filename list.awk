match($0, /^<li class="toclevel-1 tocsection-[0-9]+"><a [^>]+><span [^>]+>[^<]+<\/span>.<span class="toctext">([^<]+)/, gr) {
	printf "- %s\n", gr[1];
}
