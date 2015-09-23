#!/usr/bin/Rscript

# ------------------------------------------------------------------------
# SMALL POST-PROCESSING SCRIPT
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# ........................................................................
# SETUP
# ........................................................................
#
# Adjust:
# - Directory to read data from: 'files_to_crporize'
# - 'saveRDS'
# - 'write.table'
# ........................................................................
#
library(data.table)
if(!"dtq_ml_wuv" %in% ls())
{
    dtq_ml_wuv <- readRDS("./05_Model_Data/data-150000/dtq_ml_wuv.RDS")
}
if(!"dtq_ml_wv" %in% ls())
{
    dtq_ml_wv  <- readRDS("./05_Model_Data/data-150000/dtq_ml_wv.RDS")
}
if(!"dtq_ml_w" %in% ls())
{
    dtq_ml_w   <- readRDS("./05_Model_Data/data-150000/dtq_ml_w.RDS")
}

setkey(dtq_ml_wuv, "rn")
setkey(dtq_ml_wv, "rn")
setkey(dtq_ml_w, "rn")
dtq_ml_wuv <- unique(dtq_ml_wuv)
dtq_ml_wv  <- unique(dtq_ml_wv)
dtq_ml_w   <- unique(dtq_ml_w)

saveRDS(dtq_ml_wuv, "./05_Model_Data/data-150000/dtq_ml_wuv.RDS")
saveRDS(dtq_ml_wv,  "./05_Model_Data/data-150000/dtq_ml_wv.RDS")
saveRDS(dtq_ml_w,   "./05_Model_Data/data-150000/dtq_ml_w.RDS")


