
library(rmr2)

hdfs.init()

Sys.setenv(HADOOP_CMD='/usr/bin/hadoop')
Sys.setenv(HADOOP_STREAMING='/usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming.jar') 

cancer.path = 'filepath/file.csv'
cancer.data = from.dfs(cancer.path, format = "csv")

require(caret)
require(mlbench)

set.seed(123)
# calculate correlation matrix
correlationMatrix <- cor(cancerData[,3:32])

# find attributes that are highly corrected (ideally >0.75)
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.5)

# define the control using a random forest selection function
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
# run the RFE algorithm
results <- rfe(cancerData[,3:32], cancerData[,2], sizes=c(3:32), rfeControl=control)

features <- predictors(results)
newdata <- cancerData[, features]
newdata$diagnosis <- cancerData$diagnosis

inTrain <- createDataPartition(y = newdata$diagnosis ,
                               p=0.7, list=FALSE)
training <- newdata[inTrain,]
testing <- newdata[-inTrain,]

set.seed(323)
cancer.fitted = train(diagnosis ~.,data=training, preProcess = c("center", "scale"), method="glm")

# mapper function
predict.mapper<- function(train, test){
  predict.result = keyval(1, predict(train,test))
}

# reducer function
predict.reducer <- function(v){
  Mode <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
  }
  require(dplyr)
  result <- v %>% 
    group_by(key) %>% 
    summary(Mode(value))
}

mapred.result = mapreduce(input = "fileurl",
                          input.format ="csv",
                          output.format = "text",
                          map = predict.mapper,
                          reduce = predict.reducer)

mapred.result.data = from.dfs(mapred.result(), format = "text")


