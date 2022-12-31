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
figcaps("SumLength","Proportion of female Yelloweye Rockfish that were mature in each 2-cm length category.")
figcaps("LogisticFit1","Fitted logistic regression for the proportion of female Yelloweye Rockfish that are mature by total length.")
figcaps("LogisticFit2","Fitted logistic regression for the proportion of female Yelloweye Rockfish that are mature by total length with $L_{50}$ shown.")
figcaps("LogisticFit3",'Fitted logistic regression for the proportion of female Yelloweye Rockfish that are mature by total length separated by the "pre-2002" and "2002 and after" eras.')

eqncaps <- captioner(prefix="Equation")
eqncaps("LogisticModel")
eqncaps("LogisticPredict")
eqncaps("LogisticReverseGnrl")
eqncaps("LogisticReverse50")

set.seed(534234789)  # for reproducibility
# == END -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
##############################################################

library(FSA)
library(magrittr)
library(dplyr)
library(lubridate)
library(car)

##############################################################
df <- read.csv("https://raw.githubusercontent.com/droglenc/FSAdata/master/data-raw/YERockfish.csv")
##############################################################

str(df)

headtail(df)

df %<>% mutate(date=as.POSIXct(date,format="%m/%d/%Y"))
str(df)

df %<>% mutate(year=year(date),
               era=ifelse(year<2002,"pre-2002","2002 and after"),
               era=factor(era,levels=c("pre-2002","2002 and after")))
headtail(df)

df %<>% filterD(!is.na(maturity))

df %<>% mutate(lcat2=lencat(length,w=2))
headtail(df)

freq <- xtabs(~lcat2+maturity,data=df)
props <- prop.table(freq,margin=1)
round(props,3)   # for display only
plot(props[,"Mature"]~as.numeric(rownames(props)),pch=19,
     xlab="Total Length (cm)",ylab="Proportion Mature")

glm1 <- glm(maturity~length,data=df,family=binomial)

bcL <- bootCase(glm1,B=1000)
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

df2 <- df %>%
  group_by(length) %>%
  summarize(pmat=mean(as.numeric(maturity)-1),
            n=n()) %>%
  as.data.frame()
headtail(df2)

glm2 <- glm(pmat~length,data=df2,family=binomial,weights=n)
bcL2 <- bootCase(glm2,B=1000)
cbind(Ests=coef(glm2),confint(bcL2))
predict(glm2,data.frame(length=c(32,42)),type="response")
p32a <- apply(bcL2,1,predP,x=32)
quantile(p32a,c(0.025,0.975))

glm3 <- glm(maturity~length*era,data=df,family=binomial)

Anova(glm3)

coef(glm3)

levels(df$era)

bcL3 <- bootCase(glm3,B=1000)  
headtail(bcL3)

L50.pre= apply(bcL3[,1:2],1,lrPerc,p=0.5)
L50.post=apply(bcL3[,1:2]+bcL3[,3:4],1,lrPerc,p=0.5)

L50.diff <- L50.pre-L50.post

( p.L50.diff <- 2*min(c(mean(L50.diff>0),mean(L50.diff<0))) )

( ci.L50.diff <- quantile(L50.diff,c(0.025,0.975)) )
( ci.L50.pre <-  quantile(L50.pre,c(0.025,0.975)) )
( ci.L50.post <- quantile(L50.post,c(0.025,0.975)) )

clrs1 <- c("black","red")
clrs2 <- col2rgbt(clrs1,1/5)
lvls <- levels(df$era)
lens <- seq(30,70,length.out=99)
pa02 <- predict(glm3,type="response",
                data.frame(length=lens,era=factor("2002 and after",levels=lvls)))
pp02 <- predict(glm3,type="response",
                data.frame(length=lens,era=factor("pre-2002",levels=lvls)))
plot((as.numeric(maturity)-1)~length,data=filterD(df,era==lvls[1]),
     pch=19,col=clrs2[1],xlab="Total Length (cm)",ylab="Proportion Mature")
points((as.numeric(maturity)-1)~length,data=filterD(df,era==lvls[2]),
     pch=19,col=clrs2[2])
lines(pa02~lens,lwd=2,col=clrs1[1])
lines(pp02~lens,lwd=2,col=clrs1[2])


# Script created at 2015-11-06 17:17:10
