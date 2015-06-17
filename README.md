# Overview
This repository is for ongoing projects involving analysis of breweries and other related activities. The structure of the repository is that one folder, Data, is contains all of the data that is used or to be used within this repository. Each project/analysis then has a separate folder which accesses the data folder to perform its task. Or something like that.

# Helpful Websites

* [University of Denver](http://libguides.du.edu/c.php?g=90474&p=581818) research guide to the U.S. beer industry.
* [Breweries NAICS 312120](http://www.census.gov/econ/isp/sampler.php?naicscode=312120&naicslevel=6) listing of relevant employment indicators from the U.S. Census.
* [USGS Water Quality Data](http://water.usgs.gov/owq/data.html) for in-depth look at a key input to the beer making process.

## North Carolina Brew

[STATE OF GROWTH: THE RISE OF NORTH CAROLINA BEER](http://allaboutbeer.com/state-of-growth-the-rise-of-north-carolina-beer/)

## Packages Needed
Various packages used are not found on CRAN, therefore the [devtools package](http://cran.r-project.org/web/packages/devtools/index.html) needs to be installed.

```R
# install.packages("devtools")
devtools::install_github("jtilly/cbpR")
library("cbpR")
```

Further, other packages needed include: <!-- `gdata`, `ggplot2`, `maptools`, `plyr`, `raster`, `reshape2`, `rgdal`, `spdep`, `xtable`. -->


<!--
THE FOLLOWING HAS BEEN COMMENTED OUT BUT IS EXTREMELY HELPFUL FOR REMEMBERING MARKDOWN COMMANDS

# Cheat Sheet
Plain text
End a line with two spaces to start a new paragraph.  
*italics* and _italics_  
**bold** and __bold__  
superscript^2^  
~~strikethrough~~  
[link](www.rstudio.com)  

# Header 1  
## Header 2  
### Header 3  
#### Header 4  
##### Header 5  
###### Header 6  

endash: --  
emdash: ---  
ellipsis: ...  
inline equation: $A = \pi*r^{2}$  
image: ![](RStudioSmall.png)  
horizontal rule (or slide break):

***

> block quote

* unordered list
* item 2
  + sub-item 1
  + sub-item 2

1. ordered list
2. item 2
  + sub-item 1
  + sub-item 2

Table Header  | Second Header
------------- |-------------
Table Cell    | Cell 2
Cell 3        | Cell 4

| Tables   |      Are      |  Cool |
|----------|:-------------:|------:|
| col 1 is |  left-aligned | $1600 |
| col 2 is |    centered   |   $12 |
| col 3 is | right-aligned |    $1 |
-->