if(FALSE) {
    z = getAllPostLinks(cookie, max = 150)
    class(z)
    dim(z)
    sapply(z, class)

    table(duplicated(z$url))
}



nextPage =
    #
    # Get the URL for the next page of search results.
    #
function(doc, baseURL)
{
    nxt = getNodeSet(doc, "//a[contains(., 'Next')]")
    if(length(nxt) == 0)
        return(NULL)

    getRelativeURL(xmlGetAttr(nxt[[1]], "href"), baseURL)    
}

getAllPostLinks =
    #
    # This goes the first page of the stats.stackexchange.com questions search results
    # and gets the link for each question along with some additional information and
    # then gets the next page of search results/questions.
    #
function(cookie, url = "https://stats.stackexchange.com/questions",
         max = NA,
         useragent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0")
{
    doc = htmlParse(getURLContent(url, cookie = cookie, useragent = useragent))
    ans = processSearchResultPage(doc, url)

    while( (is.na(max) ||  nrow(ans) < max) &&
             length(nxt <- nextPage(doc, url)) > 0 ) {

        doc = htmlParse(getURLContent(nxt, cookie = cookie, useragent = useragent))
        ans = rbind(ans, processSearchResultPage(doc, url))
    }

    cleanResults(ans)
}


processSearchResultPage =
    #
    # Get the list of search result nodes and process each of them to get a data.frame with 1 row for each.
    # Then combine these into a single data.frame.
    #
function(doc, baseURL)
{
    nodes = getNodeSet(doc, "//div[@data-post-id]")
    els = lapply(nodes, processNode, baseURL)
    do.call(rbind, els)
}    

processNode =
function(node, baseURL)
{
    # when this was last updated
    # Leave as string for now.
    # We will convert to POSIXct when have the full data.frame of all pages of all posts.
    when = getNodeSet(node, ".//time/span")
    if(length(when))
        when = xmlGetAttr(when[[1]], "title")

    # User information
    user = getNodeSet(node, ".//div[@class = 's-user-card--info']")[[1]]
    user2 = user[["div"]][["a"]]


    # Get the votes, answers, views. Same structure for each and can get the value and the name programmatically.
    els = getNodeSet(node, ".//div[contains(@class, 's-post-summary--stats-item')]")
    tmp = structure(lapply(els, function(x) xmlValue(x[["span"]])),
                             names = sapply(els, function(x) xpathSApply(x, "./span[@class = 's-post-summary--stats-item-unit']", xmlValue)))

    # Make certain we have answers, votes, views and not vote, answer or view singular. Otherwise, the column names won't match.
    names(tmp) = paste0(gsub("s$", "", names(tmp)), "s")
    
    responseInfo = structure(rep(NA, 3), names = c("answers", "votes", "views"))
    responseInfo[ names(tmp) ] = tmp
    
    # 1 row
    ans = cbind(data.frame(title = xpathSApply(node, ".//h3/a", xmlValue, trim = TRUE),
                     url = getRelativeURL(getNodeSet(node, ".//h3/a/@href")[[1]], baseURL),
                     qid = xmlGetAttr(node, "data-post-id"),
                     type = xmlGetAttr(node, "data-post-type-id"),
                     when = orNA(when),
                     who  = if(length(user2)) xmlValue(user2) else NA,
                     whoURL = if(length(user2)) getRelativeURL(xmlGetAttr(user2, "href"),  baseURL) else NA
                     ),
                responseInfo
                )

    # Add the tags as a list of length 1 but which has a character vector.
    # Alternatively, could combine the tags into a single string separated by, e.g., ';'.
    ans$tags = list( xpathSApply(node, ".//a[contains(@class, 's-tag post-tag')]", xmlValue) )

    ans
}    
        
orNA =
    # Utility function that returns NA if x is NULL or empty vector/list or x itself it is a value
function(x)
  if(length(x) > 0) x else NA

cleanResults =
    #
    # Called after we get the single data.frame of all posts for all pages we processed
    # Convert the relevant columns from strings to POSIXct, integers.
    #
function(df)
{
    df$qid = as.integer(df$qid)
    df$when = as.POSIXct( strptime(df$when, "%Y-%m-%d %H:%M:%S") )
    df
}






