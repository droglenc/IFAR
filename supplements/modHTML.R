modHTML <- function(f) {
  # Render the HTML file
  require(rmarkdown)
  render(paste0(f,".Rmd"))
  # Read in HTML and RMarkdown files
  h <- readLines(paste0(f,".html"))
  r <- readLines(paste0(f,".Rmd"))
  # Remove everything before the line after the last mention of
  # Derek H. Ogle in the HTML file
  tmp <- which(grepl("Derek H. Ogle",h))
  h <- h[-(1:(tmp[length(tmp)]+1))]
  # Get the layout, title and author from RMD file
  r <- r[1:4]
  # Put it all together as a new html file
  h <- c(r,"---",h)
  writeLines(h,paste0(f,".html"))
}
