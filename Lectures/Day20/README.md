# Interactive plots without plotly/leaflet/etc.


## TL;DR - Too Long; Didn't Read.

+ The plotly/leaflet/.... libraries are great for creating relatively straightforward interactive
   plots and hide a lot of details from you.
+ They become "black-box" or complicated to deal with for more complex interactivity.
+ It can be useful to create the plots in R as SVG plots, then programmatically add the interactive code (event
  handlers) and then create the HTML, JavaScript code, any JSON data.
+ By dealing with the existing SVG before viewing-time, we have some additional opportunities
  to control what it does.
+ How to deal with interactivity between multiple plots is "clearer".
+ The discussion here and the AnimatedMap.html/ from Day 18 shows how to do this.
+ There are advantages and disadvantages, i.e., tradeoffs.
+ One can use this approach in combination with plotly/leaflet/etc.


## Ouputs To See

+ [AnimatedMap.html](../Day18/AnimatedMap.html)
   + [Directly runnable version](https://www.stat.ucdavis.edu/~duncan/VizEg/AnimatedCOVIDMap/animatedMap.html)
   + State-level animation of COVID cases with interactivity.

+ [view2.html](view2.html)
   + California COVID cases
   + Map of CA
   + Click on a county, see a PNG time series for that county.

+ [view3.html](view3.html)
   + Same as view2.html above, but display an SVG plot for the county time series.

+ [inlineSVG.html](inlineSVG.html)
   + Version of view3.html that doesn't require using a Web server to serve the files.

## Background


As I briefly mentioned in class, the AnimatedMap.html/ directory
implements an interactive, animated display of data and was
written without using plotly or leaflet or other JavaScript plotting libraries.

These packages and JS libraries are often exactly what you want.
Sometimes they are not. 
The multiple layers from R to HTML to JavaScript to the JS library creating the elements
to being able to customize the event handling can be hard to understand and get through.
When it "just works", it is good. When it doesn't, it can take a lot of time trying to 
figure out how to achieve what you want.

This indirectness and complexity can sometimes make it better to build things from scratch
and avoid these problems.

We can make SVG (scalar vector graphics) plots in R. We can post-process them to add JavaScript code to the specific
elements.
We can write the HTML document and embed the enhanced/JS-enabled SVG plots within the document,
controlling the appearance.
We can write JavaScript functions and include them in the HTML document (directly or indirectly via
a separate file.)

The SVG that we make in R is analogous to the SVG elements that plotly or leaflet create
at viewing time. We are making them earlier and more directly from within R.
There are pros and cons.


You have seen the AnimatedMap.html example and also the JavaScript code that

+ runs/pauses the animation
+ sets the colors of each state for the corresponding day
+ handles a click in the scatterplot to set the map to that day
+ reacts to changes in the slider to update the map to that day.


The one part that isn't in the AnimatedMap.html/ directory is how we created the 
two SVG plots. These are regular R plots created using an SVG graphics device,
just like a PDF or PNG graphics device creates PDF and PNG files, respectively.
The SVG also contains JavaScript code  that we add after R has created the plot.
We programmatically add this JavaScript code by reading the SVG file back into R.
It is an XML document so we can XPath to find the SVG nodes of interest and then
add attributes and child nodes to enhance the SVG elements when they will be rendered.


We can use the `svglite()` function in the svglite package as a graphics device
to create any plot in R as an SVG document.


## Annotating a Scatter plot

We'll  make a simple scatter plot of 1:10
```{r}
svglite('scatterplot.svg')
plot(seq(0, length = 11, by = 10), pch = 20, col = c("green", "orange"))
dev.off()
``
We can look at the contents of this text file in an editor. (It is in this git repository.)
We can also view it in a Web browser and then inspect the different elements
using the Developer Tools.
We'll parse this SVG/XML document in R:
```{r}
doc = xmlParse('scatterplot.svg')
```

We'll quickly explore its contents and structure:
```{r}
a = getNodeSet(doc, "//*")
length(a)
```
It has 51 nodes in total.
The node names are 
```{r}
table(sapply(a, xmlName))
```
```
  circle clipPath     defs        g     line  polygon     rect    style      svg     text 
      11        2        3        3       13        1        3        1        1       13 
```

An SVG display consists of 1) shapes, e.g., circles, squares, rectangles, polygons, and 2) text.

We have 3 rect nodes corresponding to rectangles.
We have 11 circles.  It turns out that these are 10 points in our plot.
The 13 text nodes correspond to the axes labels and the tick-mark labels.
The 13 lines include the tick marks on the axes.

The clipPath, defs, g, style and svg nodes provide structure to the document but are not themselves
directly visible.

The name g stands for groups and each g node contains collections of nodes/objects that are related 
to each other to form a part of the display.

Let's take a look at these
```
names(a) = sapply(a, xmlName)
g = a[names(a) == "g"]
```
We could also get these directly via XPath with
```{r}
getNodeSet(doc, "//x:g", "x")
```
This adds a wrinkle we didn't see when parsing HTML (or many other XML documents.)
SVG defines its own namespace for the nodes and we have to indicate that we are using that. 
We use a shorthand to indicate "x" is the name of the namespace and maps to the default namespace
used  in the SVG document, and then we qualify the node name "g" with this namespace alias, i.e., "//x:g".

The three g nodes are 
```
$g
<g clip-path="url(#cpMC4wMHw3MjAuMDB8MC4wMHw1NzYuMDA=)">
</g> 

$g
<g clip-path="url(#cpNTkuMDR8Njg5Ljc2fDU5LjA0fDUwMi41Ng==)">
  <circle cx="82.40" cy="486.13" r="1.80" style="stroke-width: 0.75; stroke: #00FF00; fill: #00FF00;"/>
  <circle cx="140.80" cy="445.07" r="1.80" style="stroke-width: 0.75; stroke: #FFA500; fill: #FFA500;"/>
  <circle cx="199.20" cy="404.00" r="1.80" style="stroke-width: 0.75; stroke: #00FF00; fill: #00FF00;"/>
  <circle cx="257.60" cy="362.93" r="1.80" style="stroke-width: 0.75; stroke: #FFA500; fill: #FFA500;"/>
  <circle cx="316.00" cy="321.87" r="1.80" style="stroke-width: 0.75; stroke: #00FF00; fill: #00FF00;"/>
  <circle cx="374.40" cy="280.80" r="1.80" style="stroke-width: 0.75; stroke: #FFA500; fill: #FFA500;"/>
  <circle cx="432.80" cy="239.73" r="1.80" style="stroke-width: 0.75; stroke: #00FF00; fill: #00FF00;"/>
  <circle cx="491.20" cy="198.67" r="1.80" style="stroke-width: 0.75; stroke: #FFA500; fill: #FFA500;"/>
  <circle cx="549.60" cy="157.60" r="1.80" style="stroke-width: 0.75; stroke: #00FF00; fill: #00FF00;"/>
  <circle cx="608.00" cy="116.53" r="1.80" style="stroke-width: 0.75; stroke: #FFA500; fill: #FFA500;"/>
  <circle cx="666.40" cy="75.47" r="1.80" style="stroke-width: 0.75; stroke: #00FF00; fill: #00FF00;"/>
</g> 

$g
<g clip-path="url(#cpMC4wMHw3MjAuMDB8MC4wMHw1NzYuMDA=)">
  <line x1="140.80" y1="502.56" x2="608.00" y2="502.56" style="stroke-width: 0.75;"/>
  <line x1="140.80" y1="502.56" x2="140.80" y2="509.76" style="stroke-width: 0.75;"/>
  <line x1="257.60" y1="502.56" x2="257.60" y2="509.76" style="stroke-width: 0.75;"/>
  <line x1="374.40" y1="502.56" x2="374.40" y2="509.76" style="stroke-width: 0.75;"/>
  <line x1="491.20" y1="502.56" x2="491.20" y2="509.76" style="stroke-width: 0.75;"/>
  <line x1="608.00" y1="502.56" x2="608.00" y2="509.76" style="stroke-width: 0.75;"/>
  <text x="140.80" y="528.48" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="6.67px" lengthAdjust="spacingAndGlyphs">2</text>
  <text x="257.60" y="528.48" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="6.67px" lengthAdjust="spacingAndGlyphs">4</text>
  <text x="374.40" y="528.48" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="6.67px" lengthAdjust="spacingAndGlyphs">6</text>
  <text x="491.20" y="528.48" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="6.67px" lengthAdjust="spacingAndGlyphs">8</text>
  <text x="608.00" y="528.48" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="13.35px" lengthAdjust="spacingAndGlyphs">10</text>
  <line x1="59.04" y1="486.13" x2="59.04" y2="75.47" style="stroke-width: 0.75;"/>
  <line x1="59.04" y1="486.13" x2="51.84" y2="486.13" style="stroke-width: 0.75;"/>
  <line x1="59.04" y1="404.00" x2="51.84" y2="404.00" style="stroke-width: 0.75;"/>
  <line x1="59.04" y1="321.87" x2="51.84" y2="321.87" style="stroke-width: 0.75;"/>
  <line x1="59.04" y1="239.73" x2="51.84" y2="239.73" style="stroke-width: 0.75;"/>
  <line x1="59.04" y1="157.60" x2="51.84" y2="157.60" style="stroke-width: 0.75;"/>
  <line x1="59.04" y1="75.47" x2="51.84" y2="75.47" style="stroke-width: 0.75;"/>
  <text transform="translate(41.76,486.13) rotate(-90)" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="6.67px" lengthAdjust="spacingAndGlyphs">0</text>
  <text transform="translate(41.76,404.00) rotate(-90)" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="13.35px" lengthAdjust="spacingAndGlyphs">20</text>
  <text transform="translate(41.76,321.87) rotate(-90)" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="13.35px" lengthAdjust="spacingAndGlyphs">40</text>
  <text transform="translate(41.76,239.73) rotate(-90)" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="13.35px" lengthAdjust="spacingAndGlyphs">60</text>
  <text transform="translate(41.76,157.60) rotate(-90)" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="13.35px" lengthAdjust="spacingAndGlyphs">80</text>
  <text transform="translate(41.76,75.47) rotate(-90)" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="20.02px" lengthAdjust="spacingAndGlyphs">100</text>
  <polygon points="59.04,502.56 689.76,502.56 689.76,59.04 59.04,59.04 " style="stroke-width: 0.75;"/>
  <text x="374.40" y="557.28" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="29.35px" lengthAdjust="spacingAndGlyphs">Index</text>
  <text transform="translate(12.96,280.80) rotate(-90)" text-anchor="middle" style="font-size: 12.00px; font-family: &quot;Arial&quot;;" textLength="146.76px" lengthAdjust="spacingAndGlyphs">seq(0, length = 11, by = 10)</text>
</g> 
```

We can ignore the first.

The second contains the 11 circle nodes. This is the actual contents of the data region of the R plot.

The third contains the line and text nodes. These are the tick marks and text and axes labels.


### Adding event handlers to each circle node.

For each circle node, we want to add

+ an id attribute to each circle which will be its index, 1, 2, 3, ..., 11
+ an onclick attribute that calls the Javascript function alert() with the index of this point.

We might do this in the following way.
We get the circle nodes via XPath
```{r}
circles = getNodeSet(doc, "//x:g//x:circle", "x")
```
Then for each of these, we add the 2 attributes.  
```{r}
invisible(mapply(function(cir, index) 
                     xmlAttrs(cir) = c(id = index, onclick = sprintf("alert('%d')", index)),
                 circles, seq(along = circles)))
```
We don't care about the result. xmlAttrs() has actually updated the actual node in circles and in
the SVG tree.

Printing the first circle, we see the id and onclick attributes:
```
circles[[1]]
```
```
<circle cx="82.40" cy="486.13" r="1.80" style="stroke-width: 0.75; stroke: #00FF00; fill: #00FF00;" 
    id="1" onclick="alert('1')"/> 
```

Let's save the entire document to a new file name and view it in the Web browser and click on some
of the points
```
saveXML(doc, "scatterplot2.svg")
```

Clicking on a point raises the alert dialog that shows the corresponding index.



## Annotating the Map


Consider the a map of the "lower" 48 states of the US.
```{r}
k = maps::map('state', fill = TRUE, col = "white")
```
This will draw a map on a graphics device.

If we use `svglite()`, we can see the resulting SVG document:
```{r}
library(svglite)
svglite('map.svg')
k = maps::map('state', fill = TRUE, col = "white")
dev.off()
```

We can parse it in R
```{r}
library(XML)
mdoc = xmlParse('map.svg')
```

Let's do some quick checks to see how complex this is:
```{r}
a = getNodeSet(mdoc, "//*")
length(a)
```
So there are 75 nodes in total.

```{r}
table(sapply(a, xmlName))
```
```
clipPath     defs        g  polygon     rect    style      svg 
       2        3        2       63        3        1        1 
```

In our map.svg file, we have 3 rectangles (rect) and and 63 polygons.
The other elements are (svg, g, style, defs and clipPath) organize the document and are not directly
visible.

The g elements are "groups" and combine related objects.


```{r}
sapply(g, function(x) length(xmlChildren(x)))
```
```
 g  g 
 1 63 
```
The first group is 
```
<g clip-path="url(#cpMC4wMHw3MjAuMDB8MC4wMHw1NzYuMDA=)"></g> 
```
This is quite comprehensible, but we don't have to worry about it.


The second has 63 child nodes. There also happens to be 63 rectangles and these are the child nodes:
```{r}
table(names(g[[2]]))
```
```
polygon 
     63 
```

If we were to inspect these in the Web browser, we'd see that they correspond to the states.
But why are there 63 and not 48?

The reason is that boundary of some states is not a simple polygon.
For example, Washington State has 4 islands and they need their own polygons.

So how do we know which polygon(s) correspond to a given state?
Fortunately, the return value from the `maps::map()` function
identifies the corresponding state.
Specifically, `k$names` is the character vector
```
 [1] "alabama"                         "arizona"                         "arkansas"                       
 [4] "california"                      "colorado"                        "connecticut"                    
 [7] "delaware"                        "district of columbia"            "florida"                        
[10] "georgia"                         "idaho"                           "illinois"                       
[13] "indiana"                         "iowa"                            "kansas"                         
[16] "kentucky"                        "louisiana"                       "maine"                          
[19] "maryland"                        "massachusetts:martha's vineyard" "massachusetts:main"             
[22] "massachusetts:nantucket"         "michigan:north"                  "michigan:south"                 
[25] "minnesota"                       "mississippi"                     "missouri"                       
[28] "montana"                         "nebraska"                        "nevada"                         
[31] "new hampshire"                   "new jersey"                      "new mexico"                     
[34] "new york:manhattan"              "new york:main"                   "new york:staten island"         
[37] "new york:long island"            "north carolina:knotts"           "north carolina:main"            
[40] "north carolina:spit"             "north dakota"                    "ohio"                           
[43] "oklahoma"                        "oregon"                          "pennsylvania"                   
[46] "rhode island"                    "south carolina"                  "south dakota"                   
[49] "tennessee"                       "texas"                           "utah"                           
[52] "vermont"                         "virginia:chesapeake"             "virginia:chincoteague"          
[55] "virginia:main"                   "washington:san juan island"      "washington:lopez island"        
[58] "washington:orcas island"         "washington:whidbey island"       "washington:main"                
[61] "west virginia"                   "wisconsin"                       "wyoming"                        
```
So now we can connect each polygon to a state.


We could use these names as the id for each polygon node.
We could also add an attribute named `state` to each polygon node.
`state` is not an SVG attribute, but one we are adding for our own purposes.  This is how XML is
eXtensible.

When our JavaScript code needs to change the color of a given state, it can 
find the polygons via the `state` attribute matching the given state name.


### Adding an event handler for each county.

We'll switch from a map of the 48 states to a map of CA and its counties.

We'll draw a map of Californian counties and make it possible 
for a viewer  to click on a state and show
a plot beside it, e.g., the time series of COVID cases just for that state.


We'll create the map with its polygons as before.
We'll add an onclick attribute and have JavaScript code that displays the plot.
The plot may be a PNG file, or another SVG plot, or a plotly or leaflet plot.
That's up to us.


For now, let's assume we have created a PNG file for each of the 58 counties.
(See [pngs.R](pngs.R) for the code that does this. )
We've used the names from the map polygons, removing the leading "California," prefix.
So we have alameda.png, alpine.png, ..., yuba.png.


We create the map of the CA counties with
```{r}
svgFilename = 'ca.svg'
svglite(svgFilename)
k = map('county', 'california', fill = TRUE, col = "white")
dev.off()
```

We get the county name for each polygon, removing the 'California,' prefix.
```{r}
counties = gsub("california,", "", k$names)
```

Now we get the polygon nodes.
```{r}
doc = xmlParse(svgFilename)
poly = getNodeSet(doc, "//x:g//x:polygon", "x")
```

Next, we update each node to add the onclick attribute:
```
invisible(mapply(function(node, county, png)
                           xmlattrs(node) = c(id = county,
                                             onclick = sprintf("top.showCountyTimeSeries('%s')", png)),
                  poly, counties, file.path("png", paste0(counties, ".png"))))
```
Recall that this is now in the nodes in the `doc` document.

I'll explain the `top.showCountyTimeSeries()` below.

We can save this document to a file
```
saveXML(doc, 'map2.svg')
```

We'll now create a new HTML document that displays the SVG and has
an additional place to show any of the PNG files.
See [view2.html](view2.html)


We write a reasonably simple Javascript function to implement `showCountryTimeSeries()`.
This is 
```
function showCountyTimeSeries(png)
{
    var img = document.getElementById('countyPNG');
    img.src = png;
}
```
It gets the element in the HTML with an id attribute with a value of countyPNG.
We created this and gave it the id so we could fetch it later.
It is an &lt;img&gt; node.

We then set the `src` attribute on this node and the Web browser will display the image.


### top.showCountyTimeSeries.

The HTML document refers to the SVG image. It is like a PNG file.
However, the SVG image is its own XML document.
Therefore, we have two documents - the HTML and the SVG documents.

Within the SVG document, we can use top to refer to the HTML document in which the SVG is
contained/housed.

There are other approaches to being able to find the HTML document.
Similarly, there are ways for the HTML document to access an embedded SVG document.


### Cross-origin Errors

Since we have 2 documents - an SVG inside an HTML document - 
the Web browser will block the SVG document from accessing contents in the
HTML document.
It thinks this is a cross-origin issue where 2 objects in an HTML
document cannot interact with each other unless they come from the same
Web site.

These two documents do come from the same location - namely our file system and in the same
directory. However, the Web browser doesn't allow that.

One way to avoid this problem is to deliver these files to the Web **browser** via a Web **server**.
There are several ways to do this.
We can put them on a host on the internet, or on our own machine to server them to ourselves.
On our own local machine, there may be a central Web server running, and
we can put the files in our area, e.g., ~/Sites/ on OSX.

Alternatively, we can run our own Web server in the current directory, e.g.,
```
python3 -m http.server
```
Now we can view the view2.html file by vising 
[http://localhost:8000/view2.html](http://localhost:8000/view2.html).


If dealing with this cross-origin issue is a problem,
we can, alternatively, place the SVG directly into the HTML, e.g., 
with in  a &lt;div&gt; element.

See [inlineSVG.html](inlineSVG.html). 
You can view this directly in your browser as a local file and can skip the Web server.

This puts almost exactly the same SVG as the [ca.svg](ca.svg) into the HTML under a &lt;div&gt;,
i.e., directly inlines the SVG and not within an &lt;object&gt; or &lt;embed&gt;.
The only difference is that the onclick code  calls setCountyTimeSeries() directly
without the top.setCountyTimeSeriesCallbacks.
Since the SVG is directly part of the HTML document, there is no cross-document problem.
We may have other problems if the SVG elements, for example, have id attributes that conflict with
HTML elements.
Since we are creating the SVG and the HTML, we can try to ensure there are no conflicts.



## Interactions between two SVG plots.

In your assignment, we wanted two plotly plots or a ploty and a leaflet plot to interact.
Specifically, when we click on a point in one, we want to update the other.
This can be involved.


Let's take our examples above and add something just to illustrate interaction between
2 embedded SVG documents within an HTML document.


Suppose in the county-level SVG plots, we added an onclick  for each point (corresponding to a date)
that attempted to change the CA state map to color each county the appropriate color for that date.

One approach to handle this is to have a Javascript function, say `colorCounties()`, in the HTML
document.
The onclick attribute for each point in the county-level time series would call this with the
specific date or index for the date, e.g., `top.colorCounties(10)` or as `colorCounties(10)` if the
county SVG document was inlined and not a sub-document.

This `colorCounties()` Javascript function would then find the state-level SVG document.
It would then use XPath to query the polygons by their id attribute which we set to be the
county name in the code above.

We'll assume we have the data exported from R as a JSON in the HTML document and so is a Javascript
variable that we can reference. Let's assume we can access a Javascript named list/associative array
of colors for each county for that date. The names on the elements are the county names.
We'll assume a Javascript function getCasesByDate() gets this list for us.

Then we can 

+ get the SVG document associated with the CA count plot.
+ loop over the county names
+ find the polygon for that county
+ set its fill color to the value in the list.

```
function colorCounties(date)
{
	let cases = getCasesByDate(date);
	let svg = document.getElementById('caCountyMap').getSVGDocument();
	for(let k in cases) {
	    let p = svg.getElementById(k);
		p.style.fill = cases[k];
	}
}
```


We need to serialize the JSON to create the colors for the number of cases
for each date/day for each count.
See [mkCountCasesByDate.R](mkCountCasesByDate.R)

Now we need to update the SVG count time series plots.
We need to add the onclick attribute to each of the 285 points.
Each of these needs to call
`top.colorCounties(index)`
where index is 0, 1, 2, ....

Of course, we are now using the same SVG county plots for multiple HTML documents.
So we need to ensure that the other HTML documents have a version of a `colorCounties()`
Javascript function and it can do nothing so no errors occur.





## Useful References


+ https://vecta.io/blog/best-way-to-embed-svg
+ http://dahlström.net/svg/html/from-svg-get-embedding-element.html
+ http://dahlström.net/svg/html/from-svg-to-parent-html-script.html
