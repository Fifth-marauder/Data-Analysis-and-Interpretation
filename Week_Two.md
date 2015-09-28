# Data Preparation - R
Sarah Pohl  
Wednesday, September 23, 2015  



As [mentioned before](http://lilithelina.tumblr.com/post/128638794919/choice-of-language), I want to compare Python and R analysis steps in the [DataManViz](http://lilithelina.tumblr.com/tagged/DataManViz) project, so this is the R version of the [Data Preparation in Python script](http://lilithelina.tumblr.com/post/129435011659/data-preparation-python).

In R, I don't need to load extra libraries for data preparation, so we can start with loading the data and having a first look.


```r
gapminder <- read.table("gapminder.csv", sep = ",", header = TRUE, quote = "\"")

# print some information
print(paste("number of observations:", nrow(gapminder)))
print(paste("number of variables:", ncol(gapminder)))
print("types of data:")
str(gapminder)
```

```
[1] "number of observations: 213"
[1] "number of variables: 16"
[1] "types of data:"
'data.frame':	213 obs. of  16 variables:
 $ country             : chr  "Afghanistan" "Albania" "Algeria" "Andorra" ...
 $ incomeperperson     : num  NA 1915 2232 21943 1381 ...
 $ alcconsumption      : num  0.03 7.29 0.69 10.17 5.57 ...
 $ armedforcesrate     : num  0.57 1.02 2.31 NA 1.46 ...
 $ breastcancerper100th: num  26.8 57.4 23.5 NA 23.1 NA 73.9 51.6 NA 83.2 ...
 $ co2emissions        : num  7.59e+07 2.24e+08 2.93e+09 NA 2.48e+08 ...
 $ femaleemployrate    : num  25.6 42.1 31.7 NA 69.4 ...
 $ hivrate             : num  NA NA 0.1 NA 2 NA 0.5 0.1 NA 0.1 ...
 $ internetuserate     : num  3.65 44.99 12.5 81 10 ...
 $ lifeexpectancy      : num  48.7 76.9 73.1 NA 51.1 ...
 $ oilperperson        : num  NA NA 0.42 NA NA ...
 $ polityscore         : int  0 9 2 NA -2 NA 8 5 NA 10 ...
 $ relectricperperson  : num  NA 636 591 NA 173 ...
 $ suicideper100th     : num  6.68 7.7 4.85 5.36 14.55 ...
 $ employrate          : num  55.7 51.4 50.5 NA 75.7 ...
 $ urbanrate           : num  24 46.7 65.2 88.9 56.7 ...
```

Of course, the number of observations and variables is the same whether I use Python or R. A - very comfortable - difference between the languages is that R already guesses the data types of my variables, so I don't have to convert them to numeric before further analysis.

As before, I want to create a subset of the Gapminder data set containing only the country names as unique identifiers and "breastcancerper100th", "femaleemployrate", and "internetuserate" as variables. This is just as easy in R as it is with Python:


```r
# subset data
sub_data <- subset(gapminder, select = c("country", "breastcancerper100th", 
    "femaleemployrate", "internetuserate"))

# print the first five rows
print("first five rows of my subsetted data:")
head(sub_data, 5)
```

```
[1] "first five rows of my subsetted data:"
      country breastcancerper100th femaleemployrate internetuserate
1 Afghanistan                 26.8             25.6        3.654122
2     Albania                 57.4             42.1       44.989947
3     Algeria                 23.5             31.7       12.500073
4     Andorra                   NA               NA       81.000000
5      Angola                 23.1             69.4        9.999954
```

In the Python script I used frequency tables to access the number of NAs in my data subset (and because they were required in the course). In R, to see the number and general distribution of my values of interest, I would simply look at a data summary.


```r
# print a data summary, excluding the 'country' variable
summary(sub_data[, 2:4])
```

```
 breastcancerper100th femaleemployrate internetuserate  
 Min.   :  3.9        Min.   :11.30    Min.   : 0.2101  
 1st Qu.: 20.6        1st Qu.:38.73    1st Qu.: 9.9996  
 Median : 30.0        Median :47.55    Median :31.8101  
 Mean   : 37.4        Mean   :47.55    Mean   :35.6327  
 3rd Qu.: 50.3        3rd Qu.:55.88    3rd Qu.:56.4160  
 Max.   :101.1        Max.   :83.30    Max.   :95.6381  
 NA's   :40           NA's   :35       NA's   :21       
```

Again, I can see the different numbers of NAs in my data: 40 for the breast cancer cases, 35 for the female employ rate, and 21 for internet usage. Additionally, the data summary shows the minima, means, maxima and quartiles for the variables. For example, the female employment rate (considering the female population of at least 15 years of age) ranged between 11.3% and 83.3% in 2007, while the internet use rate starts as low as 0.21 per 100 people in 2010. On average, 37.4 per 100,000 women were diagnosed with breast cancer all over the world - and so on.

Now we have to remove the rows/observations/countries that contain at least one NA, which is as easy here as it is in Python.


```r
# remove rows with NAs
sub_data2 <- na.omit(sub_data)

# print first five rows, summary and row & column number
print("first five rows of my subsetted data:")
head(sub_data2, 5)

print("data summary:")
summary(sub_data2[, 2:4])

print(paste("number of observations:", nrow(sub_data2)))
print(paste("number of variables:", ncol(sub_data2)))
```

```
[1] "first five rows of my subsetted data:"
      country breastcancerper100th femaleemployrate internetuserate
1 Afghanistan                 26.8             25.6        3.654122
2     Albania                 57.4             42.1       44.989947
3     Algeria                 23.5             31.7       12.500073
5      Angola                 23.1             69.4        9.999954
7   Argentina                 73.9             45.9       36.000335
[1] "data summary:"
 breastcancerper100th femaleemployrate internetuserate 
 Min.   :  3.90       Min.   :12.40    Min.   : 0.720  
 1st Qu.: 20.73       1st Qu.:38.90    1st Qu.: 9.637  
 Median : 30.45       Median :47.80    Median :29.440  
 Mean   : 37.90       Mean   :47.73    Mean   :34.082  
 3rd Qu.: 50.38       3rd Qu.:55.88    3rd Qu.:52.769  
 Max.   :101.10       Max.   :83.30    Max.   :95.638  
[1] "number of observations: 162"
[1] "number of variables: 4"
```

The result looks exactly like it did in Python: 162 observations/countries are in the final data set, and there are no NAs left.
