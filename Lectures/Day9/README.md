
+ Grouping lines in email header
  + e.g., easy_ham/01425.c6c34c1234e8b04e01326868202110fd
  + Take first few elements from this header and put in the file [jasper](jasper)
  +  We want to transform these lines in R into [jasper2](jasper2)
     + Join the lines that start with white space to the previous line that starts a "Name: Value" line
  + So lines 1 and line 2 stay the same,
    + group lines 3, 4, 5 into one line.
	+ group lines 6, 7, 8
	+ group lines 9, 10, 11, 12
  + Want to get the group number for each line as in [jasper3](jasper3)
  + `cumsum(grepl())`
  
+ Grouping lines for attachments (and body parts) in the email



