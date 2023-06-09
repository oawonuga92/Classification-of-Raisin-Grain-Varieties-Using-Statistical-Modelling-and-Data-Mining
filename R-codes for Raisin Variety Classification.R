#install.packages('Hmisc')
#install.packages('moments')
library(Hmisc)
library(GGally)
library(ggplot2)
library(caret)



# # LOADNG THE DATASET INTO THE TEMPORARY VARIABLE FOR STATISTICAL SUMMARY
raisin_df.summary <- read.csv("C:/Users/mds22awo/Documents/New folder/Raisin_Dataset.csv")
raisin_df.reuse <- raisin_df.summary
dim(raisin_df.summary)
table(raisin_df.summary$Class)
raisin_df.summary$Class = as.factor(raisin_df.summary$Class)
head(raisin_df.summary[1:8])
head(raisin_df.summary[856:900,])
is.null(raisin_df.summary)
str(raisin_df.summary)



# LOADNG THE DATASET INTO A VARIABLE FOR STATISTICAL ANALYSIS. THIS VARIABLE WILL BE USED FOR THE REMAINDER OF THE PROJECT
raisin_df <- read.csv("C:/Users/mds22awo/Documents/New folder/Raisin_Dataset.csv")

raisin_df$Class <-ifelse(raisin_df$Class =="Kecimen",1,0) # Transform the raisin class labels to binary outcomes
raisin_df$Area = as.numeric(raisin_df$Area)
raisin_df$ConvexArea = as.numeric(raisin_df$ConvexArea)
raisin_df.reuse <- raisin_df
raisin_df$Class = as.factor(raisin_df$Class)
raisin_df <- as.data.frame(raisin_df)



# CALCULATE THE STANDARD DEVIATION AND MEAN OF RAISIN GROUPS
set.seed(123)
summary(raisin_df)
sapply(split(raisin_df$Area, raisin_df$Class), sd)
sapply(split(raisin_df$ConvexArea, raisin_df$Class), sd)
sapply(split(raisin_df$Perimeter, raisin_df$Class), sd)
sapply(split(raisin_df$MajorAxisLength, raisin_df$Class), sd)
sapply(split(raisin_df$MinorAxisLength, raisin_df$Class), sd)
sapply(split(raisin_df$Eccentricity, raisin_df$Class), sd)
sapply(split(raisin_df$Extent, raisin_df$Class), sd)

sapply(split(raisin_df$Area, raisin_df$Class), mean)
sapply(split(raisin_df$ConvexArea, raisin_df$Class), mean)
sapply(split(raisin_df$Perimeter, raisin_df$Class), mean)
sapply(split(raisin_df$MajorAxisLength, raisin_df$Class), mean)
sapply(split(raisin_df$MinorAxisLength, raisin_df$Class),mean)
sapply(split(raisin_df$Eccentricity, raisin_df$Class), mean)
sapply(split(raisin_df$Extent, raisin_df$Class), mean)



# ANOVA OF EACH RAISIN FEATURE TO FIND VARIATION IN MEAN VALUES
plot(Class ~ ConvexArea, data = raisin_df)
aov(Area ~ Class, data = raisin_df)

raisin_df.area <- aov(Area ~ Class, data = raisin_df)
summary(raisin_df.area)

raisin_df.ca <- aov(ConvexArea ~ Class, data = raisin_df)
summary(raisin_df.ca)

raisin_df.per <- aov(Perimeter ~ Class, data = raisin_df)
summary(raisin_df.per)

raisin_df.majaxl <- aov(MajorAxisLength ~ Class, data = raisin_df)
summary(raisin_df.majaxl)

raisin_df.minaxl <- aov(MinorAxisLength ~ Class, data = raisin_df)
summary(raisin_df.minaxl)

raisin_df.ecc <- aov(Eccentricity ~ Class, data = raisin_df)
summary(raisin_df.ecc)

raisin_df.ext <- aov(Extent ~ Class, data = raisin_df)
summary(raisin_df.ext)

raisin_df.all <- aov(Area + ConvexArea + Perimeter + MajorAxisLength + MinorAxisLength + Eccentricity
                     + Extent ~ Class, data = raisin_df)
summary(raisin_df.all)



# SPEARMAN CORRRELATION BETWEEN EACH VARIABLE AND TARGET CLASS
raisin.df.cor <- read.csv('C:/Users/mds22awo/Documents/New folder/Raisin_Dataset.csv')
raisin.df.cor$Class <-ifelse(raisin.df.cor$Class =="Kecimen",1,0)
raisin.df.cor$Area <- as.numeric(raisin.df.cor$Area)
raisin.df.cor$ConvexArea <- as.numeric(raisin.df.cor$ConvexArea)
str(raisin.df.cor)
cor(raisin.df.cor$Area, raisin.df.cor$Class, method = c("spearman"))
cor(raisin.df.cor$ConvexArea,raisin.df.cor$Class, method = c("spearman"))
cor(raisin.df.cor$Perimeter, raisin.df.cor$Class, method = c("spearman"))
cor(raisin.df.cor$MajorAxisLength,raisin.df.cor$Class, method = c("spearman"))
cor(raisin.df.cor$MinorAxisLength, raisin.df.cor$Class, method = c("spearman"))
cor(raisin.df.cor$Eccentricity, raisin.df.cor$Class, method = c("spearman"))
cor(raisin.df.cor$Extent, raisin.df.cor$Class, method = c("spearman"))





# To check pair waise correlation among variables, skewness, scatterplot matrix
# THE GGPAIRS FUNCTION USED TO CALCULATE SCATTERPLOT MATRIX, SKEWNESS, KURTOSIS AND RAISIN GROUP MEDIAN MEASUREMENTS
# correlation and skewness of all variables ( continous data)
ggpairs(raisin_df, 
       columns = 1:8, # select columns to plot
       upper = list(continuous = wrap("cor", method = "spearman")), # add correlation coefficients
       lower = list(continuous = wrap("points", alpha = 0.3, size = 0.5))) + # add scatterplots
  theme_bw() # apply a clean black and white theme

# spearman correlation with each variable and outcome class ( continous data)
ggpairs(raisin_df.reuse, 
        columns = 1:8, # select columns to plot
        upper = list(continuous = wrap("cor", method = "spearman")), # add correlation coefficients
        lower = list(continuous = wrap("points", alpha = 0.3, size = 0.5))) + # add scatterplots
  theme_bw() # apply a clean black and white theme


# SKEWNESS AND KURTOSIS
library(moments)
raisin_df1 <- raisin_df
skewness(raisin_df1[-8])
kurtosis(raisin_df1[-8])



# CORRELATION P-VALUE TEST FOR ALL THE VARIABLES
library(Hmisc)
res <- rcorr(as.matrix(raisin_df[c(-8)])) # rcorr() accepts matrices only
# display p-values (rounded to 3 decimals)
round(res$P, 15)


# CALCULATE VARIABLE IMPORTANCE USING RANDOM FOREST CLASSIFIER
raisin.vaimp <- read.csv('C:/Users/mds22awo/Documents/New folder/Raisin_Dataset.csv')
library(caret)
library(dplyr)
library(randomForest)

raisin.vaimp$Area = as.numeric(raisin.vaimp$Area)
raisin.vaimp$ConvexArea = as.numeric(raisin.vaimp$ConvexArea)
raisin.vaimp$Class = as.factor(raisin.vaimp$Class)
raisin.vaimp <- as.data.frame(raisin.vaimp)
rrfmod <- train(Class ~ ., data = raisin.vaimp, method = "RRF")
rrfImp <- varImp(rrfmod)
rrfImp
plot(rrfImp, top = 7)


# Normalize the Data in preparation for modelling
library(dplyr)
raisin_df <- raisin_df %>% mutate(across(c(1:7), ~ (.-min(.)) / (max(.) - min(.))))
str(raisin_df)


# SUMMARY OF THE UNIVARIATE LOGISTIC REGRESSION MODEL FOR 5 FEATURES
#install.packages("corrr")
library(MASS)
set.seed(12345)
raisin.df.shuffle <- raisin_df[sample(nrow(raisin_df)),]
raisin.df.shuffle <- as.data.frame(raisin.df.shuffle)
logitmodel1 <- glm(formula = Class ~ Area, data=raisin.df.shuffle, family=binomial)
summary(logitmodel1)

logitmodel2 <- glm(formula = Class ~ Perimeter, data=raisin.df.shuffle, family=binomial)
summary(logitmodel2)

logitmodel3 <- glm(formula = Class ~ MinorAxisLength , data=raisin.df.shuffle, family=binomial)
summary(logitmodel3)

logitmodel4 <- glm(formula = Class ~ Eccentricity, data=raisin.df.shuffle, family=binomial)
summary(logitmodel4)

logitmodel5 <- glm(formula = Class ~ MajorAxisLength, data=raisin.df.shuffle, family=binomial)
summary(logitmodel5)

logitmodel6 <- glm(formula = Class ~ Extent, data=raisin.df.shuffle, family=binomial)
summary(logitmodel6)

logitmodel7 <- glm(formula = Class ~ ConvexArea, data=raisin.df.shuffle, family=binomial)
summary(logitmodel7)

# THE ODDS RATEIO CALCULATED FOR EACH OF THE 5 UNIVARIATE LOGISTIC REGRESSION MODEL
exp(cbind(coef(logitmodel1), confint(logitmodel1)))
exp(cbind(coef(logitmodel2), confint(logitmodel2)))
exp(cbind(coef(logitmodel3), confint(logitmodel3)))
exp(cbind(coef(logitmodel4), confint(logitmodel4)))
exp(cbind(coef(logitmodel5), confint(logitmodel5)))
exp(cbind(coef(logitmodel6), confint(logitmodel6)))
exp(cbind(coef(logitmodel7), confint(logitmodel7)))



# BI-VARIATE AND MULTIVARIATE MODEL EVALUATION
set.seed(12345)

model.1 <- glm(formula = Class ~ Perimeter +  Extent , data = raisin.df.shuffle, family=binomial)
summary(model.1)

model.2 <- glm(formula = Class ~ MajorAxisLength + Extent , data = raisin.df.shuffle, family=binomial)
summary(model.2)

model.3 <- glm(formula = Class ~ Perimeter + Extent + Eccentricity , data = raisin.df.shuffle, family=binomial)
summary(model.3)

model.4 <- glm(formula = Class ~ MajorAxisLength + Extent + Eccentricity , data = raisin.df.shuffle, family=binomial)
summary(model.4)

# THE ODDS RATIO CALCULATED FOR EACH OF THE 4 MULTIVARIATE LOGISTIC REGRESSION MODEL
set.seed(12345)
exp(cbind(coef(model.1), confint(model.1)))
exp(cbind(coef(model.2), confint(model.2)))
exp(cbind(coef(model.3), confint(model.3)))
exp(cbind(coef(model.4), confint(model.4)))



# USING AKAIKE CRITERION TECHNIQUE TO SLECET THE BEST FIT MODEL FOR CLASSIFYING RAISIN VARIETIES
library(aic)
library(AICcmodavg)
model_list <- list(model.1, model.2, model.3, model.4)
model.list <- c('model.1', 'model.2', 'model.3', 'model.4')
aictab(model_list, modnames = model.list)



# USING A KNN CLASSIFIER TO TEST CLASSIFICATION ACCURACY OF THE AIC BEST FIT MODEL 
training.samples <- raisin.vaimp$Class %>% 
  createDataPartition(p = 0.8, list = FALSE)
train.data <- raisin.vaimp[training.samples, ]
test.data <- raisin.vaimp[-training.samples, ]

MdlKnn <- train(Class ~ Perimeter + Eccentricity +Extent, train.data, method="knn", trControl=trainControl(method="cv"))
Knn_Predictions <- predict(MdlKnn,test.data)
table(Knn_Predictions,test.data$Class)

