# User must set working directory appropriately.

##############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
# 
# Setup of knitr
source("../knitr_setup.R")
# declare packages used
rqrd <- c("FSAdata","dplyr","captioner","knitr")
# setup figure, table, and equation captioning
library(captioner)
figcaps <- captioner(prefix="Figure")
figcaps("parEx1","Schematic plot that illustrates the plotting area (inside the dark black box), the figure area (inside the dark gray box), and the outer margin area (between the dark and light gray boxes).")
figcaps("LayoutPar","Grid of plots that uses the outer margin area to provide common axis labels.")
# == END -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
##############################################################

library(FSAdata)
library(dplyr)

data(BullTroutRML2)
BT <- BullTroutRML2
headtail(BT)

# ############################################################
# This code is not shown in the supplement, but is used to
# construct the plot that demonstrates the three areas in a
# plot.
par(mar=c(1.5,1.5,0.5,0.5),mgp=c(3,1,0),oma=c(2,2,2,2))
X <- Y <- 0:10
plot(Y~X,type="n",xaxt="n",yaxt="n",xlab="",ylab="")

box("plot",col="black")
text(5,5,"Plot Area",col="black",cex=1.25)
box("figure",lwd=2,col="gray25")
mtext("Figure Area",side=1,line=0.2,adj=0.0,cex=1.25,col="gray25")
box("outer",lwd=3,col="gray50")
mtext("Outer Margin Area",side=3,line=0.4,adj=0.0,cex=1.25,col="gray50",outer=TRUE)
# ############################################################

par(mfrow=c(2,2),oma=c(2,2,0,0))

xlmts <- c(-0.5,14.5)
ylmts <- c(0,700)
BTH1 <- BT %>% filterD(lake=="Harrison",era=="1977-80")
plot(fl~age,data=BTH1,main="Harrison, 1977-80",
     xlab="",ylab="",pch=19,xlim=xlmts,ylim=ylmts)
BTO1 <- BT %>% filterD(lake=="Osprey",era=="1977-80")
plot(fl~age,data=BTO1,main="Osprey, 1977-80",
     xlab="",ylab="",pch=19,xlim=xlmts,ylim=ylmts)
BTH2 <- BT %>% filterD(lake=="Harrison",era=="1997-01")
plot(fl~age,data=BTH2,main="Harrison, 1997-01",
     xlab="",ylab="",pch=19,xlim=xlmts,ylim=ylmts)
BTO2 <- BT %>% filterD(lake=="Osprey",era=="1997-01")
plot(fl~age,data=BTO2,main="Osprey, 1997-01",
     xlab="",ylab="",pch=19,xlim=xlmts,ylim=ylmts)

# ############################################################
# This code is a repeat of the code immediately above and is
# only used to efficiently produce the plot for the supplement.
par(mfrow=c(2,2),oma=c(2,2,0,0))
par(cex.main=0.9)
xlmts <- c(-0.5,14.5)
ylmts <- c(0,700)
BTH1 <- BT %>% filterD(lake=="Harrison",era=="1977-80")
plot(fl~age,data=BTH1,main="Harrison, 1977-80",
     xlab="",ylab="",pch=19,xlim=xlmts,ylim=ylmts)
BTO1 <- BT %>% filterD(lake=="Osprey",era=="1977-80")
plot(fl~age,data=BTO1,main="Osprey, 1977-80",
     xlab="",ylab="",pch=19,xlim=xlmts,ylim=ylmts)
BTH2 <- BT %>% filterD(lake=="Harrison",era=="1997-01")
plot(fl~age,data=BTH2,main="Harrison, 1997-01",
     xlab="",ylab="",pch=19,xlim=xlmts,ylim=ylmts)
BTO2 <- BT %>% filterD(lake=="Osprey",era=="1997-01")
plot(fl~age,data=BTO2,main="Osprey, 1997-01",
     xlab="",ylab="",pch=19,xlim=xlmts,ylim=ylmts)
# ############################################################
mtext("Age (years)",side=1,line=0,outer=TRUE,cex=1.3)
mtext("Fork Length (mm)",side=2,line=0,outer=TRUE,cex=1.3,las=0)


# Script created at 2015-09-21 08:52:15
