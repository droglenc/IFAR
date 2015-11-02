---
layout: page
title: Errata & Notes
---

## Errata

* **Page 123** -- The `$ks$p.value` in the first full paragraph returns the p-value from the overall Kolmogorov-Smirnov test.  Appending `$ks.boot.pvalue` to the `ks.boot()` object will return the bootstrapped p-value.  In other words, the sentence should read as follows: "The p-value for a single K-S test is extracted by appending `$p.value` to a `ks.test()` object or `$ks.boot.pvalue` to a `ks.boot()` object."

\ 

\ 

----

## Post-Production Notes

* **Page xvi** -- All code found in the book still produces the same results when using version 0.8.4 of `FSA`.

* **Page 295** -- The McBride (2015) reference has now been assigned to a volume with page numbers.  Thus, the end of that citation should include *ICES Journal of Marine Science* 72:2149-2167.
