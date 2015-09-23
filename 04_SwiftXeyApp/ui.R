#!/usr/bin/Rscript

library(shiny)

shinyUI(
    bootstrapPage(
        verticalLayout(
            wellPanel(
                verbatimTextOutput(outputId="verbatimTextOutput")
            ),
            headerPanel("SwiftXey App"),
            wellPanel(
                h3("Message Input"),
                textInput(inputId = "userInput",
                          label = "(White space is trimmed, no special characters)",
                          value = ""
                )
                #actionButton(inputId="goButton", label="Predict and append next word")
            ),
                tabsetPanel(
                    tabPanel("Basic Output",
                        wellPanel(
                            h4("Predicted Word:"),
                            textOutput(outputId = "prediction_out_text")
                        )
                    ),
                    tabPanel("Advanced Output",
                        wellPanel(
                            h4("Search results"),
                            p("Advanced output can be used to inspect search
                               results in detail."),
                            dataTableOutput(outputId = "prediction_out_data_table")
                        )
                    ),
                    tabPanel("About",
                        wellPanel(
                            p("Usage: Type your message in the input field.
                               The next most likely word will be predicted immediately."),
                            p("Upcoming Features:"),
                            tags$li("Special character input"),
                            tags$li("Numeric input"),
                            tags$li("Stopword suggestion optional"),
                            tags$li("Select suggestion by clicking on graph"),
                            tags$li("Add option how many suggestions"),
                            tags$li("Use selectize.js"),
                            tags$li("Suggestion is written to input field and
                                     highlighted: <Left arrow> for accept")
                        )
                    )
                ),
                wellPanel(
                    p("The diagram shows calculated likelihood values for terms."),
                    plotOutput(outputId="prediction_plot")
                )
        )
    )
)
