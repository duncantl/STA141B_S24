dir.create("SVG2")

svg = list.files("SVG", full.names = TRUE)

annotate =
function(svg, doc = xmlParse(svg))
{
    circles = getNodeSet(doc, "//x:g//x:circle", "x")
    mapply(function(node, index)
             xmlAttrs(node) = c(onclick = sprintf("top.colorCounties(%d)", index)),
        circles, seq(along = circles) - 1L)

    saveXML(doc, file.path("SVG2", basename(svg)))
}

svg2 = sapply(svg, annotate)
