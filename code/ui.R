#ui.R

library(shiny)
shinyUI(
    pageWithSidebar(
        headerPanel("Kaggle Competition Point Calculator"),
        sidebarPanel(
            #sliderInput('mu', 'What is the mean?', value = 70, min = 62, max = 74, step = 0.05),
            numericInput('NTeammates', 'How many on your team?', value = 1, min = 1, max = 20, step = 1),
            numericInput('NTeams', 'How many teams?', value = 100, min = 50, max = 1000, step = 50),
            sliderInput('GoalPoints', 'How many points you need?', value = 11500, min = 500, max = 20000, step = 500),
            selectInput('pointsFunction', label = NULL, choices = c("Current Points Algorithm", "Old Points Algorithm")),
            h4("Rank needed to obtain points goal:"),
            verbatimTextOutput("omessage")
        ),
        mainPanel(
            h4("Kaggle.com hosts contests for Data Scientists to solve real-world predictive and machine learning 
                problems. For a single Kaggle contest, this graph shows the points awarded for any given rank (black dots),
               and how those points decay over time (red and yellow dots)."),
            helpText(a("Click here for more on how Kaggle.com awards points.", href = "http://blog.kaggle.com/2015/05/13/improved-kaggle-rankings/", target = "_blank")),
            plotOutput('newHist')
        )
    )
)