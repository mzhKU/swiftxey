# DS Specialization Capstone Project: Milestone Report
## Martin Hediger, PhD 

(Demonstrate downloading and successfully loading it)
(Basic report of summary statistics)
(Report interesting findings)
(Get feedback on creating prediction algorithm and shiny app) 

(Link to HTML page with report)
(Basic summaries of the corpus files: word counts, line counts, basic data tables)
(Histograms)
(Brief, concise style, understandable for non-data scientists)


## Introduction
The task is to develop an application that provides suggestions
for words based in words typed by the user.

The application is trained on data from blogs, news and twitter texts.

The application basically works by calculating probabilities of uni-, di-
and tri-grams.
Then, input is cross-checked against the previously calculated probabilities.

## Results

### Basic summary analysis
Distribution of line lengths in the three data sets.

<img src="./line_length_distribution_blogs.png" style="width:240px">
<img src="./line_length_distribution_news.png" style="width:240px">
<img src="./line_length_distribution_twitter.png" style="width:240px">

It is apparent that the line length distribution of twitter posts falls off
sharply at 140 characters (the limit of a twitter post).

*Note: data is prepared using Python and converted to `integer` data type
in R.*





## Longest and shortest lines in any of the documents?

## Use tables and diagrams to summarize exploratory analysis


## Methods [Move to end of report]

### Initial data preprocessing
In the following, we prepare the training setup.
Basic preprocessing consists of removal of stopwords, punctuation and numbers
and stripping of whitespace.
All characters are converted to lower case
The input data is encoded as ASCII, allowing for efficient removal of
additional UTF-8 encoding signals.


### Tokenization
Tokenization is done using the tokenizer application from the `RWeka`
package.
An important note is that the `RWeka` package requires to set
`options(mc.cores=1)` due to discrepancies when working with multiple
cores.
Uni-, di- and tri-gram tokenizers are prepared individually`:

```r
NGT <- function(N, x)
{
    NGramTokenizer(x, Weka_control(min=N, max=N))
}
```

Term-document matrices are prepared for uni-, di- and trigrams:

```r
tdm <- TermDocumentMatrix(corp, control=list(tokenize=NGT))
```

```
## Error in eval(expr, envir, enclos): konnte Funktion "TermDocumentMatrix" nicht finden
```

Currently, all development is carried out on a very limited data set in
order to avoid extensive computational cost.
However, it is strongly assumed that the outlined methods translate easily
to the complete data set.


### Line length distribution measurement
```
f = open("./en_US.twitter.txt", "r")
d = f.readlines()`
f.close()
line_length_distribution = []
for i in range(len(d)):
    line_length_distribution.append(len(d[i]))
f = open("line_length_distribution_twitter.dat", "w")
for i in line_length_distribution:
    f.write(str(i) + "\n")
f.close()
```

Histogram preparation in R.
```
f = readLines("./line_length_distribution_twitter.dat")
f = as.numeric(f)
p = png("./line_length_distribution_twitter.png", width=600, height=400)
hist(f[f<1200], main="Line Length Distribution Twitter", xlab="Line Length",
     ylab="Occurence", breaks=100)
dev.off()
```


## Outlook and future development
- Model with stop word removal
- Model without stop word removal
- Provide suggestions continuously or only after every 
  n'th word has been typed


# Plans for creating the prediction algorithm
- Preprocessing
- n-gram tokenization
- Try naive Bayes learning
- Try random forest learning
- other machine learning methods

# Develop shiny app

# Develop slidify pitch presentation
