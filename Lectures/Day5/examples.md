# General

## Find start and end of text in a file.

+ Recall the [.stat](../Day3/USA_CA_Bodega.Bay.CG.Light.Station.724995_TMYx.stat) files we discussed a week ago 

+ Wanted to find lines that
  + starts with ` - Monthly Statistics for Dry Bulb temperatures [C]`
     + actually equals this, not just starts with.
  + ends with   `   - Maximum Dry Bulb temperature of ` but not the specifics

+ And other prefixes/strings for other tables.


```{r}
ll = readLines("../Day3/USA_CA_Bodega.Bay.CG.Light.Station.724995_TMYx.stat")
grep(" - Monthly Statistics for Dry Bulb temperatures", ll)
grep("- Maximum Dry Bulb temperature of", ll)
```


## Formatted numbers - , for 1000s

+ Just yesterday, I was cleaning data of the form "17,231" i.e., with , for formatting for humans.

+ Want to remove the , and then call as.integer() or as.numeric().
  + We'd get NAs without removing the ','

```{r}
vals = c("17,231", "8.91", "1,234.20")
vals2 = as.numeric(gsub(",", "", vals))
vals2
sum(vals2)
```

## Currency

+ We often get data with dollar amounts of the form "$123.20" or a euro or any other currency
  identifying character.

```{r}
x = c("$123.20", "$456.19", "€789.11", "¥432.00")
```

+ Again, as.numeric() would give an NA if we passed it this.

+ We need to remove the $ and the other currency symbols.

+ $ is a special character in regular expressions so we have several ways we could deal with this:
   1. start after the first character with substring
   2. remove the first character
   3. remove the currency identifier at the start of the string
   
```{r}
as.numeric(substring(x, 2))
```

```{r}
as.numeric(gsub("^.", "", x))
```

```{r}
as.numeric(gsub("^[$€¥]", "", x))
```

We can adapt the last of these to allow us to also detect the characters in the middle of a string followed by
digits

```{r}
y = c("The amount is $123.20 after savings", "Total = $456.16", "Fin = €789.11 + VAT", "全部的: ¥432.00", "No Charge", "Sin cargo")
grepl("[$€¥]([0-9]+)", y)

gsub(".*[$€¥]([0-9.]+).*", "\\1", y)
```

In some circumstances, we might create a variable for the amount and pre-populate it with NAs.
Then set just the values that have a matching pattern with the actual value
```{r}
amt = rep(NA, length(y))
w = grepl("[$€¥]([0-9]+)", y)
amt[w] = gsub(".*[$€¥]([0-9.]+).*", "\\1", y[w])
amt = as.numeric(amt)
```


## % signs

Consider "numbers" of the form 
```{r}
p = c("99%", "23%")
```

We need to remove the % to interpret as numbers.

```{r}
as.numeric( gsub("%", "", p) )
```



# NASA

## Get the variable name from the file names

```{r}
ff = list.files("~/Data/NASAWeather", pattern = "txt$", full.names = TRUE)
varNames = gsub("[0-9]{,2}\\.txt$", "", basename(ff))
table(varNames)
```

Now we can 

+ group by variable name.
   + `stackedVars = tapply(allDFs, varNames, function(x) do.call(rbind, x))`
+ or use the file name to put the appropriate column name on the data.frame.
   + `names(df)[4] = gsub("[0-9]{,2}\\.txt$", "", basename(filename))`


## Get and transform the Date

```{r}
ll = readLines(filename)
tm = ll[5]
strsplit(tm, " +")[[1]] [ 4 ] 
```
Or
```{r}
gsub(" 00:00", "", gsub(".* : ", "", tm))
```

Figure out what we are doing in each of these.


## Deal with the North/South and West(/East)


Remove the N or S.
```{r}
lat = c("36.2N", "33.8N", "31.2N", "28.8N", "26.2N", "23.8N", "21.2N", 
	    "18.8N", "16.2N", "13.8N", "11.2N", "8.8N", "6.2N", "3.8N", "1.2N", 
        "1.2S", "3.8S", "6.2S", "8.8S", "11.2S", "13.8S", "16.2S", "18.8S", 
        "21.2S")

tmp = gsub("[NS]", "", lat)
lat2 = as.numeric(tmp)
```

Multiply those that have S by -1
```{r}
w = grepl("S", lat)
lat2[w] = lat2[w] * -1
```


Alternatively, sometimes useful to get the N and S and then use that to subset another variable

```{r}
mul = c(N = 1, S = 1)
i = substring(lat, nchar(lat))
lat3 = lat2* mul[ i ]
```

Just use substring & nchar since last character; not a regular expression. 
But we could  and in many ways it is more general.

Remove all the digits and the . to leave only the N or the S

```{r}
gsub("[0-9.]", "", lat)
```

Or keep only the last character
```{r}
gsub(".*([NS])", "\\1", lat)
```



## Deal with "paragraphs" of text

When data come in free-form text, we have to find the elements above within the other words.

Consider the [following part of a job posting from indeed](jobPost.md):


+ Often has much more structure. But if dealing with simple text
  + Find the salary information
  + Academic qualifications
     + required 
	 + preferred
  + 




## Find email addresses

Which lines contain  `<something>@<domain>`


## IP Addresses

Consider the log files in Examples.html


```
Dec 10 06:55:46 LabSZ sshd[24200]: reverse mapping checking getaddrinfo for ns.marryaldkfaczcz.com [173.234.31.186] failed - POSSIBLE BREAK-IN ATTEMPT!
Dec 10 06:55:46 LabSZ sshd[24200]: Invalid user webmaster from 173.234.31.186
Dec 10 06:55:46 LabSZ sshd[24200]: input_userauth_request: invalid user webmaster [preauth]
Dec 10 06:55:46 LabSZ sshd[24200]: pam_unix(sshd:auth): check pass; user unknown
Dec 10 06:55:46 LabSZ sshd[24200]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=173.234.31.186 
Dec 10 06:55:48 LabSZ sshd[24200]: Failed password for invalid user webmaster from 173.234.31.186 port 38926 ssh2
Dec 10 06:55:48 LabSZ sshd[24200]: Connection closed by 173.234.31.186 [preauth]
Dec 10 07:02:47 LabSZ sshd[24203]: Connection closed by 212.47.254.145 [preauth]
Dec 10 07:07:38 LabSZ sshd[24206]: Invalid user test9 from 52.80.34.196
Dec 10 07:07:38 LabSZ sshd[24206]: input_userauth_request: invalid user test9 [preauth]
Dec 10 07:07:38 LabSZ sshd[24206]: pam_unix(sshd:auth): check pass; user unknown
```

+ Find the lines that contain an IP address
+ Extract them


```
ll = readLines("log1.txt")
grep("173.234.31.186", ll)
```

+ Remember, . means any character. Works, but may be too general
   + Would match 172x234...

+ Let's match an IP address generally

+ Looking for a number between 0 and 255 and then a . and then 3 more of these.
   + We'll allow 256 or 999. 
   + We can validate later.
   + Or we can restrict to 0..255 but that is harder with regular expressions. 
      + They don't understand the value, just the text.




# Web Server Log

+ ../../Data/eeyore.log

```
114.188.183.88 - - [01/Nov/2015:03:41:50 -0800] "GET /stat141/Code/Session1.txt HTTP/1.1" 404 223 "https://www.google.co.jp/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
114.188.183.88 - - [01/Nov/2015:03:41:50 -0800] "GET /favicon.ico HTTP/1.1" 404 209 "http://eeyore.ucdavis.edu/stat141/Code/Session1.txt" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
114.188.183.88 - - [01/Nov/2015:03:42:10 -0800] "GET /stat141/Code/ HTTP/1.1" 404 211 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
114.188.183.88 - - [01/Nov/2015:03:42:12 -0800] "GET /stat141/ HTTP/1.1" 200 4176 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36"
```

+

# Mannheim Wireless Data
