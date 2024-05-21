u = "https://static01.nyt.com/newsgraphics/2015/04/21/county-mobility/0360769d17a8ef66ee331b8cf7d1a1f02c88c70b/Countycausalestimates25Apr2015smaller.csv"
ny = read.csv(u)
dim(ny)

i = which(ny$ctyname == "Nassau")
ny[i,]


u2 = "https://static01.nyt.com/newsgraphics/2015/04/21/county-mobility/0360769d17a8ef66ee331b8cf7d1a1f02c88c70b/PercentiletoDollarConversion25Apr2015.csv"
ny2 = read.csv(u2)
