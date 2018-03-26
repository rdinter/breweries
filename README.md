# Overview
This repository is for ongoing projects involving analysis of breweries and other related activities. The structure of the repository is that one folder, `0-data`, contains all of the data that is used or to be used within this repository. Each project/analysis then has a separate folder which accesses the data folder to perform its task.

# Order of Analysis
The files `0-CBP.R` and `0-ZBP.R` will download all of the raw zipped files related to [County Business Patterns](https://www.census.gov/econ/cbp/download/). For `0-CBP.R`, the downloaded files are from 1986 to 2013 with each file between 7 and 16 MBs (total of about 165 MBs). For `0-ZBP.R`, the files cover 1994 to 2013 with a file for total establishments each year as well as a separate file for industry classifications by zip code. The total files are less than 1 MB in size (total of less than 20 MBs) while the detail files are between 12 and 17 MBs (around 310 MBs).

## Packages Needed
Various packages used are not found on CRAN, therefore the [devtools package](http://cran.r-project.org/web/packages/devtools/index.html) needs to be installed. For instance, the [cleangeo](https://github.com/eblondel/cleangeo) pacakge is needed to clean up the Zip Code shapefile for geometry inconsistencies. The following code is useful for installing packages that are not yet on CRAN:

Current needed packages include: `dplyr`, `RCurl`, `readr`. These are accessible through CRAN and can therefore be installed with the `install.packages()` command.

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
* [Brewer's Association](https://www.brewersassociation.org/) is a trade organization that provides Insights & Analysis, State Craft Beer Stats, National Beer Stats, [Economic Impact](https://www.brewersassociation.org/attachments/0001/3790/State_by_State_Data.pdf), Brewery Production, [Number of Breweries](https://www.brewersassociation.org/statistics/number-of-breweries/), and Market Segments. Their data are proprietary, although for there are [student memberships](http://members.brewersassociation.org/store/detail.aspx?id=INTL_BA_IN) which cost $195 in order to access the data.
* [Beer Serves America](http://www.beerservesamerica.org/) is a biennual economic impact study commissioned by the Beer Institute and National Beer Wholesalers Association. The U.S. brewing industry is a dynamic part of our national economy, contributing billions of dollars in wages and taxes. Also affiliated with [Beer Institute](http://www.beerinstitute.org/) which appears to have similar data to Brewer's Association.

## National Information

[Craft Brewing Industry Still Growing](http://www.cpr.org/news/story/craft-brewing-industry-still-growing-says-boulder-based-trade-group), 27 July 2015:

>The Boulder-based Brewers Association reports craft brewers sold 12.2 million barrels of beer in the first half of 2015 -- a 16 percent increase over the same period last year. The group's new numbers suggest the growth in demand for craft beers isn't slowing down. U.S. production of craft beer has more than doubled since 2011.
>![](http://www.cpr.org/sites/default/files/styles/full-width/public/images/mid-year-craft-production-volume-production_chartbuilder.png?itok=S6ib5nwE)
>
>Bart Watson, chief economist for the Brewers Association, says the numbers reflect a growing demand for craft beer, but warns that growth brings competition.
>![](http://www.cpr.org/sites/default/files/styles/full-width/public/images/mid-year-brewery-count-count_chartbuilder.png?itok=ZT4XnQH0)
>
>That sense of competition will likely only increase in the coming months. 699 breweries opened over the last year, according to the Brewers Association, bringing the total number to 3,739 in the U.S. There are also an additional 1,755 breweries in planning stages.

[The United States of Beer](http://priceonomics.com/the-united-states-of-beer/), 10 July 2015. Various insights from [BeerMenus](https://www.beermenus.com/) data:

>We analyzed the beer listings of 6,000 bars and restaurants across all 50 states to find out exactly which beers predominate menus in which states. Although the macro brews Bud Light, Miller Lite and Coors Light still rule much of the country, according to our dataset, there are many states and cities where the most available beer is one of the plucky underdogs.

[Local Hops Can't Keep Pace With Colorado Breweries](http://www.cpr.org/news/story/local-hops-can-t-keep-pace-colorado-breweries), 14 October 2014:

>Some call the Front Range, with its 230 breweries, the Napa Valley of beer. Unlike Napa, however, Colorado doesn't grow most of the key ingredients, and it’s been a struggle to change that.
>
> ...

## North Carolina Brew

[THE VEGETABLE ROOTS OF THE NORTH CAROLINA BEER BOOM](http://allaboutbeer.com/north-carolina-beer-history/), 9 September 2014:

>The Stroh’s brewery, which that company had acquired from a failing Jos. Schlitz in 1982, dated from late 1969. It was then the first new brewery in North Carolina since the repeal of Prohibition in 1933. It would close in August 1999
> 
> ...
> 
>It was in 1986, in fact, that things began to really pick up beer-wise in North Carolina. On the Fourth of July that year, the Weeping Radish brewpub opened in Manteo, a town on the Outer Banks, the islands that line much of North Carolina’s coast.

[STATE OF GROWTH: THE RISE OF NORTH CAROLINA BEER](http://allaboutbeer.com/state-of-growth-the-rise-of-north-carolina-beer/), 14 June 2015:

>While brewery openings waned, others sought to grow North Carolina’s beer scene in another way—by raising the state’s 6% ABV cap. Sean Lilly Wilson (who would later open Durham’s Fullsteam Brewery in 2010) and a group of beer enthusiasts did just that through Pop the Cap, a grassroots movement that—through educational events, tastings and lobbying—helped **raise that cap to 15% in August of 2005.**

[DISTRIBUTION LAW CAPS NC BREWEERS ABILITY TO GROW](http://www.wral.com/distribution-law-caps-nc-brewers-ability-to-grow/15655744/), 23 April 2016:

>But the state encourages the growth of North Carolina breweries only to a certain point. Brewers can obtain a malt beverage wholesaler permit to sell, deliver and ship at wholesale their own products, but only until the brewery reaches a 25,000 barrel cap of annual production.
> 
> ...
> 
>“Just to put it in perspective, if you were brewing 25,000 barrels and all of a sudden you had to turn over your full allotment to wholesalers, in order to make the same amount of money, you'd have to sell 40,000 barrels immediately.”
> 
> ...
> 
>It’s a double whammy for craft brewers at 25,000 barrels of production — not only must brewers sign with a wholesaler and lose 30 percent of revenue, but franchise law kicks in as well.

## Various
Not sure what to call this, but interesting tidbits from [The Beer Boom: Here, There or Everywhere?](http://datatante.com/?p=259)

[A citylab article on Missoula Montana's brewery scene](https://www.citylab.com/life/2017/08/missoula-taps-the-power-of-beer/535800/)

Craft brewing in Montana, infosheet from [Bureau of Business and Economic Research at the University of Montana](http://montanabrewers.org/wp-content/uploads/2016/12/Brewers-Infographic-2016.jpg)

Beer and cities: A toast to 2017 from [City Commentary](http://cityobservatory.org/beer-and-cities-a-toast-to-2017/)