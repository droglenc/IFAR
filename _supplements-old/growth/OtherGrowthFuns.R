# User must set working directory appropriately.

##############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
# 
# Setup of knitr
source("../../rhelpers/knitr_setup.R")
# declare packages used
rqrd <- c("FSA","dplyr","nlstools","AICcmodavg","captioner","knitr")
# setup figure, table, and equation captioning
library(captioner)
figcaps <- captioner(prefix="Figure")
figcaps("RichardsStarts","Richards growth function evaluated at potential starting values superimposed on the length-at-age data for male Black Drum.")
figcaps("OtherGFCompare","Fitted models for the von Bertalanffy (black), Richards (blue), Gompertz (red), and logistic (orange) growth functions fit to the male Black Drum data.")
# == END -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
##############################################################

library(FSA)
library(dplyr)
library(nlstools)
library(AICcmodavg)

bdmf <- read.csv("BlackDrum2001.csv") %>%
  select(-c(spname,day,weight)) %>%
  filterD(sex %in% c("male","female"),otoage<50)
bdm <- filterD(bdmf,sex=="male")
headtail(bdm)

l1 <- logisticFuns()
g1 <- GompertzFuns()
r1 <- RichardsFuns()

plot(tl~otoage,data=bdm,pch=19,col=rgb(0,0,0,1/4),
     xlab="Otolith Age",ylab="Total Length (mm)")
svR1 <- list(Linf=1200,k=0.1,a=1.1,b=0.4)
curve(r1(x,unlist(svR1)),from=3,to=42,add=TRUE,lwd=2)

# ############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR SCRIPT ONLY =======
plot(tl~otoage,data=bdm,pch=19,col=rgb(0,0,0,1/4))
svG1 <- list(Linf=1250,gi=0.15,ti=2)
curve(g1(x,unlist(svG1)),from=3,to=42,add=TRUE,lwd=2)
plot(tl~otoage,data=bdm,pch=19,col=rgb(0,0,0,1/4))
svL1 <- list(Linf=1250,gninf=0.15,ti=4)
curve(l1(x,unlist(svL1)),from=3,to=42,add=TRUE,lwd=2)
# == END -- NOT SHOWN IN SUPPLEMENT, FOR SCRIPT ONLY =========
# ############################################################

svG1 <- list(Linf=1250,gi=0.15,ti=2)
svL1 <- list(Linf=1250,gninf=0.15,ti=4)

fitR1 <- nls(tl~r1(otoage,Linf,k,a,b),data=bdm,start=svR1)
bootR1 <- nlsBoot(fitR1)
cbind(Ests=coef(fitR1),confint(bootR1))
predict(bootR1,r1,t=3)

vbTyp <- vbFuns()
svTyp <- list(Linf=1193,K=0.13,t0=-2.0)
fitTyp <- nls(tl~vbTyp(otoage,Linf,K,t0),data=bdm,start=svTyp)
fitG1 <- nls(tl~g1(otoage,Linf,gi,ti),data=bdm,start=svG1)
fitL1 <- nls(tl~l1(otoage,Linf,gninf,ti),data=bdm,start=svL1)

aictab(list(fitTyp,fitL1,fitG1,fitR1),c("VBGF","logistic","Gompertz","Richards"))

plot(tl~otoage,data=bdm,pch=19,col=rgb(0,0,0,1/4),
     xlab="Otolith Age",ylab="Total Length (mm)")
curve(vbTyp(x,coef(fitTyp)),from=3,to=42,add=TRUE,lwd=6)
curve(r1(x,coef(fitR1)),from=3,to=42,add=TRUE,lwd=4,col="blue")
curve(g1(x,coef(fitG1)),from=3,to=42,add=TRUE,lwd=2,col="red")
curve(l1(x,coef(fitL1)),from=3,to=42,add=TRUE,col="orange")


# Script created at 2015-11-06 09:26:06
