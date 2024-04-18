mkDF =
function(rx, ll)
{
    m = gregexec(rx, ll)
    els = regmatches(ll, m)
    nels = sapply(els, length)
    if(length(unique(nels)) != 1)
        warning("Different number of matches for different lines")
    
    d = matrix(unlist(els), , nels[1], byrow = TRUE)[,-1]
    d = as.data.frame(d)

    ids = c("IP", "login", "timestamp", "action", "path", "httpVersion",
            "status", "numBytes", "referrer", "browserInfo")
    names(d) = ids[1:ncol(d)]

    invisible(cvtCols(d))
}


cvtCols =
function(d)
{
    if("timestamp" %in% names(d))
       d$timestamp = as.POSIXct(strptime( d$timestamp, "%d/%b/%Y:%H:%M:%S -0800"))

    if("numBytes" %in% names(d))
        d$numBytes = as.integer(d$numBytes)
    
    d
}

cvtNumBytes =
function(x)
{
    ans = rep(as.integer(NA),  length(x))    
    w = x != "-"

    ans[w] = as.integer(x[w])
    ans
}
