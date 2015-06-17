# Overview
This repository is for ongoing projects involving analysis of breweries and other related activities. The structure of the repository is that one folder, Data, is contains all of the data that is used or to be used within this repository. Each project/analysis then has a separate folder which accesses the data folder to perform its task. Or something like that.

# Helpful Websites

* [University of Denver](http://libguides.du.edu/c.php?g=90474&p=581818) research guide to the U.S. beer industry.
* [Breweries NAICS 312120](http://www.census.gov/econ/isp/sampler.php?naicscode=312120&naicslevel=6) listing of relevant employment indicators from the U.S. Census.
* [USGS Water Quality Data](http://water.usgs.gov/owq/data.html) for in-depth look at a key input to the beer making process.

## North Carolina Brew

[THE VEGETABLE ROOTS OF THE NORTH CAROLINA BEER BOOM](http://allaboutbeer.com/north-carolina-beer-history/)

>The Stroh’s brewery, which that company had acquired from a failing Jos. Schlitz in 1982, dated from late 1969. It was then the first new brewery in North Carolina since the repeal of Prohibition in 1933. It would close in August 1999
> 
> ...
> 
>It was in 1986, in fact, that things began to really pick up beer-wise in North Carolina. On the Fourth of July that year, the Weeping Radish brewpub opened in Manteo, a town on the Outer Banks, the islands that line much of North Carolina’s coast.

[STATE OF GROWTH: THE RISE OF NORTH CAROLINA BEER](http://allaboutbeer.com/state-of-growth-the-rise-of-north-carolina-beer/) - key quote:

>While brewery openings waned, others sought to grow North Carolina’s beer scene in another way—by raising the state’s 6% ABV cap. Sean Lilly Wilson (who would later open Durham’s Fullsteam Brewery in 2010) and a group of beer enthusiasts did just that through Pop the Cap, a grassroots movement that—through educational events, tastings and lobbying—helped **raise that cap to 15% in August of 2005.**



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