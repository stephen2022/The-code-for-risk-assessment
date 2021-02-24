  
# RF for Risk Assessment from Stephen in Oct.2021

  library(randomForest)
  library(openxlsx)
  library(VIM)
  trust= read.xlsx("C:/Users/Ashley/Desktop/HXbank_DataA/E_Data12.xlsx")
  
  #Data factor preprocessing
  trust$CC=as.factor(trust$CC)
  trust$BS=as.factor(trust$BS)
  trust$IC=as.factor(trust$IC)
  trust$ES=as.factor(trust$ES)
  trust$CS=as.factor(trust$CS)
  trust$DIS=as.factor(trust$DIS)
  
  train_sub = sample(nrow(trust),6/10*nrow(trust))
  train_data = trust[train_sub,]
  test_data = trust[-train_sub,]
  
  #data model
  trust_randomforest <- randomForest(CC ~.,
                                             data = train_data,
                                             ntree =600,
                                             mtry=3,
                                             importance=TRUE,
                                             proximity=TRUE)
  trust_randomforest
  
   #Check the importance of variables
  trust_randomforest$importance
  varImpPlot(trust_randomforest, main = "variable importance")
  #Test set data prediction
  pre_ran <- predict(trust_randomforest,newdata=test_data)
  obs_p_ran = data.frame(prob=pre_ran,obs=test_data$CC)
  #Output confusion matrix
  confusion <- table(test_data$CC,pre_ran,dnn=c("Actual","Predicted"))
  confusion
  
  #Draw the ROC curve
  library(pROC) 
  ran_roc <- roc(test_data$CC,as.numeric(pre_ran))
  plot(ran_roc, print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),grid.col=c("green", "red"), max.auc.polygon=TRUE,auc.polygon.col="skyblue", print.thres=TRUE,main='ROC of RF for data12,mtry=3,ntree=600')
  # Map distribution
  MDSplot(trust_randomforest,trust$CC,k=2,palette=NULL,pch=20,xlab="",ylab="")
  #Out the evaluation index
  performance <- function(table, n=2){
    if(!all(dim(table) == c(2,2)))
      stop("Must be a 2 x 2 table")
    tn = table[1,1]
    fp = table[1,2]
    fn = table[2,1]
    tp = table[2,2]
    sensitivity = tp/(tp+fn)
    specificity = tn/(tn+fp)
    ppp = tp/(tp+fp)
    npp = tn/(tn+fn)
    hitrate = (tp+tn)/(tp+tn+fp+fn)
    result <- paste("recall = ", round(sensitivity, n) ,
                    "\nSpecificity = ", round(specificity, n),
                    "\nPositive= ", round(ppp, n),
                    "\nNegative = ", round(npp, n),
                    "\nAccuracy = ", round(hitrate, n), "\n", sep="")
    cat(result)
  }
  performance(confusion)
 
  
  