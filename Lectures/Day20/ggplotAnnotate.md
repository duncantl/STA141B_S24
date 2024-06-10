# ggplot Scatter Plot

Consider a plot
```
library(ggplot2)
p = ggplot(mpg, aes(x = displ, y = hwy)) + geom_point(size = 3)
```

We'll create it as an SVG file using `svglite()`
```
svglite::svglite("ggplot.svg")
print(p)
dev.off()
```

Now we read it back into R as a parsed XML document.
```
library(XML)
doc = xmlParse("ggplot.svg")
```

```
ci = getNodeSet(doc, "//x:circle", "x")
```

We have 234 circles which is the same as the number of rows in the data.frame `mpg`.

We can annotate these SVG nodes and save the updated document back to an .svg file and use it in
an HTML document or directly in a Web browser.


# Plot with a Legend

Consider the example from https://rkabacoff.github.io/datavis/Interactive.html#plotly
```
library(ggplot2)

p <- ggplot(mpg, aes(x = displ, 
                     y = hwy, 
                     color = class)) +
  geom_point(size=3) +
  labs(x = "Engine displacement",
       y = "Highway Mileage",
       color = "Car Class") +
  theme_bw()
```

We'll create it as an SVG file using `svglite()`
```
svglite::svglite("ggplotLegend.svg")
print(p)
dev.off()
```

Now we read it back into R as a parsed XML document.
```
library(XML)
doc = xmlParse("ggplotLegend.svg")
```

We want to find all the circles in the plotting region.
Looking for all circles will also find the ones in the legend.
We want the second g node.
```
ci = getNodeSet(doc, "(//x:g)[2]//x:circle", "x")
```
This gives 234 nodes and nrow(mpg) is also 234.
So we have all the points.



# facet_wrap()

From the examples on the facet_wrap() help page:

```
p <- ggplot(mpg, aes(displ, hwy)) + geom_point()

# Use vars() to supply faceting variables:
p <- p + facet_wrap(vars(class))
```

Again, we create it as an SVG file:
```
svglite::svglite("ggplotFacet.svg")
print(p)
dev.off()
```

Now we read it back into R as a parsed XML document.
```
library(XML)
doc = xmlParse("ggplotFacet.svg")
```

There are 234 circles
```
length(getNodeSet(doc, "//x:circle", "x"))
```
They are in 7 different sub-plots or plotting regions.

There are 37 &lt;g&gt; nodes.

We can find all the g nodes that contain circle nodes
```
gc  = getNodeSet(doc, "//x:g[./x:circle]", "x")
```
There are 7 of these.


The number of circles in each panel is 
```
sapply(gc, function(x) sum(names(x) == "circle"))
```
```
[1]  5 11 62 47 33 41 35
```

Looking at the number in each class with `table(mpg$class)`
```
   2seater    compact    midsize    minivan     pickup subcompact        suv 
         5         47         41         11         33         35         62 
```

So the g nodes are organized by column first and then within column, i.e.,
2seater, minivan, suv, compact, pickup, midsize, subcompact.
ggplot orders them row-wise alphabetically.


We'll add a tooltip to each
```
rg = split(mpg, mpg$class)
names(gc) = c("2seater", "minivan", "suv", "compact", "pickup", "midsize", "subcompact")
mapply(function(g, d) {
          tip = paste(d$model, d$year, d$cyl, d$trans, sep = ", ")
		  ci = g[names(g) == "circle"]
		  mapply(function(node, tip)
		         newxmlnode("title", tip, parent = node),
				 ci, tip)
       }, gc, rg[names(gc)])

savexml(doc, "ggplotfacettt.svg")
```

Now view this in the Web browser and mouse-over some of the points.


## ggplot - multiple plots together.

With ggplot, we can combine multiple sub-plots to create a single ggplot.
We can create an SVG file for the overall plot.
We can then try to find the different sub-plots and their elements in the SVG file.

However, rather than have a single ggplot with n sub-plots,
we can have n separate ggplot objects and n separate SVG files
and arrange them in the HTML page.
We can then annotate each of the n SVG documents separately.

But we'll look at a single plot with 4 sub-plots.
From https://ggplot2-book.org/arranging-plots
```{r}
p1 <- ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy))

p2 <- ggplot(mpg) + 
  geom_bar(aes(x = as.character(year), fill = drv), position = "dodge") + 
  labs(x = "year")

p3 <- ggplot(mpg) + 
  geom_density(aes(x = hwy, fill = drv), colour = NA) + 
  facet_grid(rows = vars(drv))

p4 <- ggplot(mpg) + 
  stat_summary(aes(x = drv, y = hwy, fill = drv), geom = "col", fun.data = mean_se) +
  stat_summary(aes(x = drv, y = hwy), geom = "errorbar", fun.data = mean_se, width = 0.5)
```

Again, we create the SVG file:
```{r}
library(patchwork)
svglite::svglite('ggplotArrange.svg')
p1 + p2 + p3 + p4
dev.off()
```


And again, we parse the document:
```
doc = xmlParse('ggplotArrange.svg')
```

We can find the circles in the scatter plot,
as these are the only circles in the entire overall plot.

The three density plots correspond to the three polygon nodes in the entire plot.

The barchart of count-by-year has 6 bars.
We can find the g node that has 7 rectangles, including the rectangle for the plotting region
itself:
```
getNodeSet(doc, "//x:g[count(.//x:rect) = 7]")
```
The rect nodes are ordered from left to right.

This either requires knowledge of the specifics of the different subplots 
or can become less reliable.

We could study more ggplot examples to learn the structure of the corresponding 
SVG documents created by svglite.

