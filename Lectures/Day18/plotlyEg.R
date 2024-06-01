p = plot_ly(cars, x = ~speed, y = ~dist)
p2 = add_markers(p)
htmlwidgets::saveWidget(p2, "simplePlotly.html", selfcontained = FALSE, title = "My Plot")
