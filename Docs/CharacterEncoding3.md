# Email Character Encoding

### TLDR
We can get the character encoding for an email from the header entry Content-Type 
and use that to read the body (and subject) correctly.



To correctly read the content of an email in terms of its character encoding, 
we need to know the character encoding with which it was saved.
Suppose I write an email using my favorite email tool
using my preferred/default character encoding, say ISO-2022-JP.
I type
```
<事業者>
```
The email tool displays this to me correctly. 
It may use the ISO-2022-JP encoding or it could chose to convert each character
I input to another encoding, e.g., UTF-8.
But let's suppose the tool keeps the characters in ISO-2022-JP encoding.

It then sends message. The tool displaying the message to the receiver 
may be using a very different character encoding, again set by the user of that tool.
Suppose this is UTF-8, but it can be anything. 
If this tool assumes the content of the message is UTF-8, it will display it incorrectly, e.g.,
```
<\033$B;v6H<T\033(B>
```

The receiving email tool needs to know the character set/encoding of
the original message and then it can either switch to that encoding
or convert the message from that encoding to the tool's current encoding,
UTF-8 in our example.


So how do we find the character set/encoding of the original message?
It is in the header of the email, specifically in the Content-Type field, e.g.,
```
Content-Type: text/plain; charset=ISO-2022-JP
```

For example, consider the file `spam/00325.58d1a52f435030dc38568bc12a3d76a2` in the
SpamAssassin data.


This tells us that 
+ the content is plain text AND
+ the character set/encoding is ISO-2022-JP.


We can read the file in several ways and compare the results
```{r}
f = "spam/00325.58d1a52f435030dc38568bc12a3d76a2"
z1 = readLines(f, encoding = "UTF-8")
z2 = readLines(f, encoding = "latin1")
z3 = readLines(f, encoding = "ISO-2022-JP")
con = file(f, encoding = "ISO-2022-JP"); z4 = readLines(con); close(con)
```
The final version (z4) specifies the encoding in the connection
(file) and this causes R to convert the content from the original encoding
to the R user's  default encoding - UTF-8 in this case.


They all have the same length, i.e., number of lines:
```r
sapply(list(z1, z2, z3, z4), length)
```

nchar() works for all versions
```{r}
v = lapply(list(z1, z2, z3, z4), function(x) try(nchar(x)))
```

However, they are far from the same or correct.
How many elements in z1, z2 and z3 are different from z4?
```{r}
sapply(list(z1, z2, z3), function(x) sum(x != z4))
```

Which elements are the same
```{r}
lapply(list(z1, z2, z3), function(x) x[x == z4])
```

The header lines and the following lines in the body are the same
```
[21] ""                                                                                              
[22] "stop-vip@e-project-web.com"                                                                    
[23] ""                                                                                              
[24] "http://www.vip-jp.net/?sid=2"                                                                  
[25] "http://www.vip-jp.net/?sid=2"                                                                  
[26] ""                                                                                              
[27] "stop-vip@e-project-web.com"                                                                    
```

But line 23 in z1, z2 and z3 is
```
"\033$B;aL>\033(B:Vip-mail"
```
but in z4 is
```
"氏名:Vip-mail"
```

What is the Encoding for each 

```
lapply(list(z1, z2, z3, z4), function(x) table(Encoding(x)))
```
```
[[1]]

unknown 
     49 

[[2]]

unknown 
     49 

[[3]]

unknown 
     49 

[[4]]

unknown   UTF-8 
     27      22 
```
This shows that R converted the content to UTF-8, knowing that it was
ISO-2022-JP.

When we grep for the character "突" 
```
sapply(list(z1, z2, z3, z4), function(x) grep("突", x))
```
we get 
```
[[1]]
integer(0)

[[2]]
integer(0)

[[3]]
integer(0)

[[4]]
[1] 24 46
```
So, as expected, we fail to find it in the first 3 but do find it in version
that was read correctly.




In the SpamAssassin data, we have 6540 files (excluding the ones with the mv commands.)
We read the header for each.  5639 have a Content-Type (or Content-type) field in the header.
Of these, 2211 have a value for charset in the Content-Type
with the following distribution:
```
 ISO-2022-JP   iso-8859-1   ISO-8859-1  iso-8859-15  ISO-8859-15 
           3           88          258           21           16 
unknown-8bit     us-ascii     US-ASCII        utf-8        UTF-8 
           1         1053          747            2            3 
windows-1251 windows-1252 Windows-1252 WINDOWS-1252         <NA> 
           2            3            1           13         4329 
```



## Windows-1252

Consider the file `spam_2/00575.cbefce767b904bb435fd9162d7165e9e`.
In the header, the charset is identified as `windows-1252`.

We read this file using our 4 approaches
```
f2 = "./spam_2/00575.cbefce767b904bb435fd9162d7165e9e"    
v1 = readLines(f2)
v2 = readLines(f2, encoding = "WINDOWS-1252")
v3 = readLines(f2, encoding = "latin1")
con = file(f2, encoding = "WINDOWS-1252"); v4 = readLines(con); close(con)
```

We can check that they are all identical to v4
```
sapply(list(v1, v2, v3, v4), identical, v4)
```
In other words, for this specific file, there is no difference.
This is because it does not contain any characters that are different
from the Latin-1/ISO-8859-1 equivalents.
