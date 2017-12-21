#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

library(caret)
library(mlbench)



userdata <- data.frame(area_worst = numeric(), concave.points_worst = numeric(), perimeter_worst= numeric(),     
                       radius_worst= numeric(), texture_worst= numeric(), concave.points_mean= numeric(),
                        area_se = numeric(),texture_mean= numeric(),concavity_worst= numeric(),  
                        smoothness_worst= numeric(), area_mean = numeric()) 


shinyServer(function(input, output) {
  
  result <- eventReactive(input$start, {
    # load the data
    cancerData <- read.csv("data.csv", sep = ",", header = T)
    
    set.seed(123)
    
    # calculate correlation matrix
    correlationMatrix <- cor(cancerData[,3:32])
    # summarize the correlation matrix
    print(correlationMatrix)
    # find attributes that are highly corrected (ideally >0.75)
    highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.5)
    
    # define the control using a random forest selection function
    control <- rfeControl(functions=rfFuncs, method="cv", number=10)
    # run the RFE algorithm
    results <- rfe(cancerData[,3:32], cancerData[,2], sizes=c(3:32), rfeControl=control)
    
    # plot the results
    a = plot(results, type=c("g", "o"))
    
    features <- predictors(results)
    newdata <- cancerData[, features]
    newdata$diagnosis <- cancerData$diagnosis
    
    inTrain <- createDataPartition(y = newdata$diagnosis ,
                                   p=0.7, list=FALSE)
    training <- newdata[inTrain,]
    testing <- newdata[-inTrain,]
    dim(training)
    
    set.seed(323)
    modelFit1 <- train(diagnosis ~.,data=training, preProcess = c("center", "scale"), method="rf")
    
    pred1 <- predict(modelFit1,newdata=testing)
    
    confusionMatrix(pred1,testing$diagnosis)
    
    
    
    userdata$area_worst[1]= input$Area_worst
    userdata$concave.points_mean[1] = input$Concave.points_mean
    userdata$perimeter_worst[1] = input$Perimeter_worst
    userdata$radius_worst[1] = input$Radius_worst
    userdata$texture_worst[1] = input$Texture_worst
    userdata$concave.points_worst[1] = input$Concave.points_worst
    userdata$area_se[1] = input$Area_se
    userdata$texture_mean[1] = input$Texture_mean
    userdata$concavity_worst[1] = input$Concavity_worst
    userdata$smoothness_worst[1] = input$Smoothness_worst
    userdata$area_mean[1] = input$Area_mean
    
    re_predict = predict(modelFit1, userdata)
    
    if (re_predict == "M"){
      result = "Malignant"
    }
    else{
      result = "Benign"
    }
    
  })
  
  output$prediction <- renderText({
    result()
  })
  
})