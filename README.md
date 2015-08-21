**[Download KML file for Google Earth Here](https://github.com/cbdavis/Visualizing-Shipments-from-Coal-Mines-to-US-Power-Plants/raw/master/US-Coal-Mines-and-Powerplants.kmz)**

# Overview
On August 3, 2015 the [Clean Power Plan](http://www2.epa.gov/cleanpowerplan/clean-power-plan-existing-power-plants) was finalized by the U.S. Environmental Protection Agency.  This was accompanied by both celebration and controversy.  The coal industry in particular is quite concerned over the impacts that this may have on their industry.  

The US states differ considerably in terms of how much coal they produce, and how much they use for electricity generation.  This visualization allows you to explore the web of dependencies between both the production and consumption of coal.

![Visualization of all US Data](https://raw.githubusercontent.com/cbdavis/Visualizing-Shipments-from-Coal-Mines-to-US-Power-Plants/master/images/ScreenshotWholeUS.png)
*Exports from Wyoming dominate the landscape, with a much lesser amount coming from Appalachia.*

![](https://raw.githubusercontent.com/cbdavis/Visualizing-Shipments-from-Coal-Mines-to-US-Power-Plants/master/images/ScreenshotZoomedIn.png)

*Coal-fired power plants in Alabama source much of their coal from local mines.  On the horizon, Wyoming can be seen with its coal exports to the rest of the nation.*

![](https://raw.githubusercontent.com/cbdavis/Visualizing-Shipments-from-Coal-Mines-to-US-Power-Plants/master/images/FilterByFolderOrPlacemark.png)  


  
*By selecting folders in the sidebar you can see the destinations for all the coal mined within a state or all the origins for all the coal consumed by power plants within a state.  You can make further subselections on individual mines or power plants.*

#Source Data
* [Data on mines](http://catalog.data.gov/dataset/mines-ae135) and their locations is from the U.S. Department of Labor Mine Safety and Health Administration
* [Power plant coordinates](http://www.eia.gov/electricity/data/eia860/) sourced from EIA Form 860
* [Shipments from coal mines to power plants](http://www.eia.gov/electricity/data/eia923/) sourced from EIA form 923
* Map icons are sourced from the [Maps Icons Collection](https://mapicons.mapsmarker.com)

# Running the Source Code
Make sure to open this as a project in [RStudio](https://www.rstudio.com/) as this will take care of all path issues.  The main file to run is `CreateVisualization.R`, which will call the rest of the code.  Make sure that you have the specified libraries installed, and everything should work out of the box, with a new US-Coal-Mines-and-Powerplants.kmz being generated.

# Questions, Comments, Suggestions
I can be reached at c.b.davis@rug.nl




