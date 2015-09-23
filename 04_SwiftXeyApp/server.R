#!/usr/bin/Rscript

library(shiny)
library(ggplot2)
source("./../script_load_data.r")
source("./script_app_library.r")
source("./../script_back_off.r")
source("./../script_library.r")

# -------------------------------------------------------------------------
# Code before 'shinyServer' is called at runtime.
# dtq_ml_wuvxyz <- readRDS("./../05_Model_Data/data-100000/dtq_ml_wuvxyz.RDS")
# dtq_ml_wuvxy  <- readRDS("./../05_Model_Data/data-100000/dtq_ml_wuvxy.RDS")
# dtq_ml_wuvx   <- readRDS("./../05_Model_Data/data-100000/dtq_ml_wuvx.RDS")
# dtq_ml_wuv    <- readRDS("./../05_Model_Data/data-100000/dtq_ml_wuv.RDS")
# dtq_ml_wv     <- readRDS("./../05_Model_Data/data-100000/dtq_ml_wv.RDS")
# dtq_ml_w      <- readRDS("./../05_Model_Data/data-100000/dtq_ml_w.RDS")
load_data(path="./../")
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
# Code within 'function' but not within 'reactive' is called
# once for every session.
# Whenever 'input' changes, all 'output' are notified that they
# need to reexecute.
# 'function' is visible per session.
# 'function' is called only when a browser connects and a session starts.
shinyServer(function(input, output, session)
{
    get_prediction <- reactive(
    {
        # .................................................................
        # Input:
        # - NULL
        # - Only space
        # => Remain silent
        # Prevent error when input is NULL, this happens when the session
        # is started for the first time, (s. "Execution scheduling"):
        #   "When someone first starts a session with a Shiny application,
        #   all of the endpoints start out invalidated, triggering this
        #   series of events."
        validate(
            need(input$userInput, FALSE),
            need(trim_all(input$userInput) != "", "Enter message.")
        )

        # 01. Sept. 2015: Exported to 'back_off' function.
        gp <- trim_all(input$userInput)
        #gp <- sub("'", "", gp)
        

        # This makes it unnecessary to check for input with length > 4.
        #gp <- get_last_four_words(gp)

        #back_off(gp, dtq_ml_wuvxyz, dtq_ml_wuvxy, dtq_ml_wuvx,
        #             dtq_ml_wuv, dtq_ml_wv, dtq_ml_w)
        back_off(gp)
    })
    # .....................................................................
    # ---------------------------------------------------------------------


    # ---------------------------------------------------------------------
    # Reactive Endpoints
    # To make application react instantaneously, remove 'input$goButton'
    # dependencies from reactive endpoints and remove 'isolation'.
    # .....................................................................
    # Update browser widgets data table, plot, user text, verbatim text.
    #
    output$verbatimTextOutput <- renderPrint(
    {
        d <- get_prediction()
        d[1:min(5, nrow(d)), ]
    })

    output$prediction_out_text <- renderText(
    {
        data_found  <- get_prediction()
        top_finding <- get_top_finding(data_found)
        top_finding
    })

    output$prediction_out_data_table<- renderDataTable(
    {
        get_prediction()
    })

    output$prediction_plot <- renderPlot(
    {
        get_plot(get_prediction())
    })
    # .....................................................................
    # ---------------------------------------------------------------------
})

# Outside of session scope, 'get_plot' is visible across sessions.
# If the objects change, then the changed objects will be visible in every user
# session. But note that you would need to use the <<- assignment operator to
# change bigDataSet, because the <- operator only assigns values in the local
# environment.
get_plot <- function(prediction)
{
    k <- prediction[order(prediction$qmle, decreasing=TRUE), ]
    theme_set(theme_gray(base_size=24)) 
    if(nrow(k)<5)
    {
        ggplot(k) +
        aes(x=reorder(rn, -qmle), y=qmle) +
        theme(axis.text.x=element_text(angle=45, hjust=1)) +
        geom_bar(stat="identity") +
        xlab("N-Gram Term") + 
        ylab(expression(y=q[ML]))
    } else {
        ggplot(k[1:4, ]) +
        aes(x=reorder(rn, -qmle), y=qmle) +
        theme(axis.text.x=element_text(angle=45, hjust=1)) +
        geom_bar(stat="identity") +
        xlab("N-Gram Term") + 
        ylab(expression(y=q[ML]))
    }
}
