require(caret)
require(mlbench)

# load the data
cancerData <- read.csv("data.csv", sep = ",", header = T)

set.seed(123)

# calculate correlation matrix
correlationMatrix <- cor(cancerData[,3:32])
# summarize the correlation matrix
print(correlationMatrix)
# find attributes that are highly corrected (ideally >0.75)
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.5)
# print indexes of highly correlated attributes
print(highlyCorrelated)


# define the control using a random forest selection function
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
# run the RFE algorithm
results <- rfe(cancerData[,3:32], cancerData[,2], sizes=c(3:32), rfeControl=control)
# summarize the results
print(results)
# list the chosen features
predictors(results)
# plot the results
plot(results, type=c("g", "o"))

features <- predictors(results)
newdata <- cancerData[, features]
newdata$diagnosis <- cancerData$diagnosis

inTrain <- createDataPartition(y = newdata$diagnosis ,
                               p=0.7, list=FALSE)
training <- newdata[inTrain,]
testing <- newdata[-inTrain,]
dim(training)

set.seed(323)
modelFit1 <- train(diagnosis ~.,data=training, preProcess = c("center", "scale"), method="glm")

modelFit2 <- train(diagnosis ~.,data=training, preProcess = c("center", "scale"), method="rf")

modelFit3 <- train(diagnosis ~.,data=training, preProcess = c("center", "scale"), method="nnet")

pred1 <- predict(modelFit1,newdata=testing)
pred2 <- predict(modelFit2,newdata=testing)
pred3 <- predict(modelFit3,newdata=testing)

confusionMatrix(pred1,testing$diagnosis)
confusionMatrix(pred2,testing$diagnosis)
confusionMatrix(pred3,testing$diagnosis)

# model ensemble
predDF <- data.frame(pred1,pred2,pred3, diagnosis=testing$diagnosis)
combModFit <- train(diagnosis ~.,method="nnet",data=predDF)
combPred <- predict(combModFit,predDF)

confusionMatrix(combPred,testing$diagnosis)