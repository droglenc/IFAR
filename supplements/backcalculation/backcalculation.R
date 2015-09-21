# User must set working directory appropriately.

##############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
# 
# Setup of knitr
source("../knitr_setup.R")
# declare packages used
rqrd <- c("FSA","magrittr","dplyr","tidyr","stringr","captioner","knitr")
# setup figure, table, and equation captioning
library(captioner)
figcaps <- captioner(prefix="Figure")
figcaps("BackCalcEx704","Plot of length-at-capture versus scale radius for West Bearskin Lake Smallmouth Bass in 1990.  All four methods of backcalculation are shown for fish 704 ($S_{2}=3.49804$, $L_{C}=218$, and $S_{C}=7.44389$; black point and line) with calculational steps shown with the arrows.  Fish 701 is shown as the gray point and line for comparative purposes.")

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
library(tidyr)
library(stringr)

data(SMBassWB)
wb90 <- filterD(SMBassWB,yearcap==1990) %>%
  select(-(species:gear),-(anu10:anu12))

# ############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
par(mfrow=c(2,2),mar=c(3.05,3.05,1.15,0.65),mgp=c(1.5,0.3,0))
# ------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------
makePlot <- function(name) {
  plot(lencap~radcap,data=wb90,xlim=c(0,max(radcap)),ylim=c(0,max(lencap)),
       xlab=expression(S[C]),ylab=expression(L[C]),yaxt="n",xaxt="n",cex=0.75)
  axis(2,at=seq(0,350,50),labels=c(0,50,NA,NA,seq(200,350,50)))
  xs <- c(0,2,6,8,10)
  axis(1,xs)
  mtext(name,line=0.1)
}
addCalc <- function(Si,Li,Sc,Lc,int) {
  points(Sc,Lc,pch=19)
  lines(c(0,Sc),c(int,Lc),lwd=2)
  text(Si,-10,paste(round(Si,3)),pos=1,xpd=TRUE)
  arrows(Si,-5,Si,Li,lwd=2,length=0.1,angle=20,xpd=TRUE)
  arrows(Si,Li,-0.1,Li,lwd=2,length=0.1,angle=20,xpd=TRUE)
  text(-0.1,Li,paste(round(Li,2)),pos=2,xpd=TRUE)
}

lm.sl <- lm(radcap~lencap,data=wb90)
a <- coef(lm.sl)[1]; b <- coef(lm.sl)[2]
lm.ls <- lm(lencap~radcap,data=wb90)
c <- coef(lm.ls)[1]; d <- coef(lm.ls)[2]

Sc701 <- 9.2219; Lc701 <- 312
Sc <- 7.44389; Lc <- 218; Si <- 3.49804

# ------------------------------------------------------------
# Plots the Dahl-Lea
# ------------------------------------------------------------
makePlot("Dahl-Lea")
# Fish #701 as an example -- just show line
points(Sc701,Lc701,pch=19,col="grey",cex=1.25)
lines(c(0,Sc701),c(0,Lc701),lwd=2,col="grey")
# Fish #704 as an example -- show calculation
Li <- (Si/Sc)*Lc
addCalc(Si,Li,Sc,Lc,0)

# ------------------------------------------------------------
# Plots Fraser-Lee method
# ------------------------------------------------------------
makePlot("Fraser-Lee")
# Fish #701 as an example -- just show line
points(Sc701,Lc701,pch=19,col="grey",cex=1.25)
lines(c(0,Sc701),c(c,Lc701),lwd=2,col="grey")
# Fish #704 as an example -- show calculation
Li <- (Si/Sc)*(Lc-c)+c
addCalc(Si,Li,Sc,Lc,c)

#-------------------------------------------------------------------------------
# Plots the SPH method
#-------------------------------------------------------------------------------
makePlot("SPH")
# Fish #701 as an example -- just show line
points(Sc701,Lc701,pch=19,col="grey",cex=1.25)
lines(c(0,Sc701),c(-a/b,Lc701),lwd=2,col="grey")
# Fish #704 as an example -- show calculation
Li <- (-a/b)+(Lc+a/b)*(Si/Sc)
addCalc(Si,Li,Sc,Lc,-a/b)

#-------------------------------------------------------------------------------
# Plots the BPH method
#-------------------------------------------------------------------------------
makePlot("BPH")
# Fish #701 as an example -- just show line
int <- (c*Lc701)/(c+d*Sc701)
points(Sc701,Lc701,pch=19,col="grey",cex=1.25)
lines(c(0,Sc701),c(int,Lc701),lwd=2,col="grey")
# Fish #704 as an example -- show calculation
int <- (c*Lc)/(c+d*Sc)
Li <- Lc*(c+d*Si)/(c+d*Sc)
addCalc(Si,Li,Sc,Lc,int)
# == END -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =======
##############################################################

headtail(wb90,n=2)

wb90r <- gather(wb90,agei,radi,anu1:anu9) %>%
  arrange(fish,agei)
headtail(wb90r)

str_sub(wb90r$agei,start=1,end=3) <- ""
wb90r %<>% mutate(agei=as.numeric(agei)) %>%
  filterD(!is.na(radi)) %>%
  filterD(agei<=agecap)
headtail(wb90r)

lm.sl <- lm(radcap~lencap,data=wb90)
( a <- coef(lm.sl)[[1]] )
( b <- coef(lm.sl)[[2]] )

lm.ls <- lm(lencap~radcap,data=wb90)
( c <- coef(lm.ls)[[1]] )
( d <- coef(lm.ls)[[2]] )

wb90r %<>% mutate(DL.len=(radi/radcap)*lencap,
                  FL.len=(radi/radcap)*(lencap-c)+c,
                  SPH.len=(-a/b)+(lencap+a/b)*(radi/radcap),
                  BPH.len=lencap*(c+d*radi)/(c+d*radcap))
headtail(wb90r,n=2)

tmp <- wb90r %>% group_by(agei) %>%
  summarize(n=validn(FL.len),mn=mean(FL.len),sd=sd(FL.len)) %>%
  as.data.frame()
tmp

sumTable(FL.len~agecap*agei,data=wb90r,digits=1)


# Script created at 2015-09-21 08:23:06
