For a line such as

```
114.188.183.88 - - [01/Nov/2015:03:41:50 -0800] "GET /stat141/Code/Session1.txt HTTP/1.1" 404 223 "https://www.google.co.jp/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
```
we want a row in a data.frame with

+ IP address
+ value of -
+ second -
+ timestamp within the [] (but not including the []
+ GET  - operation/action
+ /stat141/Code/Session1.txt - path to file on the Web server
+ 1.1 from HTTP/1.1 - version of HTTP being used
+ 404 - status code
+ 223 - number of bytes returned
+ https//www.google.co.jp  - page from which the person was referred to this request
+ operating system and browser detals
   + We'll get the entire string and decompose it separately.
   


Start by reading the data as separate lines, so a character vector.
```
ll = readLines("../../Data/eeyore.log")
length(ll)
class(ll)
```


Let's match the first 4 elements.

Consider
```
rx = "^([0-9.]+) - - \\[([^]]+)\\]"
```

Now use this regular expression to see if it matches all the lines
```
w = grepl(rx, ll)
table(w)
ll[!w]
```

+ So missed some.
+ What is the pattern for the ones we missed?



+ So the second - may have a login
   + The first - is always a -, at least in this data set.


+ So add EITHER  - or sequence of letters, upper and lower case

```
rx = "^([0-9.]+) - (-|[a-zA-Z]+) \\[([^]]+)\\]"
w = grepl(rx, ll)
table(w)
```

login may contain number?  or just 1

```
rx = "^([0-9.]+) - (-|[a-zA-Z1]+) \\[([^]]+)\\]"
w = grepl(rx, ll)
table(w)
```

So adding 1 doesn't capture all cases.



```
rx = "^([0-9.]+) - (-|[a-zA-Z0-9]+) \\[([^]]+)\\]"
w = grepl(rx, ll)
table(w)
```

+ Alternatively, we could have used "everything that isn't a space"

```
rx = "^([0-9.]+) - ([^ ]+) \\[([^]]+)\\]"
w = grepl(rx, ll)
table(w)
```

+ Does this give the same results for each element?

```
m = gregexec(rx, ll)
els = regmatches(ll, m)
```

```
class(els)
table(sapply(els, length))
```

+ Why 4 elements?

```
els[[1]]
```


+ For each, drop the first match and convert to a matrix

```
d = do.call(rbind, lapply(els, function(x) matrix(x[-1], 1)))
```
or
```
d2 = matrix(unlist(els), , 4, byrow = TRUE)[,-1]
```


+ So far, we got everything for the first 3 fields.
+ Now expand to 4th field and so on.
+ The next 3 fields are in the `"GET /stat141.../Session1.txt HTTP/1.1"` 
   + Can deal with them separately, but exploit the matching "
+ Want the GET, then the path, then 1.1 in HTTP 1.1

```
rx = '^([0-9.]+) - ([^ ]+) \\[([^]]+)\\] "(GET) ([^ ]+) HTTP/(1.1)"'
w = grepl(rx, ll)
```

+ Note that I switched to '' for the entire regular expression so I could use " inside.


+ Again, didn't match everything. 
   + Look at those that didn't match and generalize the regexp.

+ HTTP/1.0

```
rx = '^([0-9.]+) - ([^ ]+) \\[([^]]+)\\] "(GET) ([^ ]+) HTTP/(1.[01])"'
w = grepl(rx, ll)
```

+ Now not matching HEAD instead of GET

```
rx = '^([0-9.]+) - ([^ ]+) \\[([^]]+)\\] "(GET|HEAD) ([^ ]+) HTTP/(1.[01])"'
w = grepl(rx, ll)
```

+ Now not matching 7
   + HBESPY, POST, WFZWXO for the operation
   + Could match these  OR any sequence of capital letters
   
   
```
rx = '^([0-9.]+) - ([^ ]+) \\[([^]]+)\\] "([A-Z]+) ([^ ]+) HTTP/(1.[01])"'
w = grepl(rx, ll)
```   
   

+ Now we want the status and the number of bytes

```
rx = '^([0-9.]+) - ([^ ]+) \\[([^]]+)\\] "([A-Z]+) ([^ ]+) HTTP/(1.[01])" ([0-9]+) ([0-9]+)'
w = grepl(rx, ll)
table(w)
```

+ > 2500 non-matches.

+ The number of bytes can be -


```
rx = '^([0-9.]+) - ([^ ]+) \\[([^]]+)\\] "([A-Z]+) ([^ ]+) HTTP/(1.[01])" ([0-9]+) (-|[0-9]+)'
w = grepl(rx, ll)
table(w)
```


Let's convert to a data.frame to check the results so far.

```
m = gregexec(rx, ll)
els = regmatches(ll, m)
d = matrix(unlist(els), , 8, byrow = TRUE)[,-1]
d = as.data.frame(d)
```

+ Warnings
   + What went wrong?
   

```
d = matrix(unlist(els), , 9, byrow = TRUE)[,-1]
d = as.data.frame(d)
```

```
sapply(d, class)
```

```
names(d) = c("IP", "login", "timestamp", "action", "path", "httpVersion", "status", "numBytes")
```

```
d$when = as.POSIXct(strptime( d$timestamp, "%d/%b/%Y:%H:%M:%S -0800"))
```

+ Check results 
```
class(d$when)
table(is.na(d$when))

table(format(d$when, "%d"))
```

```
table(d$action)
```

```
table(d$status)
```

```
tmp = as.integer(d$numBytes)
table(is.na(tmp))
table(d$numBytes[is.na(tmp)])
d$numBytes = tmp
```

```
sapply(d, class)
```


+ Now the referrer and the OS/browser information.

```
rx = '^([0-9.]+) - ([^ ]+) \\[([^]]+)\\] "([A-Z]+) ([^ ]+) HTTP/(1.[01])" ([0-9]+) (-|[0-9]+) "([^"])+" "([^"]+)"'
w = grepl(rx, ll)
table(w)
```

+ Missed 1

+ What's different about this?
   + Why didn't it match?


```
rx = '^([0-9.]+) - ([^ ]+) \\[([^]]+)\\] "([A-Z]+) ([^ ]+) HTTP/(1.[01])" ([0-9]+) (-|[0-9]+) "([^"])*" "([^"]+)"'
w = grepl(rx, ll)
table(w)
```

```
source("weblogFun.R")
d = mkDF(rx, ll)
```


+ Verify results.
   + Already did most of this.
   

```
table(nchar(d$referrer))
```

+ Seems wrong.
   + Check rx

```
rx = '^([0-9.]+) - ([^ ]+) \\[([^]]+)\\] "([A-Z]+) ([^ ]+) HTTP/(1.[01])" ([0-9]+) (-|[0-9]+) "([^"]*)" "([^"]+)"'
w = grepl(rx, ll)
table(w)
```

+ A lot more sensible.

+ But what did the original rx match for referrer and browserInfo?
   + Do we take the time to learn or keep moving forward now that we appear to have fixed the issue?
   

```
table(nchar(d$browser))
```
 
+ What about the short ones 

```
w = nchar(d$browser) < 20
table(w)
table(d$browser[w])
```
+ Seem okay.


# OS and Browser info.

```
head(d$browser)
```

```
w = grepl("Windows", d$browser)
table(w)
head(d$browser[!w])
```

+ Get the text after the ( and up to the ;
```
tmp = gsub(".*\\(([^;]+);.*", "\\1", d$browser)
range(nchar(tmp))
```

+ Adjust to match ; or )
```
tmp = gsub(".*\\(([^;]+)[;)].*", "\\1", d$browser)
range(nchar(tmp))
```
+ Look at values.  
   + Not quite right.
   + Lost the R before the 3.0

+ Added the ) to [;)] but not in the capture group.
```
tmp = gsub(".*\\(([^;)]+)[;)].*", "\\1", d$browser)
range(nchar(tmp))
```
