# R-Case-Study-on-OP-Waiting-List
R CS on Analysis of OP waiting list
This Case Study provides the knowledge of accessing and analysing the datasets available on open data platform. In this task, R program is developed to process OP waiting list data available on National Open Data portal (http://data.gov.ie/). This involves connecting to the CKAN platform and accessing the datasets and associated files for each year on the portal. The datasets from 2014 to 2018 is cleaned , integrated and analysed visually by aggregating the counts by hospital, speciality and age group .
2.Packages used:
•	ckanr: ‘Client for the Comprehensive Knowledge Archive Network’ package is used to search, show and list the packages and resources in https://data.gov.ie API. 
•	tidyverse: is used to tidy the data, here separate function is used split and extract year from the date column.
•	dplyr: is used for data manipulation such as filter, mutate, select and summarize is used for preprocessing of the data.
•	ggplot2: is used to plot the various graph for visual analysis of data.
