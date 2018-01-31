library(tidyverse) # which includes pkg.s such as dplyr, ggplot2, etc.
library(data.table)
library(shiny)
library(shinythemes)
library(leaflet)
library(leaflet.extras) 

cat('\014');  # MATLAB user's favorite: "clc"
rm(list = ls());  # MATLAB user's favorite: "clear all"

boros     = c('Bronx', 'Brooklyn', 'Manhattan', 'Queens', 'Staten Island');
months     = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");

nyc2017     = fread('nyc2017.csv',     sep=',', header = TRUE);
nyc2017_z   = fread('nyc2017_z.csv',   sep=',', header = TRUE);
nyc2017_Vol = fread('nyc2017_Vol.csv', sep=',', header = TRUE);
volume_stats_by_month = 
              fread('Volume_Stats_by_Month.csv', sep = ',', header = TRUE)