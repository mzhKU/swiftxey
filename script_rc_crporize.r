#!/usr/bin/Rscript

# ------------------------------------------------------------------------
# RUN CONTROL GENERATE CORPORA AND MODEL DATA
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# ........................................................................
# SETUP
# ........................................................................
#
# Adjust:
# - 'files_to_crporize'
# - 'saveRDS'
# - 'write.table'
# ........................................................................
#
# Required for RWeka functionality.
options(mc.cores=1)

loaded <- search()

if(!"package:tm"         %in% loaded) { library(tm)         }
if(!"package:RWeka"      %in% loaded) { library(RWeka)      } 
if(!"package:data.table" %in% loaded) { library(data.table) }
# ........................................................................
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# ........................................................................
# DATA
# ........................................................................
#
# Load 'crporize' function and custom tokenizers.
source("./script_library.r")
source("./script_tokenizers.r")

# To crporize specific files check 'script_library.r'
# and adjust function 'crporize'.
# files_to_crporize <- c("./path/file1", "./path/file2", ...)
files_to_crporize <- "./final_working/capped-150000/"

# Operate over all files simultaneously, no for-looping required.
print("Crporizing")
crp <- crporize(files_to_crporize)

print("Beginning 6-gram tokenization.")

sixGram_tdm   <- get_tdm(crp, SixGramTokenizer)
print("6-grams finished")

quintGram_tdm <- get_tdm(crp, QuintGramTokenizer)
print("5-grams finished")

quadGram_tdm  <- get_tdm(crp, QuadGramTokenizer)
print("4-grams finished")

triGram_tdm   <- get_tdm(crp, TriGramTokenizer)
print("3-grams finished")

diGram_tdm    <- get_tdm(crp, DiGramTokenizer)
print("2-grams finished")

uniGram_tdm   <- get_tdm(crp, UniGramTokenizer)
print("1-grams finished")
# inspect(tdm)

# Prepare data structures.
print("Preparing data structures")
dtuniGram_tdm   <- prepare_data_structure(uniGram_tdm)
dtdiGram_tdm    <- prepare_data_structure(diGram_tdm)
dttriGram_tdm   <- prepare_data_structure(triGram_tdm)
dtquadGram_tdm  <- prepare_data_structure(quadGram_tdm)
dtquintGram_tdm <- prepare_data_structure(quintGram_tdm)
dtsixGram_tdm   <- prepare_data_structure(sixGram_tdm)

# Required for q(w).
print("Counting words")
w_df <- data.frame(words = numeric())
w_df <- lapply(crp, doc_i_w, w_df)
total <- data.frame(tot = numeric())
crp_w_tot <- get_w_tot(w_df, total)
print("Corpus: Total number of words.")
print(crp_w_tot)

# order_by_sum(dtdiGram_tdm)
# add_rank_column(dttriGram_tdm)
# ........................................................................
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# ........................................................................
# DATA ACQUISITION
# ........................................................................
#
source("./script_calculate_qml.r")

print("Calculating column sums.")
column_sum(dtuniGram_tdm)
column_sum(dtdiGram_tdm)
column_sum(dttriGram_tdm)
column_sum(dtquadGram_tdm)
column_sum(dtquintGram_tdm)
column_sum(dtsixGram_tdm)

# Version 1: using 'tapply'
# 'tapply' : tapply(<Summary variable to operate 'Function' over>,
#                   <Group-by variable>, <Function>)
# 'INDEX'  : Each argument is at the same time a factor (occuring only once).
# tapply(X=dtdiGram_tdm$rn, INDEX=dtdiGram_tdm$rn, FUN=grep_digrams, dttriGram_tdm) 
#
# Signature:
# grep_digrams <- function(digram, trigrams)
#
#
# Version 2: using 'lapply'
# lapply(X=dtdiGram_tdm$rn, FUN=grep_digrams, dttriGram_tdm)
#
# Signature:
# grep_digrams <- function(digram, trigrams)
#
# 'lapply' seems to make more sense, because the group-by functionality
# of 'tappyl' is not really used because every 2-gram of 'X' is a group
# by its own.
# In the call to 'grep_digrams', 'X' is passed to the 'digram' slot.
#
# 'q_ml_wuv': All 3-grams given 2-grams.
# 'q_ml_wv' : All 2-grams given 1-grams.
print("grep 6-gram")
q_ml_wuvxyz <- lapply(X=dtquintGram_tdm$rn, FUN=grep_ngrams, dtsixGram_tdm)

print("grep 5-gram")
q_ml_wuvxy <- lapply(X=dtquadGram_tdm$rn, FUN=grep_ngrams, dtquintGram_tdm)

print("grep 4-gram")
q_ml_wuvx <- lapply(X=dttriGram_tdm$rn, FUN=grep_ngrams, dtquadGram_tdm)

print("grep 3-gram")
q_ml_wuv <- lapply(X=dtdiGram_tdm$rn, FUN=grep_ngrams, dttriGram_tdm)


print("grep 2-gram")
q_ml_wv  <- lapply(X=dtuniGram_tdm$rn, FUN=grep_ngrams, dtdiGram_tdm)

print("grep 1-gram")
q_ml_w   <- dtuniGram_tdm
q_ml_w[, qmle:= q_ml_w$count/crp_w_tot]

# Calculate q_ML(w|u,v), q_ML(w|v) and q_ML(w).
# No explicit reassignment to 'q_ml_wuv' or 'q_ml_wv' required.
print("6-gram qml")
lapply(X=q_ml_wuvxyz, FUN=q_ML, dtquintGram_tdm)

print("5-gram qml")
# **
lapply(X=q_ml_wuvxy, FUN=q_ML, dtquadGram_tdm)

print("4-gram qml")
lapply(X=q_ml_wuvx, FUN=q_ML, dttriGram_tdm)

print("3-gram qml")
lapply(X=q_ml_wuv, FUN=q_ML, dtdiGram_tdm)

print("2-gram qml")
lapply(X=q_ml_wv, FUN=q_ML, dtuniGram_tdm)
# ........................................................................
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# ........................................................................
# MODEL CONSTRUCTION
# ........................................................................
#
# Required to cast list of data tables into a single data table.
library(plyr)

# [What am i doing here?]
print("Filter")
dtq_ml_wuvxyz <- as.data.table(ldply(Filter(nrow, q_ml_wuvxyz), rbind))
dtq_ml_wuvxy <- as.data.table(ldply(Filter(nrow, q_ml_wuvxy), rbind))
dtq_ml_wuvx <- as.data.table(ldply(Filter(nrow, q_ml_wuvx), rbind))
dtq_ml_wuv <- as.data.table(ldply(Filter(nrow, q_ml_wuv), rbind))
dtq_ml_wv  <- as.data.table(ldply(Filter(nrow, q_ml_wv), rbind))
dtq_ml_w   <- q_ml_w

# Filter out duplicates.
print("Filter duplicates")
setkey(dtq_ml_wuvxyz, "rn")
setkey(dtq_ml_wuvxy, "rn")
setkey(dtq_ml_wuvx, "rn")
setkey(dtq_ml_wuv, "rn")
setkey(dtq_ml_wv, "rn")
setkey(dtq_ml_w, "rn")
dtq_ml_wuvxyz <- unique(dtq_ml_wuvxyz)
dtq_ml_wuvxy <- unique(dtq_ml_wuvxy)
dtq_ml_wuvx <- unique(dtq_ml_wuvx)
dtq_ml_wuv <- unique(dtq_ml_wuv)
dtq_ml_wv  <- unique(dtq_ml_wv)
dtq_ml_w   <- unique(dtq_ml_w)

print("Saving data.")
saveRDS(dtq_ml_wuvxyz, "./05_Model_Data/data-100000/dtq_ml_wuvxyz.RDS")
saveRDS(dtq_ml_wuvxy, "./05_Model_Data/data-100000/dtq_ml_wuvxy.RDS")
saveRDS(dtq_ml_wuvx, "./05_Model_Data/data-100000/dtq_ml_wuvx.RDS")
saveRDS(dtq_ml_wuv, "./05_Model_Data/data-100000/dtq_ml_wuv.RDS")
saveRDS(dtq_ml_wv,  "./05_Model_Data/data-100000/dtq_ml_wv.RDS")
saveRDS(dtq_ml_w,   "./05_Model_Data/data-100000/dtq_ml_w.RDS")

write.table(x=dtq_ml_wuvxyz, file="./05_Model_Data/data-100000/dtq_ml_wuvxyz.dat")
write.table(x=dtq_ml_wuvxy, file="./05_Model_Data/data-100000/dtq_ml_wuvxy.dat")
write.table(x=dtq_ml_wuvx, file="./05_Model_Data/data-100000/dtq_ml_wuvx.dat")
write.table(x=dtq_ml_wuv, file="./05_Model_Data/data-100000/dtq_ml_wuv.dat")
write.table(x=dtq_ml_wv,  file="./05_Model_Data/data-100000/dtq_ml_wv.dat")
write.table(x=dtq_ml_w,   file="./05_Model_Data/data-100000/dtq_ml_w.dat")
# ........................................................................
# ------------------------------------------------------------------------
