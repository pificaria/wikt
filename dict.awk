function stripTags(t) {
	gsub("<[^>]*>", "", t);
	gsub("&(#160|nbsp);", " ", t);
	return t;
}

function setInd(i) {
	ind = tabs * (i - 3);
}

function incInd() {
	ind += tabs;
}

function printSpaces() {
	for(i = 0; i < ind; ++i) printf " ";
}

function printText(t) {
	split(stripTags(t), arr, "\n");
	for(a in arr) {
		printSpaces();
		printf "%s\n", arr[a];
	}
}

BEGIN {
	flag     = 0;
	flagPar  = 0;
	flagList = 0;
	isOl     = 0;
	ulPos    = 0;
	ind      = 0;
	tabs     = 4;
	idx      = 1;
	regexpPar  = "(Etymology)(_[0-9]+)?";
	regexpList = "(Synonyms|Noun|Verb|Pronoun|Determiner|Preposition|Symbol|Conjunction|Adjective|Adverb|Prefix)(_[0-9]+)?";
	regexpH2   = "^<h2><(a href=\"#|span class=\"mw-headline\" id=\")([A-Za-z]+)(_[0-9]*)?";
	regexpHn   = "^<h([0-9])><(a href=\"#|span class=\"mw-headline\" id=\")";
}

match($0, regexpH2, gr) {
	if(gr[2] == lang) flag = 1; 
	else flag = 0;
}

flag && match($0, regexpHn regexpPar, gr) {
	setInd(gr[1]);
	printSpaces();
	printf "[-] %s\n", gr[3];
	incInd();
	flagPar = 1;
}

flag && match($0, regexpHn regexpList, gr) {
	setInd(gr[1]);
	printSpaces();
	printf "[-] %s\n", gr[3];
	incInd();
	flagList = 1;
	flagPar  = 1;
}

flagList && match($0, "^<(ol|ul)>", gr) {
	if(!ulPos && gr[1] == "ol") { incInd(); isOl = 1; }
	ulPos += 1;
}

flagList && (ulPos > 0) && /^<\/(ol|ul)>/ {
	if(ulPos == 1) {
		flagList = 0;
		flagPar  = 0;
		idx      = 1;
		isOl     = 0;
		print "";
	}

	ulPos -= 1;
}

flagPar && /^<p>/ {
	printText($0);
	flagPar = 0;
	if(!flagList) print "";
}

flagList && (ulPos == 1) && /^<li>/ {
	printSpaces();
	if(isOl) printf "%d. ", idx;
	else printf "- ";
	printf "%s\n", stripTags($0);
	idx += 1;
}
