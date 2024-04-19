# Mannheim Wifi Strength Study 

```
t=1139643118358;id=00:02:2D:21:0F:33;pos=0.0,0.0,0.0;degree=0.0;00:14:bf:b1:97:8a=-38,2437000000,3;00:14:bf:b1:97:90=-56,2427000000,3;00:0f:a3:39:e1:c0=-53,2462000000,3;00:14:bf:b1:97:8d=-65,2442000000,3;00:14:bf:b1:97:81=-65,2422000000,3;00:14:bf:3b:c7:c6=-66,2432000000,3;00:0f:a3:39:dd:cd=-75,2412000000,3;00:0f:a3:39:e0:4b=-78,2462000000,3;00:0f:a3:39:e2:10=-87,2437000000,3;02:64:fb:68:52:e6=-88,2447000000,1;02:00:42:55:31:00=-84,2457000000,1
```


+ Read the data from Data/mannheim into a data.frame
+ Each row has a
  + timestamp
  + id
  + position with 3 numbers 
  + degree/rotation
+ Sequence of terms of the form
```
00:14:bf:b1:97:8a=-38,2437000000,3
```
   + MAC address
   + =
   + signal strength
   + channel
   + 1 or 3 for fixed or mobile.

+ These identify the other devices in the building that were detected at this time and position.

+ Each line has potentially a different number of detected devices.


+ What is the desired format?

+ Don't want a column  (or 3 columns) for each detected device

+ One good approach is to have 
```
timestamp, id, posX, posY, posZ, degree, MAC, signal, channel, type
```

+ For each line in the file, we will have multiple rows in the data.frame
   + 1 row for each detected MAC address.



```
ll = readLines("../../Data/mannheim")
w = grepl("^#", ll)
ll = ll[!w]
```

+ Or
```
ll = grepl("^#", ll, invert = TRUE, value = TRUE)
```


+ Can use strsplit() to separate the terms
```
els = strsplit(ll, ";")
```
   + Note: I mistakenly typed `strsplit(";", ll)` since the regexp comes first in grep../gsub/...


+ For the first element, we get
```
[[1]]
 [1] "t=1139643118358"                   
 [2] "id=00:02:2D:21:0F:33"              
 [3] "pos=0.0,0.0,0.0"                   
 [4] "degree=0.0"                        
 [5] "00:14:bf:b1:97:8a=-38,2437000000,3"
 [6] "00:14:bf:b1:97:90=-56,2427000000,3"
 [7] "00:0f:a3:39:e1:c0=-53,2462000000,3"
 [8] "00:14:bf:b1:97:8d=-65,2442000000,3"
 [9] "00:14:bf:b1:97:81=-65,2422000000,3"
[10] "00:14:bf:3b:c7:c6=-66,2432000000,3"
[11] "00:0f:a3:39:dd:cd=-75,2412000000,3"
[12] "00:0f:a3:39:e0:4b=-78,2462000000,3"
[13] "00:0f:a3:39:e2:10=-87,2437000000,3"
[14] "02:64:fb:68:52:e6=-88,2447000000,1"
[15] "02:00:42:55:31:00=-84,2457000000,1"
```

+ So we will have 11 rows in the data frame for this one line

+ How to read elements 5 through 15 into a 4 column table/data.frame?

+ 2 approaches come to mind
  + Split by = and then ,
  + Change the = to a , and use read.csv(textConnection())

```
tmp = els[[1]][-(1:4)]
tmp2 = gsub("=", ",", tmp)
v = read.csv(textConnection(tmp2), header = FALSE)
```


+ We can do better by doing this for all lines in one step
```
tmp = unlist(lapply(els, function(x) x[-(1:4)]))
tmp2 = gsub("=", ",", tmp)
v = read.csv(textConnection(tmp2), header = FALSE)
```

+ Now we need to add the fixed values for each line, 
   + i.e., timestamp, posX, posY, posY, degree.
   
+ We need to remove the t=, id=, ... and get the values.

```
tmp = unlist(lapply(els, function(x) x[1:4]))
tmp2 = gsub(".*=", "", tmp)
m = matrix(tmp2, , 4, byrow = TRUE)
```

+ Have to split the pos
   + Can do that separately
   + But can also do at the same time
   + Split also by ,
```
tmp = unlist(lapply(els, function(x) x[1:4]))
tmp2 = gsub(".*=", "", tmp)
tmp3 = unlist(strsplit(tmp2, ","))
m = matrix(tmp3, , 6, byrow = TRUE)
```

+ We need to convert these to numbers, time stamps

```
m2 = as.data.frame(m)
names(m2) = c("timestamp", "MAC0", "X", "Y", "Z", "degree")

m2[3:6] = lapply(m2[3:6], as.numeric)
```

+ To convert the timestamp to a POSIXct object, we can use
```
structure(1139643118358/1000, class = c("POSIXct","POSIXt"))
```

+ Doing this for the entire vector
```
m2$tm = structure(as.numeric(m2$timestamp)/1000, class = c("POSIXct","POSIXt"))
```

+ Now we need to match the row here with the **rows** in `v` above

+ How rows dow need for each line
    + It is the number elements  less 4 to account the t, id, pos, degree elements
```
nels = sapply(els, length) - 4
```

+ So now we can use subsetting to repeat each row of m2 the correct number of times
```
idx = rep(seq(along.with = els), nels)
m2[ idx, ]
```

+ And now we combine m2 and v
```
dt = cbind(m2[idx, ], v)
```
