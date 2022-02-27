library(rvest)
library(tidyverse)
library(dplyr)
library(tidyr)
library(writexl)
library(stringr)
library(purrr)



url <- 'https://www.citymed.ch/psychiatrische-klinik-psychiatrie-klinik/v5-lp-2-199.html'
webpage <- read_html(url)

KlinikName_html <- html_nodes(webpage,'.address_title')
KlinikName <- html_text(KlinikName_html)
KlinikName <- as.data.frame(KlinikName)

KlinikAdresse <- html_nodes(webpage,'.address')
KlinikAdresse1  <- as.data.frame(html_text(KlinikAdresse))

KlinikAdresse2 <- separate(KlinikAdresse1, 1, sep = " ", into = c("Strasse", "Hausnummer", "PLZ", "Ort"))


KlinikTel <- html_nodes(webpage,'.phone')
KlinikTel1 <- as.data.frame(html_text(KlinikTel))

# KlinikInfo <- html_nodes(webpage,'.showd')
# KlinikInfo1 <- as.data.frame(html_text(KlinikInfo))

# KlinikEmail <- html_nodes(webpage,'.mail')
# KlinikEmail1 <- as.data.frame(html_text(KlinikEmail))

# KlinikURL <- html_nodes(webpage,'.url')
# KlinikURL1 <- as.data.frame(html_text(KlinikURL))

Kliniken_CH_Psy <- as.data.frame(c(KlinikName, KlinikAdresse2, KlinikTel1))

write_xlsx(Kliniken_CH_Psy, 'C:/Users/theme.mar/Documents/PriorizR/PsychiatriesKlinikenCH.xlsx')

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
