Consider the file 2c which contains
```
8°
```

We can read this as a binary file and see the bytes:
```{r}
ff = "~/sta141b/Public/Data/2c"
x = readBin(ff, "raw", 3)
```
(or use `file.info(ff)$size` for the number of bytes to read)


This yields
```
[1] 38 c2 b0
```

38 is the hexadecimal equivalent of 56 which is the ASCII code for the character 8.
(https://theasciicode.com.ar/ascii-printable-characters/number-eight-ascii-code-56.html)


The 2 elements c2 b0 combine to correspond to `°`.  See https://www.utf8-chartable.de/.


