source("CleanColnames.R")

# create a data directory to organize things - the zip files downloaded contains lots of spreadsheets
dir.create("data")

##### U.S. Department of Labor Mine Safety and Health Administration #####
# Metadata: http://catalog.data.gov/dataset/mines-ae135
if (!file.exists("./data/Mines.zip")){
  download.file("http://www.msha.gov/OpenGovernmentData/DataSets/Mines.zip", "./data/Mines.zip")  
  unzip("./data/Mines.zip", exdir="./data")
}

mines = read.csv("./data/Mines.txt", sep="|", header=TRUE)
mines = mines[,c("MINE_ID", "CURRENT_MINE_NAME", "LONGITUDE", "LATITUDE", "STATE")]
colnames(mines)[3] = "MINE_LONGITUDE"
colnames(mines)[4] = "MINE_LATITUDE"
colnames(mines)[5] = "MINE_STATE"

##### EIA form 860 - contains power plant coordinates #####
# http://www.eia.gov/electricity/data/eia860/
if (!file.exists("./data/eia8602013.zip")){
  download.file("http://www.eia.gov/electricity/data/eia860/xls/eia8602013.zip", "./data/eia8602013.zip")
  unzip("./data/eia8602013.zip", exdir="./data")
}

powerPlantCoords = cleanColnames(readWorksheet(loadWorkbook("./data/2___Plant_Y2013.xlsx"), sheet=1, startRow=2, header=TRUE))
powerPlantCoords = powerPlantCoords[,c("plant_code", "plant_name", "state", "latitude", "longitude")]
gc()

##### EIA form 923 - contains data on shipments from coal mines to power plants #####
# http://www.eia.gov/electricity/data/eia923/
if (!file.exists("./data/f923_2013.zip")){
  download.file("http://www.eia.gov/electricity/data/eia923/xls/f923_2013.zip", "./data/f923_2013.zip")
  unzip("./data/f923_2013.zip", exdir="./data")
}

powerPlantsAndSourceMines = cleanColnames(readWorksheet(loadWorkbook("./data/EIA923_Schedules_2_3_4_5_2013_Final_Revision.xlsx"), sheet=5, startRow=5, header=TRUE))
keepLocs = which(!is.na(powerPlantsAndSourceMines$coalmine_msha_id) & powerPlantsAndSourceMines$coalmine_msha_id != "")
powerPlantsAndSourceMines = powerPlantsAndSourceMines[keepLocs, 
                                                      c("year", "month", "plant_id", "plant_name", "quantity", "average_heat_content", "average_sulfur_content", "average_ash_content", "fuel_cost", "coalmine_msha_id", "coalmine_name")]
gc()

df = merge(powerPlantsAndSourceMines, powerPlantCoords, all.x=TRUE, by.x="plant_id", by.y="plant_code")
df$plant_name = df$plant_name.y
df$plant_name.x = NULL
df = merge(df, mines, by.x="coalmine_msha_id", by.y="MINE_ID")
# make mine longitude negative, currently degrees East
df$MINE_LONGITUDE = 0 - df$MINE_LONGITUDE

# coordinates for the Red Brush Mine are wrong in the original data (middle of Atlantic)
df$MINE_LONGITUDE[which(df$coalmine_msha_id == 1202259)] = -87.299222

removeLocs = which(is.na(df$MINE_LATITUDE) | is.na(df$MINE_LONGITUDE) | is.na(df$latitude) | is.na(df$longitude))
df = df[-removeLocs,]
df$latitude = as.numeric(df$latitude)
df$longitude = as.numeric(df$longitude)

df = sqldf("select coalmine_msha_id, plant_id, state, MINE_STATE, CURRENT_MINE_NAME, plant_name, sum(quantity) as quantity, latitude, longitude, MINE_LATITUDE, MINE_LONGITUDE from df group by coalmine_msha_id, plant_id")

stateAbbrevs = read.csv("US_state_abbreviations.csv", sep=";")
stateNames = stateAbbrevs$name
names(stateNames) = stateAbbrevs$abbreviation

df$PowerPlantStateName = stateNames[df$state]
df$MineStateName = stateNames[df$MINE_STATE]