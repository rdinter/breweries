#Robert Dinterman

# Download files using RCurl (because of https issues)
bdown <- function(url, folder){
  require(RCurl, quietly = T)
  file <- paste(folder, basename(url), sep = "/")
  
  if (!file.exists(file)){
    f <- CFILE(file, mode = "wb")
    a <- curlPerform(url = url, writedata = f@ref,
                     noprogress = FALSE)
    close(f)
    return(a)
  } else print("File Already Exists!")
}

zipdata <- function(file, tempDir, year){
  unlink(tempDir, recursive = T)
  
  unzip(file, exdir = tempDir)
  file       <- list.files(tempDir, pattern = "\\.txt$", full.names = T)
  rdata      <- read_csv(file)
  
  names(rdata) <- tolower(names(rdata))
  rdata$year <- year
  
  return(rdata)
}
