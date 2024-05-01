
# Recap of Essential Elements of Regular Expression Domain Specific Language (DSL)

+ match literal string patterns
+ `.` - match any character
+ `[a-z]` - one of a set of characters
+ `[[:space:][:digit:]]` - named character sets
+ `[^a-z]` - negation/anything but any of the set of characters
+ `(pat1|pat2)` - either of two patterns
+ `^` - start of string
+ `$` - end of string

+ Quantifiers
  + refer to the most recent subpattern
  + `?` - optional, 0 or 1 occurrences
  + `*` - zero or more occurrences
  + `+` - 1 or more occurrences
  + `{m,n}` - between m and n occurrences, inclusive
  + `{m,}` - at least m occurrences
  + `{,n}` - at most n occurrences


+ Capture Groups and Backreferences
  + `( patterns )`
  + Can refer to them via \\1, \\2, ...

+ Escape Meta-characters
  + "\\*" - two slashes and character.


+ Other elements
  + `\\s`
  + `\\w`
  + `\\d`

# R Functions

+ grep(), grepl()
+ gregexpr(), gregexec()
+ regmatches()
+ sub(), gsub()
+ strsplit()
