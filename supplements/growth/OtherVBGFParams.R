# User must set working directory appropriately.

##############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
# 
# Setup of knitr
source("../../rhelpers/knitr_setup.R")
# declare packages used
rqrd <- c("FSA","dplyr","nlstools","captioner","knitr")
# setup figure, table, and equation captioning
library(captioner)
figcaps <- captioner(prefix="Figure")
figcaps("","")
# == END -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
##############################################################

library(FSA)
library(dplyr)
library(nlstools)

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


# Script created at 2015-10-25 09:00:40
