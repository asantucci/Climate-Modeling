# Climate-Modeling
This data challenge is a multi-class classification problem involving three international climate models. Different climate models involve alternative ways to characterize the physical system, resulting in different forecasts. Each model has an inherent bias in the way in which it forecasts climate.

The challenge is focused on determining whether the biases are significant enough to make differentiation of location specific forecasts possible. 

The data includes just over 100 years of monthly data, by location, starting in 1900 and ending in 2005.

### Training Data
The training data consists of four 'runs' of the climate model (each seeded differently) at each unique latitude and longitude location. A fifth run is withheld from the data at random. The ordering of the runs presented in the training data has been scrambled.

The training data has two variables describing longitude and latitude, 1,271 variables describing temperatures measured in each year-month from 1900 through 2005. Each model has a different "resolution", meaning that the step-size for adjacent locations is different.

### Test Data
The goal of the contest is to correctly classify the generating model for 30,000 observations of the test data. The test data consists of latitude and longitude coordinates, as well as a time-series of temperature data for each location. A total of 55,296 observations were withheld from model 1, 51,200 observations were withheld from model 2, and another 32768 observations were withheld from model 3 (the model with lowest resolution). 10,000 observations are randomly selected from each model to comprise the test data set. The observations are ordered by latitude and longitude, however, observations within the same lat/lon have been shuffled.

### Output
The output should consist of a single user-entered value from {1, 2, 3} describing the choice of the generating model for each observation.