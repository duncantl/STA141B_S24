library(maps)
library(XML)

svgFilename = 'ca.svg'
svglite(svgFilename)
k = map('county', 'california', fill = TRUE, col = "white")
dev.off()

counties = gsub("california,", "", k$names)

doc = xmlParse(svgFilename)
poly = getNodeSet(doc, "//x:g//x:polygon", "x")

invisible(mapply(function(node, county, png)
                           xmlattrs(node) = c(id = county,
                                             onclick = sprintf("top.showCountyTimeSeries('%s')", png)),
                  poly, counties, file.path("png", paste0(counties, ".png"))))

saveXML(doc, svgFilename)
