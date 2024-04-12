wea =
function(f)
{
    # read the data
    d = read.table(f, skip = 6)

    # Got this from searching for this file format and finding
    # the variable descriptions.
    names(ans) = c("month", "day", "time", "direct", "diffuse")

    # Get the metadata
    ll = readLines(f, 5)
    tmp = strsplit(ll, " ") 
    x = sapply(tmp, `[`, 2)
    names(x) = sapply(tmp, `[`, 1)

    # Put the metadata into the data.frame as additional columns.
    d$site = x["place"]

    # Turn latitude, longitude, elevation, time zone into numbers
    vars = names(x)[-1]
    vals = as.numeric(x[-1])
    d[vars] = lapply(vals, function(x) rep(x, nrow(d)))

    d
}
