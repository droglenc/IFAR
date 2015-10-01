modHTML <- function(f) {
  # Render the HTML file
  require(rmarkdown)
  render(paste0(f,".Rmd"))
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

modHTML2 <- function(f) {
  # Use when HTML was crated with knit HTML button
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
