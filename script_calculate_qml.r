#!/usr/bin/Rscript

# ------------------------------------------------------------------
# MODEL
# ..................................................................
#
# Sequence of calls:
#
# <script_rc.r>
# 'SETUP' and 'DATA' sections
#
# <script_library.r>
# dtdiGram_tdm  <- prepare_data_structure(diGram_tdm)
#
# <script_data_acquisition.r>
# column_sum(dtdiGram_tdm)
#
# <script_rc.r>
# q_ml_wuv <- lapply(X=dtdiGram_tdm$rn, FUN=grep_digrams, dttriGram_tdm)
# lapply(X=k[410:415], FUN=trigram_mle, dtdiGram_tdm)
# ..................................................................
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# ..................................................................
# CALCULATION
# ..................................................................
#
# Count number of occurences of n-grams over all documents.
column_sum <- function(tdm)
{
    tdm[, count := blogs + news + twitter]
}

grep_ngrams <- function(n_min_one_gram, n_grams)
{
    # "^" required to only extract those matches where the pattern
    # is at the beginning of the n-gram.
    n_grams[grep(paste("^", n_min_one_gram, sep=""), n_grams$rn)]
}

q_ML <- function(k_item, n_min_one_grams)
{
    # Check for:
    # > for(i in 1:nrow(q_ml_wv[[416]])){print(q_ml_wv[[416]][i])}
    #    rn blogs news twitter count
    # 1: NA    NA   NA      NA    NA
    # Empty data.table (0 rows) of 5 cols: rn,blogs,news,twitter,count
    if(length(k_item$rn)>0)
    {
        if(length(strsplit(x=k_item$rn, split=" ")[[1]]) == 5)
        {
            print("5-grams")
            grep_pattern <- strsplit(x=k_item$rn, split=" ")[[1]][1:4]
        }

        if(length(strsplit(x=k_item$rn, split=" ")[[1]]) == 4)
        {
            grep_pattern <- strsplit(x=k_item$rn, split=" ")[[1]][1:3]
        }

        # Extract 2-grams from 3-grams.
        # '[[1]]': If the 'k_item' has rows, then splitting the first
        # element will indicate how many elements there are in the row.
        if(length(strsplit(x=k_item$rn, split=" ")[[1]]) == 3)
        {
            grep_pattern <- strsplit(x=k_item$rn, split=" ")[[1]][1:2]
        }

        # Extract 1-grams from 2-grams.
        if(length(strsplit(x=k_item$rn, split=" ")[[1]]) == 2)
        {
            grep_pattern <- strsplit(x=k_item$rn, split=" ")[[1]][1]
        }
            
        grep_pattern <- paste(grep_pattern, collapse=" ")
        grep_pattern <- paste("^", grep_pattern, "$", sep="")

        # ................................................................
        # 14. Aug. 2015:
        # ................................................................
        #
        # This 'if'-statement had to be removed because in the
        # 2-gram data set, the 2-grams which could match to a stopword
        # had NA qmle-values (not the 1-gram and 3-gram data sets).
        #
        #if(!grep_pattern %in% paste("^", stopwords(), "$", sep=""))
        #{
        n_gram_count <- n_min_one_grams[grep(grep_pattern, n_min_one_grams$rn)]$count
        for(i in 1:nrow(k_item))
        {
            if(length(k_item[i]$rn)>0)
            {
                k_item[i, qmle:= count/n_gram_count]
            } 
        }
        # ................................................................
        #}
        # ................................................................
    k_item
    } 
}
# ..................................................................
# ------------------------------------------------------------------
