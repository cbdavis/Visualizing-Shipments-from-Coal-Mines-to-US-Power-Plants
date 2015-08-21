#never ever ever convert strings to factors
options(stringsAsFactors = FALSE)
options(java.parameters="-Xmx4g")

library(XLConnect)
library(geosphere)
library(sqldf)

# downloads data from official sources processes it, and returns data frames to the working environment
source("DownloadData.R")

fileConn<-file("doc.kml", open="w")

writeLines('<?xml version="1.0" encoding="UTF-8"?>', fileConn)
writeLines('<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">', fileConn)
writeLines('<Document>', fileConn)
writeLines('<name>Coal Production and Consumption in the US Electricity Sector</name>', fileConn)

writeLines('<Style id="sn_powerplantBlackBackground">', fileConn)
writeLines('<LabelStyle>', fileConn)
writeLines('<scale>0.6</scale>', fileConn)
writeLines('</LabelStyle>', fileConn)
writeLines('<IconStyle>', fileConn)
writeLines('<scale>0.8</scale>', fileConn)
writeLines('<Icon>', fileConn)
writeLines('<href>icons/powerplant.png</href>', fileConn)
writeLines('</Icon>', fileConn)
writeLines('</IconStyle>', fileConn)
writeLines('<ListStyle>', fileConn)
writeLines('</ListStyle>', fileConn)
writeLines('</Style>', fileConn)
writeLines('<Style id="sh_powerplantBlackBackground">', fileConn)
writeLines('<IconStyle>', fileConn)
writeLines('<scale>1.4</scale>', fileConn)
writeLines('<Icon>', fileConn)
writeLines('<href>icons/powerplant.png</href>', fileConn)
writeLines('</Icon>', fileConn)
writeLines('</IconStyle>', fileConn)
writeLines('<ListStyle>', fileConn)
writeLines('</ListStyle>', fileConn)
writeLines('</Style>', fileConn)
writeLines('<StyleMap id="msn_powerplantBlackBackground">', fileConn)
writeLines('<Pair>', fileConn)
writeLines('<key>normal</key>', fileConn)
writeLines('<styleUrl>#sn_powerplantBlackBackground</styleUrl>', fileConn)
writeLines('</Pair>', fileConn)
writeLines('<Pair>', fileConn)
writeLines('<key>highlight</key>', fileConn)
writeLines('<styleUrl>#sh_powerplantBlackBackground</styleUrl>', fileConn)
writeLines('</Pair>', fileConn)
writeLines('</StyleMap>', fileConn)

writeLines('<Style id="sn_mineBlackBackground">', fileConn)
writeLines('<LabelStyle>', fileConn)
writeLines('<scale>0.6</scale>', fileConn)
writeLines('</LabelStyle>', fileConn)
writeLines('<IconStyle>', fileConn)
writeLines('<scale>0.8</scale>', fileConn)
writeLines('<Icon>', fileConn)
writeLines('<href>icons/mine.png</href>', fileConn)
writeLines('</Icon>', fileConn)
writeLines('</IconStyle>', fileConn)
writeLines('<ListStyle>', fileConn)
writeLines('</ListStyle>', fileConn)
writeLines('</Style>', fileConn)
writeLines('<Style id="sh_mineBlackBackground">', fileConn)
writeLines('<IconStyle>', fileConn)
writeLines('<scale>1.4</scale>', fileConn)
writeLines('<Icon>', fileConn)
writeLines('<href>icons/mine.png</href>', fileConn)
writeLines('</Icon>', fileConn)
writeLines('</IconStyle>', fileConn)
writeLines('<ListStyle>', fileConn)
writeLines('</ListStyle>', fileConn)
writeLines('</Style>', fileConn)
writeLines('<StyleMap id="msn_mineBlackBackground">', fileConn)
writeLines('<Pair>', fileConn)
writeLines('<key>normal</key>', fileConn)
writeLines('<styleUrl>#sn_mineBlackBackground</styleUrl>', fileConn)
writeLines('</Pair>', fileConn)
writeLines('<Pair>', fileConn)
writeLines('<key>highlight</key>', fileConn)
writeLines('<styleUrl>#sh_mineBlackBackground</styleUrl>', fileConn)
writeLines('</Pair>', fileConn)
writeLines('</StyleMap>', fileConn)

numQuantityClasses = 10

for (i in c(1:numQuantityClasses)){
  
  lineWidth = i
  
  writeLines(paste('<StyleMap id="QuantityClass', i, '">', sep=""), fileConn)
  writeLines('<Pair>', fileConn)
  writeLines('<key>normal</key>', fileConn)
  writeLines(paste('<styleUrl>#QuantityClass', i, '_normal</styleUrl>', sep=""), fileConn)
  writeLines('</Pair>', fileConn)
  writeLines('<Pair>', fileConn)
  writeLines('<key>highlight</key>', fileConn)
  writeLines(paste('<styleUrl>#QuantityClass', i, '_highlight</styleUrl>', sep=""), fileConn)
  writeLines('</Pair>', fileConn)
  writeLines('</StyleMap>', fileConn)
  
  writeLines(paste('<Style id="QuantityClass', i, '_normal">', sep=""), fileConn)
  writeLines('<LineStyle>', fileConn)
  writeLines('<color>4c00ffff</color>', fileConn)
  writeLines(paste('<width>', lineWidth, '</width>', sep=""), fileConn)
  writeLines('</LineStyle>', fileConn)
  writeLines('</Style>', fileConn)
  
  writeLines(paste('<Style id="QuantityClass', i, '_highlight">', sep=""), fileConn)
  writeLines('<LineStyle>', fileConn)
  writeLines('<color>4cffffff</color>', fileConn)
  writeLines(paste('<width>', lineWidth, '</width>', sep=""), fileConn)
  writeLines('</LineStyle>', fileConn)
  writeLines('</Style>', fileConn)
  
}

writeLines(paste('<Folder><open>0</open><visibility>0</visibility><name>Coal-Fired Power Plants</name>', sep=""), fileConn)

df = df[with(df, order(plant_name)), ]

# find all the power plants mentioned
powerPlantIDs = unique(df$plant_id)
for (plantID in powerPlantIDs){
  loc = which(df$plant_id == plantID)[1]
  name = df$plant_name[loc]
  lat = df$latitude[loc]
  lon = df$longitude[loc]
  
  writeLines(paste('<Placemark><name><![CDATA[', name, ']]></name><styleUrl>#msn_powerplantBlackBackground</styleUrl>', sep=""), fileConn)
  writeLines(paste('<Point><coordinates>',lon, ',', lat, ',0</coordinates></Point>', sep=""), fileConn)
  writeLines('</Placemark>', fileConn)
}

writeLines('</Folder>', fileConn)


writeLines(paste('<Folder><open>0</open><visibility>0</visibility><name>Coal Mines</name>', sep=""), fileConn)

df = df[with(df, order(CURRENT_MINE_NAME)), ]

# find all the mines mentioned
mineIDs = unique(df$coalmine_msha_id)
for (mineID in mineIDs){
  loc = which(df$coalmine_msha_id == mineID)[1]
  name = df$CURRENT_MINE_NAME[loc]
  lat = df$MINE_LATITUDE[loc]
  lon = df$MINE_LONGITUDE[loc]
  
  writeLines(paste('<Placemark><name><![CDATA[', name, ']]></name><styleUrl>#msn_mineBlackBackground</styleUrl>', sep=""), fileConn)
  writeLines(paste('<Point><coordinates>',lon, ',', lat, ',0</coordinates></Point>', sep=""), fileConn)
  writeLines('</Placemark>', fileConn)
}

writeLines('</Folder>', fileConn)

numSegments = 35

lineCoords = gcIntermediate(cbind(df$MINE_LONGITUDE, df$MINE_LATITUDE), 
                            cbind(df$longitude, df$latitude), n=numSegments, addStartEnd = TRUE)

df$distance = distCosine(cbind(df$MINE_LONGITUDE, df$MINE_LATITUDE), 
                         cbind(df$longitude, df$latitude))

# group into folders base on state and then on mine

df$LineCoords = lineCoords

writeLines(paste('<Folder><open>1</open><visibility>0</visibility><name>Coal Produced per State</name>', sep=""), fileConn)

df = df[with(df, order(MineStateName, CURRENT_MINE_NAME)), ]

mineStates = sort(unique(df$MineStateName))
for (mineState in mineStates){
  locs = which(df$MineStateName == mineState)
  minesInState = df[locs,]
  
  # folder for the state
  writeLines(paste('<Folder><name>',mineState,'</name>', sep=""), fileConn)
  
  mineList = unique(minesInState$CURRENT_MINE_NAME)
  for (mine in mineList){
    # folder for each mine
    writeLines(paste('<Folder><name><![CDATA[',mine,']]></name>', sep=""), fileConn)
    
    for (index in which(minesInState$CURRENT_MINE_NAME == mine)){
      lineCoord = matrix(unlist(minesInState$LineCoords[index]), ncol=2)
      
      writeLines('<Placemark>', fileConn)
      writeLines(paste('<name><![CDATA[', minesInState$CURRENT_MINE_NAME[index], " -> ", minesInState$plant_name[index], ']]></name>',sep=""), fileConn)
      writeLines(paste('<description><![CDATA[', 
                       minesInState$CURRENT_MINE_NAME[index], " -> ", minesInState$plant_name[index], 
                       ', ', prettyNum(minesInState$quantity[index],big.mark=",",scientific=FALSE), ' tons in 2013', 
                       ']]></description>',sep=""), fileConn)
      
      quantityClass = 1 + round((minesInState$quantity[index] / max(minesInState$quantity)) * (numQuantityClasses-1))
      
      writeLines(paste('<styleUrl>#QuantityClass',quantityClass,'</styleUrl>', sep=""), fileConn)
      
      writeLines('<LineString>', fileConn)
      writeLines('<tessellate>1</tessellate>', fileConn)
      writeLines('<altitudeMode>relativeToGround</altitudeMode>', fileConn)
      writeLines('<coordinates>', fileConn)
      
      #radius = 50000
      
      radius = minesInState$distance[index]/5
      # semicircleprofile
      height = radius * sin(seq(0,180,5)*pi/180)
      
      lineString = paste(apply( cbind(lineCoord, height) , 1 , paste , collapse = "," ), collapse=" ")
      writeLines(lineString, fileConn)
      
      writeLines('</coordinates>', fileConn)
      writeLines('</LineString>', fileConn)
      
      writeLines('</Placemark>', fileConn)
    }
    writeLines('</Folder>', fileConn)
  }
  writeLines('</Folder>', fileConn)
}
writeLines('</Folder>', fileConn)

# don't have this checked initially.  
# There is no way to have radio folders where we can switch between the top level folders and then select all of the subitems
# With the radio option, only single subitems can be selected
writeLines(paste('<Folder><open>1</open><visibility>1</visibility><name>Coal Consumed per State</name>', sep=""), fileConn)


df = df[with(df, order(PowerPlantStateName, plant_name)), ]
powerPlantStates = sort(unique(df$PowerPlantStateName))
for (state in powerPlantStates){
  locs = which(df$PowerPlantStateName == state)
  minesInState = df[locs,]
  
  # folder for the state
  writeLines(paste('<Folder><name>',state,'</name>', sep=""), fileConn)
  
  plants = unique(minesInState$plant_name)
  for (plant in plants){
    # folder for each mine
    writeLines(paste('<Folder><name><![CDATA[',plant,']]></name>', sep=""), fileConn)
    
    for (index in which(minesInState$plant_name == plant)){
      lineCoord = matrix(unlist(minesInState$LineCoords[index]), ncol=2)
      
      writeLines('<Placemark><visibility>0</visibility>', fileConn)
      writeLines(paste('<name><![CDATA[', minesInState$CURRENT_MINE_NAME[index], " -> ", minesInState$plant_name[index], ']]></name>',sep=""), fileConn)
      writeLines(paste('<description><![CDATA[', 
                       minesInState$CURRENT_MINE_NAME[index], " -> ", minesInState$plant_name[index], 
                       ', ', prettyNum(minesInState$quantity[index],big.mark=",",scientific=FALSE), ' tons in 2013', 
                       ']]></description>',sep=""), fileConn)
      
      quantityClass = 1 + round((minesInState$quantity[index] / max(minesInState$quantity)) * (numQuantityClasses-1))
      
      writeLines(paste('<styleUrl>#QuantityClass',quantityClass,'</styleUrl>', sep=""), fileConn)
      
      writeLines('<LineString>', fileConn)
      writeLines('<tessellate>1</tessellate>', fileConn)
      writeLines('<altitudeMode>relativeToGround</altitudeMode>', fileConn)
      writeLines('<coordinates>', fileConn)
      
      radius = minesInState$distance[index]/5
      # semicircleprofile
      height = radius * sin(seq(0,180,5)*pi/180)
      
      lineString = paste(apply( cbind(lineCoord, height) , 1 , paste , collapse = "," ), collapse=" ")
      writeLines(lineString, fileConn)
      
      writeLines('</coordinates>', fileConn)
      writeLines('</LineString>', fileConn)
      
      writeLines('</Placemark>', fileConn)
    }
    writeLines('</Folder>', fileConn)
  }
  writeLines('</Folder>', fileConn)
}
writeLines('</Folder>', fileConn)

writeLines('</Document>', fileConn)
writeLines('</kml>', fileConn)

close(fileConn)

# create kmz file
zip(zipfile="US-Coal-Mines-and-Powerplants.kmz", files=c("doc.kml", "./icons"))