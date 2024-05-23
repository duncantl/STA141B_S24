library(RSelenium)
library(XML)


# Get the HTML page that Javascript will fill in on the user's browser
u = "https://www.nytimes.com/interactive/2015/05/03/upshot/the-best-and-worst-places-to-grow-up-how-your-area-compares.html"
txt1 = readLines(u)
grep("<svg", txt1, fixed = TRUE)
# So 2 <svg nodes.
# grep("<svg", txt1, fixed = TRUE, value = TRUE)

doc = htmlParse(txt1)
length(getNodeSet(doc, "//svg"))

svg = getNodeSet(doc, "//svg")
sapply(svg, function(x) length(getNodeSet(x, ".//*")))
# 4, 3 


# Now get the HTML page that was filled in and see the full content.
# We are looking for an SVG - scalable vector graphics - map
# We'd like to get the tooltips with the text the user can see.
# Otherwise, we have to work out how these tips are generated from the raw data which are CSV files
# containing regression coefficients for a model we don't necessarily understand.

dr = remoteDriver$new()
dr$open()
dr$navigate(u)

# Wait until the content is generated.

txt = dr$getPageSource()[[1]]
grep("<svg", txt, fixed = TRUE)
doc2 = htmlParse(txt)
length(getNodeSet(doc2, "//svg"))
# 4 SVG nodes

svg2 = getNodeSet(doc2, "//svg")
sapply(svg2, function(x) length(getNodeSet(x, ".//*")))

# 1 4 3, 6291



# Can we find each county?
# Can we get the tooltips?

map = svg2[[4]]
z = getNodeSet(map, ".//text()[contains(., 'Suffolk')]")


z = getNodeSet(map, ".//@*[contains(., 'Suffolk')]")


