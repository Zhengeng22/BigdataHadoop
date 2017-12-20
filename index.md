## Hadoop for Big data

### What is Hadoop?

Hadoop is an open source, Java-based programming framework that supports the processing and storage of extremely large datasets in a distributed computing environment. It is part of the Apache project sponsored by the Apache Software Foundation.


![alt text](https://www.sas.com/content/sascom/en_us/insights/big-data/hadoop/_jcr_content/par/styledcontainer_8bf1/par/image_8ed0.img.png/1499696730997.png)

### what is MapReduce

MapReduce – a parallel processing software framework. It is comprised of two steps. Map step is a master node that takes inputs and partitions them into smaller subproblems and then distributes them to worker nodes. After the map step has taken place, the master node takes the answers to all of the subproblems and combines them to produce output

![alt text](https://user-images.githubusercontent.com/33737176/34189340-f10b2958-e508-11e7-92c4-d994a5439dab.png)

<center>Hadoop Distributed File System (HDFS)</center> 

The Hadoop Distributed File System (HDFS) is a distributed file system designed to run on commodity hardware. 
HDFS is highly fault-tolerant and is designed to be deployed on low-cost hardware. HDFS provides high throughput access to application data and is suitable for applications that have large data sets. It relaxes a few POSIX requirements to enable streaming access to file system data.

![alt text](https://user-images.githubusercontent.com/33737176/34227870-b2cee500-e59c-11e7-8514-6b240d9c5ce6.png)
                                          





### Set up with Hadoop

1.Download the platform Virtual Box from Cloudera VMs:

link:[Cloudera downloads](https://www.cloudera.com/downloads/quickstart_vms/5-12.html)

2.Select “Virtual Box” and then click on “get it now”.
And it will ask you to fill out some information about you or sign in. After that, agree with the contract. And it will start downloading the Virtual Box.

![alt text](https://user-images.githubusercontent.com/33737176/34186822-fd5cfdd8-e4fb-11e7-8285-2bf4bc1f2b80.png)

3.Unzip the file, you will see two file under the folder

![alt text](https://user-images.githubusercontent.com/33737176/34188005-21e31c90-e502-11e7-970f-9a64ca8e5642.png)


4.Download the VirtualBox

[VirtualBox](https://www.virtualbox.org/wiki/Downloads)
select OS X hosts for mac user.

![alt text](https://user-images.githubusercontent.com/33737176/34188396-1dc92544-e504-11e7-9beb-f19934f90ca0.png)


This is the VirtualBox interface looklike:
![alt text](https://user-images.githubusercontent.com/33737176/34189588-33025a7e-e50a-11e7-99df-e806e611fc14.png)



5.Then slecte "File" --> "import Application" to import "cloudera-quickstart-vm-5.12.0-0-virtualbox.ovf" 
![alt text](https://user-images.githubusercontent.com/33737176/34227725-286dfed2-e59c-11e7-9885-89fc6a01169f.png)



### How to Install RStudio Server on CentOS
(RStudio Server is the web edition of RStudio which is a series of tools designed to facilitate the coding job using the R programming language.)

##### Step 1: Update the system
Log in as a sudo user, and then execute the below commands:
```
sudo yum install epel-release
sudo yum update
sudo shutdown -r now
```

##### Step 2: Install R
```
sudo yum install R -y
```

##### Step 3: Install RStudio Server
Install the latest stable release of RStudio Server. 
```
cd
wget https://download2.rstudio.org/rstudio-server-rhel-1.0.136-x86_64.rpm
sudo yum install --nogpgcheck rstudio-server-rhel-1.0.136-x86_64.rpm -y
```
Note: find the latest release of RStudio Server from this webset: [official download page](https://www.rstudio.com/products/rstudio/download-server/)

##### Step 4: Access RStudio Server from a web browser
```
sudo firewall-cmd --permanent --zone=public --add-port=8787/tcp
sudo firewall-cmd --reload
```























### Project abstract  

Data source:
[Breast Cancer Wisconsin (Diagnostic) Data Set](https://www.kaggle.com/uciml/breast-cancer-wisconsin-data/data)
This data source is use to predict whether the cancer is benign or malignant



### Build Prediction Model in R 

##### Load Data:
```
require(caret)
require(mlbench)

# load the data
cancerData <- read.csv("data.csv", sep = ",", header = T)

```


##### Feature selection:
```
set.seed(123)

# calculate correlation matrix
correlationMatrix <- cor(cancerData[,3:32])

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

```

##### The list of chosen features and Plot of features by accuracy
```
predictors(results)
plot(results, type=c("g", "o"))

```

##### Subsetting the data using the selected features
```
features <- predictors(results)
newdata <- cancerData[, features]
newdata$diagnosis <- cancerData$diagnosis

```

##### Partition the data into training and testing being 70% and 30% resoectively.
```
inTrain <- createDataPartition(y = newdata$diagnosis ,
                               p=0.7, list=FALSE)
training <- newdata[inTrain,]
testing <- newdata[-inTrain,]
dim(training)

```

##### Generalized Linear Model
``` 
set.seed(323)
modelFit1 <- train(diagnosis ~.,data=training, preProcess = c("center", "scale"), method="glm")
pred1 <- predict(modelFit1,newdata=testing)
confusionMatrix(pred1,testing$diagnosis)
```










Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).


### Jekyll Themes
```


```



### Support or Contact

Having trouble with Pages? Check out our [documentation](https://help.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.
