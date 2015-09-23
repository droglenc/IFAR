---
layout: page
title: Age-Length Keys
subtitle: Lake Ontario Rock Bass
---

<style type="text/css">
ol ol { list-style-type: lower-alpha; }
</style>

Wolfert (1980) measured the total length (TL) of 1288 Rock Bass (*Ambloplites rupestris*) from Eastern Lake Ontario in the late 1970s.  In addition, scales were removed for age estimation from as many as 10 specimens from each 10-mm length interval.  All data are recorded in `data(RockBassLO2)` from `FSAdata` [Note: the filename contains an "oh" not a "zero."].

1. Separate the observed data into age- and length-samples.  How many fish are in each sample?
1. Add a variable to the age-sample that contains the 10 mm TL categories.  Construct a table of the **number** (not proportion) of fish in each age and 10 mm TL category in the age-sample.  From these results, compute each of the following *by hand* (i.e., not using R).
    1. How many Rock Bass in the age-sample are in the 180-mm TL category?
    1. How many age-7 Rock Bass are in the age-sample?
    1. What proportion of Rock Bass in the 140-mm TL category are age-4?
    1. What proportion of Rock Bass in the 200-mm TL category are age-8?
1. Construct an **observed** age-length key from the table above (using R).  From these results answer the following questions.
    1. What proportion of Rock Bass in the 210-mm TL category should be assigned age-5?
    1. How many of thirty Rock Bass in the 180-mm TL category should be assigned age-5?
    1. Construct a plot of the **observed** age-length key.  Are there any potential anomalies in the plot that would suggest that a smoothed age-length key could be appropriate?
1. Construct a **smoothed** age-length key.  From these results answer the following questions.
    1. What proportion of Rock Bass in the 210-mm length category should be assigned age-5?
    1. How many of thirty Rock Bass in the 180-mm length category should be assigned age-5?
1. Continue with the **observed** age-length key generated for Lake Ontario Rock Bass in the previous question.  Use the semi-random age assignment technique from Isermann and Knight (2005) to assign ages to the unaged fish in the length-sample.  Combine the age-sample and the age-assigned length-sample into a single data frame.  Add a variable to this data.frame that contains the 10 mm TL categories.  Use the combined data frame to answer the following questions.
    1. How many fish are estimated to be age-5?  [Hint: use `xtabs()` or `Summarize()`.]
    1. How many fish are estimated to be age-11?
    1. Plot the age distribution for all fish.
    1. How many fish are in the 150-mm TL interval? [Hint: use `xtabs()`.]
    1. What is the mean TL of age-5 fish?
    1. Plot the length-at-age with the mean length-at-age superimposed for all fish.
    1. Compare your results to someone else's results.  Did you both get the *exact* same results? Why or why not?  If not, how different were they?

---
<p style="font-size: 0.75em; color: c6c6c6;">from <a href="http://derekogle.com">Derek H. Ogle</a>, 23-Sep-15, updated 23-Sep15</p>

