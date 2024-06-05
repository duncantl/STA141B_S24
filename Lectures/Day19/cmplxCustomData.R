# See https://stackoverflow.com/questions/72848035/plotly-r-open-url-on-click-with-facetting

library(ggplot2)
library(plotly)
library(htmlwidgets)

myData <- data.frame(
  x = c(1, 2, 3, 4, 6),
  y = c(3, 2, 1, 5, 4),
  type = c("a", "b", "c", "a", "b"),
  urls = c("https://www.google.com/", "http://stackoverflow.com/", "https://www.r-project.org/", "https://www.reddit.com/", "https://www.yahoo.com/")
 )



# Separate list for each observation in myData.
myData$custom = list(
    # using list() instead of c() preserves the names - jsonlite!
    list(label = "google", a = 10, b = 100),
    list(label = "SO", a = 50, b = 111),
    list(label = "R", a = 10, b = 121),
    list(label = "reddit", a = 10, b = 132),
    list(label = "yahoo", a = 10, b = 143)
  )

ggp <- ggplot(data = myData, aes(x = x, y = y, customdata = custom)) +
  geom_point() +
  facet_wrap(type ~ .)

ply <- ggplotly(ggp)

# Set the id value for this plot to something we control and know. We can use this in the JavaScript functions.
ply$elementId = "myPlot"

# The following JS function will get the JS object associated with the given point/observation
# and display it in the Developer Tools console and also as a dialog window.  Only need one, but showing both.
ply <- onRender(
  ply, "
  function(el) {
    el.on('plotly_click', function(d) {
      var d2 = d.points[0].customdata;
      console.log(d2);
      alert(d2.label + ' ' + d2.a + ' '  + d2.b + ' ' + el.id);
    });
  }
")

saveWidget(ply, "alert.html", selfcontained = FALSE, title = "alert() handler")
