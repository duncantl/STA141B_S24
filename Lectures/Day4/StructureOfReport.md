+ Structure of submission.
   + Submit PDF of report & separate R file(s) with all the code.
   + Should have functions, best in a separate file rather than an .Rmd

+ Report should describe what you did
   + high-level and medium-level details
      + Not explaining each line of code
   + Explain steps
   + Goal is to convince the reader (me, TA, boss, co-workers, other students)
      that what you did is correct.
   + Describe how you validated any assumptions, e.g.,
       + that the latitude & longitudes for the different files for the different variables were the
         same
	   + that the dates for files 1 through 72 were the same for the different variables	 
   + Describe where things went wrong and 
       + how you changed strategies for a particular step, and/or
	   + how you debugged the problem.


+ Consider what we did for reading the FEC data
   + Determined the separator and no column headers by looking at the first few lines
      + used head in the shell, or readLines(  n = 5) in R.
   + Used read.table() but got an error.
      + Verified that the problematic line in the file had 21 elements.
      + Programmatically found which character(s) occurred in that line that had not appeared in the
        earlier lines - '
      + Used fill = TRUE to see what read.table() was doing if read 128 lines.
        + That it actually read ~256 lines
        + Explain what is happening with the ' and finding the end ' on line 255
      + Use quote parameter - quote = ""
    + Got another error
	   + Same approach.
	   + Find contains # - comment character
	   + read.table() ignores all content on that line after this
	   + Use comment.char = ""
    + How did we verify that the final result was correct
	   + Check number of lines in file and number of rows in data.frame() from read.table()
	   + summary(data) and check for any unexpected results
	   + Check random rows and cells
	   + Check 
	   + More numerical summaries and plots of the data


+ If writing about approaches for the Solar data
   + wrote a function to read the weather - .wea - files
      + Simple structure for the records past line 6
	      + each row has 5 values - month, day, hour, and 2 values
		  + read.table() with skip = 6
		  + get names from Web
		  
      + Metadata
	      + name value pairs on first 6 lines
		  + read via read.table( nrow = 6) or strsplit(readLines(), " ")
		  + loop over these to create vectors with same value repeated nrow(d) to add to d.
      + Verify data
	      + numerical summaries
		  + plots
		      + Confirm hourly and seasonal trend
    + Tables from .stat file
	  + How to read each table with a general function
	     + User/caller specifies the text identifying the start of a given table.
		 + Find start and end line of content
		 + Get content/lines
         + Recognize tab-separated values
		 + Use textConnection() and pass to read.table()
		 + Transpose and transform the table so rows are months and columns are variables.
		 + Split the day and hour column into 2.

+ Not saying explicitly how for each step
   + That is in the code
   + But saying what the concept is.
+   
