library(rvest)
library(tidyverse)
library(dplyr)
library(tidyr)
library(writexl)
library(stringr)
library(purrr)

# Quelle: https://bookdown.org/joone/ComputationalMethods/web-scraping.html
url1 <- 'https://www.jameda.de/kliniken/psychotherapie/fachgebiet/'

url <- 'https://www.deutsche-depressionshilfe.de/depression-infos-und-hilfe/wo-finde-ich-hilfe/klinikadressen/geo_lat/Frankfurt/geo_lat_range/900'
webpage <- read_html(url)

KlinikName_html <- html_nodes(webpage,'h2')
KlinikName <- html_text(KlinikName_html)
KlinikName <- as.data.frame(KlinikName[-1,])

KlinikAdresse <- html_nodes(webpage,'.address')
KlinikAdresse1  <- as.data.frame(html_text(KlinikAdresse))

KlinikTel <- html_nodes(webpage,'.phone')
KlinikTel1 <- as.data.frame(html_text(KlinikTel))

KlinikEmail <- html_nodes(webpage,'.mail')
KlinikEmail1 <- as.data.frame(html_text(KlinikEmail))

KlinikURL <- html_nodes(webpage,'.url')
KlinikURL1 <- as.data.frame(html_text(KlinikURL))

KlinikenDeut <- as.data.frame(c(KlinikName, KlinikAdresse1, KlinikTel1, KlinikEmail1, KlinikURL1))

write_xlsx(KlinikenDeut, 'C:/Users/theme.mar/Documents/PriorizR/DeDepressionsKlinikenDeut.xlsx')

Klinikliste <- function(url) {
  webpage <- read_html(url)
  
Klinikliste <- webpage %>%
  html_nodes('h2, .address, .phone, .mail, .url') %>% 
  html_text() %>% 
  str_squish()

KlinikListe <- tibble(
  Klinikname = Klinikliste[1],
  Klinikadresse = Klinikliste[2],
  Telefon = Klinikliste[3],
  Email = Klinikliste[4],
  Webseite = Klinikliste[5]
)

Sys.sleep(5)
return(KlinikListe)
}

to_scrape <- c('https://www.deutsche-depressionshilfe.de/depression-infos-und-hilfe/wo-finde-ich-hilfe/klinikadressen/geo_lat/Frankfurt/geo_lat_range/900')

Liste <- map_dfr(to_scrape, Klinikliste)
