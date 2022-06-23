help () {
	echo "$0 word ?language"
	echo "$0 -l word"
	exit 1
}

[ -z "$1" ] && help
case "$1" in
	"-l") flagL=1
		  [ -z "$2" ] && help || word="$2";;
	*) flagL=0
	   word="$1"
	   lang=${2:-"English"}
esac

url="http://en.wiktionary.org/wiki/$word"

if [ "$flagL" -eq 1 ]; then
	wget -q -t 1 -T 5 -O - "$url" | awk "$listAwk"
else
	wget -q -t 1 -T 5 -O - "$url" | awk -v "lang=$lang" "$dictAwk"
fi
