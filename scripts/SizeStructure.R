# User must set working directory appropriately.

library(FSA)
library(magrittr)
library(dplyr)
library(plotrix)
library(Matching)

inchAll <- read.csv("InchLake1113.csv")
headtail(inchAll)

levels(inchAll$species)

bg <- filter(inchAll,species=="Bluegill")
bg11 <- filter(bg,year==2011)
bg12 <- filter(bg,year==2012)
bg13 <- filter(bg,year==2013)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
lmb11 <- filter(inchAll,species=="Largemouth Bass" & year==2011)
lmb12 <- filter(inchAll,species=="Largemouth Bass" & year==2012)
lmb13 <- filter(inchAll,species=="Largemouth Bass" & year==2013)
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

bg11 %<>% mutate(lcat10=lencat(tl,w=10))
headtail(bg11)

( bgFreq10 <- xtabs(~lcat10,data=bg11) )

round(prop.table(bgFreq10)*100,1)  # rounded for display only

hist(~tl,data=bg11,breaks=seq(20,270,10),
      xlab="Total Length (mm)")

hist(~tl,data=filter(bg11,tl<=100),breaks=seq(20,100,5),
     xlab="Total Length (mm)")
hist(~tl,data=filter(bg11,tl>=100),breaks=seq(100,270,10),
     xlab="Total Length (mm)")

clr <- c("black","gray50")
plot(ecdf(bg11$tl),xlab="Total Length (mm)",
     do.points=FALSE,verticals=TRUE,main="",col.01line=NULL)
plot(ecdf(bg12$tl),add=TRUE,do.points=FALSE,
     verticals=TRUE,col=clr[2],col.01line=NULL)
legend("bottomright",c("2011","2012"),col=clr,lty=1,
       bty="n",cex=0.75)

( bg.cuts2 <- psdVal("Bluegill") )

bg11s <- bg11 %>%
  filter(tl>=bg.cuts2["stock"]) %>%
  mutate(gcat=lencat(tl,breaks=bg.cuts2,
                     use.names=TRUE,drop.levels=TRUE))
headtail(bg11s)

( gfreq <- xtabs(~gcat,data=bg11s) )

( psdXY1 <- prop.table(gfreq)*100 )

( psdX1 <- rcumsum(psdXY1) )

bg11s %<>% mutate(gcat2=lencat(tl,breaks=c(80,175,225)))
gfreq2 <- xtabs(~gcat2,data=bg11s)
( psdXY2 <- prop.table(gfreq2)*100 )
( psdX2 <- rcumsum(psdXY2))

psdCI(c(1,0,0,0),ptbl=psdXY1,n=sum(gfreq),method="binomial",
      label="PSD S-Q")

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
tmp <- psdCI(c(1,0,0,0),ptbl=psdXY1,n=sum(gfreq))
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

psdCI(c(0,1,1,1),ptbl=psdXY1,n=sum(gfreq),method="binomial",
      label="PSD-Q")

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
tmp <- psdCI(c(0,1,1,1),ptbl=psdXY1,n=sum(gfreq))
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

( ivmat <- rbind("PSD S-Q"=c(1,0,0,0),
                 "PSD Q-P"=c(0,1,0,0)) )

psdXY2 <- t(apply(ivmat,FUN=psdCI,MARGIN=1,
                  ptbl=psdXY1,n=sum(gfreq),
                  method="multinomial"))
colnames(psdXY2) <- c("Estimate","95% LCI","95% UCI")
psdXY2

psdCalc(~tl,data=bg11,species="Bluegill",what="incremental")

psdCalc(~tl,data=bg11,species="Bluegill",what="traditional")

psdCalc(~tl,data=bg11,species="Bluegill",
        addLens=c(minSlot=175,maxSlot=225))

psd.bg11 <- psdCalc(~tl,data=bg11,species="Bluegill")
psd.bg12 <- psdCalc(~tl,data=bg12,species="Bluegill")
psd.bg13 <- psdCalc(~tl,data=bg13,species="Bluegill")

( psd.bg <- rbind(psd.bg11["PSD-Q",],psd.bg12["PSD-Q",],
                  psd.bg13["PSD-Q",]) )

psd.lmb11 <- psdCalc(~tl,data=lmb11,species="Largemouth Bass")
psd.lmb12 <- psdCalc(~tl,data=lmb12,species="Largemouth Bass")
psd.lmb13 <- psdCalc(~tl,data=lmb13,species="Largemouth Bass")
( psd.lmb <- rbind(psd.lmb11["PSD-Q",],psd.lmb12["PSD-Q",],
                   psd.lmb13["PSD-Q",]) )

# ############################################################
# This is a repeat of above, used solely for purposes of the
#   book.  Note use of plotrix:: to force use of proper
#   version of plotCI()
tictactoe(predobj=c(50,80),predlab="Largemouth Bass PSD-Q",
          preyobj=c(10,50),preylab="Bluegill PSD-Q")
plotrix::plotCI(psd.lmb[,"Estimate"],psd.bg[,"Estimate"],li=psd.lmb[,"95% LCI"],ui=psd.lmb[,"95% UCI"],err="x",add=TRUE,pch=19)
plotrix::plotCI(psd.lmb[,"Estimate"],psd.bg[,"Estimate"],li=psd.bg[,"95% LCI"],ui=psd.bg[,"95% UCI"],err="y",add=TRUE,pch=19)
lines(psd.lmb[,"Estimate"],psd.bg[,"Estimate"])
text(psd.lmb[,"Estimate"],psd.bg[,"Estimate"],
     labels=2011:2013,adj=c(1.2,-0.5),cex=0.75)
# ############################################################

ks.test(bg11$tl,bg12$tl)

bg.ksb <- ks.boot(bg11$tl,bg12$tl,nboots=5000)
summary(bg.ksb)

( ks.ps <- c(ks.test(bg11$tl,bg12$tl)$p.value,
             ks.test(bg11$tl,bg13$tl)$p.value,
             ks.test(bg12$tl,bg13$tl)$p.value) )
p.adjust(ks.ps)

# note: bg.cuts2 was constructed previously
bgs <- bg %>% filter(tl>=bg.cuts2["stock"]) %>%
  mutate(gcat=lencat(tl,breaks=bg.cuts2,
                     use.names=TRUE,drop.levels=TRUE))

( bg.LF <- xtabs(~year+gcat,data=bgs) )

chisq.test(bg.LF)

round(prop.table(bg.LF,margin=1)*100,0)

bgs %<>%  mutate(gcat2=mapvalues(gcat,
                       from=c("preferred","memorable"),
                       to=c("preferred+","preferred+")),
                 gcat2=droplevels(gcat2))
( bg.LF2 <- xtabs(~year+gcat2,data=bgs) )

bgs %<>% mutate(gcat3=mapvalues(gcat,
         from=c("stock","quality","preferred","memorable"),
         to=c("quality-","quality+","quality+","quality+")),
         gcat3=droplevels(gcat3))
( bg.LF3 <- xtabs(~year+gcat3,data=bgs) )
chisq.test(bg.LF3)

( ps <- c(chisq.test(bg.LF3[1:2,])$p.value,
          chisq.test(bg.LF3[c(1,3),])$p.value,
          chisq.test(bg.LF3[2:3,])$p.value) )
p.adjust(ps)

inchAll %<>% mutate(gcat=psdAdd(tl,species))
headtail(inchAll)

inchAlls <- filterD(inchAll,gcat!="substock")

freq <- xtabs(~species+gcat,data=inchAlls)
iPSDs <- prop.table(freq,margin=1)*100
round(iPSDs,0)

PSDs <- t(apply(iPSDs,MARGIN=1,FUN=rcumsum))
round(PSDs,1)

# ############################################################
# # Results not shown in the book
freq <- xtabs(~year+species+gcat,data=inchAlls)
ffreq <- ftable(freq)
iPSDs <- prop.table(ffreq,margin=1)*100
round(iPSDs,1)
PSDs <- t(apply(iPSDs,MARGIN=1,rcumsum))
round(PSDs,1)
# ############################################################


# Script created at 2015-10-06 10:23:31
