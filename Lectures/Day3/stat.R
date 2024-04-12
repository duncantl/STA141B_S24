readTable =
    #
    # lines should be - for now - a integer vector with 2 elements
    # giving the start line and end line.
    #
function(file, lines)
{
    ll = readLines(file)
    i = seq(lines[1], lines[2])
    tmp = ll[i]
    d = read.table( textConnection(tmp) , sep = "\t", header = TRUE)
    transformTable( d[, - c(1, ncol(d)) ] )
}

transformTable =
function(d)    
{
    tmp = t(d)
    ids = tmp[1,]
    ans = as.data.frame(tmp[-1,])
    names(ans) = trimws(ids)

    w = names(ans) == "Day:Hour"
    browser()
    tmp2 = as.POSIXct(strptime(paste("2023", rownames(ans), ans[[2]]), "%Y %b %d:%H"))
    
}


findTableLines =
function(file)    
{
    ll = readLines(file)
    s = grep("Monthly Statistics for Dry Bulb temperatures", ll)
    e = grep("Maximum Dry Bulb temperature of", ll)
    c(s + 1L, e - 1L)
}


