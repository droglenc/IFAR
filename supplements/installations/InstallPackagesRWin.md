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

The `FSA` and `FSAdata` packages are distributed on CRAN and can be installed using the directions above.
