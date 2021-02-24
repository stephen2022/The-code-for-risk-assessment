
# SVM for Risk Assessment from Stephen in Oct.2021

library(e1071)
library(openxlsx)
set.seed(1234)

#data reading
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
# Parameter Settings
tuned <- tune.svm(CC~., data=train_data,
                  gamma=10^(-6:1),
                  cost=10^(-10:10))
tuned
#Data model
trust.svm <- svm(CC~., data=train_data,gamma=0.1,cost=10)
trust.svm

#Model predicted
svm.pred <- predict(trust.svm, na.omit(test_data))
svm.perf <- table(na.omit(test_data)$CC,
                    svm.pred, dnn=c("Actual", "Predicted"))
svm.perf

#Draw the ROC curve
library(pROC) 
ran_roc <- roc(test_data$CC,as.numeric(svm.pred))
plot(ran_roc, print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),grid.col=c("green", "red"), max.auc.polygon=TRUE,auc.polygon.col="skyblue", print.thres=TRUE,main='ROC of SVM for data12')

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
performance(svm.perf)


