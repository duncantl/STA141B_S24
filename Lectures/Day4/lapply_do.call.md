# lapply() and do.call()

I showed the following in class on the board.


Suppose we have a collection of files, e.g.,
+  solar data, e.g., .wea files for many weather stations
+  several years of the FEC `itcont<year>.txt` files
+  NASA weather data.


We'll think about the first of these.
We have a directory with many .wea files.
I've put 3 such files in a directory WeatherFiles under this one.

We can get the names of these files with
```{r}
weaFiles = list.files("WeatherFiles", full.names = TRUE, pattern = "wea")
```
(We'll discuss making this more precise when we cover regular expressions starting  on Tuesday.)


As always, check the class and length of the variable before proceeding.


We have a function from Day3/ named `readWeather`.
```{r}
source("../Day3/wea.R")
```
This function takes the name of a single file and returns the data.frame with 9 (or 10) columns with the data
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

```{r}
allWead = do.call(rbind, wead)
```

Again, check the result is sensible and what you expect.
That includes plots to see the distribution of the values, not just the structure of the object.


If we wanted to identify which files these came from, we could add a column with each filename
repeated for as many values as there are in the corresponding data.frame for that file, e.g.,

```{r}
allWead$filename = rep(weaFiles, sapply(wead, nrow))
```

Overall summary
```{r}
summary(allWead)
```

Summary by site
```{r}
by(allWead, allWead$site, summary)
```


Plot of direct versus hour.
```{r}
ggplot(allWead, aes(x = time, y = direct, color = site)) + geom_point()
```
Lots of overlap


```{r}
ggplot(allWead, aes(x = time, y = direct)) + geom_point() + facet_wrap("site")
```
