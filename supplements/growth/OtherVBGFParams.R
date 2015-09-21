# User must set working directory appropriately.

##############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
# 
# Setup of knitr
source("../knitr_setup.R")
# declare packages used
rqrd <- c("FSA","magrittr","dplyr","nlstools","AICcmodavg","(minpack.lm","captioner","knitr")
# setup figure, table, and equation captioning
library(captioner)
figcaps <- captioner(prefix="Figure")
figcaps("","")

tabcaps <- captioner(prefix="Table")

eqncaps <- captioner(prefix="Equation")
eqncaps("BackCalcESL")
eqncaps("BackCalcELS")
eqncaps("BackCalcDahlLea")
eqncaps("BackCalcFraserLee")
eqncaps("BackCalcSPHLinear")
eqncaps("BackCalcBPHLinear")
# == END -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
##############################################################

library(FSA)
library(magrittr)
library(dplyr)
library(nlstools)
library(AICcmodavg)
library(minpack.lm)

bdmf <- read.csv("BlackDrum2001.csv") %>%
  select(-c(spname,day,weight)) %>%
  filterD(sex %in% c("male","female"),otoage<50)
bdm <- filterD(bdmf,sex=="male")
headtail(bdm)

( vbF <- vbFuns("Francis") )

( ages <- range(bdm$otoage) )

( svF <- vbStarts(tl~otoage,data=bdm,type="Francis",ages2use=ages) )

nlsF <- nls(tl~vbF(otoage,L1,L2,L3,t1=ages),data=bdm,start=svF)
cbind(Ests=coef(nlsF),confint(nlsF))
bootF <- nlsBoot(nlsF)
cbind(Ests=coef(nlsF),confint(bootF))
predict(bootF,vbF,t=3,t1=ages)

summary(nlsF,correlation=TRUE)

l1 <- logisticFuns()
g1 <- GompertzFuns()
r1 <- RichardsFuns()

plot(tl~otoage,data=bdm,pch=19,col=rgb(0,0,0,1/4))
svR1 <- list(Linf=1200,k=0.1,a=1.1,b=0.4)
curve(r1(x,unlist(svR1)),from=3,to=42,add=TRUE,lwd=2)

# ############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
plot(tl~otoage,data=bdm,pch=19,col=rgb(0,0,0,1/4))
svG1 <- list(Linf=1250,gi=0.15,ti=2)
curve(g1(x,unlist(svG1)),from=3,to=42,add=TRUE,lwd=2)
plot(tl~otoage,data=bdm,pch=19,col=rgb(0,0,0,1/4))
svL1 <- list(Linf=1250,gninf=0.15,ti=4)
curve(l1(x,unlist(svL1)),from=3,to=42,add=TRUE,lwd=2)
# == END -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =======
# ############################################################

svG1 <- list(Linf=1250,gi=0.15,ti=2)
svL1 <- list(Linf=1250,gninf=0.15,ti=4)

nlsR1 <- nls(tl~r1(otoage,Linf,k,a,b),data=bdm,start=svR1)
bootR1 <- nlsBoot(nlsR1)
cbind(Ests=coef(nlsR1),confint(bootR1))
predict(bootR1,r1,t=3)

nlsG1 <- nls(tl~g1(otoage,Linf,gi,ti),data=bdm,start=svG1)
nlsL1 <- nls(tl~l1(otoage,Linf,gninf,ti),data=bdm,start=svL1)

aictab(list(nlsF,nlsL1,nlsG1,nlsR1),c("VBGF","logistic","Gompertz","Richards"))

plot(tl~otoage,data=bdm,pch=19,col=rgb(0,0,0,1/4))
curve(r1(x,coef(nlsR1)),from=3,to=42,add=TRUE,lwd=4)
curve(vbF(x,coef(nlsF),t1=ages),from=3,to=42,add=TRUE,lwd=2,
      col="blue")
curve(g1(x,coef(nlsG1)),from=3,to=42,add=TRUE,col="red")
curve(l1(x,coef(nlsL1)),from=3,to=42,add=TRUE,col="orange")

lmR1 <- nlsLM(tl~r1(otoage,Linf,k,a,b),data=bdm,start=svR1)
bootlmR1 <- nlsBoot(lmR1)
cbind(Ests=coef(lmR1),confint(bootlmR1))
predict(bootlmR1,r1,t=3)

lmR1b <- nlsLM(tl~r1(otoage,Linf,k,a,b),data=bdm,start=svR1,
               lower=c(Linf=1,K=0.0001,a=0.0001,b=0.0001),
               upper=c(Linf=Inf,K=Inf,a=Inf,b=Inf))
bootlmR1b <- nlsBoot(lmR1b)
cbind(Ests=coef(lmR1b),confint(bootlmR1b))

nlsR1c <- nls(tl~r1(otoage,Linf,k,a,b),data=bdm,start=svR1,
              algorithm="port",
              lower=c(Linf=1,K=0.0001,a=0.0001,b=0.0001),
              upper=c(Linf=Inf,K=Inf,a=Inf,b=Inf))
bootnlsR1c <- nlsBoot(nlsR1c)
cbind(Ests=coef(nlsR1c),confint(bootnlsR1c))


# Script created at 2015-09-21 17:04:59
