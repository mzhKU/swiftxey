#!/usr/bin/env Rscript

# ------------------------------------------------------------------------
# LIBRARY
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# ........................................................................
# PREPROCESSING
# ........................................................................
#
# Create corpus.
crporize <- function(tmp_file)
{
    # Load specific files.
    # Use 'language=de_DE' when working with German corpus.
    # crp <- Corpus(URISource(tmp_file, mode="text", encoding="UTF-8"),
    #              readerControl=list(reader=readPlain, language="de_DE"))

    # Load all files from a directory.
    crp <- Corpus(DirSource(tmp_file, mode="text", encoding="ASCII"),
                 readerControl=list(reader=readPlain, language="en_EN"))
    crp <- tm_map(crp, removeWords, stopwords("english"))
    crp <- tm_map(crp, removePunctuation, preserve_intra_word_dashes=F)
    crp <- tm_map(crp, removeNumbers)
    crp <- tm_map(crp, stripWhitespace)

    # Use 'content_transformer' to preserve meta data structure on corpus.
    crp <- tm_map(crp, content_transformer(tolower))

    # 25. Aug. 2015:
    # Switch ordering of 'tm_map' calls: 'stopwords' and 'tolower'.
    # Optional: do not remove stopwords.
}

crporize_file <- function(tmp_file)
{
    crp <- Corpus(URISource(tmp_file, mode="text", encoding="ASCII"),
                  readerControl=list(reader=readPlain, language="en_EN"))
    crp <- tm_map(crp, removeWords, stopwords("english"))
    crp <- tm_map(crp, removePunctuation, preserve_intra_word_dashes=F)
    crp <- tm_map(crp, removeNumbers)
    crp <- tm_map(crp, stripWhitespace)
    crp <- tm_map(crp, content_transformer(tolower))
}
# ........................................................................
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# ........................................................................
# SUMMARIZE
# ........................................................................
get_tdm <- function(crp, tokenizer)
{
    tmp_tdm <- TermDocumentMatrix(crp, control=list(tokenize=tokenizer))
    removeSparseTerms(tmp_tdm, 0.3)
}

# Order by decreasing n-gram total sum.
order_by_sum <- function(tdm_dt)
{
    tdm_dt[order(tdm_dt$sum, decreasing=TRUE)]
}

# Add a column with rank. 'tdm_dt' has to be in decreasing order.
add_rank_column <- function(tdm_dt)
{
    tdm_dt[order(tdm_dt$sum, decreasing=TRUE), rank := 1:nrow(tdm_dt)]
}

# Count number of words in specific documents from corpus.
doc_i_w <- function(doc_i, w_df)
{
    for(i in 1:length(doc_i$content))
    {
        w_df <- rbind(w_df, length(strsplit(doc_i$content[i], split=" ")[[1]]))
    }
    w_df
}

# Required to sum over all word-counts from the different corpora documents.
get_w_tot <- function(w_df, total)
{
    for(i in 1:length(w_df))
    {
        total <- rbind(total, sum(w_df[[i]]))
    }
    sum(total[1])
}
# ........................................................................
# ------------------------------------------------------------------------


# ------------------------------------------------------------------
# ..................................................................
# CLEAN
# ..................................................................
#
# Adding column name for the terms requires conversion to data.frame.
prepare_data_structure <- function(tdm)
{
    tdm_matrix           <- as.matrix(tdm)
    colnames(tdm_matrix) <- c("blogs", "news", "twitter")
    tdm_df               <- as.data.frame(tdm_matrix)
    as.data.table(tdm_df, keep.rownames=TRUE)
}
# ..................................................................
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# ..................................................................
# PROCESS INPUT
# ..................................................................
#
# Return last term in top counting pattern.
get_top_finding <- function(db)
{
    suggestion <- db[1, "rn"]
    #print(paste("Suggestion:", suggestion))
    suggestion <- strsplit(suggestion, split=" ")[[1]]
    suggestion[length(suggestion)]
}

get_last_four_words <- function(gp)
{
    # 02. Sept. 2015: 'strsplit' gives problems with empty string.
    if((length(gp)==0) && (typeof(gp)=="character"))
    {
        c("the", "and", "a")
    } else if(typeof(gp)=="NULL")
    {
        c("the", "and", "a")
    } else {
        gp_split <- strsplit(gp, split=" ")[[1]]
        length_gp <- length(gp_split)
        if(length_gp > 4)
        {
            first_pos <- (length_gp - 3)
            last_four_words <- paste(gp_split[first_pos:length_gp], collapse=" ")
        } else {
            last_four_words <- gp
        }
        last_four_words
    }
}

get_pattern_length <- function(gp)
{
    if((length(gp)==0) && (typeof(gp)=="character"))
    {
        c("the", "and", "i")
    } else {
        gp <- trim_all(gp)
        length(strsplit(gp, split=" ")[[1]])
    }
}

trim_leading <- function(x)
{
    sub("^\\s+", "", x)
}

trim_all <- function(s)
{
    # Required check for initialization at session start.
    if(!(s == ""))
    {
        k <- trim_leading(s)
        k <- strsplit(k, split=" +")[[1]]
        
        # Required in case input was only multiple space.
        if(length(k) > 0)
        {
            # Check for '""' required, because regular expression
            # " +" produces an empty string "" as first element
            # of results list, if a whitespaces is found at the
            # start of the search string (check help page for
            # 'grep').
            if(k[[1]] == "")
            {
                length_k <- length(k)
                k <- k[2:length_k]
            }
            paste(k, collapse=" ")
        }
    }
}

is_zero <- function(data_found)
{
   nrow(data_found)==0
}

is_found <- function(data_found)
{
    !is_zero(data_found)
}

get_data <- function(gp, db)
{
    gp <- trim_all(gp)
    gp <- paste("^", gp, " ", sep="")
    #print(paste("get_data gp:", gp))
    x <- db[grep(gp, db[, "rn"], ignore.case=TRUE), ]
    #x[order(x$qmle, decreasing=TRUE), ]
    x[order(x$count, decreasing=TRUE), ]
}

remove_first_term <- function(gp)
{
    gp <- trim_all(gp)
    length_gp <- length(strsplit(gp, split=" ")[[1]])
    if(length_gp == 1)
    {
        paste("")
    }
    if(length_gp > 1)
    {
        #gp <- paste(strsplit(gp, split=" ")[[1]][2:length_gp], collapse=" ")
        #paste("^", gp, sep="")
        #print(paste("remove_first_term:", 
        #            strsplit(gp, split=" ")[[1]][2:length_gp], collapse=" "))
        paste(strsplit(gp, split=" ")[[1]][2:length_gp], collapse=" ")
    }
}   

get_top_unigrams <- function(db)
{
    x <- db[order(db$qmle, decreasing=TRUE), ]
    x[1:4, ]
}
# ..................................................................
# ------------------------------------------------------------------
