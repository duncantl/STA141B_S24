# General

## Find start and end of text in a file.

+ Recall the [.stat](../Day3/USA_CA_Bodega.Bay.CG.Light.Station.724995_TMYx.stat) files we discussed a week ago 

+ Wanted to find lines that
  + starts with ` - Monthly Statistics for Dry Bulb temperatures [C]`
     + actually equals this, not just starts with.
  + ends with   `   - Maximum Dry Bulb temperature of ` but not the specifics

+ And other prefixes/strings for other tables.


```

grep(" - Monthly Statistics for Dry Bulb temperatures", ll)
grep("- Maximum Dry Bulb temperature of", ll)
```


## Formatted numbers - , for 1000s

+ Just yesterday, I was cleaning data of the form "17,231" i.e., with , for formatting for humans.

+ Want to remove the , and then call as.integer() or as.numeric().
  + We'd get NAs without removing the ','

```
vals = c("17,231", "8.91", "1,234.20")
vals2 = as.numeric(gsub(",", "", vals))
vals2
sum(vals2)
```

## Currency

+ We often get data with dollar amounts of the form "$123.20" or a euro or any other currency
  identifying character.

```
x = c("$123.20", "$456.19", "€789.11", "¥432.00")
```

+ Again, as.numeric() would give an NA if we passed it this.

+ We need to remove the $.

+ $ is a special character in regular expressions so we have several ways we could deal with this:
   1. start after the first character with substring
   2. remove the first character
   3. remove the currency identifier at the start of the string
   
```
as.numeric(substring(x, 2))
```

```
as.numeric(gsub("^.", "", x))
```

```
as.numeric(gsub("^[$€¥]", "", x))
```

The last of these allows us also to detect the characters in the middle of a string followed by
digits

```
y = c("The amount is $123.20 after savings", "Total = $456.16", "Fin = €789.11 + VAT", "全部的: ¥432.00")
grepl("[$€¥]([0-9]+)", y)

gsub(".*[$€¥]([0-9.]+).*", "\\1", y)
```


## % signs

Consider "numbers" of the form 
```
p = c("99%", "23%")
```

We need to remove the % to interpret as numbers.

```
as.numeric( gsub("%", "", p) )
```


## Find email addresses

Which lines contain


# NASA

## Get the variable name from the file names

ff = list.files("~/Data/NASAWeather", pattern = "txt$", full.names = TRUE)
varNames = gsub("[0-9]{,2}\\.txt$", "", basename(ff))
table(varNames)


Now we can 

+ group by variable name.
   + `stackedVars = tapply(allDFs, varNames, function(x) do.call(rbind, x))`
+ or use the file name to put the appropriate column name on the data.frame.
   + `names(df)[4] = gsub("[0-9]{,2}\\.txt$", "", basename(filename))`


## Get and transform the Date

```
ll = readLines(filename)
tm = ll[5]
strsplit(tm, " +")[[1]] [ 4 ] 
```
Or
```
gsub(" 00:00", "", gsub(".* : ", "", tm))
```

Figure out what we are doing in each of these.


## Deal with the North/South and West(/East)


Remove the N or S.
```
lat = c("36.2N", "33.8N", "31.2N", "28.8N", "26.2N", "23.8N", "21.2N", 
	    "18.8N", "16.2N", "13.8N", "11.2N", "8.8N", "6.2N", "3.8N", "1.2N", 
        "1.2S", "3.8S", "6.2S", "8.8S", "11.2S", "13.8S", "16.2S", "18.8S", 
        "21.2S")

tmp = gsub("[NS]", "", lat)
lat2 = as.numeric(tmp)
```

Multiply those that have S by -1
```
w = grepl("S", lat)
lat2[w] = lat2[w] * -1
```


Alternatively, sometimes useful to get the N and S and then use that to subset another variable

```
mul = c(N = 1, S = 1)
i = substring(lat, nchar(lat))
lat3 = lat2* mul[ i ]
```

Just use substring & nchar since last character; not a regular expression. 
But we could  and in many ways it is more general.

Remove all the digits and the . to leave only the N or the S

```
gsub("[0-9.]", "", lat)
```

Or keep only the last character
```
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
