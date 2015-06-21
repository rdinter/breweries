# Overview
This repository is for ongoing projects involving analysis of breweries and other related activities. The structure of the repository is that one folder, `0-data`, contains all of the data that is used or to be used within this repository. Each project/analysis then has a separate folder which accesses the data folder to perform its task.

# Order of Analysis
The files `0-CBP.R` and `0-ZBP.R` will download all of the raw zipped files related to [County Business Patterns](https://www.census.gov/econ/cbp/download/). For `0-CBP.R`, the downloaded files are from 1986 to 2013 with each file between 7 and 16 MBs (total of about 165 MBs). For `0-ZBP.R`, the files cover 1994 to 2013 with a file for total establishments each year as well as a separate file for industry classifications by zip code. The total files are less than 1 MB in size (total of less than 20 MBs) while the detail files are between 12 and 17 MBs (around 310 MBs).

## Packages Needed
Current needed packages include: `dplyr`, `RCurl`, `readr`. These are accessible through CRAN and can therefore be installed with the `install.packages()` command.
<!--
`gdata`, `ggplot2`, `maptools`, `plyr`, `raster`, `reshape2`, `rgdal`, `spdep`, `xtable`. -->

<!--
Various packages used are not found on CRAN, therefore the [devtools package](http://cran.r-project.org/web/packages/devtools/index.html) needs to be installed.

```R
# install.packages("devtools")
devtools::install_github("jtilly/cbpR")
library("cbpR")
```
-->

## NAICS Classifications
[NAICS Code Structure](http://www.bls.gov/bls/naics.htm) description of how the industry structure classifications. Breweries are in:

* [31-33 Manufacturing](http://www.census.gov/cgi-bin/sssd/naics/naicsrch?chart=2012) "31----"
    * [312 Beverage and Tobacco Product Manufacturing](http://www.census.gov/cgi-bin/sssd/naics/naicsrch?code=312&search=2012%20NAICS%20Search) "312///"
        * 3121 Beverage Manufacturing "3121//"
            * 31212 Breweries "31212/"
                * [312120 Breweries](http://www.census.gov/cgi-bin/sssd/naics/naicsrch?code=312120&search=2012%20NAICS%20Search)

Description entails that breweries include: "Ale brewing; Beer brewing; Beverages, beer, ale, and malt liquors, manufacturing; Breweries; Grain, brewers' spent, manufacturing; Lager brewing; Malt liquor brewing; Near beer brewing; Nonalcoholic beer brewing; Porter brewing; and Stout brewing."

Further, the bottling process is a separate NAICS classification:

* [42 Wholesale Trade](http://www.census.gov/cgi-bin/sssd/naics/naicsrch?code=424810&search=2012) "42----"
    * [424 Merchant Wholesalers, Nondurable Goods](http://www.census.gov/cgi-bin/sssd/naics/naicsrch?code=424&search=2012%20NAICS%20Search) "424///"
        * 4248 Beer, Wine, and Distilled Alcoholic Beverage Merchant Wholesalers "4248//"
            * 42481 Beer and Ale Merchant Wholesalers "42481/"
                * [424810 Beer and Ale Merchant Wholesalers](http://www.census.gov/cgi-bin/sssd/naics/naicsrch?code=424810&search=2012%20NAICS%20Search)

Description entails: "Alcoholic beverages (except distilled spirits, wine) merchant wholesalers; Ale merchant wholesalers; Beer merchant wholesalers; Beverages, alcoholic (except distilled spirits, wine), merchant wholesalers; Fermented malt beverages merchant wholesalers;and Porter merchant wholesalers."

## SIC Classification
[SIC Code Structure](https://www.osha.gov/pls/imis/sic_manual.html) description on how the SIC is structure for industries. Breweries are in:

* [Division D: Manufacturing](https://www.osha.gov/pls/imis/sic_manual.display?id=4&tab=division) 19-- in 1986, but 20-- from 1987 to 1997.
    * [Major Group 20](https://www.osha.gov/pls/imis/sic_manual.display?id=13&tab=group): Food And Kindred Products
        * Industry Group 208: Beverages
            * [2082 Malt Beverages](https://www.osha.gov/pls/imis/sic_manual.display?id=467&tab=description)

Description entails: "Establishments primarily engaged in manufacturing malt beverages. Establishments primarily engaged in bottling purchased malt beverages are classified in Industry 5181. (Ale; Beer (alcoholic beverage); Breweries; Brewers' grain; Liquors, malt; Malt extract, liquors, and syrups; Near beer; Porter (alcoholic beverage); Stout (alcoholic beverage))"

For the distribution, [Beer and Ale SIC 5181](https://www.osha.gov/pls/imis/sic_manual.display?id=7&tab=description) gives a description of distributors:

* [Division F: Wholesale Trade](https://www.osha.gov/pls/imis/sic_manual.display?id=6&tab=division) 50--
    * [Major Group 51](https://www.osha.gov/pls/imis/sic_manual.display?id=44&tab=group): Wholesale Trade-non-durable Goods
        * Industry Group 518: Beer, Wine, And Distilled Alcoholic Beverages
            * [5181 Beer and Ale](https://www.osha.gov/pls/imis/sic_manual.display?id=7&tab=description)

Description entails: "Establishments primarily engaged in the wholesale distribution of beer, ale, porter, and other fermented malt beverages; Ale-wholesale; Beer and other fermented malt liquors-wholesale Porter-wholesale"


# Helpful Websites

* [University of Denver](http://libguides.du.edu/c.php?g=90474&p=581818) research guide to the U.S. beer industry.
* [USGS Water Quality Data](http://water.usgs.gov/owq/data.html) for in-depth look at a key input to the beer making process.
* [All About Beer Magazine](http://allaboutbeer.com/) various articles on the growth of breweries across the United States as well as descriptions of brewers choices of locations.

## North Carolina Brew

[THE VEGETABLE ROOTS OF THE NORTH CAROLINA BEER BOOM](http://allaboutbeer.com/north-carolina-beer-history/)

>The Stroh’s brewery, which that company had acquired from a failing Jos. Schlitz in 1982, dated from late 1969. It was then the first new brewery in North Carolina since the repeal of Prohibition in 1933. It would close in August 1999
> 
> ...
> 
>It was in 1986, in fact, that things began to really pick up beer-wise in North Carolina. On the Fourth of July that year, the Weeping Radish brewpub opened in Manteo, a town on the Outer Banks, the islands that line much of North Carolina’s coast.

[STATE OF GROWTH: THE RISE OF NORTH CAROLINA BEER](http://allaboutbeer.com/state-of-growth-the-rise-of-north-carolina-beer/) - key quote:

>While brewery openings waned, others sought to grow North Carolina’s beer scene in another way—by raising the state’s 6% ABV cap. Sean Lilly Wilson (who would later open Durham’s Fullsteam Brewery in 2010) and a group of beer enthusiasts did just that through Pop the Cap, a grassroots movement that—through educational events, tastings and lobbying—helped **raise that cap to 15% in August of 2005.**


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