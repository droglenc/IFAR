##############################################################
# Creates a footer for the bottom of the exercises
#   f: filename without the extension
#   author: author name
##############################################################
exercise_footer <- function(f,author="Derek H. Ogle") {
  # get file info
  info <- file.info(paste0(f,".Rmd"))
  # set the date format
  dfmt <- "%d-%b-%y"
  ## start making footer string
  ftr <- '<p style="font-size: 0.75em; color: c6c6c6;">from'
  ftr <- paste(ftr,author,', created ',format(info$ctime,format=dfmt))
  ftr <- paste0(ftr,', updated ',format(info$mtime,format=dfmt))
  ftr <- paste0(ftr,', <a href="mailto:fishr@derekogle.com?subject=')
  ftr <- paste0(ftr,f,' exercise">Comments/Suggestions</a>.</p>')
  cat(ftr)
  ## Add CSS directives
  cat('<style type="text/css">')
  cat('ol ol { list-style-type: lower-alpha; }')
  cat('</style>')
}

##############################################################
# Creates (if need2render=TRUE) and modifies the created HTML
#   file to better utilize GitHub's abilities.
# Modifications are ...
# 1. Remove a bunch of header stuff from the HTML file and
#    replace it with the YAML header in the Rmd file.
# 2. Remove the hard-wired RStudio ordered lists so that the
#    the first level will be numbers (the GitHub) default and
#    the second level will be letters (as per the CSS line
#    at the bottom of each Rmd file).
# Note that for some reason, some Rmd files need to be
#   rendered with the Knit HTML button in RStudio.  In these
#   cases, do that and then use need2render=FALSE in this
#   function.
##############################################################
modHTML <- function(f,need2render=TRUE) {
  # Render the HTML file
  if (need2render) {
    require(rmarkdown)
    render(paste0(f,".Rmd"))
  }
  # Read in HTML and RMarkdown files
  h <- readLines(paste0(f,".html"))
  r <- readLines(paste0(f,".Rmd"))
  # Remove everything before the line after the last mention of
  # Derek H. Ogle in the HTML file
  tmp <- which(grepl("<em>Derek H. Ogle</em>",h))
  h <- h[-(1:(tmp[length(tmp)]+1))]
  # Get the layout, title, subtitle, and author from RMD file
  r <- r[1:5]
  # Put it all together as a new html file
  h <- c(r,"---",h)
  # Remove Rstudio's ol styles
  tmp <- which(grepl("list-style-type: decimal",h))
  h[tmp] <- "<ol>"
  # Write out the new file
  writeLines(h,paste0(f,".html"))
}
