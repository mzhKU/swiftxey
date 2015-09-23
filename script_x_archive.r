# Previously used for construction of corpus.
# [Optional]
# Remove characters and restore plain text document structure.
# Else the error: 'Fehler: inherits(doc, "TextDocument") ist nicht TRUE'
# is returned.
# unicodeCharacters <- c("\u0093", "\u0094", "\u0095", "\u0096", "\u0097")
# crp <- tm_map(crp, removeUnicodeCharacters, unicodeCharacters)
# crp <- tm_map(crp, PlainTextDocument)
# Define custom function to remove additional unicode characters.
# For some reason, does not return a value of class 'TextDocument',
# therefore the 'PlainTextDocument' conversion below is required.
removeUnicodeCharacters <- function(x, characters)
{
    gsub(sprintf("%s", paste(characters, collapse="|")), "", x, perl=TRUE)
}


# Previously used in preprocessing.
# Solved by using "ASCII" encoding.
# Define custom function to remove additional unicode characters.
# For some reason, does not return a value of class 'TextDocument',
# therefore the 'PlainTextDocument' conversion below is required.
removeUnicodeCharacters <- function(x, characters)
{
    gsub(sprintf("%s", paste(characters, collapse="|")), "", x, perl=TRUE)
}


# ------------------------------------------------------------------
# ------------------------------------------------------------------
# OLD 'script_prediction.r'
# ------------------------------------------------------------------
# ------------------------------------------------------------------
# Remove after 'script_modeling' was sourced:
# - crp
# - tdm[uni|di|tri]
# - tdm[uni|di|tr]df
# - tdm[uni|di|tr]m
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# Zipf law file export
# ------------------------------------------------------------------
# zipf_law <- file("zipf_law.dat")
# writeLines(tdmunidt$p, zipf_law)
# close(zipf_law)
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# Remove previously used objects.
# ------------------------------------------------------------------
rm(list=c("crp", "tdmuni", "tdmdi", "tdmtri",
          "tdmunidf", "tdmdidf", "tdmtridf",
          "tdmunim", "tdmdim", "tdmtrim"))
gc()
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# Input 01 -> tokenize to uni01, di01, tri01
# ------------------------------------------------------------------
# Tokenize input to 1-gram.
uni01 <- TermDocumentMatrix(Corpus(VectorSource(input01)),
                            control=list(tokenize=UniGramTokenizer))
uni01 <- as.matrix(uni01)
colnames(uni01) <- c("counts")
uni01 <- as.data.frame(uni01)
uni01 <- as.data.table(uni01, keep.rownames=T)

# Tokenize input to 2-grams.
# di01  <- TermDocumentMatrix(Corpus(VectorSource(input01)),
#                             control=list(tokenize=DiGramTokenizer))
# di01 <- as.matrix(di01)
# colnames(di01) <- c("counts")
# di01 <- as.data.frame(di01)
# di01 <- as.data.table(di01, keep.rownames=T)
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# Find input 1-grams in rownames of 2-gram term-document matrix.
for_loop_length <- nrow(uni01)
for(i in 1:for_loop_length)
{
    # Matches
    mtdi  <- grep(uni01$rn[i], tdmdidt$rn)
    mttri <- grep(uni01$rn[i], tdmtri$rn)
}

# Reduced data table of filtered expressions
tdmdidtred  <- tdmdidt[mtdi]
tdmtridtred <- tdmtridt[mttri]

# Order by decreasing probability.
tdmdidtred[order(tdmdidtred$p, decreasing=T)]
tdmtridtred[order(tdmtridtred$p, decreasing=T)]
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# Prediction utilities.
# ..................................................................
# build_model(n-gram)
# -> return a list of (n+1)-grams where the (n+1)-token follows
#    the n-gram
#
# For the top x 1-grams with 'p' > 0.01: get the 2-grams
# containing the 1-gram.
uni <- tdmunidt[tdmunidt$p > 0.01]
for(i in uni){tdmdidt[grep(sprintf("^%s ", i), tdmdidt$rn)]}
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# input01 <- paste("The guy in front of me", "just bought a pound of",
#                "bacon, a bouquet, and a case of", collapse= " ")
# 
# input02 <- paste("You're the reason why I smile everyday.",
#                  "Can you follow me please?", "It would mean the", collapse=" ")
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# ------------------------------------------------------------------

        # .................................................................
        # Input:
        # -  0 space
        #   >0 characters
        #    0 space
        #
        # - >0 space
        #   >0 characters
        #    0 space
        #
        # -  0 space
        #   >0 characters
        #   >0 space
        #
        # - >0 space
        #   >0 characters
        #   >0 space
        #
        # Remove all beginning/ending spaces.
        grep_pattern        <- trim_all(input$userInput)
        grep_pattern_length <- get_pattern_length(grep_pattern)
   
        # One word input.
        if(grep_pattern_length == 1)
        {
            data_found <- get_data(grep_pattern, dtq_ml_wv)
            if(data_found_is_zero(data_found))
            {
                data_found <- rbind(data_found, get_data(grep_pattern, dtq_ml_wuv))
            }
            if(data_found_is_zero(data_found))
            {
                data_found <- get_top_unigrams(dtq_ml_w)
            }
        }
        # .................................................................

        
        # .................................................................
        # Input:
        # -  0 space
        #   >0 characters
        #    1 space
        #   >0 characters
        #    0 space
        #
        # - >0 space
        #   >0 characters
        #    1 space
        #   >0 characters
        #    0 space
        #
        # -  0 space
        #   >0 characters
        #   >1 space
        #   >0 characters
        #    0 space
        #
        # -  0 space
        #   >0 characters
        #    1 space
        #   >0 characters
        #   >0 space
        #
        # - >0 space
        #   >0 characters
        #   >1 space
        #   >0 characters
        #   >0 space
        #
        #if(grep_pattern_length == 2)
        #{
        #    data_found <- get_data(grep_pattern, dtq_ml_wuv)

        #    if(data_found_is_zero(data_found))
        #    {
        #        grep_pattern <- last_word(grep_pattern)
        #        data_found <- rbind(data_found, get_data(grep_pattern, dtq_ml_wuv))
        #    }
        #    if(data_found_is_zero(data_found))
        #    {

        #    data_found <- rbind(data_found, get_data(grep_pattern, dtq_ml_wuv))
        #    
        #    if(data_found_is_zero(data_found))
        #    {
        #        data_found <- get_top_unigrams(dtq_ml_w)
        #    }
        #}
        # .................................................................
        if(get_pattern_length(gp) == 1)
        {
            data_found <- get_data(gp, dtq_ml_wv)
            if(data_is_found(data_found))
            {
                get_top_finding(data_found)
            }
        }
        if(get_pattern_length(gp) == 2)
        {
            data_found <- get_data(gp, dtq_ml_wuv)
            if(data_is_found(data_found))
            {
                get_top_finding(data_found)
            }
            if(data_found_is_zero(data_found))
            {
                gp_tmp <- remove_first_term(gp)
                data_found <- get_data(gp_tmp, dtq_ml_wv)
            }
        }
        if(get_pattern_length(gp) == 3)
        {
            data_found <- get_data(gp, dtq_ml_wuvx)
            if(data_is_found(data_found))
            {
                get_top_finding(data_found)
            }
            if(data_found_is_zero(data_found))
            {
                gp_tmp <- remove_first_term(gp)
                data_found <- get_data(gp_tmp, dtq_ml_wuv)
                if(data_is_found(data_found))
                {
                    data_found
                }
            }
        }
        if(get_pattern_length(gp) == 4)
        {
            data_found <- get_data(gp, dtq_ml_wuvxy)
            if(data_is_found(data_found))
            {
                get_top_finding(data_found)
            }
        }
        
        if gp < 5
        {
            if gp = 1
                w_in_wv(w, wv)
                if found
                    v
                if not found
                    w_random()
            if gp = 2
                wv_in_wuv(wv, wuv)
                if found
                    u
                if not found
                    v <- remove_first(wv)
                    w_in_wv(v, wv)
            if gp = 3
                wuv_in_wuvx(wuv, wuvx)
                if found
                    u
                if not found
                    uv <- remove_first(wuv)
                    wv_in_wuv(uv, wuv)
            if gp = 4
                wuvx_in_wuvxy(wuvx, wuvxy)
                if found
                    u
                if not found
                    uvx <- remove_first(wuvx)
                    wuv_in_wuvx(uvx, wuvx)
        }
            
        if(is_found(data_found))
        {
            data_found
        }
        if(is_zero(data_found))
        {
            gp <- remove_first_term(gp)
            data_found <- get_data(gp, dtq_ml_wuvx)
            if(is_zero(data_found))
            {
                gp <- remove_first_term(gp)
                data_found <- get_data(gp, dtq_ml_wuv)
                if(is_zero(data_found))
                {
                    gp <- remove_first_term(gp)
                    data_found <- get_data(gp, dtq_ml_wv)
                }
            }
        }
