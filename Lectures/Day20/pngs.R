z = readRDS("ca.counties.covid.rds")

if(!(file.exists("PNG") && file.info("PNG")$isdir))
    dir.create("PNG")

# Simple counts rather than per capita.

mkPlot =
function(dates, cases, main)
{        
    plot(dates, cases, type = "l", xlab = "Date", ylab = "Number of Cases", main = main)
    points(dates, cases, pch = 20, col = "red")
}

ca.cases = tapply(z$cases, z$date, sum)
png("PNG/CA.png")
mkPlot(unique(z$date), ca.cases, "California")
dev.off()

countyNames = unique(z$name)
pngs = sapply(countyNames,
        function(cty) {
           png(f <- file.path("PNG", paste0(tolower(cty), ".png")))
           on.exit(dev.off())
           tmp = subset(z, name == cty)
           mkPlot(tmp$date, tmp$cases, main = cty)
           f
        })



#
dir.create("SVG")
svgs = sapply(countyNames,
        function(cty) {
           svglite::svglite(f <- file.path("SVG", paste0(tolower(cty), ".svg")))
           on.exit(dev.off())
           tmp = subset(z, name == cty)
           mkPlot(tmp$date, tmp$cases, main = cty)
           f
        })
