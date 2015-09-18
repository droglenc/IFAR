library(knitr)

################################################################################
## Set some switches
################################################################################
# set to TRUE to highlight R input/Output -- TRUE for web, FALSE for printing
highlight <- TRUE

################################################################################
## load packages
################################################################################
# extrafont library to allow using Computer Modern font in graphics
library(extrafont)
loadfonts(quiet=TRUE)


################################################################################
## knitr custom hooks
################################################################################
knit_hooks$set(
  par1 = function(before, options, envir) {
    if (before && options$fig.show != "none") {
      par(mar=c(3.05,3.05,0.65,0.65),
          mgp=c(1.9,0.3,0),
          tcl=-0.2,
          las=1,
          cex.lab=0.95,
          cex.axis=0.9)
      if (is.list(options$par))
        do.call(par, options$par)
    }
  }
)


################################################################################
## knitr options -- figure handling
################################################################################
# set default plot options
figsz <- 2.5
fullwide <- '.99\\linewidth'
halfwide <- '.49\\linewidth'
thirdwide <- '.32\\linewidth'

# output look
opts_chunk$set(prompt=TRUE,
               comment='',
               highlight=highlight,
               background=c(235,235,235)/255)


################################################################################
## r options
################################################################################
options(width=66,
        show.signif.stars=FALSE,
        continue="  ",
        str=strOptions(strict.width="cut"))
