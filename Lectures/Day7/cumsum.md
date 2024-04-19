# Logical vector, Cumsum and Grouping lines.


The following is a useful idiom/approach I use.

This idiom works when we want to group consecutive lines in a file where
we can identify the start of each group with a TRUE and other lines with a FALSE in a logical
vector.
This might be a simple `ll == ""` or a `grepl("pattern", ll)` or some other logical predicate query/test.




Consider the following text from a job posting.
```
The Data Scientist (Statistics and Machine Learning) is responsible for designing, developing, and
deploying high-quality statistical and Artificial Intelligence (AI) solutions to meet predictive
advanced data analytics needs and support the decision-making of early clinical trials. The
individual in this role will collaborate with multidisciplinary functions to ensure that appropriate
statistical models, Natural Language Processing (NLP) technologies, or Deep Neural Network (DNN)
methodologies are applied in advanced data analytics and visualization solutions to predict patterns
or trends during the clinical data review. The individual will collaborate with the clinical
operation team and other related functions as a data science expert to contribute to the success of
landscape analysis and patient enrollment forecasting. Your responsibilities may include:

    Provide deep expertise in statistical and Machine Learning (ML) methods and applications

    Lead the development and implementation of statistical and ML methods and applications to
    accelerate data-driven decision-making and automate clinical data review

    Utilize epidemiology and real-world evidence data to identify the patient
    population. Responsible for building a model for project landscape analysis and enrollment
    forecasting

    Support the advanced data analytics with the deployment of statistical and ML solutions in
    interactive visualizations for ECD (Early Clinical Development) across therapeutic areas on
    safety signal detection, trajectory prediction, and correlation analysis

    Master knowledge sharing on statistical and AI / ML methodologies

    Act as a coach, mentor, or buddy to help ECDi group members to grow and develop statistical and
    AI / ML awareness per business needs

    Collaborate with internal and cross-functional team members to identify, evaluate, deliver, and
    improve data science solutions

    Refine the algorithms during the conduct of clinical trials to support the enrollment rate

    Conduct regular reviews of opportunities to simplify and innovate processes and ways of working in the ECDi

    Contribute statistical and AI / ML expertise to multiple elements of the business, including strategic planning; competitive landscape, communication; and implementation

    Support and/or represent the ECDi on statistical and AI / ML topics or projects across multiple
    functions of the Roche global organization, which may include; Pharma Research and Early
    Development (pRED); Genentech Research and Early Development (gRED); Product Development (PD);
    Market Access, Global Product Strategy (GPS); and Pharma Technical (PT)

    Purposefully collaborate and influence to ensure the ECDi to be at the forefront of data science and new technology

Who you are:

    Master of Science or PhD degree in Data Science, Computer Science, Statistics, Informatics, or other quantitative disciplines

    3+ years experience in an industry setting, preferably pharma or biotech

    Expertise in statistical methods and analytical methodology

    Experience with Machine Learning (ML) algorithms development and evolution

    Familiarity with Deep Neural Network (DNN) or Deep Learning (DL) and frameworks

    Advanced programming skills and prior work experience with analytical/statistical data analysis tools such as R/R-Shiny, SAS, Python, IronPython, JavaScript, Spotfire, Tableau

Preferred:

    Understanding of the end-to-end drug development lifecycle, knowledge of GCP, international regulations, guidelines and their application, and all other applicable compliance standards is a plus


Relocation benefits are not available for this posting.

The expected salary range for this position based on the primary location of South San Francisco,
California is 172,500 and 320,300. Actual pay will be determined based on experience,
qualifications, geographic location, and other job-related factors permitted by law. A discretionary
annual bonus may be available based on individual and Company performance. This position also
qualifies for the benefits detailed at the link provided below.

Benefits

Genentech is an equal opportunity employer, and we embrace the increasingly diverse world around
us. Genentech prohibits unlawful discrimination based on race, color, religion, gender, sexual
orientation, gender identity or expression, national origin or ancestry, age, disability, marital
status and veteran status.
```
This is in [../Day5/jobPost.md](../Day5/jobPost.md)


The content is free form text. It is separated into paragraphs
which are separated by one or more blank lines.


I want to read the lines in the file and then assemble them back into paragraphs.
When I get the lines for each paragraph, I'll collapse them into a single string so we can
search the paragraph, not individual lines.
This will help searching across lines.
But that is not the issue here.
**We are focused on how to assemble the lines in the file into paragraphs.**

We read the lines
```{r}
ll = readLines("../Day5/jobPost.md")
```


Let's assume the blank lines are `""`, i.e., no additional spaces.  If not, we can fix that with
```{r}
ll[  grepl("^[[:space:]]+$", ll) ] = ""
```


Where are the blank lines?
```{r}
which(ll == "")
```
```
 [1] 10 12 15 19 23 25 28 31 33 35 37 42 44 46 48 50 52 54 56 58 60 62 63 65 71 73
```

We could loop over these and collect the lines between the start of one paragraph and up to the
start of the next paragraph. 

Another approach is the following:
```{r}
step = cumsum(ll == "")
```
```
 [1]  0  0  0  0  0  0  0  0  0  1  1  2  2  2  3  3  3  3  4  4  4  4  5  5  6  6  6  7  7  7  8  8  9  9 10 10 11 11 11 11 11 12
[43] 12 13 13 14 14 15 15 16 16 17 17 18 18 19 19 20 20 21 21 22 23 23 24 24 24 24 24 24 25 25 26 26 26 26 26
```

We now have a group identifier for each line that identifies which paragraph it belongs to.
So we can split/group-by the lines by the group identifier.

```{r}
paras = split(ll, step)
```

We can also collapse the lines for each paragraph using
```{r}
cparas = tapply(ll, step, paste, collapse = " ")
```

Some of these paragraphs will be just a single element "" if there are two lines separating the
actual content. 
```{r}
w = cparas == ""
table(w)
```
So just 1.  We can drop this.

```
cparas = cparas[!w]
```

Note that when we paste() the lines for a paragraph, the empty first blank element doesn't add any
content to the paragraph,  so we didn't have to remove that.


Again, there are other ways to group these, but this is less involved code when it works.
