# get the number of cases
casesByDate = tapply(z, z$date, function(x) structure(x$cases, names = tolower(x$name)))

# normalize
casesByDate = lapply(casesByDate, function(x) x/max(z$cases))

N = 10
# q = quantile(unlist(casesByDate), seq(0, 1, length = N))
v = sort(unique(unlist(casesByDate)))
i = (1:length(v))[ seq(1, length = N, by = length(v)/N) ]
q = unique(c(min(v), v[i], max(v)))

cols = colorRampPalette(c("white", "red"))(N)

# map to colors
casesByDate = lapply(casesByDate, function(x) structure(cols[cut(x, q)], names = names(x)))

# remove the dates as names so we can index in Javascript as 0, 1, 2, ....
j = RJSONIO::toJSON(unname(casesByDate))
cat("var countyCasesByDate =",
    j,
    ";", sep = "\n", file = "countyCasesByDate.js")
