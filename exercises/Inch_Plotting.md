---
layout: page
title: Basic Plotting
subtitle: Inch Lake
---

[Inch Lake](http://dnr.wi.gov/lakes/lakepages/LakeDetail.aspx?wbic=2764300&page=facts) is a 12.5 ha inland lake in northern Wisconsin that has been managed as catch-and-release for all species since 2006.  Researchers at Northland College have monitored fish populations in Inch Lake since 2007.  The total lengths (inches) and weights (g) for subsamples of several species of fish collected from Inch Lake in May of 2007 and 2008 are recorded in [this CSV file](data/InchLake2.csv) (these data are also available in `InchLake2` from `FSAdata`).  Use these data to answer the following questions.

1. Complete [this Data Manipulation exercise](Inch_DataManip.html).
1. Describe the following from plots constructed from the Bluegill only data.frame.
    1. The distribution of lengths.
    1. The distribution of weights.
    1. The distribution of lengths separately for each year (using only one command to make separate plots).
    1. The relationship between weight and length.
    1. The relationship between the natural logs of weight and length.
    1. The relationship between the natural logs of weight and length separately for each year (using only one plot).
    1. The difference in mean lengths between the two years (plot should include confidence intervals).
1. Repeat the above for Largemouth Bass.
1. Describe the species distribution of (only) non-game species.

Save the script from this exercise as these data will be used in these weight-length relationhip ([A](Inch_WLBluegill_A.html) and [B](Inch_WLLargemouthBass_A.html)) and these condition ([A](Inch_ConditionBluegill.html) and [B](Inch_ConditionLargemouthBass.html)) exercises.

---
<p style="font-size: 0.75em; color: c6c6c6;">from <a href="http://derekogle.com">Derek H. Ogle</a>, 29-Sep-15, updated 30-Sep-15, <a href="mailto:fishr@derekogle.com?subject=Inch Lake Plotting Exercise">Comments/Suggestions</a></p>

<style type="text/css">
ol ol { list-style-type: lower-alpha; }
</style>