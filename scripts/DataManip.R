# User must set working directory appropriately.

library(FSA)
library(magrittr)
library(dplyr)
library(tidyr)

getwd()

tmp <- readLines("inchBio.csv",n=11)
tmp2 <- tmp[1]
for (i in 2:11) tmp2 <- rbind(tmp2,tmp[i])
dimnames(tmp2) <-list(rep("", dim(tmp2)[1]), rep("", dim(tmp2)[2]))
print(tmp2,quote=FALSE)

bio <- read.table("inchBio.csv",sep=",",header=TRUE)

bio <- read.csv("InchBio.csv")

str(bio)

levels(bio$species)

headtail(bio,n=4)

data(Mirex)
tail(Mirex,n=3)

tmp <- bio

bio[2,]                 # all variables for 2nd individual/row

tmp <- bio[-2,]         # omit 2nd individual/row
tmp <- bio[-c(2,7,10),] # omit 2nd, 7th, 10th individuals/rows

bg <- filter(bio,species=="Bluegill")
head(bg,n=3)

tmp <- filter(bio,species=="Yellow Perch",tl>=200)
head(tmp,n=3)

tmp <- filter(bio,species %in%
              c("Black Crappie","Bluegill","Pumpkinseed"))

levels(tmp$species)

tmp <- filterD(bio,species %in%
               c("Black Crappie","Bluegill","Pumpkinseed"))
levels(tmp$species)

tmp <- select(bio,species,tl,w)
head(tmp,n=3)

tmp <- select(bio,species:w)
head(tmp,n=3)

tmp <- select(bio,-c(netID,fishID,tag,scale))
head(tmp,n=3)

tmp <- select(bio,-ends_with("ID"))
tmp <- select(bio,-contains("ID"))
head(tmp,n=3)

tmp <- rename(bio,length=tl,weight=w)
head(tmp,n=3)

tmp <- mutate(bio,logL=log10(tl),logW=log10(w))
head(tmp,n=3)

bg <- mutate(bg,lcat10=lencat(tl,w=10))
headtail(bg)

range(bg$tl,na.rm=TRUE)          # min & max length

brks <- c(0,80,150,200,250,300)  # cutoffs for intervals
bg <- mutate(bg,lcatX=lencat(tl,breaks=brks))
headtail(bg)

bg <- mutate(bg,lcatX=lencat(tl,breaks=brks,as.fact=TRUE))
levels(bg$lcatX)

bg <- mutate(bg,lcatX=lencat(tl,breaks=brks,as.fact=TRUE,
                             droplevels=TRUE))
levels(bg$lcatX)

( brks <- c(Z=0,S=80,Q=150,P=200,M=250,T=300) )
bg <- mutate(bg,lcatX=lencat(tl,breaks=brks,use.names=TRUE))
levels(bg$lcatX)

old <- c("Z","S","Q","P","M","T")
new <- c("Sub-Stock","Stock","Quality","Preferred",
         "Memorable","Trophy")

bg <- select(bg,-c(netID,fishID,lcat10))
bg <- mutate(bg,lcatY=mapvalues(lcatX,from=old,to=new))
headtail(bg)

old <- c("Z","S","Q","P","M","T")
new <- c("Sub-Stock","Stock","Quality","Preferred",
         "Preferred","Preferred")

tmp <- arrange(bio,netID,species,desc(tl))
headtail(tmp)

tmp <- bio %>% arrange(netID,species,desc(tl))

bg <- bio %>%
  filter(species=="Bluegill") %>%
  select(-tag,-scale) %>%
  mutate(logL=log10(tl),logW=log10(w),
         lcat=lencat(tl,w=10)) %>%
  arrange(netID,tl)

head(bg,n=3)

bg %<>% filter(tl>100)
head(bg,n=3)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Creates helper functions to aid construction of diagrams to
# illustrate different data.frame manipulations.
shadecell <- function(i,j,col) { rect(j-1,-i+1,j,-i,col=col) }
textcell <- function(i,j,lbl,col="black") { text(j-0.5,-i+0.5,lbl,col=col,cex=1.5) }

puthdr <- function(nms,col="black") {
  if (length(col)==1) col <- rep(col,length(nms))
  for (i in 1:length(nms)) {
    shadecell(1,i,col[i])
    textcell(1,i,nms[i],"white")
  }
}

addrow <- function(nms,row,cellcol,txtcol="black") {
  if (length(cellcol)==1) cellcol <- rep(cellcol,length(nms))
  if (length(txtcol)==1) txtcol <- rep(txtcol,length(nms))
  for (i in 1:length(nms)) {
    shadecell(row,i,cellcol[i])
    textcell(row,i,nms[i],txtcol[i])
  }
}
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Construct diagram that illustrates row-binding data.frames.
layout(matrix(c(0,1,1,2,2,0,0,0,3,3,0,0),byrow=TRUE,nrow=2),heights=c(5,6.5)/12)
par(mar=c(0.5,1.25,3,1.25),xaxs="i",yaxs="i",xaxt="n",yaxt="n",bty="n")
clrs <- c("gray95","gray80")

plot(0,0,xlim=c(-0.5,3.5),ylim=c(-4,0),col="white",xlab="",ylab="")
mtext("Source A",line=0.5,cex=1.25)
puthdr(c("net","lake","code"))
addrow(c("1","A","BG"),row=2,cellcol=clrs[1])
addrow(c("1","A","LMB"),row=3,cellcol=clrs[1])

plot(0,0,xlim=c(-0.5,3.5),ylim=c(-4,0),col="white",xlab="",ylab="")
mtext("Source B",line=0.5,cex=1.25)
puthdr(c("net","lake","code"))
addrow(c("2","A","BG"),row=2,cellcol=clrs[2])
addrow(c("2","A","LMB"),row=3,cellcol=clrs[2])
addrow(c("2","A","SMB"),row=4,cellcol=clrs[2])

plot(0,0,xlim=c(-0.5,3.5),ylim=c(-6,0),col="white",xlab="",ylab="")
mtext("Row Bound",line=0.5,cex=1.25)
puthdr(c("net","lake","code"))
addrow(c("1","A","BG"),row=2,cellcol=clrs[1])
addrow(c("1","A","LMB"),row=3,cellcol=clrs[1])
addrow(c("2","A","BG"),row=4,cellcol=clrs[2])
addrow(c("2","A","LMB"),row=5,cellcol=clrs[2])
addrow(c("2","A","SMB"),row=6,cellcol=clrs[2])
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

bio07 <- read.csv("inchBio07.csv")
str(bio07)

bio08 <- read.csv("inchBio08.csv")
str(bio08)

bio08 %<>% rename(netID=net)

tmp <- rbind(bio07,bio08)
str(tmp)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Constructs plot that illustrates different types of joins.
layout(matrix(c(0,1,1,2,2,0,3,3,4,4,5,5),byrow=TRUE,nrow=2),heights=c(0.45,0.55))
par(mar=c(0.5,1.25,3,1.25),xaxs="i",yaxs="i",xaxt="n",yaxt="n",bty="n")
clrs <- c("gray95","gray80","white")

plot(0,0,xlim=c(-0.5,2.5),ylim=c(-5,0),col="white",xlab="",ylab="")
mtext("Source A",line=0.5,cex=1.25)
puthdr(c("net","lake"))
addrow(c("1","A"),row=2,cellcol=clrs[1])
addrow(c("2","A"),row=3,cellcol=clrs[1])
addrow(c("3","B"),row=4,cellcol=clrs[1])

plot(0,0,xlim=c(-0.5,2.5),ylim=c(-5,0),col="white",xlab="",ylab="")
mtext("Source B",line=0.5,cex=1.25)
puthdr(c("net","code"))
addrow(c("1","BG"),row=2,cellcol=clrs[2])
addrow(c("1","LMB"),row=3,cellcol=clrs[2])
addrow(c("2","BG"),row=4,cellcol=clrs[2])
addrow(c("4","BG"),row=5,cellcol=clrs[2])

plot(0,0,xlim=c(0,3),ylim=c(-6,0),col="white",xlab="",ylab="")
mtext("Inner Join",line=0.5,cex=1.25)
puthdr(c("net","lake","code"))
addrow(c("1","A","BG"),row=2,cellcol=clrs[c(1,1,2)])
addrow(c("1","A","LMB"),row=3,cellcol=clrs[c(1,1,2)])
addrow(c("2","A","BG"),row=4,cellcol=clrs[c(1,1,2)])

plot(0,0,xlim=c(0,3),ylim=c(-6,0),col="white",xlab="",ylab="")
mtext("Left Join",line=0.5,cex=1.25)
puthdr(c("net","lake","code"))
addrow(c("1","A","BG"),row=2,cellcol=clrs[c(1,1,2)])
addrow(c("1","A","LMB"),row=3,cellcol=clrs[c(1,1,2)])
addrow(c("2","A","BG"),row=4,cellcol=clrs[c(1,1,2)])
addrow(c("3","B","NA"),row=5,cellcol=clrs[c(1,1,3)])

plot(0,0,xlim=c(0,3),ylim=c(-6,0),col="white",xlab="",ylab="")
mtext("Outer Join",line=0.5,cex=1.25)
puthdr(c("net","lake","code"))
addrow(c("1","A","BG"),row=2,cellcol=clrs[c(1,1,2)])
addrow(c("1","A","LMB"),row=3,cellcol=clrs[c(1,1,2)])
addrow(c("2","A","BG"),row=4,cellcol=clrs[c(1,1,2)])
addrow(c("3","B","NA"),row=5,cellcol=clrs[c(1,1,3)])
addrow(c("4","NA","BG"),row=6,cellcol=clrs[c(2,3,2)])
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

gear <- read.csv("inchGear.csv")
head(gear,n=3)

head(bio,n=3)          # reminder of what bio looks like

bio2 <- left_join(gear,bio,by="netID") %>%
  rename(effort=unitsOfEffort) %>%
  select(netID,netType,year,effort,fishID,species,tl)
headtail(bio2)

age <- read.csv("inchAge.csv")
head(age,n=4)

age2 <- merge(bio2,age) %>%
  select(-c(netID,netType,effort,ageCap))
head(age2,n=4)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Constructs plot that illustrates wide-to-long conversion.
par(mfrow=c(1,2),mar=c(0.25,1.25,2,1.25),xaxs="i",yaxs="i",xaxt="n",yaxt="n",bty="n")
clrs <- c("white","gray85","gray70","gray40","gray25","black")
tclrs <- c("black","white")

plot(0,0,xlim=c(0,4),ylim=c(-5,0),col="white",xlab="",ylab="")
mtext("Original Wide Format",line=0.5,cex=1.5)
puthdr(c("fish","code","rad1","rad2"),col=clrs[c(6,6,4,5)])
addrow(c("1","BG",1.3,1.1),row=2,cellcol=clrs[c(1,1,2,2)])
addrow(c("2","LMB",1.6,1.4),row=3,cellcol=clrs[c(1,1,3,3)])

plot(0,0,xlim=c(0,4),ylim=c(-5,0),col="white",xlab="",ylab="")
mtext("New Long Format",line=0.5,cex=1.5)
puthdr(c("fish","code","num","meas"),col="black")
addrow(c("1","BG","rad1",1.3),row=2,cellcol=clrs[c(1,1,4,2)],txtcol=tclrs[c(1,1,2,1)])
addrow(c("1","BG","rad2",1.1),row=3,cellcol=clrs[c(1,1,5,2)],txtcol=tclrs[c(1,1,2,1)])
addrow(c("2","LMB","rad1",1.6),row=4,cellcol=clrs[c(1,1,4,3)],txtcol=tclrs[c(1,1,2,1)])
addrow(c("2","LMB","rad2",1.4),row=5,cellcol=clrs[c(1,1,5,3)],txtcol=tclrs[c(1,1,2,1)])
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Constructs plot that illustrates long-to-wide conversion.
par(mfrow=c(1,2),mar=c(0.25,1.25,2,1.25),xaxs="i",yaxs="i",xaxt="n",yaxt="n",bty="n")

plot(0,0,xlim=c(0,4),ylim=c(-5,0),col="white",xlab="",ylab="")
mtext("Original Long Format",line=0.5,cex=1.5)
puthdr(c("fish","code","num","meas"),col="black")
addrow(c("1","BG","rad1",1.3),row=2,cellcol=clrs[c(1,1,4,2)],txtcol=tclrs[c(1,1,2,1)])
addrow(c("1","BG","rad2",1.1),row=3,cellcol=clrs[c(1,1,5,2)],txtcol=tclrs[c(1,1,2,1)])
addrow(c("2","LMB","rad1",1.6),row=4,cellcol=clrs[c(1,1,4,3)],txtcol=tclrs[c(1,1,2,1)])
addrow(c("2","LMB","rad2",1.4),row=5,cellcol=clrs[c(1,1,5,3)],txtcol=tclrs[c(1,1,2,1)])

plot(0,0,xlim=c(0,4),ylim=c(-5,0),col="white",xlab="",ylab="")
mtext("New Wide Format",line=0.5,cex=1.5)
puthdr(c("fish","code","rad1","rad2"),col=clrs[c(6,6,4,5)])
addrow(c("1","BG",1.3,1.1),row=2,cellcol=clrs[c(1,1,2,2)])
addrow(c("2","LMB",1.6,1.4),row=3,cellcol=clrs[c(1,1,3,3)])
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

age2L <- gather(age2,age,rad,rad1:rad7)
headtail(age2L)

age2W <- spread(age2L,age,rad)
head(age2W,n=3)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Construct plot that illustrates aggregating.
par(mfrow=c(1,3),mar=c(0.25,1.25,2,1.25),xaxs="i",yaxs="i",xaxt="n",yaxt="n",bty="n",cex=1.05)
clrs <- c("gray70","gray85","white")

plot(0,0,xlim=c(-0.5,2.5),ylim=c(-9,0),col="white",xlab="",ylab="")
mtext("Original",line=0.5,cex=1.65)
puthdr(c("sex","len"))
addrow(c("F",17),row=2,cellcol=clrs[1])
addrow(c("F",19),row=3,cellcol=clrs[1])
addrow(c("M",13),row=4,cellcol=clrs[2])
addrow(c("M",15),row=5,cellcol=clrs[2])
addrow(c("M",20),row=6,cellcol=clrs[2])
addrow(c("J",13),row=7,cellcol=clrs[3])

plot(0,0,xlim=c(-0.5,2.5),ylim=c(-9,0),col="white",xlab="",ylab="")
mtext("Split",line=0.5,cex=1.75)
puthdr(c("sex","len"))
addrow(c("F",17),row=2,cellcol=clrs[1])
addrow(c("F",19),row=3,cellcol=clrs[1])
addrow(c("M",13),row=5,cellcol=clrs[2])
addrow(c("M",15),row=6,cellcol=clrs[2])
addrow(c("M",20),row=7,cellcol=clrs[2])
addrow(c("J",13),row=9,cellcol=clrs[3])

plot(0,0,xlim=c(-0.5,2.5),ylim=c(-9,0),col="white",xlab="",ylab="")
mtext("Combined",line=0.5,cex=1.75)
puthdr(c("sex","AVG"))
addrow(c("F",18),row=2,cellcol=clrs[1])
addrow(c("M",16),row=3,cellcol=clrs[2])
addrow(c("J",13),row=4,cellcol=clrs[3])
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

tmp <- group_by(bio,netID,species)

class(tmp)

tmp

tmp <- age %>% group_by(fishID) %>%
 summarize(aageCap=mean(ageCap),aradCap=mean(radCap),
           arad1=mean(rad1),arad2=mean(rad2),arad3=mean(rad3),
           arad4=mean(rad4),arad5=mean(rad5),arad6=mean(rad6),
           arad7=mean(rad7)) %>% as.data.frame()
head(tmp,n=2)

tmp <- bio %>% group_by(netID,species) %>%
  summarize(catch=n()) %>%
  as.data.frame()
head(tmp,n=3)

tmp <- bio2 %>% group_by(year,species) %>%
  summarize(n=n(),val.n=validn(tl),
            mean=round(mean(tl,na.rm=TRUE),1),
            sd=round(sd(tl,na.rm=TRUE),2),
            min=min(tl,na.rm=TRUE),
            mdn=quantile(tl,0.5,na.rm=TRUE),
            max=max(tl,na.rm=TRUE)) %>%
  as.data.frame()
head(tmp,n=3)

gear <- read.csv("BGHRsample.csv") %>%
  mutate(effort=effort/60)
head(gear,n=3)

fish <- read.csv("BGHRfish.csv") %>%
 mutate(spec=mapvalues(specCode,from=c(116,118,122),
        to=c("Smallmouth Bass","Largemouth Bass","Bluegill")))
headtail(fish)

catch <- fish %>% group_by(UID,spec) %>%
  summarize(caught=sum(count)) %>%
  as.data.frame()

catch <- left_join(gear,catch,by="UID")
headtail(catch)

catch %<>% addZeroCatch("UID","spec",zerovar="caught") %>%
  arrange(UID,spec)

catch %<>% mutate(cpe.hr=caught/effort)
headtail(catch)

cpeSum <- catch %>% group_by(spec) %>%
  summarize(samples=n(),fish=sum(caught),
            mean=mean(cpe.hr),sd=sd(cpe.hr),
            se=sd/sqrt(samples),RSE=se/mean*100) %>%
  as.data.frame()
cpeSum


# Script created at 2015-10-09 09:02:47
