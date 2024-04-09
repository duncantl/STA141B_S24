readWeather = 
function(f)
{
    # Read the records/row with 5 values, skipping the metadata
    d = read.table(f, skip = 6, sep = " ")
    names(d) = c("month", "dayOfMonth", "hour", "direct", "diffuse")

    # read the meta data as name value pairs.
    # data.frame with 5 rows.
    m = read.table(f, nrow = 5)

    # Repeat each meta-value so we have a vector for each with the same number of elements
    # as rows in d
    tmp = lapply(m$V2, function(x) rep(x, nrow(d)))

    # insert these new columns into using the names from column in m
    d [ m$V1 ] = tmp

    # convert the numeric meta values to actual numbers from character/string values.
    #
    i = c( 7, 8, 9, 10)
    d[, i] = lapply(d[, i], as.numeric)


    d
}

