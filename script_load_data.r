#!/usr/bin/Rscript

load_data <- function(path)
{
    # Global variables.
    dtq_ml_wuvxyz <<- readRDS(paste(path, "/",
                              "05_Model_Data/data-100000/dtq_ml_wuvxyz.RDS", sep=""))
    dtq_ml_wuvxy  <<- readRDS(paste(path,
                              "05_Model_Data/data-100000/dtq_ml_wuvxy.RDS" , sep=""))
    dtq_ml_wuvx   <<- readRDS(paste(path,
                              "05_Model_Data/data-100000/dtq_ml_wuvx.RDS"  , sep=""))
    dtq_ml_wuv    <<- readRDS(paste(path,
                              "05_Model_Data/data-100000/dtq_ml_wuv.RDS"   , sep=""))
    dtq_ml_wv     <<- readRDS(paste(path,
                              "05_Model_Data/data-100000/dtq_ml_wv.RDS"    , sep=""))
    dtq_ml_w      <<- readRDS(paste(path,
                              "05_Model_Data/data-100000/dtq_ml_w.RDS"     , sep=""))
}
