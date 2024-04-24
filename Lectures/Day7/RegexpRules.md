
# Regular Expressions

+ literal matching - `"abc"`

+ wildcard - any character - `.`

+ start and end of string - `^` and `$`
   + meta characters 
   + escape meta-characters  (\\) to match literal character
   + ^ and $ often called anchors
   + also word boundary \\b

+ character classes
   + `[abc]`
   + `[0-9a-zA-F]`
   + named character classes  ( `[[:space:][:punct:]]` )
   + complement set   - `[^"]`

+ quantifiers  
   + apply to preceding pattern
   + `?` - 0 or 1, optional
   + `*` - 0 or more 
   + `+` - 1 or more
   + `{m,n}` - between m and n inclusive

+ alternate patterns -  `|`
   +  `(abc|1234)`
   + `("[^"]+"|-)`

+ grouping -  ()
   + precedence
   + labeling for reference
   + "(the|a) \\1 " - matches "a a " or "the the "

+ back references  (\\1)
