ll = readLines("../../Data/offline")
ll2 = ll[!grepl("^#", ll)]

z = strsplit(ll2[1], "[;,=]")[[1]]

# get all the values for the detected devices, ignoring the first 10 elements from the fixed data.

z[-(1:10)]

# Arrange this into a 4 column matrix, by row.

v = matrix(z[-(1:10)], , 4, byrow = TRUE)

# We'll convert the relevant columns to numbers later when we process all rows.


# Get the fixed data values
z[c(2, 4, 6, 7, 8, 10)]

# Can arrange these as a matrix and then replicate them
fixed = matrix(z[c(2, 4, 6, 7, 8, 10)], 1)
fixed[ rep(1, nrow(v)), ]

v2 = cbind(fixed[ rep(1, nrow(v)), ], v)


##########################################
# Now do the whole thing for all the lines


tmp = strsplit(ll2, "[;,=]")
vals = lapply(tmp, function(x) x[-(1:10)])
v = matrix(unlist(vals), , 4, byrow = TRUE)

# How many devices were detected on each line
# Get all the elements we separated. 4 for each detected device and 10 for the fixed part.
# So ...
numDetected = (sapply(tmp, length) - 10)/4

# Make the fixed part for each line

fixed0 = mapply(function(lineEls, numRows) {
          matrix(lineEls[c(2, 4, 6, 7, 8, 10)], 1)[ rep(1, numRows), ]
       }, tmp, numDetected, SIMPLIFY = FALSE)

# Now stack these on top of each other.
fixed = do.call(rbind, fixed0)

# Should have the same number of rows as v
stopifnot(nrow(fixed) == nrow(v))

data = cbind(fixed, v)

# Now check the results
