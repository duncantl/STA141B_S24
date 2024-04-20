# Dates, Locales, functions and on.exit()

Recall in assignment 1, we were reading dates of the form
`16-Oct-1996`.

We can convert this to a Date object with `as.Date()`, i.e.,
```
eg = "16-Oct-1196"
as.Date(eg, "%d-%b-%Y")
```
The `%b` means "abbreviated name of the month". `as.Date()` uses this to recognize the Oct value in
the string.

Some of you may have written this exact code and yet got `NA` as the result.
The most likely reason is that your version of R (and your computer) are using a different
**locale** which controls the "internationalization services".  The locale controls, amongst other aspects,

+ the ordering for characters and so how strings are sorted,
+ how (non-monetary) numbers are represented, e.g., with . or , 
+ how dates and times

Suppose I am using a German locale, e.g., `de_DE`.
Then `%b` will look for values from 
 Jan, Feb, Mär, Apr, Mai, Jun, Jul, Aug, Sep, Okt, Nov, Dez
since these are the German abbreviated month names.
(We found these via the command
```
m = seq(as.Date("2024/1/1"), length = 12, by = "month")
# or 
m = as.Date(sprintf("1-%d-2024", 1:12), "%d-%m-%Y")
format(m, "%b")
```
)
Since Oct is not one of these, `as.Date()` cannot make sense of our example string and returns `NA`.


Similarly, if my computer defaults to an "English" locale, e.g., en_US, how do I read a date of the
form "janvier/9/2024" which uses the full French month name.

In other words, if I have date that use one language and my locale is for a different language, how
do I get R to read the date using the appropriate locale for that specific string/date.

One way is to set your locale to the target language, e.g., French in the case above for `janvier` or
English in the original example of `Oct`.
We can do this with
```{r}
Sys.setlocale(locale = "fr_CA")
as.Date("janvier/9/2024", "%B/%d/%Y")
```
```{r}
Sys.setlocale(locale = "en_US")
as.Date(eg, "%d-%b-%Y")
```

However, we are not using that locale we set.
We really should reset it back to the original value after we call `as.Date()`.
We can query the current locale and then arrange to reset the locale to that value.
```{r}
curLocale = Sys.getlocale()
Sys.setlocale(locale = "fr_CA")
as.Date("janvier/9/2024", "%B/%d/%Y")
Sys.setlocale(locale = curLocale)
```
But on my machine, this gives a warning message
```
Warning message:
In Sys.setlocale(locale = curLocale) :
  OS reports request to set locale to "en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8" cannot be honored
```

Let's not set all categories in the locale, but just the LC_TIME category:
```{r}
curLocale = Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", locale = "fr_CA")
as.Date("janvier/9/2024", "%B/%d/%Y")
Sys.setlocale("LC_TIME", locale = curLocale)
```
We can check the locale is back to the original
```{r}
Sys.getlocale("LC_TIME") == curLocale
```


So now we can write a function to convert the date, allowing the caller
to specify the format and, optionally, a locale.
If the locale is provided, we arrange to set the locale to that value
and reset to the original locale when the function was called.
We do this with `on.exit()` to ensure it happens even if there is an error 
and the function does return in the usual succesful manner.

Our function is 
```{r}
cvtDate =
function(str, fmt = "%d-%b-%Y", locale = NA)
{
    if(length(locale) > 0 && !is.na(locale)) {
        prev = Sys.getlocale("LC_TIME")
        on.exit(Sys.setlocale("LC_TIME", locale = prev))
        Sys.setlocale("LC_TIME", locale = locale)
    }

    as.Date(str, fmt)
}
```

We can use this and don't have to set our locale ourselves.

Let's capture our current locale and then test the function
```{r}
orig = Sys.getlocale()
```

```{r}
cvtDate("16-Oct-1996")

cvtDate("5/Okt/2024", "%d/%b/%Y") # NA
cvtDate("5/Okt/2024", "%d/%b/%Y", "de_DE") # correct

cvtDate("janvier/9/2024", "%B/%d/%Y") # NA
cvtDate("janvier/9/2024", "%B/%d/%Y", "fr_CA")    
```

And we can check the locale is back to its original
```
Sys.getlocale() == orig
```



It is always good to know what locale you are using and share that with others when asking
questions, e.g., on Piazza.
It is good to report the output from `sessionInfo()`, e.g.,

```
R Under development (unstable) (2024-04-19 r86451)
Platform: aarch64-apple-darwin22.2.0
Running under: macOS Ventura 13.1

Matrix products: default
BLAS:   /Users/duncan/Rtrunk3/build/lib/libRblas.dylib 
LAPACK: /Users/duncan/Rtrunk3/build/lib/libRlapack.dylib;  LAPACK version 3.12.0

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

time zone: America/Los_Angeles
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices datasets  utils     methods   base     

other attached packages:
[1] RShellTools_0-1.0

loaded via a namespace (and not attached):
[1] compiler_4.5.0
```
