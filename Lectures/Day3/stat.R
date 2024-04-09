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
  d
}


findTableLines =
function(file)    
{
    ll = readLines(file)
    s = grep("Monthly Statistics for Dry Bulb temperatures", ll)
    e = grep("Maximum Dry Bulb temperature of", ll)
    c(s + 1L, e - 1L)
}


