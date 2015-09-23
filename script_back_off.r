#!/usr/bin/Rscript

#back_off <- function(gp, dtq_ml_wuvxyz, dtq_ml_wuvxy, dtq_ml_wuvx,
#                         dtq_ml_wuv, dtq_ml_wv, dtq_ml_w)
back_off <- function(gp)
                         
{
    iconv(gp, "latin1", "ASCII", sub="")
    gp <- gsub("'", "", gp)
    gp <- gsub("\\(|\\)", "", gp)
    gp <- gsub("\\[|\\]", "", gp)
    gp <- gsub("\\{|\\}", "", gp)
    gp <- gsub("\\*", "", gp)
    gsub("\\.\\.", "", gp)
    gp <- trim_all(gp)

    # This makes it unnecessary to check for input with length > 4.
    print(paste("length(gp)==0:", length(gp)==0))
    print(paste("typeof(gp)=='character':", typeof(gp)=="character"))
    print(paste("typeof(gp):", typeof(gp)))
    gp <- get_last_four_words(gp)

    if(get_pattern_length(gp) == 0)
    {
        data_found <- get_top_unigrams(dtq_ml_w)
    }
    if(get_pattern_length(gp) == 1)
    {
        data_found <- get_data(gp, dtq_ml_wv)
    }
    if(get_pattern_length(gp) == 2)
    {
        data_found <- get_data(gp, dtq_ml_wuv)
        if(is_zero(data_found))
        {
            gp <- remove_first_term(gp)
            data_found <- get_data(gp, dtq_ml_wv)
        }
    }
    if(get_pattern_length(gp) == 3) 
    {
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
    if(get_pattern_length(gp) == 4)
    {
        data_found <- get_data(gp, dtq_ml_wuvxy)
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
    }
    if(is_zero(data_found))
    {
        data_found <- get_top_unigrams(dtq_ml_w)
    }
        
    # Modify to optionally only return first 3 results.
    data_found
}
