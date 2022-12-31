# User must set working directory appropriately.

library(FSA)
library(car)      # Before dplyr to reduce conflicts with MASS
library(magrittr)
library(dplyr)
library(plotrix)
library(multcomp)

ruf950 <- read.csv("RuffeSLRH.csv") %>%
  filter(month==7,year %in% c(1990,1995,2000)) %>%
  mutate(logW=log10(wt),logL=log10(tl)) %>%
  select(-c(fishID,month,day))
headtail(ruf950,n=2)

ruf950 %<>% mutate(K=wt/(tl^3)*100000)
headtail(ruf950,n=2)

lm1 <- lm(logW~logL,data=ruf950)
coef(lm1)

ruf950 %<>% mutate(lwresid=residuals(lm1))
headtail(ruf950,n=2)

ruf950 %<>% mutate(predW=10^fitted(lm1),Kn=wt/predW)
headtail(ruf950,n=2)

cor(ruf950$Kn,10^ruf950$lwresid)

wsVal("Ruffe")

( wsRuf <- wsVal("Ruffe",simplify=TRUE) )

# Below for demonstration purposes
wsRuf[["int"]]
wsRuf[["slope"]]
wsRuf[["quad"]]

ruf950 %<>% mutate(Ws=10^(wsRuf[["int"]]+wsRuf[["slope"]]*logL
                          +wsRuf[["quad"]]*(logL^2)),
                   Wr=wt/Ws*100)
headtail(ruf950,n=2)

ruf90 <- ruf950 %>%
  filter(tl>=wsRuf[["min.TL"]],tl<=wsRuf[["max.TL"]]) %>%
  mutate(gcat=lencat(tl,breaks=psdVal("Ruffe"),
                     use.names=TRUE)) %>%
  filterD(year==1990)

Summarize(Wr~gcat,data=ruf90,digits=0)

aov1 <- lm(Wr~gcat,data=ruf90)

Anova(aov1)

mc1 <- glht(aov1,mcp(gcat="Tukey"))
summary(mc1)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ======
smc1 <- summary(mc1)
# this removes the "extra" message printed by summary
tmp <- smc1$test
tmp <- with(tmp,cbind(coefficients,sigma,tstat,pvalues))
colnames(tmp) <- c("Estimate","Std. Error","t value","p value")
rownames(tmp) <- paste (rownames(tmp),"== 0")
round(tmp,3)
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

grps <- c("stock","quality","preferred","memorable")
nd <- data.frame(gcat=factor(grps,levels=grps))
( pred <- predict(aov1,nd,interval="confidence") )

plotCI(as.numeric(nd$gcat),pred[,"fit"],
       li=pred[,"lwr"],ui=pred[,"upr"],
       pch=19,xaxt="n",xlim=c(0.8,4.2),ylim=c(100,120),
       xlab="Gabelhouse Length Category",ylab="Mean Wr")
lines(nd$gcat,pred[,"fit"],col="gray50")
axis(1,at=nd$gcat,labels=nd$gcat)

cld(mc1)

# ############################################################
# == BEGIN -- REDUNDANT CODE, FOR BOOK PRINTING ONLY =========
plotCI(as.numeric(nd$gcat),pred[,"fit"],
       li=pred[,"lwr"],ui=pred[,"upr"],
       pch=19,xaxt="n",xlim=c(0.8,4.2),ylim=c(100,120),
       xlab="Gabelhouse Length Category",ylab="Mean Wr")
lines(nd$gcat,pred[,"fit"],col="gray50")
axis(1,at=nd$gcat,labels=nd$gcat)
text(x=nd$gcat,y=pred[,"upr"],
     labels=c("ab","b","a","ab"),pos=3)
# == END -- REDUNDANT CODE, FOR BOOK PRINTING ONLY ===========
# ############################################################

residPlot(aov1)

leveneTest(aov1)

kruskal.test(Wr~gcat,data=ruf90)

dunnTest(Wr~gcat,data=ruf90,method="holm")


# Script created at 2015-11-02 12:54:57
