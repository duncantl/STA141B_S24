u = "https://stats.stackexchange.com/"
tt = getURLContent(u)

# Failed

cookie = "prov=23df98c1-fecb-4fc0-b995-b2bce084bb59; __cf_bm=lp_ugiNSgOJmXLaouBAgaQRBEFmNRhfQGa7SPzbjUDQ-1716250806-1.0.1.1-PaVfuJuzCPzXO_uD85Lf10NOlVZ2kCNgafZ49Qbu8FKAeuKhpELB4Yi2u5gXnFJHOBAww1qkTTYnwJK0buGBGA; __cflb=0H28v9NS2R23PyzVciRb1s59j5MuszAvZWduPyMkoqv; OptanonConsent=isGpcEnabled=0&datestamp=Mon+May+20+2024+17%3A22%3A44+GMT-0700+(Pacific+Daylight+Time)&version=202312.1.0&browserGpcFlag=0&isIABGlobal=false&hosts=&consentId=a9d3a950-7d10-4e13-bfab-e9d044c01daa&interactionCount=1&landingPath=NotLandingPage&groups=C0001%3A1%2CC0002%3A0%2CC0003%3A0%2CC0004%3A0&geolocation=%3B&AwaitingReconsent=false; OptanonAlertBoxClosed=2024-05-21T00:20:10.897Z"

tt = getURLContent(u, cookie = cookie)

# Failed

tt = getURLContent(u, cookie = cookie,
                   useragent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0",
                   verbose = TRUE)

# verbose just to see the request and response details
# No error. Did we get the correct document?

# Look for text in first question...
grepl("Increasing sample size", tt)


# See if there is any information about the content
attributes(tt)

# Parse the HTML document
doc = htmlParse(tt)


# Now find each question
# Can use the Web browser and Inspect to find the structure
# Or explore the tree in R.


# So looking for <div> nodes but not all div nodes.
# We want the ones identified by
# the following conditions on some of the attributes
# class = "s-post-summary    js-post-summary"
# id starts with "question-summary-"
# has a data-post-id attribute
# has data-post-type-id = 1
# Maybe any of these conditions or all or some combination.


n1 = getNodeSet(doc, "//div[@class = 's-post-summary    js-post-summary']")
n2 = getNodeSet(doc, "//div[starts-with(@id, 'question-summary')]")
n3 = getNodeSet(doc, "//div[@data-post-id]")
n4 = getNodeSet(doc, "//div[@data-post-type-id = 1]")

identical(n1, n2)
# All identical.
# 14 nodes

# Let's get the title  for each


ti = getNodeSet(doc, "//div[@data-post-id]//div[@class = 's-post-summary--content']/h3/a")

# want the text
ti = sapply(n3, xmlValue)


# Can get the nodes and do the lapply in one go
ti = xpathSApply(doc, "//div[@data-post-id]//div[@class = 's-post-summary--content']/h3/a", xmlValue)


# Let's get the link to the question's page. In the <a> that we got

lnk = getNodeSet(doc, "//div[@data-post-id]//div[@class = 's-post-summary--content']/h3/a/@href")


# This is a relative link, relative to the URL from which we got the current/original document - https://stats.stackexchange.com

lnk2 = getRelativeURL(unlist(lnk), u)


# Now
lnk2


# We can get more information from the initial page for each question.
# We can also get much of the same information from the question page itself.
# Often we get both and combine for each record - question in this case.
# 



####
# Use Inspect on the text of the question.

#

# Comments under the question are in
#  <div> with class that contains  js-post-comments-component
#  <ul> with class "comments-list js-comments-list"
# Each comment is in a <li>.
#    class="comment js-comment"

#
# Can get all comments with

agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0"
tt2 = readLines(lnk2[1])
tt2 = getURLContent(lnk2[1], cookie = cookie, useragent = agent)
doc2 = htmlParse(tt2)


coms = getNodeSet(doc2, "//li[@class = 'comment js-comment']")
length(coms)

# What went wrong?


coms = getNodeSet(doc2, "//li[@class = 'comment js-comment ']")
length(coms)



# What about the "Show 4 more comments"

mc = getNodeSet(doc2, "//a[contains(., 'more comments')]")

# There are 2 of these
# There is no explicit link in the href.


# Clicking on the 2nd and watching the Network panel in the Developer Tools, we see this triggers
# another HTTP request.
#  https://stats.stackexchange.com/posts/647621/comments?_=1716300605782

# Clicking on the first generates a request
#  https://stats.stackexchange.com/posts/647422/comments?_=1716301192440

# The 647422 is the same as in the URL for the question.
# Is it the question post id ?  Yes.  See @data-questionid.
#

# What about the 647621 for the comments for the answer.

# First, let's find the answer
# Inspect again
#
ans = getNodeSet(doc2, "//div[@class = 'answer js-answer']")

# only 1, but could be more in other posts.

id = xmlGetAttr(ans[[1]], "data-answerid")

# So we can get all the comments for a given post with
uc = sprintf("https://stats.stackexchange.com/posts/%s/comments", id)
ll = readLines(uc)




#
# Next page of results from front page

# See Browse more Questions
# Let's find that and the parent node in the doc for the front page

nxt = getNodeSet(doc, "//text()[. = 'Browse more Questions']/..")

# The link is relative - to u
getRelativeURL( xmlGetAttr(nxt[[1]], "href"), u)

# If we click on this in the browser it brings us to
#  https://stats.stackexchange.com/questions

# This is like the front page.  It shows 15 questions.
# But also has links to go to the next page, page 2, page 3, .... up to 14328
# And we can change the number of questions per page - 15, 30, 50.
#
# We want to get the information for the questions on this page
# Then go to the next page
# Get the information for those questions and then the next page .....

# Next page

uq = "https://stats.stackexchange.com/questions"
tt = readLines(uq)
docq = htmlParse(tt)
getNodeSet(docq, "//a[. = 'Next']")

# No results
nxt = getNodeSet(docq, "//a[contains(., 'Next')]")

# So need ' Next'

getRelativeURL(xmlGetAttr(nxt[[1]], "href"), uq)





#######################


######
# Front page question <div>




<div id="question-summary-647549" class="s-post-summary    js-post-summary" data-post-id="647549" data-post-type-id="1">
    <div class="s-post-summary--stats js-post-summary-stats">
        <div class="s-post-summary--stats-item s-post-summary--stats-item__emphasized" title="Score of 0">
            <span class="s-post-summary--stats-item-number">0</span>
            <span class="s-post-summary--stats-item-unit">votes</span>
        </div>
        <div class="s-post-summary--stats-item has-answers has-accepted-answer" title="one of the answers was accepted as the correct answer">
<svg aria-hidden="true" class="svg-icon iconCheckmarkSm" width="14" height="14" viewBox="0 0 14 14"><path d="M13 3.41 11.59 2 5 8.59 2.41 6 1 7.41l4 4 8-8Z"></path></svg>            <span class="s-post-summary--stats-item-number">1</span>
            <span class="s-post-summary--stats-item-unit">answer</span>
        </div>
        <div class="s-post-summary--stats-item " title="28 views">
            <span class="s-post-summary--stats-item-number">28</span>
            <span class="s-post-summary--stats-item-unit">views</span>
        </div>
    </div>
    <div class="s-post-summary--content">
        <h3 class="s-post-summary--content-title">
            <a href="/questions/647549/one-sided-likelihood-ratio-test-for-a-logistic-regression-model" class="s-link">One sided likelihood ratio test for a logistic regression model?</a>
        </h3>
        <div class="s-post-summary--meta">
            <div class="s-post-summary--meta-tags d-inline-block tags js-tags t-hypothesis-testing t-logistic t-generalized-linear-model t-likelihood-ratio t-profile-likelihood">

<ul class="ml0 list-ls-none js-post-tag-list-wrapper d-inline"><li class="d-inline mr4 js-post-tag-list-item"><a href="/questions/tagged/hypothesis-testing" class="post-tag flex--item mt0 js-tagname-hypothesis-testing" title="" aria-label="show questions tagged 'hypothesis-testing'" rel="tag" aria-labelledby="tag-hypothesis-testing-tooltip-container" data-tag-menu-origin="Unknown">hypothesis-testing</a></li><li class="d-inline mr4 js-post-tag-list-item"><a href="/questions/tagged/logistic" class="post-tag flex--item mt0 js-tagname-logistic" title="show questions tagged 'logistic'" aria-label="show questions tagged 'logistic'" rel="tag" aria-labelledby="tag-logistic-tooltip-container" data-tag-menu-origin="Unknown">logistic</a></li><li class="d-inline mr4 js-post-tag-list-item"><a href="/questions/tagged/generalized-linear-model" class="post-tag flex--item mt0 js-tagname-generalized-linear-model" title="show questions tagged 'generalized-linear-model'" aria-label="show questions tagged 'generalized-linear-model'" rel="tag" aria-labelledby="tag-generalized-linear-model-tooltip-container" data-tag-menu-origin="Unknown">generalized-linear-model</a></li><li class="d-inline mr4 js-post-tag-list-item"><a href="/questions/tagged/likelihood-ratio" class="post-tag flex--item mt0 js-tagname-likelihood-ratio" title="show questions tagged 'likelihood-ratio'" aria-label="show questions tagged 'likelihood-ratio'" rel="tag" aria-labelledby="tag-likelihood-ratio-tooltip-container" data-tag-menu-origin="Unknown">likelihood-ratio</a></li><li class="d-inline mr4 js-post-tag-list-item"><a href="/questions/tagged/profile-likelihood" class="post-tag flex--item mt0 js-tagname-profile-likelihood" title="show questions tagged 'profile-likelihood'" aria-label="show questions tagged 'profile-likelihood'" rel="tag" aria-labelledby="tag-profile-likelihood-tooltip-container" data-tag-menu-origin="Unknown">profile-likelihood</a></li></ul>
            </div>
<div class="s-user-card s-user-card__minimal" aria-live="polite">
                <a href="/users/129321/gordon-smyth" class="s-avatar s-avatar__16 s-user-card--avatar js-user-hover-target" data-user-id="129321">        <div class="gravatar-wrapper-16">
            <img src="https://www.gravatar.com/avatar/e33579a403a3cdf70ec458d2681ab0df?s=32&amp;d=identicon&amp;r=PG&amp;f=y&amp;so-version=2" alt="Gordon Smyth's user avatar" width="16" ,="" height="16" class="s-avatar--image">
        </div>
</a>
    <div class="s-user-card--info">
            <div class="s-user-card--link d-flex gs4">
                <a href="/users/129321/gordon-smyth" class="flex--item">Gordon Smyth</a>
            </div>
                <ul class="s-user-card--awards">
            <li class="s-user-card--rep"><span class="todo-no-class-here" title="reputation score 13,032" dir="ltr">13k</span></li>

        </ul>
    </div>
        <time class="s-user-card--time">
                <a href="/questions/647549/one-sided-likelihood-ratio-test-for-a-logistic-regression-model?lastactivity" class="s-link s-link__muted">modified <span title="2024-05-21 00:27:25Z" class="relativetime">14 mins ago</span></a>
            </time>
</div>
        </div>
    </div>
</div>




###
    # Question in Post

<div class="question js-question" data-questionid="647422" data-position-on-page="0" data-score="1" id="question">
    <style>
    </style>
<div class="js-zone-container zone-container-main">
    <div id="dfp-tlb" class="everyonelovesstackoverflow everyoneloves__top-leaderboard everyoneloves__leaderboard" style="min-height: auto; height: auto; display: none;" data-dfp-zone="true"><iframe id="google_ads_iframe_/248424177/stats.stackexchange.com/lb/question-pages_1" srcdoc="<body></body>" style="position: absolute; width: 0px; height: 0px; left: 0px; right: 0px; z-index: -1; border: 0px;" width="0" height="0"></iframe></div>
		<div class="js-report-ad-button-container " style="width: 728px"></div>
</div>


    <div class="post-layout ">
        <div class="votecell post-layout--left">
            


<div class="js-voting-container d-flex jc-center fd-column ai-center gs4 fc-black-300" data-post-id="647422" data-referrer="None">
        <button class="js-vote-up-btn flex--item s-btn s-btn__muted s-btn__outlined bar-pill bc-black-225 f:bc-theme-secondary-400 f:bg-theme-secondary-400 f:fc-black-050 h:bg-theme-primary-200" data-controller="s-tooltip" data-s-tooltip-placement="right" aria-pressed="false" aria-label="Up vote" data-selected-classes="fc-theme-primary-100 bc-theme-primary-500 bg-theme-primary-500" data-unselected-classes="bc-black-225 f:bc-theme-secondary-400 f:bg-theme-secondary-400 f:fc-black-050 h:bg-theme-primary-200" aria-describedby="--stacks-s-tooltip-x33f17c7">
            <svg aria-hidden="true" class="svg-icon iconArrowUp" width="18" height="18" viewBox="0 0 18 18"><path d="M1 12h16L9 4l-8 8Z"></path></svg>
        </button><div id="--stacks-s-tooltip-x33f17c7" class="s-popover s-popover__tooltip" role="tooltip">This question shows research effort; it is useful and clear<div class="s-popover--arrow"></div></div>
        <input type="hidden" id="voteUpHash" value="68:3:31e,16:b53e9b881748469d,10:1716252848,16:c1d99f2c4aad8597,6:647422,cac0f563fb7fd7de84d50a6ef502efc0cefb7c6bacb71f2e98261c39896c1dd9">
        <div class="js-vote-count flex--item d-flex fd-column ai-center fc-theme-body-font fw-bold fs-subheading py4" itemprop="upvoteCount" data-value="1">
            1
        </div>
        <button class="js-vote-down-btn js-vote-down-question flex--item mb8 s-btn s-btn__muted s-btn__outlined bar-pill bc-black-225 f:bc-theme-secondary-400 f:bg-theme-secondary-400 f:fc-black-050 h:bg-theme-primary-200" title="This question does not show any research effort; it is unclear or not useful" aria-pressed="false" aria-label="Down vote" data-selected-classes="fc-theme-primary-100 bc-theme-primary-500 bg-theme-primary-500" data-unselected-classes="bc-black-225 f:bc-theme-secondary-400 f:bg-theme-secondary-400 f:fc-black-050 h:bg-theme-primary-200">
            <svg aria-hidden="true" class="svg-icon iconArrowDown" width="18" height="18" viewBox="0 0 18 18"><path d="M1 6h16l-8 8-8-8Z"></path></svg>
        </button>
        <input type="hidden" id="voteDownHash" value="68:3:31e,16:2e056ba4981bdcff,10:1716252848,16:c5b0db12298a73c9,6:647422,4423266f2756439694762e1f11de95e7666aa14b7d872c16c48473fd9c775f9b">


        
<button class="js-saves-btn s-btn s-btn__unset c-pointer py4" type="button" id="saves-btn-647422" data-controller="s-tooltip" data-s-tooltip-placement="right" data-s-popover-placement="" aria-pressed="false" data-post-id="647422" data-post-type-id="1" data-user-privilege-for-post-click="0" aria-controls="" data-s-popover-auto-show="false" aria-describedby="--stacks-s-tooltip-7dnt8x4f">
    <svg aria-hidden="true" class="fc-theme-primary-400 js-saves-btn-selected d-none svg-icon iconBookmark" width="18" height="18" viewBox="0 0 18 18"><path d="M3 17V3c0-1.1.9-2 2-2h8a2 2 0 0 1 2 2v14l-6-4-6 4Z"></path></svg>
    <svg aria-hidden="true" class="js-saves-btn-unselected svg-icon iconBookmarkAlt" width="18" height="18" viewBox="0 0 18 18"><path d="m9 10.6 4 2.66V3H5v10.26l4-2.66ZM3 17V3c0-1.1.9-2 2-2h8a2 2 0 0 1 2 2v14l-6-4-6 4Z"></path></svg>
</button><div id="--stacks-s-tooltip-7dnt8x4f" class="s-popover s-popover__tooltip" role="tooltip">Save this question.<div class="s-popover--arrow"></div></div>








    
    <a class="js-post-issue flex--item s-btn s-btn__unset c-pointer py6 mx-auto" href="/posts/647422/timeline" data-shortcut="T" data-ks-title="timeline" data-controller="s-tooltip" data-s-tooltip-placement="right" aria-label="Timeline" aria-describedby="--stacks-s-tooltip-cd6cqk8v"><svg aria-hidden="true" class="mln2 mr0 svg-icon iconHistory" width="19" height="18" viewBox="0 0 19 18"><path d="M3 9a8 8 0 1 1 3.73 6.77L8.2 14.3A6 6 0 1 0 5 9l3.01-.01-4 4-4-4h3L3 9Zm7-4h1.01L11 9.36l3.22 2.1-.6.93L10 10V5Z"></path></svg></a><div id="--stacks-s-tooltip-cd6cqk8v" class="s-popover s-popover__tooltip" role="tooltip">Show activity on this post.<div class="s-popover--arrow"></div></div>

</div>

        </div>

        

<div class="postcell post-layout--right">
    <span class="d-none"><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-1-Frame" tabindex="0" style="position: relative;" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot; />" role="presentation"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-1" style="width: 0em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0em; height: 0px; font-size: 122%;"><span style="position: absolute; clip: rect(3.783em, 1000em, 4.161em, -1000em); top: -3.972em; left: 0em;"><span class="mrow" id="MathJax-Span-2"></span><span style="display: inline-block; width: 0px; height: 3.972em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.077em; border-left: 0px solid; width: 0px; height: 0.154em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"></math></span></span><script type="math/tex" id="MathJax-Element-1">\begingroup</script></span>
    <div class="s-prose js-post-body" itemprop="text">
                
<p>Suppose random triplicate samples are taken from a Gaussian distribution with known mean and SD. What should be the distribution of the maximum absolute difference between 3 possible pairs of observations within each sample (the range of a triplicate)?</p>
    </div>

        <div class="mt24 mb12">
            <div class="post-taglist d-flex gs4 gsy fd-column">
                <div class="d-flex ps-relative fw-wrap">
                    
                    <ul class="ml0 list-ls-none js-post-tag-list-wrapper d-inline"><li class="d-inline mr4 js-post-tag-list-item"><a href="/questions/tagged/normal-distribution" class="post-tag" title="" aria-label="show questions tagged 'normal-distribution'" rel="tag" aria-labelledby="tag-normal-distribution-tooltip-container" data-tag-menu-origin="Unknown">normal-distribution</a></li><li class="d-inline mr4 js-post-tag-list-item"><a href="/questions/tagged/variance" class="post-tag" title="" aria-label="show questions tagged 'variance'" rel="tag" aria-labelledby="tag-variance-tooltip-container" data-tag-menu-origin="Unknown">variance</a></li><li class="d-inline mr4 js-post-tag-list-item"><a href="/questions/tagged/sampling" class="post-tag" title="show questions tagged 'sampling'" aria-label="show questions tagged 'sampling'" rel="tag" aria-labelledby="tag-sampling-tooltip-container" data-tag-menu-origin="Unknown">sampling</a></li><li class="d-inline mr4 js-post-tag-list-item"><a href="/questions/tagged/small-sample" class="post-tag" title="show questions tagged 'small-sample'" aria-label="show questions tagged 'small-sample'" rel="tag" aria-labelledby="tag-small-sample-tooltip-container" data-tag-menu-origin="Unknown">small-sample</a></li><li class="d-inline mr4 js-post-tag-list-item"><a href="/questions/tagged/absolute-value" class="post-tag" title="" aria-label="show questions tagged 'absolute-value'" rel="tag" aria-labelledby="tag-absolute-value-tooltip-container" data-tag-menu-origin="Unknown">absolute-value</a></li></ul>
                </div>
            </div>
        </div>

    <div class="mb0 ">
        <div class="mt16 d-flex gs8 gsy fw-wrap jc-end ai-start pt4 mb16">
            <div class="flex--item mr16 fl1 w96">
                


<div class="js-post-menu pt2" data-post-id="647422" data-post-type-id="1">

    <div class="d-flex gs8 s-anchors s-anchors__muted fw-wrap">

        <div class="flex--item">
            <a href="/q/647422" rel="nofollow" itemprop="url" class="js-share-link js-gps-track" title="Short permalink to this question" data-gps-track="post.click({ item: 2, priv: 0, post_type: 1 })" data-controller="se-share-sheet s-popover" data-se-share-sheet-title="Share a link to this question" data-se-share-sheet-subtitle="" data-se-share-sheet-post-type="question" data-se-share-sheet-social="facebook twitter " data-se-share-sheet-location="1" data-se-share-sheet-license-url="https%3a%2f%2fcreativecommons.org%2flicenses%2fby-sa%2f4.0%2f" data-se-share-sheet-license-name="CC BY-SA 4.0" data-s-popover-placement="bottom-start" aria-controls="se-share-sheet-0" data-action=" s-popover#toggle se-share-sheet#preventNavigation s-popover:show->se-share-sheet#willShow s-popover:shown->se-share-sheet#didShow" aria-expanded="false">Share</a><div class="s-popover z-dropdown s-anchors s-anchors__default" style="width: unset; max-width: 28em;" id="se-share-sheet-0"><div class="s-popover--arrow"></div><div><label for="share-sheet-input-se-share-sheet-0"><span class="js-title fw-bold">Share a link to this question</span> <span class="js-subtitle"></span></label></div><div class="my8"><input type="text" id="share-sheet-input-se-share-sheet-0" class="js-input s-input wmn3 sm:wmn-initial bc-black-300 bg-white fc-black-600" readonly=""></div><div class="d-flex jc-space-between ai-center mbn4"><button class="js-copy-link-btn s-btn s-btn__link js-gps-track" data-gps-track="">Copy link</button><a href="https://creativecommons.org/licenses/by-sa/4.0/" rel="license" class="js-license s-block-link w-auto" target="_blank" title="The current license for this post: CC BY-SA 4.0">CC BY-SA 4.0</a><div class="js-social-container d-none"></div></div></div>
        </div>

            <div class="flex--item">
                <button type="button" class="js-cite-link s-btn s-btn__link">Cite</button>
            </div>

                    <div class="flex--item">
                        <a href="/posts/647422/edit" class="js-suggest-edit-post js-gps-track" data-gps-track="post.click({ item: 6, priv: 0, post_type: 1 })" title="">Improve this question</a>
                    </div>

                <div class="flex--item">
                    <button type="button" id="btnFollowPost-647422" class="s-btn s-btn__link js-follow-post js-follow-question js-gps-track" data-gps-track="post.click({ item: 14, priv: 0, post_type: 1 })" data-controller="s-tooltip " data-s-tooltip-placement="bottom" data-s-popover-placement="bottom" aria-controls="" aria-describedby="--stacks-s-tooltip-r5us9ulb">
                        Follow
                        <input type="hidden" id="voteFollowHash" value="68:3:31e,16:7ee654f3b4a170df,10:1716252848,16:e392440c2e85c16f,6:647422,63aeeffb9da08d0a0062808ea291e1d8aa175324693e3a3f1fd72fac3f46adb9">
                    </button><div id="--stacks-s-tooltip-r5us9ulb" class="s-popover s-popover__tooltip" role="tooltip">Follow this question to receive notifications<div class="s-popover--arrow"></div></div>
                </div>






    </div>
    <div class="js-menu-popup-container"></div>
</div>
            </div>

            <div class="post-signature owner flex--item">
                <div class="user-info ">
    <div class="d-flex ">
        <div class="user-action-time fl-grow1">
            asked <span title="2024-05-17 11:25:49Z" class="relativetime">May 17 at 11:25</span>
        </div>
        
    </div>
    <div class="user-gravatar32">
        <a href="/users/397858/maciej-tomczak"><div class="gravatar-wrapper-32"><img src="https://www.gravatar.com/avatar/72b3b6e852ac4fa75e930f96164be5d4?s=64&amp;d=identicon&amp;r=PG&amp;f=y&amp;so-version=2" alt="Maciej Tomczak's user avatar" width="32" height="32" class="bar-sm"></div></a>
    </div>
    <div class="user-details" itemprop="author" itemscope="" itemtype="http://schema.org/Person">
        <a href="/users/397858/maciej-tomczak">Maciej Tomczak</a><span class="d-none" itemprop="name">Maciej Tomczak</span>
        <div class="-flair">
            <span class="reputation-score" title="reputation score " dir="ltr">151</span><span title="5 bronze badges" aria-hidden="true"><span class="badge3"></span><span class="badgecount">5</span></span><span class="v-visible-sr">5 bronze badges</span>
        </div>
    </div>
</div>


            </div>
        </div>
    </div>
    <span class="d-none"><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-2-Frame" tabindex="0" style="position: relative;" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot; />" role="presentation"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-3" style="width: 0em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0em; height: 0px; font-size: 122%;"><span style="position: absolute; clip: rect(3.783em, 1000em, 4.161em, -1000em); top: -3.972em; left: 0em;"><span class="mrow" id="MathJax-Span-4"></span><span style="display: inline-block; width: 0px; height: 3.972em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.077em; border-left: 0px solid; width: 0px; height: 0.154em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"></math></span></span><script type="math/tex" id="MathJax-Element-2">\endgroup</script></span>
</div>




            <span class="d-none" itemprop="commentCount">7</span> 
    <div class="post-layout--right js-post-comments-component">
        <div id="comments-647422" class="comments js-comments-container bt bc-black-200 mt12 " data-post-id="647422" data-min-length="15">
            <ul class="comments-list js-comments-list" data-remaining-comments-count="2" data-canpost="false" data-cansee="true" data-comments-unavailable="false" data-addlink-disabled="true">

                        <li id="comment-1212317" class="comment js-comment " data-comment-id="1212317" data-comment-owner-id="79698" data-comment-score="0">
        <div class="js-comment-actions comment-actions">
            <div class="comment-score js-comment-score js-comment-edit-hide">
            </div>
        </div>
        <div class="comment-text  js-comment-text-and-form">
            <div class="comment-body js-comment-edit-hide">
                <span class="d-none"><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-3-Frame" tabindex="0" style="position: relative;" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot; />" role="presentation"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-5" style="width: 0em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0em; height: 0px; font-size: 122%;"><span style="position: absolute; clip: rect(3.783em, 1000em, 4.161em, -1000em); top: -3.972em; left: 0em;"><span class="mrow" id="MathJax-Span-6"></span><span style="display: inline-block; width: 0px; height: 3.972em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.077em; border-left: 0px solid; width: 0px; height: 0.154em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"></math></span></span><script type="math/tex" id="MathJax-Element-3">\begingroup</script></span>
                <span class="comment-copy">I don't believe the pdf or cdf has a closed-form but both can be easily approximated with numerical integration.</span>
                <span class="d-none"><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-4-Frame" tabindex="0" style="position: relative;" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot; />" role="presentation"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-7" style="width: 0em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0em; height: 0px; font-size: 122%;"><span style="position: absolute; clip: rect(3.783em, 1000em, 4.161em, -1000em); top: -3.972em; left: 0em;"><span class="mrow" id="MathJax-Span-8"></span><span style="display: inline-block; width: 0px; height: 3.972em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.077em; border-left: 0px solid; width: 0px; height: 0.154em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"></math></span></span><script type="math/tex" id="MathJax-Element-4">\endgroup</script></span>
                <div class="d-inline-flex ai-center">
–&nbsp;<a href="/users/79698/jimb" title="3,869 reputation" class="comment-user">JimB</a>
                </div>
                <span class="comment-date" dir="ltr"><a class="comment-link" href="#comment1212317_647422" aria-label="Link to comment"><span title="2024-05-17 14:10:01Z, License: CC BY-SA 4.0" class="relativetime-clean">May 17 at 14:10</span></a></span>
            </div>
        </div>
    </li>
    <li id="comment-1212370" class="comment js-comment " data-comment-id="1212370" data-comment-owner-id="411250" data-comment-score="0">
        <div class="js-comment-actions comment-actions">
            <div class="comment-score js-comment-score js-comment-edit-hide">
            </div>
        </div>
        <div class="comment-text  js-comment-text-and-form">
            <div class="comment-body js-comment-edit-hide">
                <span class="d-none"><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-5-Frame" tabindex="0" style="position: relative;" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot; />" role="presentation"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-9" style="width: 0em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0em; height: 0px; font-size: 122%;"><span style="position: absolute; clip: rect(3.783em, 1000em, 4.161em, -1000em); top: -3.972em; left: 0em;"><span class="mrow" id="MathJax-Span-10"></span><span style="display: inline-block; width: 0px; height: 3.972em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.077em; border-left: 0px solid; width: 0px; height: 0.154em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"></math></span></span><script type="math/tex" id="MathJax-Element-5">\begingroup</script></span>
                <span class="comment-copy">The difference of iid Gaussian RVs is Gaussian, and the absolute value follows a folded normal distribution - since there are 3 possible nonzero pairwise differences, try working out the distribution of the max order statistic of three folded Gaussians</span>
                <span class="d-none"><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-6-Frame" tabindex="0" style="position: relative;" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot; />" role="presentation"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-11" style="width: 0em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0em; height: 0px; font-size: 122%;"><span style="position: absolute; clip: rect(3.783em, 1000em, 4.161em, -1000em); top: -3.972em; left: 0em;"><span class="mrow" id="MathJax-Span-12"></span><span style="display: inline-block; width: 0px; height: 3.972em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.077em; border-left: 0px solid; width: 0px; height: 0.154em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"></math></span></span><script type="math/tex" id="MathJax-Element-6">\endgroup</script></span>
                <div class="d-inline-flex ai-center">
–&nbsp;<a href="/users/411250/randy-savage" title="261 reputation" class="comment-user">Randy Savage</a>
                </div>
                <span class="comment-date" dir="ltr"><a class="comment-link" href="#comment1212370_647422" aria-label="Link to comment"><span title="2024-05-17 18:35:18Z, License: CC BY-SA 4.0" class="relativetime-clean">May 17 at 18:35</span></a></span>
            </div>
        </div>
    </li>
    <li id="comment-1212395" class="comment js-comment " data-comment-id="1212395" data-comment-owner-id="79698" data-comment-score="0">
        <div class="js-comment-actions comment-actions">
            <div class="comment-score js-comment-score js-comment-edit-hide">
            </div>
        </div>
        <div class="comment-text  js-comment-text-and-form">
            <div class="comment-body js-comment-edit-hide">
                <span class="d-none"><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-7-Frame" tabindex="0" style="position: relative;" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot; />" role="presentation"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-13" style="width: 0em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0em; height: 0px; font-size: 122%;"><span style="position: absolute; clip: rect(3.783em, 1000em, 4.161em, -1000em); top: -3.972em; left: 0em;"><span class="mrow" id="MathJax-Span-14"></span><span style="display: inline-block; width: 0px; height: 3.972em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.077em; border-left: 0px solid; width: 0px; height: 0.154em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"></math></span></span><script type="math/tex" id="MathJax-Element-7">\begingroup</script></span>
                <span class="comment-copy">@RandySavage I assume you mean three non-independent folded Gaussians.  That would seem much more complicated than necessary.</span>
                <span class="d-none"><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-8-Frame" tabindex="0" style="position: relative;" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot; />" role="presentation"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-15" style="width: 0em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0em; height: 0px; font-size: 122%;"><span style="position: absolute; clip: rect(3.783em, 1000em, 4.161em, -1000em); top: -3.972em; left: 0em;"><span class="mrow" id="MathJax-Span-16"></span><span style="display: inline-block; width: 0px; height: 3.972em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.077em; border-left: 0px solid; width: 0px; height: 0.154em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"></math></span></span><script type="math/tex" id="MathJax-Element-8">\endgroup</script></span>
                <div class="d-inline-flex ai-center">
–&nbsp;<a href="/users/79698/jimb" title="3,869 reputation" class="comment-user">JimB</a>
                </div>
                <span class="comment-date" dir="ltr"><a class="comment-link" href="#comment1212395_647422" aria-label="Link to comment"><span title="2024-05-17 20:22:15Z, License: CC BY-SA 4.0" class="relativetime-clean">May 17 at 20:22</span></a></span>
            </div>
        </div>
    </li>
    <li id="comment-1212713" class="comment js-comment " data-comment-id="1212713" data-comment-owner-id="397858" data-comment-score="0">
        <div class="js-comment-actions comment-actions">
            <div class="comment-score js-comment-score js-comment-edit-hide">
            </div>
        </div>
        <div class="comment-text  js-comment-text-and-form">
            <div class="comment-body js-comment-edit-hide">
                <span class="d-none"><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-9-Frame" tabindex="0" style="position: relative;" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot; />" role="presentation"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-17" style="width: 0em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0em; height: 0px; font-size: 122%;"><span style="position: absolute; clip: rect(3.783em, 1000em, 4.161em, -1000em); top: -3.972em; left: 0em;"><span class="mrow" id="MathJax-Span-18"></span><span style="display: inline-block; width: 0px; height: 3.972em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.077em; border-left: 0px solid; width: 0px; height: 0.154em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"></math></span></span><script type="math/tex" id="MathJax-Element-9">\begingroup</script></span>
                <span class="comment-copy">@JimB, Other than Monte Carlo, is there a simpler way to estimate how scattered the triplicate samples should be if they are uncontaminated and were taken from a Gaussian parent distribution with known variance.  In other words, how far an observation in the triplicate should be from eg. the mean of the other, closer pair to suspect contamination/outlier?  I suspect that the natural spread in v. small samples may be greater than the intuition suggests even if the observations are well-behaved...</span>
                <span class="d-none"><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-10-Frame" tabindex="0" style="position: relative;" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot; />" role="presentation"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-19" style="width: 0em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0em; height: 0px; font-size: 122%;"><span style="position: absolute; clip: rect(3.783em, 1000em, 4.161em, -1000em); top: -3.972em; left: 0em;"><span class="mrow" id="MathJax-Span-20"></span><span style="display: inline-block; width: 0px; height: 3.972em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.077em; border-left: 0px solid; width: 0px; height: 0.154em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"></math></span></span><script type="math/tex" id="MathJax-Element-10">\endgroup</script></span>
                <div class="d-inline-flex ai-center">
–&nbsp;<a href="/users/397858/maciej-tomczak" title="151 reputation" class="comment-user owner">Maciej Tomczak</a>
                </div>
                <span class="comment-date" dir="ltr"><a class="comment-link" href="#comment1212713_647422" aria-label="Link to comment"><span title="2024-05-20 06:23:57Z, License: CC BY-SA 4.0" class="relativetime-clean">23 hours ago</span></a></span>
            </div>
        </div>
    </li>
    <li id="comment-1212743" class="comment js-comment " data-comment-id="1212743" data-comment-owner-id="79698" data-comment-score="0">
        <div class="js-comment-actions comment-actions">
            <div class="comment-score js-comment-score js-comment-edit-hide">
            </div>
        </div>
        <div class="comment-text  js-comment-text-and-form">
            <div class="comment-body js-comment-edit-hide">
                <span class="d-none"><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-11-Frame" tabindex="0" style="position: relative;" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot; />" role="presentation"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-21" style="width: 0em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0em; height: 0px; font-size: 122%;"><span style="position: absolute; clip: rect(3.783em, 1000em, 4.161em, -1000em); top: -3.972em; left: 0em;"><span class="mrow" id="MathJax-Span-22"></span><span style="display: inline-block; width: 0px; height: 3.972em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.077em; border-left: 0px solid; width: 0px; height: 0.154em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"></math></span></span><script type="math/tex" id="MathJax-Element-11">\begingroup</script></span>
                <span class="comment-copy">You need to specify what you want in standard statistical lingo devoid of whatever one's current "intuition" happens to be.  You now have introduced "contamination", "mean of the other, closer pair", and "natural spread" that you haven't defined.  Describing the practical/subject matter aspects of why you want the distribution of the range of 3 independent identically distributed normals would be helpful.</span>
                <span class="d-none"><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-12-Frame" tabindex="0" style="position: relative;" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot; />" role="presentation"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-23" style="width: 0em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0em; height: 0px; font-size: 122%;"><span style="position: absolute; clip: rect(3.783em, 1000em, 4.161em, -1000em); top: -3.972em; left: 0em;"><span class="mrow" id="MathJax-Span-24"></span><span style="display: inline-block; width: 0px; height: 3.972em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.077em; border-left: 0px solid; width: 0px; height: 0.154em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"></math></span></span><script type="math/tex" id="MathJax-Element-12">\endgroup</script></span>
                <div class="d-inline-flex ai-center">
–&nbsp;<a href="/users/79698/jimb" title="3,869 reputation" class="comment-user">JimB</a>
                </div>
                <span class="comment-date" dir="ltr"><a class="comment-link" href="#comment1212743_647422" aria-label="Link to comment"><span title="2024-05-20 12:36:10Z, License: CC BY-SA 4.0" class="relativetime-clean">23 hours ago</span></a></span>
            </div>
        </div>
    </li>

            </ul>
	    </div>

        <div id="comments-link-647422" data-rep="50" data-anon="true">
                    <a class="js-add-link comments-link dno" title="Use comments to ask for more information or suggest improvements. Avoid answering questions in comments." href="#" role="button"></a>
                <span class="js-link-separator dno">&nbsp;|&nbsp;</span>
            <a class="js-show-link comments-link " title="Expand to show all comments on this post" href="#" onclick="" role="button">Show <b>2</b> more comments</a>
        </div>         
    </div>
    </div>

</div>    
