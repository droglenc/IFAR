---
layout: page
title: Installing Packages
subtitle: In R for Windows
css: /supplements/installations/directions.css
---

## Installing Packages from CRAN

Packages distributed via the Comprehensive R Archive Network (CRAN) extend the functionality of R.  If you have chosen **NOT** to interact with R through RStudio, then these directions explain how to install package from within R.  If you have chosen to use RStudio, then goto [the directions for installing packages within RStudio](InstallPackagesRStudio).

1. Open R (if not already open).  Of course, these directions assume that you have installed R.  If not, here are directions to install R for [Windows](InstallRWin) or [Mac]().

1. Select the `Packages` menu and `Install package(s)' submenu items.

1. In the dialog box, select the packages to install (use the `<CTRL>` key to select multiple packages).  R should now install these packages plus all packages that these depend on.  This may take several minutes and you should see several "package 'xxx' successfully unpacked and MD5 sums checked" messages.

    * Depending on your priveleges on your machine, you may get a warning at this point about a library that "is not writable" and then be prompted with a dialog box asking you "Would you like to use a personal library instead?"  You can select `Yes` on this dialog box.  A second dialog box will appear with a question that starts with "Would you like to create a personal library."  You can also select `Yes` on this dialog box.


## Installing FSA and FSAdata

The `FSA` and `FSAdata` packages are special purpose packages for fisheries analyses that have not been officially released on CRAN.  These packages are available in GitHub and RForge.net repositories and can be installed following these directions.  *Note that about 10% of installations on Windows machines will result in some sort of error when following these directions.  In these cases, see the directions in the "Troubleshooting the Installation of the FSA Package" section following these directions.

1. Open R (if not already open).

1. In the Console, type (and run) the following two lines exactly.  This may take several minutes with a finish noted by an R prompt (a "greater than") symbol in the Console pane.
    <pre>
    source("http://www.rforge.net/FSA/InstallFSA.R")
    utils::install.packages("FSAdata",repos="http://www.rforge.net/",type="source")
    </pre>

    * Depending on your priveleges on your machine, you may get a warning at this point about a library that "is not writable.  See the note in the previous section for how to handle this.
    
1. In the Console type (and run) `library(FSAdata)` and `library(FSA)`.  The end of your Console pane should show the following message (the version number may be different).  If you received an error after running `library(FSA)`, then see the next section.

    <div class="ctrstaticimg">
    <img src="figures/InstallPkgs_RStudio_FSA.PNG" width="70%">
    </div>


## Troubleshooting the FSA Installation

The `FSA` package is not yet an official R package and, thus, the installation is non-standard.  My experience suggests that about 10% of installations on Windows machines will result in some sort of error that will cause the `FSA` package to not be installed properly.  For example, two typical errors that may be shown in the Console pane after submitting the `source()` line from above are shown below.

<div class="ctrstaticimg">
<img src="figures/InstallPkgs_RStudio_FSAErrors.PNG" width="120%">
</div>

The first error above indicates that the `gtools` package was not installed and the second error shows that the `multcomp` package was not installed.

Another typical error is a warning that starts with "unable to move temporary installation" and will include a specific package name.

If these specific errors occurr, then one may need to follow the directions from the first section to manually install the packages mentioned in the errors or warnings (e.g., `gtools` and `multcomp`) and then run the `source()` line again.  This process may take several iterations (`source()`, manually install packages in error) before `FSA` is successfully installed, though, in my experience there are usually only one or two problematic packages.
