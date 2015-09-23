#!/usr/bin/Rscript

# ------------------------------------------------------------------------
# RUN CONTROL GENERATE DEVELOPMENT DATA
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# ........................................................................
# SETUP
# ........................................................................
#
# Adjust:
# - 'files_to_crporize'
# ........................................................................
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# ........................................................................
# DATA
# ........................................................................
#
options(mc.cores=1)

loaded <- search()

if(!"package:tm"         %in% loaded) { library(tm)         }
if(!"package:RWeka"      %in% loaded) { library(RWeka)      }
if(!"package:data.table" %in% loaded) { library(data.table) }
if(!"package:plyr"       %in% loaded) { library(plyr)       }

# Build 3-grams from development data and compute c'.
source("./script_library.r")
source("./script_tokenizers.r")
source("./script_calculate_qml.r")

# Adjust to specific development data.
files_to_crporize <- "./final_development/"

crp <- crporize(files_to_crporize)

# Development data.
triGram_tdm <- get_tdm(crp, TriGramTokenizer)
dttriGram_tdm <- prepare_data_structure(triGram_tdm)
column_sum(dttriGram_tdm)

saveRDS(dttriGram_tdm, "./05_Model_Data/dev/dev.RDS")
#cp <- dttriGram_tdm
