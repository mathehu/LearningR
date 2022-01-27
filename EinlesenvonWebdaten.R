
#Vorbereitungen
setwd("~/R")
library(dplyr)


#Einlesen der Webseite
firmenNUe = readLines('https://firmenschau.com/firmenverzeichnis/vorarlberg/nueziders/')
#firmenNUe = readLines('https://www.firmenabc.at/firmen/nueziders_dgl')
firmenNUe

##Firmennamen
grep("result-list recommended", firmenNUe)
f_name <- '<h1 class="fn org" itemprop="name">([^<]*)</h1>'
datalines <-  grep(f_name, firmenNUe[298:length(firmenNUe)], value = TRUE)

getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
gg = gregexpr(f_name,datalines)
matches = mapply(getexpr,datalines,gg)
result = gsub(f_name,'\\1',matches)
names(result) = NULL
result[1:58]
result
FirmenNamen <- result[1:58]
FirmenNamen

##Adresse
grep("result-list recommended", firmenNUe)
f_Adresse <- '<span class="street-address" itemprop="streetAddress">([^<]*)</span>'
datalines <-  grep(f_Adresse, firmenNUe[1:length(firmenNUe)], value = TRUE)

getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
gg = gregexpr(f_Adresse,datalines)
matches = mapply(getexpr,datalines,gg)
result = gsub(f_Adresse,'\\1',matches)
names(result) = NULL
result[1:58]
result
FirmenAdressen <- result[1:58]
FirmenAdressen


##Verknüpfen der Namens- und Adressenvektoren

Spons <- cbind(FirmenNamen, FirmenAdressen)
Spons

##Exportieren der Daten
write.csv(Spons, file = "C:\\Users\\theme.mar\\Documents\\OFN\\Sponsorendaten.csv")
