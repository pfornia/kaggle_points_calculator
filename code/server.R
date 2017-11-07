library(UsingR)

kagglePointsNew <- function(rank, NTeammates = 1, NTeams = 100, time = 0){
    return((100000/sqrt(NTeammates)*rank^(-.75)*log10(1+log10(NTeams))*exp(-time/500)))
}

kagglePointsOld <- function(rank, NTeammates = 1, NTeams = 100, time = 0){
    return((100000/NTeammates)*rank^(-.75)*log10(NTeams)*(730 - time)/730)
}

shinyServer(
    function(input, output) {
        #mu <- reactive({input$mu})
        NTeammates <- reactive({input$NTeammates})
        NTeams <- reactive({input$NTeams})
        GoalPoints <- reactive({input$GoalPoints})
        pointsFunction <- reactive({input$pointsFunction})
        
            
        output$omessage <- renderPrint({
            
            if(pointsFunction() == "Current Points Algorithm"){
                kagglePoints <- kagglePointsNew
            } else {
                kagglePoints <- kagglePointsOld
            }            
            
            rank <- 1:NTeams()
            score <- sapply(rank, function(x){kagglePoints(x, NTeammates = NTeammates(), NTeams = NTeams())})
            aboveGoal <- sum(score > GoalPoints())
            
            #paste("You need to obtain a rank of",  aboveGoal, "to meet your points goal.")
            aboveGoal
            })
        
        output$newHist <- renderPlot({
            #input$goButton
            
            if(pointsFunction() == "Current Points Algorithm"){
                kagglePoints <- kagglePointsNew
            } else {
                kagglePoints <- kagglePointsOld
            }     
            
            rank <- 1:NTeams()
            score <- sapply(rank, function(x){kagglePoints(x, NTeammates = NTeammates(), NTeams = NTeams())})
            aboveGoal <- score > GoalPoints()
            scoreAboveGoal <- score[aboveGoal]
            score1year <- sapply(rank, function(x){kagglePoints(x, NTeammates = NTeammates(), NTeams = NTeams(), time = 365)})
            score2year <- sapply(rank, function(x){kagglePoints(x, NTeammates = NTeammates(), NTeams = NTeams(), time = 730)})
            
            plot(rank, score, log = "y", ylab = "Points (Log Scale)", xlab = "Rank")
            points(scoreAboveGoal, lwd = 3, col = "grey20")
            points(score1year, col = "red")
            points(score2year, col = "orange")
            abline(h = 11500, lty = 2)
            abline(h = GoalPoints(), lty = 1)
            legend(x = NTeams()*.5, y = max(score)*.8, cex = 0.8,
                legend = c("Points awarded", "Points left after 1 year", "Points left after 2 years", "Top 1000 Global (aprox.)"),
                col = c("black","red","yellow","black"), pch = c(1,1,1,-1), lty = c(-1,-1,-1,2))
                
            #})
        })
    }
)
