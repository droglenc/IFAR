# User must set working directory appropriately.

##############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
# 
# Setup of knitr
source("../../rhelpers/knitr_setup.R")
# declare packages used
rqrd <- c("FSA","magrittr","dplyr","lubridate","car","captioner","knitr")
# setup figure, table, and equation captioning
library(captioner)
figcaps <- captioner(prefix="Figure")
figcaps("SumLength","Proportion of female Yelloweye Rockfish that were mature at each 2-cm length category.")
figcaps("LogisticFit1","Fitted logistic regression for proportion of female Yelloweye Rockfish mature by total length.")
figcaps("LogisticFit2","Fitted logistic regression for proportion of female Yelloweye Rockfish mature by total length with $L_{50}$ shown.")

tabcaps <- captioner(prefix="Table")
tabcaps("SubsetModels","The submodels by capture year represented by the full model.")

eqncaps <- captioner(prefix="Equation")
eqncaps("LogisticPredict")
eqncaps("LogisticReverseGnrl")
eqncaps("LogisticReverse50")
# == END -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
##############################################################

library(FSA)
library(magrittr)
library(dplyr)
library(lubridate)
library(car)

df <- read.csv("YERockfish.csv")
str(df)

df %<>% mutate(date=as.POSIXct(date,format="%m/%d/%Y"))
str(df)

df %<>% mutate(year=year(date),
               era=factor(ifelse(year<2002,"pre-2002","2002 and after")))
headtail(df)

df %<>% mutate(lcat2=lencat(length,w=2))
headtail(df)

freq <- xtabs(~lcat2+maturity,data=df)
props <- prop.table(freq,margin=1)
round(props,1)   # for display only
plot(props[,"Mature"]~as.numeric(rownames(props)),pch=19,
     xlab="Total Length (cm)",ylab="Proportion Mature")

glm1 <- glm(maturity~length,data=df,family=binomial)

bcL <- bootCase(glm1,B=100)  # B should be nearer to 1000
cbind(Ests=coef(glm1),confint(bcL))

predict(glm1,data.frame(length=c(32,42)),type="response")

predP <- function(cf,x) exp(cf[1]+cf[2]*x)/(1+exp(cf[1]+cf[2]*x))
p32 <- apply(bcL,1,predP,x=32)
quantile(p32,c(0.025,0.975))

##############################################################
# This code is redundant with the code above and was used
# only for producing the supplement.
plot((as.numeric(maturity)-1)~length,data=df,
     pch=19,col=rgb(0,0,0,1/8),
     xlab="Total Length (cm)",ylab="Proportion Mature")
points(props[,"Mature"]~as.numeric(rownames(props)),pch=3)
lens <- seq(30,70,length.out=99)
preds <- predict(glm1,data.frame(length=lens),type="response")
lines(preds~lens,lwd=2)
##############################################################

lrPerc <- function(cf,p) (log(p/(1-p))-cf[[1]])/cf[[2]]

( L50 <- lrPerc(coef(glm1),0.5) )
( L90 <- lrPerc(coef(glm1),0.9) )

bL50 <- apply(bcL,1,lrPerc,p=0.5)
( L50ci <- quantile(bL50,c(0.025,0.975)) )
bL90 <- apply(bcL,1,lrPerc,p=0.9)
( L90ci <- quantile(bL90,c(0.025,0.975)) )

##############################################################
# This code is redundant with the code above and was used
# only for producing the supplement.
plot((as.numeric(maturity)-1)~length,data=df,
     pch=19,col=rgb(0,0,0,1/8),
     xlab="Total Length (cm)",ylab="Proportion Mature")
points(props[,"Mature"]~as.numeric(rownames(props)),pch=3)
lens <- seq(30,70,length.out=99)
preds <- predict(glm1,data.frame(length=lens),type="response")
lines(preds~lens,lwd=2)
lines(c(0,L50),c(0.5,0.5),lty=2,lwd=2,col="red")
lines(c(L50,L50),c(-0.2,0.5),lty=2,lwd=2,col="red")
##############################################################


# Script created at 2015-10-18 12:27:25
