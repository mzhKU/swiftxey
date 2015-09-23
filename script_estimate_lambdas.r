#!/usr/bin/Rscript

# ------------------------------------------------------------------------
# MODELING
# ------------------------------------------------------------------------

# c'(u, v, w) := number of times the 3-gram (u, v, w) is seen
#                in the development data (= 'cp')

# Log-likelihood of development data as function of l1, l2, l3:
# L(l1, l2, l3)
# := sum_{u, v, w} ( cp(u, v, w)*log[ q(w|u,v)                                   ] )
#  = sum_{u, v, w} ( cp(u, v, w)*log[ l1*q_ml(w|u,v) + l2*q_ml(w|v) + l3*q_ml(w) ] )
#
# => argmax_{l1, l2, l3} L(l1, l2, l3)

# 10. August:
# Best MLE so far: "l1: 0.65 l2: 0.3 l3: 0.05 ll: -92.329"
# ........................................................................
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# ........................................................................
# SETUP
# 
# Adjust
# - Path to RDS files
# ........................................................................
#
# Development data:
# "./final_development/"
if(file.exists("./05_Model_Data/dev/dev.RDS"))
{
    cp <- readRDS("./05_Model_Data/dev/dev.RDS")
} else {
    source("./script_rc_dev.r")
}

if(!"dtq_ml_wuv" %in% ls())
{
    dtq_ml_wuv <- readRDS("./05_Model_Data/data-100000/dtq_ml_wuv.RDS")
}
if(!"dtq_ml_wv" %in% ls())
{
    dtq_ml_wv  <- readRDS("./05_Model_Data/data-100000/dtq_ml_wv.RDS")
}
if(!"dtq_ml_w" %in% ls())
{
    dtq_ml_w   <- readRDS("./05_Model_Data/data-100000/dtq_ml_w.RDS")
}
# ........................................................................
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# ........................................................................
#
#  = sum_{u, v, w} ( cp(u, v, w)*log[ l1*q_ml(w|u,v) + l2*q_ml(w|v) + l3*q_ml(w) ] )

# The 'grep' calls take the n-grams from the development data and
# locate matching n-grams in the training data.
estimate_lambdas <- function(ll, gamma)
{
    for(cpi in c(1:nrow(cp)))
    {
        grep_pattern_uvw <- cp[cpi, "rn"]
        grep_pattern_uvw <- paste(grep_pattern_uvw, "$", sep="")
    
        # Extract 'v' from development data 3-gram.
        grep_pattern_vw  <- strsplit(cp[cpi, "rn"], split=" ")[[1]]
        grep_pattern_vw  <- paste(grep_pattern_vw[1], grep_pattern_vw[2], sep=" ")
        grep_pattern_vw  <- paste(grep_pattern_vw, "$", sep="")
    
        grep_pattern_w   <- strsplit(cp[cpi, "rn"], split=" ")[[1]][3]
        grep_pattern_w  <- paste(grep_pattern_w, "$", sep="")

        # Define l1, l2 and l3 depending on each other and on gamma.
        cuv <- dtq_ml_wv[grep(grep_pattern_vw, dtq_ml_wv$rn), "count"][1]
        l1  <- cuv/(cuv + gamma)

        cv  <- dtq_ml_w[grep(grep_pattern_w, dtq_ml_w$rn), "count"][1]
        l2  <- (1 - l1)*cv/(cv + gamma)

        l3  <- 1 - l1 - l2

        l1 <- 0.65
        l2 <- 0.3
        l3 <- 0.05

        term1 <- l1*dtq_ml_wuv[grep(grep_pattern_uvw, dtq_ml_wuv$rn), "qmle"][1]
        term2 <- l2*dtq_ml_wv[grep(grep_pattern_vw, dtq_ml_wv$rn), "qmle"][1]
        term3 <- l3*dtq_ml_w[grep(grep_pattern_w, dtq_ml_w$rn), "qmle"][1]
    
        if(!is.na(term1) && !is.na(term2) && !is.na(term3))
        {
            ll <- ll + cp[cpi, "count"]*log10(term1 + term2 + term3)
        }
    }
    print(l1+l2+l3)
    print(paste("l1:", l1, "l2:", l2, "l3:", l3, "ll:", round(ll, 3)))
}
# ........................................................................
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# ........................................................................
ll    <- 0
gamma <- c(0.999, 0.999999, 0.9999999999999)
for(gamma_i in gamma){estimate_lambdas(ll, gamma_i)}
# ........................................................................
# ------------------------------------------------------------------------
