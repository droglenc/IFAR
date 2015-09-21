# User must set working directory appropriately.

##############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
# 
# Setup of knitr
source("../knitr_setup.R")
# declare packages used
rqrd <- c("FSA","dplyr","nlstools","minpack.lm","captioner","knitr")
# setup figure, table, and equation captioning
library(captioner)
figcaps <- captioner(prefix="Figure")
figcaps("","")
# == END -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
##############################################################

library(FSA)
library(dplyr)
library(nlstools)
library(minpack.lm)

bdmf <- read.csv("BlackDrum2001.csv") %>%
  select(-c(spname,day,weight)) %>%
  filterD(sex %in% c("male","female"),otoage<50)
bdm <- filterD(bdmf,sex=="male")
headtail(bdm)

vbTyp <- vbFuns()
svTyp <- list(Linf=1193,K=0.13,t0=-2.0)
fitLM <- nlsLM(tl~vbTyp(otoage,Linf,K,t0),data=bdm,start=svTyp)
bootLM <- nlsBoot(fitLM)
cbind(Ests=coef(fitLM),confint(bootLM))
predict(bootLM,vbTyp,t=3)

fitLM1 <- nlsLM(tl~vbTyp(otoage,Linf,K,t0),data=bdm,start=svTyp,
               lower=c(Linf=1,K=0.0001,t0=-Inf),
               upper=c(Linf=Inf,K=Inf,t0=Inf))
bootLM1 <- nlsBoot(fitLM1)
cbind(Ests=coef(fitLM1),confint(bootLM1))

fitP <- nls(tl~vbTyp(otoage,Linf,K,t0),data=bdm,start=svTyp,
            algorithm="port",
            lower=c(Linf=1,K=0.0001,t0=-Inf),
            upper=c(Linf=Inf,K=Inf,t0=Inf))
bootP <- nlsBoot(fitP)
cbind(Ests=coef(fitP),confint(bootP))


# Script created at 2015-09-21 18:25:53
