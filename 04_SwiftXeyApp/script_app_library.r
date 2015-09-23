# -------------------------------------------------------------------------
# .........................................................................
# Support functions
# .........................................................................
#
# Grep 'grep_pattern' in data base.
# is_zero <- function(data_found)
# {
#    nrow(data_found)==0
# }
# 
# is_found <- function(data_found)
# {
#     !is_zero(data_found)
# }
# 
# get_data <- function(gp, db)
# {
#     gp <- trim_all(gp)
#     gp <- paste("^", gp, " ", sep="")
#     print(paste("get_data gp:", gp))
#     x <- db[grep(gp, db[, "rn"], ignore.case=TRUE), ]
#     #x[order(x$qmle, decreasing=TRUE), ]
#     x[order(x$count, decreasing=TRUE), ]
# }
#
# -> Exported to 'script_library.r'

# get_last_four_words <- function(gp)
# {
#     gp_split <- strsplit(gp, split=" ")[[1]]
#     length_gp <- length(gp_split)
#     if(length_gp > 4)
#     {
#         first_pos <- (length_gp - 3)
#         last_four_words <- paste(gp_split[first_pos:length_gp], collapse=" ")
#     } else {
#         last_four_words <- gp
#     }
#     last_four_words
# }
#
# -> Exported to 'script_library.r'
    
# get_pattern_length <- function(gp)
# {
#     gp <- trim_all(gp)
#     print(paste("get_pattern_length:", length(strsplit(gp, split=" ")[[1]])))
#     length(strsplit(gp, split=" ")[[1]])
# }
# 
# -> Exported to 'script_library.r'

# Return last term in top counting pattern.
# get_top_finding <- function(db)
# {
#     suggestion <- db[1, "rn"]
#     print(paste("Suggestion:", suggestion))
#     suggestion <- strsplit(suggestion, split=" ")[[1]]
#     suggestion[length(suggestion)]
# }
#
# -> Exported to 'script_library.r'

# get_top_unigrams <- function(db)
# {
#     x <- db[order(db$qmle, decreasing=TRUE), ]
#     x[1:4, ]
# }
# 
# -> Exported to 'script_library.r'

last_word <- function(gp)
{
    length_gp <- length(strsplit(gp, split=" ")[[1]])
    lw <- strsplit(gp, split=" ")[[1]][length_gp]
    print(paste("last_word:", lw, collapse=" "))
    paste(lw, collapse=" ")
}

last_two_words <- function(gp)
{
    length_gp <- length(strsplit(gp, split=" ")[[1]])
    ltw <- strsplit(gp, split=" ")[[1]][(length_gp-1):length_gp]
    ltw <- paste(ltw, collapse=" ")
    print(paste("last_two_words:", ltw, collapse=" "))
    ltw
}

# remove_first_term <- function(gp)
# {
#     gp <- trim_all(gp)
#     length_gp <- length(strsplit(gp, split=" ")[[1]])
#     if(length_gp == 1)
#     {
#         paste("")
#     }
#     if(length_gp > 1)
#     {
#         #gp <- paste(strsplit(gp, split=" ")[[1]][2:length_gp], collapse=" ")
#         #paste("^", gp, sep="")
#         print(paste("remove_first_term:", 
#                     strsplit(gp, split=" ")[[1]][2:length_gp], collapse=" "))
#         paste(strsplit(gp, split=" ")[[1]][2:length_gp], collapse=" ")
#     }
# }   
# 
# -> Exported to 'script_library.r'

# trim_leading <- function(x)
# {
#     sub("^\\s+", "", x)
# }
# 
# trim_all <- function(s)
# {
#     # Required check for initialization at session start.
#     if(!(s == ""))
#     {
#         k <- trim_leading(s)
#         k <- strsplit(k, split=" +")[[1]]
#         
#         # Required in case input was only multiple space.
#         if(length(k) > 0)
#         {
#             # Check for '""' required, because regular expression
#             # " +" produces an empty string "" as first element
#             # of results list, if a whitespaces is found at the
#             # start of the search string (check help page for
#             # 'grep').
#             if(k[[1]] == "")
#             {
#                 length_k <- length(k)
#                 k <- k[2:length_k]
#             }
#             paste(k, collapse=" ")
#         }
#     }
# }
# 
#
# -> Exported to 'script_library.r'

# For debugging, add empty lines in console output.
respace <- function()
{
    cat("\n")
    cat("\n")
    cat("\n")
}
# .........................................................................
# -------------------------------------------------------------------------
