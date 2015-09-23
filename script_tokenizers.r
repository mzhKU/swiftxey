# Define a unigram tokenizer.
UniGramTokenizer <- function(x)
{
    NGramTokenizer(x, Weka_control(min=1, max=1))
}

# Define a digram tokenizer.
DiGramTokenizer <- function(x)
{
    NGramTokenizer(x, Weka_control(min=2, max=2))
}

# Define a trigram tokenizer.
TriGramTokenizer <- function(x)
{
    NGramTokenizer(x, Weka_control(min=3, max=3))
}
# Define a 4-gram tokenizer.
QuadGramTokenizer <- function(x)
{
    NGramTokenizer(x, Weka_control(min=4, max=4))
}
# Define a 5-gram tokenizer.
QuintGramTokenizer <- function(x)
{
    NGramTokenizer(x, Weka_control(min=5, max=5))
}
# Define a 6-gram tokenizer.
SixGramTokenizer <- function(x)
{
    NGramTokenizer(x, Weka_control(min=6, max=6))
}
