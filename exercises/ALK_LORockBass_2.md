---
layout: page
title: Age-Length Keys
subtitle: Lake Ontario Rock Bass II
---

<style type="text/css">
ol ol { list-style-type: lower-alpha; }
</style>

Wolfert (1980) measured the total length (TL) of 1288 Rock Bass (*Ambloplites rupestris*) from Eastern Lake Ontario in the late 1970s.  In addition, scales were removed for age estimation from as many as 10 specimens from each 10 mm length interval.  All data are recorded in `data(RockBassLO2)` from `FSAdata` [Note: the filename contains an "oh" not a "zero."].

1. Separate the observed data into age- and length-samples.  Construct an **observed** age-length key from the table above (using R).  [These would have been accomplished in [this exercise](ALK_LORockBass_1.html).]

1. Use the semi-random age assignment technique from Isermann and Knight (2005) and the **observed** age-length key to assign ages to the unaged fish in the length-sample.  Combine the age-sample and the age-assigned length-sample into a single data frame.  Add a variable to this data.frame that contains the 10 mm TL categories.  Use the combined data frame to answer the following questions.
    1. How many fish are estimated to be age 5?  [Hint: use `xtabs()` or `Summarize()`.]
    1. How many fish are estimated to be age 11?
    1. Plot the age distribution for all fish.
    1. How many fish are in the 150 mm TL interval? [Hint: use `xtabs()`.]
    1. What is the mean TL of age-5 fish?
    1. Plot the length-at-age with the mean length-at-age superimposed for all fish.
    1. Compare your results to someone else's results.  Did you both get the *exact* same results? Why or why not?  If not, how different were they?

---
<p style="font-size: 0.75em; color: c6c6c6;">from <a href="http://derekogle.com">Derek H. Ogle</a>, 23-Sep-15, updated 23-Sep-15</p>

