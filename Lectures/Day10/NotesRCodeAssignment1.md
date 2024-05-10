+ Must submit PDF file
   + 3 docx files
   + 3 HTML files


+ Don't repeat code or constants
   + DRY principle

```
z1 <- list.files(path = "/Users/xxx/Downloads/STA 141B/NASA", pattern = "cloudhigh")
z2 <- list.files(path = "/Users/xxx/Downloads/STA 141B/NASA", pattern = "cloudlow")
z3 <- list.files(path = "/Users/xxx/Downloads/STA 141B/NASA", pattern = "cloudmid")
z4 <- list.files(path = "/Users/xxx/Downloads/STA 141B/NASA", pattern = "ozone")
z5 <- list.files(path = "/Users/xxx/Downloads/STA 141B/NASA", pattern = "pressure")
z6 <- list.files(path = "/Users/xxx/Downloads/STA 141B/NASA", pattern = "surftemp")
z7 <- list.files(path = "/Users/xxx/Downloads/STA 141B/NASA", pattern = "temperature")
```
   + repeating the directory
   + 7 calls
dir = "/Users/xxx/Downloads/STA 141B/NASA"
list.files(dir, pattern = "temperature", full.names = TRUE)   
list.files(dir, pattern = "cloudlow")   
list.files(dir, pattern = "temperature")   

   
+ 

```
variables_txt = c("cloudhigh", "cloudlow", "cloudmid", "ozone", "pressure", "surftemp", "temperature")
# Set the working directory
cloudhigh =list.files(pattern = "cloudhigh")
cloudlow = list.files(pattern = "cloudlow")
ozon = list.files(pattern = "ozone")
pressure = list.files(pattern = "pressure")
surftemp = list.files(pattern = "surftemp")
temperature = list.files(pattern = "temperature")
```
  + Why not `lapply(variables_txt, function(x) list.files(pattern = x))`
  + Easy to adapt to specify directory
```
lapply(variables_txt, function(x) list.files(dir = "path/to/dir", pattern = x, full.names = TRUE))
```


+ Don't hard-code values.  Read them.

```
surftemp_data = lapply(surftemp, function(file) {
  suppressWarnings(read.table(file, header = TRUE, fill = TRUE, skip = 4, 
                              col.names = c("longitude|latitude","113.8W", "111.2W", "108.8W", "106.2W", "103.8W",
                                            "101.2W", "98.8W", "96.2W", "93.8W", "91.2W", "88.8W", 
                                            "86.2W", "83.8W", "81.2W", "78.8W", "76.2W", "73.8W",
                                            "71.2W", "68.8W", "66.2W", "63.8W", "61.2W ", "58.8W",
                                            "56.2W")))
```

+ Don't supressWarnings()


+ Don't concatenate
   + Preallocate
   + Use lapply()/sapply()/...


+ Use vectorized functions
   + One person had a while() loop with a for() loop inside it.


+ 
```
read_data <- function(z_list) {
  prep <- data_prep(z_list, n)
  filename <- prep
  return(filename)
}
```
  + What is n?
  + Why not just call `data_prep(z_list, n)`



```
n = 1
while (n <= length(z1)){
  
  z1_filename <- read_data(z1)
  file1 <- get_file(z1_filename)
  long1 <- get_long(z1_filename)
  title1 <- strsplit(readLines(z1_filename)[1], split = " : ")[[1]][2]
  date1 <- get_date(readLines(z1_filename))
  
  z2_filename <- read_data(z2)
  file2 <- get_file(z2_filename)
  long2 <- get_long(z2_filename)
  title2 <- strsplit(readLines(z2_filename)[1], split = " : ")[[1]][2]
  date2 <- get_date(readLines(z2_filename))
  
  z3_filename <- read_data(z3)
  file3 <- get_file(z3_filename)
  long3 <- get_long(z3_filename)
  title3 <- strsplit(readLines(z3_filename)[1], split = " : ")[[1]][2]
  date3 <- get_date(readLines(z3_filename))
  
  z4_filename <- read_data(z4)
  file4 <- get_file(z4_filename)
  long4 <- get_long(z4_filename)
  title4 <- strsplit(readLines(z4_filename)[1], split = " : ")[[1]][2]
  date4 <- get_date(readLines(z4_filename))
  
  z5_filename <- read_data(z5)
  file5 <- get_file(z5_filename)
  long5 <- get_long(z5_filename)
  title5 <- strsplit(readLines(z5_filename)[1], split = " : ")[[1]][2]
  date5 <- get_date(readLines(z5_filename))
  
  z6_filename <- read_data(z6)
  file6 <- get_file(z6_filename)
  long6 <- get_long(z6_filename)
  title6 <- strsplit(readLines(z6_filename)[1], split = " : ")[[1]][2]
  date6 <- get_date(readLines(z6_filename))
  
  z7_filename <- read_data(z7)
  file7 <- get_file(z7_filename)
  long7 <- get_long(z7_filename)
  title7 <- strsplit(readLines(z7_filename)[1], split = " : ")[[1]][2]
  date7 <- get_date(readLines(z7_filename))
  
  new_df1 <- data.frame(file1[,1],
                        file2[,1],
                        file3[,1],
                        file4[,1],
                        file5[,1],
                        file6[,1],
                        file7[,1])
  df_lat <- rbind.data.frame(df_lat, new_df1)
  
  new_df1 <- bind_rows(long1,
                       long2,
                       long3,
                       long4,
                       long5,
                       long6,
                       long7)
  df_long <- rbind.data.frame(df_long, new_df1)
  
  new_df1 <- data.frame(title1,
                        title2,
                        title3,
                        title4,
                        title5,
                        title6,
                        title7)
  df_title <- rbind.data.frame(df_title, new_df1)
  
  new_df1 <- data.frame(date1,
                        date2,
                        date3,
                        date4,
                        date5,
                        date6,
                        date7)
  df_date <- rbind.data.frame(df_date, new_df1)
  
  n = n + 1}
```


+ Convert the 

138.2W 36.8W

128.2N
1.2S

```
w_convert <- function(x) {
  i = 1
  while (i <= dim(x)[2]){
    c <- strsplit(x[1,i], split = "")
    len <- length(c[[1]])
    if (c[[1]][len] == "W"){
      c <- c[[1]][-len]
      c <- paste(c, collapse = '')
      x[1,i] <- paste0("-", c)
    }
    i = i + 1
  }
  return(x)
}
```


