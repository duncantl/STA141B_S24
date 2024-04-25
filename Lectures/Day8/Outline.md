+ What difficulties are you having?
+ What is confusing?

















+ 
How to rewrite this regular expression to be less repetitive and so more flexible:
```
(http://|https://)
(https?://)
```


+ How to remove all the characters and numbers from a string
   + a, b, c..., z, 0, 1, 2, ... 9

```
this is the first of many words! There aren't many other characters. But how many are there? Hopefully some!
```

```
a = gsub("[a-zA-Z]", "", x)
````
Not quite correct?

```
b = gsub("[a-zA-Z ]", "", x)
```


+ Find all salary amounts

E.g. in sentences/paragraphs that include the following text
```
Salary: $120,000      120,000
Up to $120K           120K
Salary range: $120-140K,  
$120K-140K
$60k-70k
The salary range is between 172,500 and 320,300 with no ...
```
The last 2 from ../Day5/jobPost2.md and ../Day5/jobPost.md.




+ N/S in NASA Data


+ IP Addresses in Log files.

+ Mannheim Wireless Data


+ Robot Log File

+ NCBI
