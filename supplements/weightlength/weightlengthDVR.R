# User must set working directory appropriately.

##############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
# 
# Setup of knitr
source("../../rhelpers/knitr_setup.R")
# declare packages used
rqrd <- c("FSA","dplyr","car","captioner","knitr")
# setup figure, table, and equation captioning
library(captioner)
figcaps <- captioner(prefix="Figure")
figcaps("FullResidPlot","Modified residual plot (Left) and histogram of residuals (Right) from fitting a dummy variable regression to the log-transformed weights and lengths of Ruffe captured in 1990, 1995, and 2000.")
figcaps("FitPlotSlopes","Log-transformed weight versus log-transformed length of Ruffe separated by capture year.")
figcaps("FitPlotIntercepts","Log-transformed weight versus log-transformed length of Ruffe separated by capture year.")

tabcaps <- captioner(prefix="Table")
tabcaps("SubsetModels","The submodels by capture year represented by the full model.")

eqncaps <- captioner(prefix="Equation")
eqncaps("FullModel")
# == END -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
##############################################################

library(FSA)
library(dplyr)
library(car)

ruf <- read.csv("RuffeSLRH.csv") %>%
  filterD(month==7) %>%
  mutate(fYear=factor(year),logW=log10(wt),logL=log10(tl)) %>%
  select(-fishID,-month,-day)
headtail(ruf)

ruf1 <- filterD(ruf,year %in% c(1990,1995,2000))
ruf2 <- filterD(ruf,year %in% 1992:1995)

fit1 <- lm(logW~logL*fYear,data=ruf1)

residPlot(fit1,legend=FALSE)

Anova(fit1)

compSlopes(fit1)

clrs1 <- c("black","red","blue")
clrs2 <- col2rgbt(clrs1,1/4)
plot(logW~logL,data=ruf1,pch=19,col=clrs2[fYear],
     xlab="log(Total Length)",ylab="log(Weight)")
( cfs <- coef(fit1) )
minx <- min(ruf1$logL)
maxx <- max(ruf1$logL)
curve(cfs[1]+cfs[2]*x,from=minx,to=maxx,col=clrs1[1],lwd=2,add=TRUE)
curve((cfs[1]+cfs[3])+(cfs[2]+cfs[5])*x,from=minx,to=maxx,col=clrs1[2],lwd=2,add=TRUE)
curve((cfs[1]+cfs[4])+(cfs[2]+cfs[6])*x,from=minx,to=maxx,col=clrs1[3],lwd=2,add=TRUE)
legend("topleft",levels(ruf1$fYear),pch=19,col=clrs1)

fit2 <- lm(logW~logL*fYear,data=ruf2)
Anova(fit2)

compIntercepts(fit2)

tmp <- compIntercepts(fit2)

clrs1 <- c("black","red","blue","green")
clrs2 <- col2rgbt(clrs1,1/4)
plot(logW~logL,data=ruf2,pch=19,col=clrs2[fYear],
     xlab="log(Total Length)",ylab="log(Weight)")
( cfs <- coef(fit2) )
minx <- min(ruf2$logL)
maxx <- max(ruf2$logL)
curve(cfs[1]+cfs[2]*x,from=minx,to=maxx,col=clrs1[1],lwd=2,add=TRUE)
curve((cfs[1]+cfs[3])+(cfs[2]+cfs[6])*x,from=minx,to=maxx,col=clrs1[2],lwd=2,add=TRUE)
curve((cfs[1]+cfs[4])+(cfs[2]+cfs[7])*x,from=minx,to=maxx,col=clrs1[3],lwd=2,add=TRUE)
curve((cfs[1]+cfs[5])+(cfs[2]+cfs[8])*x,from=minx,to=maxx,col=clrs1[4],lwd=2,add=TRUE)
legend("topleft",levels(ruf2$fYear),pch=19,col=clrs1)


# Script created at 2015-11-05 20:49:33
