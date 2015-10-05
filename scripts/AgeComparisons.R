# User must set working directory appropriately.

library(FSA)

shad <- read.csv("ShadCR.csv")
headtail(shad)

ab.tA1 <- ageBias(agerA1~trueAge,data=shad,
                  ref.lab="True Age",nref.lab="Ager A")
plot(ab.tA1,col.CIsig="black")

plot(ab.tA1,col.CIsig="black",show.range=TRUE)

plot(ab.tA1,col.CIsig="black",show.pts=TRUE,transparency=1/6)

# ############################################################
# == BEGIN -- REDUNDANT CODE, FOR BOOK PRINTING ONLY =========
plot(ab.tA1,col.CIsig="black",show.range=TRUE)
plot(ab.tA1,col.CIsig="black",show.pts=TRUE,transparency=1/6)
# == END -- REDUNDANT CODE, FOR BOOK PRINTING ONLY ===========
# ############################################################

summary(ab.tA1,what="bias")

plot(ab.tA1,col.CIsig="black",difference=TRUE)

plot(ab.tA1,what="number",col.agree="gray50")

# ############################################################
# == BEGIN -- REDUNDANT CODE, FOR BOOK PRINTING ONLY =========
plot(ab.tA1,col.CIsig="black",difference=TRUE)
plot(ab.tA1,what="number",col.agree="gray50")
# == END -- REDUNDANT CODE, FOR BOOK PRINTING ONLY ===========
# ############################################################

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Constructs figure of grids to illustrate tests of symmetry
makegrid <- function(ttl,size=4) {
  inds <- 1:size
  divs <- inds[-length(inds)]
  plot(0,0,xlim=c(min(divs)-1,max(divs)+1),ylim=-c(max(divs)+1,min(divs)-1),col="white",xlab="",ylab="")
  abline(h=-divs)
  abline(v=divs)
  text(-0.2,-(inds-0.5),paste("i=",inds,sep=""),srt=90,xpd=TRUE,cex=1.3)
  text(inds-0.5,0.2,paste("j=",inds,sep=""),xpd=TRUE,cex=1.3)
  mtext(ttl,line=1.4,cex=1.5)
}

shadecell <- function(i,j,col) { rect(j-1,-i+1,j,-i,col=col) }

showBowkers <- function(size) {
  cells <- length(combn(size-1,size-2))
  clrs <- chooseColors("gray",cells)
  cell <- 1
  for (i in 1:size) {
    for (j in i:size) {
      if (i!=j) {
        shadecell(i,j,col=clrs[cell])
        shadecell(j,i,col=clrs[cell])
        cell <- cell+1
      }
    }
  }
}

showEvansHoenig <- function(size) {
  clrs <- chooseColors("gray",size)
  for (i in 1:size) {
    for (j in i:size) {
      if (i!=j) {
        shadecell(i,j,col=clrs[abs(j-i)])
        shadecell(j,i,col=clrs[abs(j-i)])
      }
    }
  }
}

showMcNemars <- function(size) {
  for (i in 1:size) {
    for (j in i:size) {
      if (i!=j) {
        shadecell(i,j,col="gray80")
        shadecell(j,i,col="gray80")
      }
    }
  }
}

par(mar=c(0,1.25,2.5,1.25),xaxs="i",yaxs="i",xaxt="n",yaxt="n")
size <- 4
makegrid("McNemar",size)
showMcNemars(size)
makegrid("Evans\255Hoenig",size)
showEvansHoenig(size)
makegrid("Bowker",size)
showBowkers(size)
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

summary(ab.tA1,what="symmetry")

summary(ab.tA1,what="table")

ab.tB1 <- ageBias(agerB1~trueAge,data=shad,
                  ref.lab="True Age",nref.lab="Ager B")
summary(ab.tB1,what="symmetry")
plot(ab.tB1,col.CIsig="black")

ab.tC1 <- ageBias(agerC1~trueAge,data=shad,
                  ref.lab="True Age",nref.lab="Ager C")
summary(ab.tC1,what="symmetry")
plot(ab.tC1,col.CIsig="black")

# ############################################################
# == BEGIN -- REDUNDANT CODE, FOR BOOK PRINTING ONLY =========
ab.tB1 <- ageBias(agerB1~trueAge,data=shad,
                  ref.lab="True Age",nref.lab="Ager B")
summary(ab.tB1,what="symmetry")
plot(ab.tB1,col.CIsig="black")
ab.tC1 <- ageBias(agerC1~trueAge,data=shad,
                  ref.lab="True Age",nref.lab="Ager C")
summary(ab.tC1,what="symmetry")
plot(ab.tC1,col.CIsig="black")
# == END -- REDUNDANT CODE, FOR BOOK PRINTING ONLY ===========
# ############################################################

ap.A <- agePrecision(~agerA1+agerA2,data=shad)

summary(ap.A,what="difference")

sumA1 <- ap.A$rawdiff
sumA1 <- sumA1/sum(sumA1)*100

summary(ap.A,what="absolute difference")

sumA2 <- ap.A$absdiff
sumA2 <- sumA2/sum(sumA2)*100

summary(ap.A,what="precision")

ap.ABC <- agePrecision(~agerA1+agerB1+agerC1,data=shad)
summary(ap.ABC,what="difference")
summary(ap.ABC,what="precision")


# Script created at 2015-10-05 09:37:11
