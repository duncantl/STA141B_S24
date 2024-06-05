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

ggp <- ggplot(data = myData, aes(x = x, y = y, customdata = urls)) +
  geom_point() +
  facet_wrap(type ~ .)

ply <- ggplotly(ggp)

ply <- onRender(
  ply, "
  function(el) {
    el.on('plotly_click', function(d) {
      var url = d.points[0].customdata;
      console.log(url);
      window.open(url);
    });
  }
")

saveWidget(ply, "alert.html", selfcontained = FALSE, title = "URL in separate window")
