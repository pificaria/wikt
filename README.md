# Usage
First call _build_ to generate the script itself:
```
./build > wikt
chmod +x wikt
```
Then you can search for a word definition in the English Wiktionary:
```
./wikt word
```
You can also pass it another parameter specifying the language for the search:
```
./wikt Sprache German
```
To know which languages (at least which Wiktionaries) have a given word
definition, you can use
```
./wikt -l word
```
