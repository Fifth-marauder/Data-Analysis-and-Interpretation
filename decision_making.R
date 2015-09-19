setwd("C:/Users/spo12/Dropbox/coursera/Data Management and Visualization")
setwd("C:/Users/Sarah/Dropbox/coursera/Data Management and Visualization")
options(stringsAsFactors=FALSE)

gapminder <- read.table("gapminder.csv", sep=",", header=TRUE, quote="\"")
summary(gapminder)

# alcohol consumption versus urban population (both measured/collected in 2008)
plot(gapminder$urbanrate, gapminder$alcconsumption)

# suicide per 100K versus breast cancer per 100K (female) from 2005 and 2002, respectively
plot(gapminder$suicideper100th, gapminder$breastcancerper100th)

# HIV prevalence (in %) versus life expectancy at birth, 2009 and 2011 (but HIV has quite a number of NAs)
plot(gapminder$hivrate, gapminder$lifeexpectancy)

# OK, female employees versus all... (2007)
plot(gapminder$femaleemployrate, gapminder$employrate)

# internet users per 100 people versus income per person (2010)
plot(gapminder$internetuserate, gapminder$incomeperperson)

# armed forces rate (no year) versus democracy score (2009)
plot(gapminder$armedforcesrate, gapminder$polityscore)

# life expectancy at birth versus CO2 emissions (2011 and 2006)
plot(gapminder$lifeexpectancy, gapminder$co2emissions)


### more complex ###
plot(gapminder$incomeperperson, gapminder$internetuserate, gapminder$alcconsumption, gapminder$urbanrate)


### just plot all, Goddamit ###
plot(gapminder[,2:16])


# Ok, breast cancer with internet usage
plot(gapminder$breastcancerper100th, gapminder$internetuserate)
abline(lm(gapminder$internetuserate ~ gapminder$breastcancerper100th))

gapminder[which.max(gapminder$co2emissions),]
