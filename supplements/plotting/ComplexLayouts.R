# User must set working directory appropriately.

##############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
# 
# Setup of knitr
source("../knitr_setup.R")
# declare packages used
rqrd <- c("FSAdata","FSA","dplyr","captioner","knitr")
# setup figure, table, and equation captioning
library(captioner)
figcaps <- captioner(prefix="Figure")
figcaps("Layout1","Illustration of 2x2 layout grid for graphics.")
figcaps("Layout2","Illustration of layout grid for graphics with one graph in first row and two in the second row.")
figcaps("Layout3","Illustration of layout grid for graphics with one graph in first row and two in the second row.")
figcaps("Layout4","Illustration of layout grid for graphics with differing row heights and column widths.")
figcaps("Layout5","Illustration of layout grid with differing heights and widths such that a scatterplot appears in the 'middle' with corresponding boxplots on the 'sides.'")
figcaps("Layout6","Illustration of layout grid with differing heights and widths such that labels can be placed on the sides.")
# == END -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
##############################################################

library(FSAdata)
library(FSA)
library(dplyr)

data(BullTroutRML2)
BT <- BullTroutRML2
headtail(BT)
data(BloaterLH)
BLH <- BloaterLH
headtail(BLH)

( m <- matrix(4:1,nrow=2,byrow=TRUE) )
layout(m)

# ############################################################
# This code is a repeat of the code immediately above and is
# only used to efficiently produce the plot for the supplement.
( m <- matrix(4:1,nrow=2,byrow=TRUE) )
layout(m)
# ############################################################
layout.show(4)

# ############################################################
# This code is a repeat of the code immediately below and is
# only used to efficiently produce the plot for the supplement.
( m <- matrix(c(1,1,2,3),nrow=2,byrow=TRUE) )
layout(m)
# ############################################################

# ############################################################
# This code is a repeat of the code immediately below and is
# only used to efficiently produce the plot for the supplement.
( m <- matrix(c(1,1,2,3),nrow=2,byrow=TRUE) )
layout(m)
# ############################################################
layout.show(3)

# ############################################################
# This code is a repeat of the code immediately above and is
# only used to efficiently produce the plot for the supplement.
# ############################################################
# This code is a repeat of the code immediately below and is
# only used to efficiently produce the plot for the supplement.
( m <- matrix(c(1,1,2,3),nrow=2,byrow=TRUE) )
layout(m)
# ############################################################
par(mar=c(3.05,3.05,0.65,0.65),mgp=c(1.9,0.3,0),tcl=-0.2,las=1,cex.lab=0.95,cex.axis=0.9)
# ############################################################
plot(age3~eggs,data=BLH,pch=19,xlab="Millions of Eggs",
     ylab="Relative Abundance of Age-3 Fish")
hist(~eggs,data=BLH,xlab="Millions of Eggs")
hist(~age3,data=BLH,xlab="Age-3 Relative Abundance")

# ############################################################
# This code is a repeat of the code immediately below and is
# only used to efficiently produce the plot for the supplement.
( m <- matrix(c(2,0,1,3),nrow=2,byrow=TRUE) )
layout(m,height=c(1,4),width=c(4,1),respect=TRUE)
# ############################################################

# ############################################################
# This code is a repeat of the code immediately below and is
# only used to efficiently produce the plot for the supplement.
( m <- matrix(c(2,0,1,3),nrow=2,byrow=TRUE) )
layout(m,height=c(1,4),width=c(4,1),respect=TRUE)
# ############################################################
layout.show(3)

# ############################################################
# This code is a repeat of the code immediately above and is
# only used to efficiently produce the plot for the supplement.
# ############################################################
# This code is a repeat of the code immediately below and is
# only used to efficiently produce the plot for the supplement.
( m <- matrix(c(2,0,1,3),nrow=2,byrow=TRUE) )
layout(m,height=c(1,4),width=c(4,1),respect=TRUE)
# ############################################################
# ############################################################
par(mar=c(4,4,0,0))
plot(age3~eggs,data=BLH,xlim=c(0,2.4),ylim=c(0,240),pch=19,
     ylab="Relative Abundance of Age-3 Fish",
     xlab="Millions of Eggs")
par(mar=c(0,4,0,0))
boxplot(BLH$eggs,axes=FALSE,ylim=c(0,2.4),horizontal=TRUE)
par(mar=c(4,0,0,0))
boxplot(BLH$age3,axes=FALSE,ylim=c(0,240))

BTH1 <- BT %>% filterD(lake=="Harrison",era=="1977-80")
BTO1 <- BT %>% filterD(lake=="Osprey",era=="1977-80")
BTH2 <- BT %>% filterD(lake=="Harrison",era=="1997-01")
BTO2 <- BT %>% filterD(lake=="Osprey",era=="1997-01")

( m <- matrix(c(0,1,2,3,5,6,4,7,8),nrow=3,byrow=TRUE) )
layout(m,height=c(1,8,8),width=c(1,8,8),respect=TRUE)

par(mar=c(0,0,0,0))
plot.new(); text(0.5,0.5,"Harrison",cex=1.5)
plot.new(); text(0.5,0.5,"Osprey",cex=1.5)
plot.new(); text(0.5,0.5,"Era = 1977-1980",cex=1.5,srt=90)
plot.new(); text(0.5,0.5,"Era = 1997-2001",cex=1.5,srt=90)

par(mar=c(3.05,3.05,0.65,0.65),mgp=c(1.7,0.5,0))
xlmt <- c(-0.5,14.5)
ylmt <- c(0,700)
plot(fl~age,data=BTH1,xlab="",ylab="Fork Length",
     pch=19,xlim=xlmt,ylim=ylmt)
plot(fl~age,data=BTO1,xlab="",ylab="",
     pch=19,xlim=xlmt,ylim=ylmt)
plot(fl~age,data=BTH2,xlab="Age",ylab="Fork Length",
     pch=19,xlim=xlmt,ylim=ylmt)
plot(fl~age,data=BTO2,xlab="Age",ylab="",
     pch=19,xlim=xlmt,ylim=ylmt)


# Script created at 2015-09-21 09:55:10
