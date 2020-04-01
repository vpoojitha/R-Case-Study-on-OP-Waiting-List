##Case study on 'OP Waiting List- National Open Data Portal'

#Loading libraries
library('ckanr')
library('tidyverse')
library('dplyr')
library('ggplot2')

# Accessing the datasets available on Open Data Platform (www.data.gov.ie)

#setting up the url
ckanr_setup(url = "https://data.gov.ie")

# viewing all the available packages as table
package_list(as = "table")

#package retrieval
#Searching for the "OP Waiting List" package
all_packages <- package_search(q = 'OP Waiting List By Group Hospital')$results[1]

#Displaying all the resources available in OP waiting list package 
all_resources <- package_show("7a6cc878-5b09-476e-be5e-6165a9d7130c", as="table")$resources


#Resources in Hospital package year wise
resource_2014 <- fetch(resource_show(id = "665c02c5-f01d-483f-a1ce-95290b186aaa", as = "table")$url)
resource_2015 <- fetch(resource_show(id = "2d91da47-6039-445e-b0d9-bde9ba1a600d", as = "table")$url)
resource_2016 <- fetch(resource_show(id = "a83d466f-2d12-4183-bdf1-e98afcc1d0d1", as = "table")$url)
resource_2017 <- fetch(resource_show(id = "4573fa36-4392-4b7b-9053-4a910d5c3257", as = "table")$url)
resource_2018 <- fetch(resource_show(id = "a7f03b43-008b-4174-9f3f-e08b37e11433", as = "table")$url)

#Preprocessing the data 

#Splitting the date column and renaming other columns

resource_2014<- resource_2014 %>% separate(X.U.FEFF.Archive.Date,into=c("Year","Month","Date"),sep="-",remove=TRUE,convert=FALSE)
resource_2015<- resource_2015 %>% separate(X.U.FEFF.Archive.Date,into=c("Year","Month","Date"),sep="-",remove=TRUE,convert=FALSE)
resource_2016<- resource_2016 %>% separate(X.U.FEFF.Archive.Date,into=c("Year","Month","Date"),sep="-",remove=TRUE,convert=FALSE)
resource_2017<- resource_2017 %>% separate(X.U.FEFF.Archive.Date,into=c("Year","Month","Date"),sep="-",remove=TRUE,convert=FALSE)
resource_2018<- resource_2018 %>% separate(X.U.FEFF.2018.01.31,into=c("Year","Month","Date"),sep="-",remove=TRUE,convert=FALSE)


resource_2014 = resource_2014 %>% select(Year ,Hospital, Specialty,Age.Categorisation,Count)
resource_2015 = resource_2015 %>% select(Year ,Hospital, Specialty,Age.Categorisation,Count)
resource_2016 =resource_2016 %>% select(Year ,Hospital, Specialty,Age.Categorisation,Count)
resource_2017 =resource_2017 %>%  rename(Age.Categorisation= Age.Profile,Count= Total,Specialty= Speciality) %>% select(Year ,Hospital, Specialty,Age.Categorisation,Count)
resource_2018 =resource_2018 %>% rename(Hospital= Childrens.University.Hospital.Temple.Street, Specialty=Cardiology,Age.Categorisation =X.0.15,Count=X167) %>%select(Year ,Hospital, Specialty,Age.Categorisation,Count)


##Integrating the datasets into one dataset

final_dataset <- rbind.data.frame(resource_2014,resource_2015,resource_2016,resource_2017,resource_2018)
#View(Final_dataset)

#Renaming age.categorisation column 
final_dataset =final_dataset %>%  rename(Age_group= Age.Categorisation)

#Filtering null or blank enteries in age group column and adding a new column with corresponding age category
final_dataset <- final_dataset %>% filter(!(Age_group=="")) %>%  mutate(Age_category = case_when(
  Age_group == " 0-15" ~ 'Child',
  Age_group == "16-64" ~ 'Adult',
  Age_group == "65+" ~ 'Elderly'))

View(age_df)


#Aggregating the count of Hospital, Speciality and age withrespect to year

#Year-Hospital
hospital_df<-final_dataset%>% group_by(Year,Hospital) %>% summarise(Total=mean(Count))

#Year-Speciality
Speciality_df<-final_dataset%>% group_by(Year,Specialty) %>% summarise(Total=mean(Count))

#Year-Age_group
age_df<-final_dataset%>% group_by(Year,Age_category,Age_group) %>% summarise(Total=mean(Count))


#Converting the dataframe into csv files
write.csv(final_dataset,"C:/Users/Poojitha/Desktop/NUIG_DA//final_dataset", row.names = FALSE)



#Plot 1 : Point graph of hospitals by years
ggplot(hospital_df, mapping=aes( y = Hospital,x=Total, color=Year)) +
  geom_point()+
  scale_alpha_manual(values=c(0.5,0.7,0.5,0.6,0.4))+
  xlab("Average count")+
  ylab("Hospitals")+
  theme_bw()+
  ggtitle("Point graph of waiting groups in hospitals by years")



#Plot 2 : Point graph of Speciality by years
ggplot(Speciality_df, mapping=aes( y = Specialty,x=Total, color=Year)) +
  geom_point()+
  scale_alpha_manual(values=c(0.5,0.7,0.5,0.6,0.4))+
  xlab("Average count")+
  ylab("Specialities")+
  theme_bw()+
  ggtitle("Point graph of Speciality by years")



#Plot 3 : Bar graph of Age Category by Years
ggplot(age_df, mapping = aes(x=Year, y=Total, colour=Age_category,  fill =Age_category ))+
  geom_bar(stat="identity",position = position_dodge(),na.rm = TRUE,show.legend = TRUE )+
  facet_grid(~Age_group)+
  xlab("Year")+
  ylab("Average Count")+
  theme_classic()+
  ggtitle("Bar graph of Age Category by Years")

