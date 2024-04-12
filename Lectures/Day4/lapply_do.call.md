# lapply() and do.call()

I showed the following in class on the board.


Suppose we have a collection of files, e.g.,
+  solar data, e.g., .wea files for many weather stations
+  several years of the FEC `itcont<year>.txt` files
+  NASA weather data.


We'll think about the first of these.
We have a directory with many .wea files.

We can get the names of these files with
```{r}
weaFiles = list.files(directoryPath, full.names = TRUE, pattern = "wea")
```
(We'll discuss making this more precise when we cover regular expressions starting  on Tuesday.)


As always, check the class and length of the variable before proceeding.


We have a function from Day3/ named `readWeather`.
This takes the name of a single file and returns the data.frame with 9 (or 10) columns with the data
values from row 6 onwards and then additional columns for the meta-data about this station, e.g.,
its name/place, elevation, latitute, longitude, ...


To read all of these files and get a list of data.frames, we can use
```{r}
wead = lapply(weaFiles, readWeather)
```

Check the contents of `wead`
```{r}
class(wead)
length(wead)
table(sapply(wead, class))
```

They are all data.frames.


We know want to "stack" these on top of each other to make one large data.frame.
We need to verify the number of columns are the same for all and the names of the columns
match. This is to avoid both an error, and also combining columns that measure/represent different
types of values.




