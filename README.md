#  STA141B Spring 2024
## Instructor: Duncan Temple Lang

I will put code, notes, R sessions from live coding in class, etc. from the course in this github repository and some also on Canvas.


+ [Piazza](https://piazza.com/class/lufnnjs0ub36ht)

+ [Canvas](https://canvas.ucdavis.edu/courses/877218)


+ [Bonus Idiom](Lectures/Day7/cumsum.md)
   + cumsum() and grouping lines
   + Related to and might be useful for assignment 2 - Spam Email.

+ [Note on Dates & Locales](Docs/locale.md)
   + [Function](Docs/locale.R)
   
+ [Note on Character Encoding](Docs/CharacterEncoding.md)
   + [foo](Docs/foo), [foo1](Docs/foo1), [foo2](Docs/foo2), [foo3](Docs/foo3)
   
+ [New Note on Character Encoding and Content-Type](Docs/CharacterEncoding3.md)
   
+ [Brief Git Tutorial](GitBasics.md)

+ Lectures
     + [Day 1](Lectures/Day1)
     + [Day 2](Lectures/Day2)
     + [Day 2](Lectures/Day3)
         + [Day 3 R session](Lectures/Day3/Rsession_day3.txt)		 
		 + [wea/readWeather function](Lectures/Day3/wea.R)
		 + [functions for reading a table from the .stat file](Lectures/Day3/stat.R)
		 + [Outline](Lectures/Day3/Outline.md)
     + [Day 4](Lectures/Day4)	 
	     + [Guidelines for writing report](Lectures/Day4/StructureOfReport.md)
         + [lapply() & do.call()](Lectures/Day4/lapply_do.call.md)
         + [Day 3 R session](Lectures/Day4/Day4Rsession.txt)
     + [Day 5](Lectures/Day5)
	     + [Scenarios (slides)](Lectures/Day5/Examples.html)
	     + [Regular Expression Language](Lectures/Day5/Regexp.html)		 
         + [job post 1](Lectures/Day5/jobPost.md)
         + [job post 2](Lectures/Day5/jobPost2.md)		 

     + [Day 6](Lectures/Day6)
	     + [Reading HTTP/Web server log files](Lectures/Day6/weblog.md)
            + [Support functions](Lectures/Day6/weblogFun.R)
         + [Wifi/Mannheim data]()
 	     + [Familiar, small examples of regular expressions](Lectures/Day5/examples.md)

     + [Day 7](Lectures/Day7) 
	     + [Weblog Regexp explanation figure](Lectures/Day7/weblog.pdf)
 	     + [Familiar, small examples of regular expressions](Lectures/Day5/examples.md)         
	     + [R session/code](Lectures/Day7/Day7.session)
     + [Day 8](Lectures/Day8)
	      + [R session](Lectures/Day8/Day8.rsession)
     + [Day 9 README](Lectures/Day9/README.md)
	 
     + [Day 10](Lectures/Day10)	 
	    + [R session](Lectures/Day10/Day10.Rsession)	 
	    + [Notes on R Code](Lectures/Day10/NotesRCodeAssignment1.md)	 		
	    + [Reading Wifi data](Lectures/Day10/wifi.R)	 		
     + [Day 11 README](Lectures/Day11/README.md)		
     + [Day 12](Lectures/Day12/)
         + [Slides on SQL](Lectures/Day11/dbms2.html)
         + [moz_cookies/cookies3.slite DB](Lectures/Day11/cookies3.sqlite)		 
         + [HAVING example and exploration](Lectures/Day11/havingEg.sql) 
         + [R session](Lectures/Day11/Day12.rsession)

     + [Day 13](Lectures/Day13)
	     + [slides](Lectures/Day11/dbms2.html)	 
		    + we started on page [25](Lectures/Day11/dbms2.html#25).
	     + [R session](Lectures/Day13/Rsession)
		 
     + [Day 14](Lectures/Day14)
	     + [Slides](Lectures/Day14/BBall.html)
	     + [SQL session](Lectures/Day14/SQLSession)		 
	     + [helper functions](Lectures/Day14/dbFuns.R)		 		 

     + [Day 15](Lectures/Day15)
         + [Slides](Lectures/Day15/slides.html)	 
		 + Description of HTML tree.
         + [NYTimes map example](https://www.nytimes.com/interactive/2015/05/03/upshot/the-best-and-worst-places-to-grow-up-how-your-area-compares.html)
		    + Data in CSV via separate background download			
            + [NYT.R](Lectures/Day15/NYT.R)
         + [Marine Traffic](https://www.marinetraffic.com/en/ais/home/centerx:-123.5/centery:36.9/zoom:10)
		    + Data in JSON via separate background download
			+ Can't make simple HTTP request with readLines()
         + [Stats StackExchange](https://stats.stackexchange.com)
		    + static HTML content in Question summary front page
			+ Get links to page for each question.
         + [Firefox Developer Tools](https://firefox-source-docs.mozilla.org/devtools-user/network_monitor/)			
         + [Rsession](Lectures/Day15/Rsession)			

     + [Day 16](Lectures/Day16)
         + [XPath slides](Lectures/Day16/XPath.html)	 
         + [Using selenium to remote-control a Web browser](Lectures/Day16/selenium.R)	 		 
		 + [Scraping stats.stackexchange.com & XPath](StatsSE.R)
         + [Rsession](Lectures/Day16/Ression)
		 
     + [Day 17](Lectures/Day17)		 
	      + [code to process search results/pages of question from stats.stackexchange.com](Lectures/Day17/so.R)
             + This is a good structure for harvesting posts/questions/etc. when we have page after
   			   page of search results.
			   In other words, consider using this structure for assignment 4, and specializing it
   			   to craigslist. The components correspond to
			   + loop over pages and append the results			   
			   + process a page of results
			   + process each result, e.g., get URL for actual post/question
			   + get URL or HTML for the next page of results			   
			   + fix/post-process the columns in the overall data.frame

			   
<!-- 
     + [Day 15](Lectures/Day15)

     + [Day 16](Lectures/Day16)
     + [Day 17](Lectures/Day17)
     + [Day 18](Lectures/Day18)
     + [Day 19](Lectures/Day19)
     + [Day 20](Lectures/Day20)


mdList(sprintf("[Day %d](Lectures/Day%d)", 7:20, 7:20), "     + ")
-->
    
