# Data Management - R
Sarah Pohl  
Wednesday, October 5, 2015  



As [mentioned before](http://lilithelina.tumblr.com/post/128638794919/choice-of-language), I want to compare Python and R analysis steps in the [DataManViz](http://lilithelina.tumblr.com/tagged/DataManViz) project, so this is the R version of the [Data Managment in Python script](http://lilithelina.tumblr.com/post/130065040767/data-management-python). Again, the whole thing will look better over [here](http://htmlpreview.github.io/?https://github.com/LilithElina/Data-Management-and-Visualization/blob/master/Week_Three.html).

As with the Python script, I will first run all the code from last time in one chunk, which is really not much: just removing variables I don't need and observations for which important data is missing.


```r
gapminder <- read.table("gapminder.csv", sep = ",", header = TRUE, quote = "\"")

# subset data
sub_data <- subset(gapminder, select = c("country", "breastcancerper100th", 
    "femaleemployrate", "internetuserate"))

# remove rows with NAs
sub_data2 <- na.omit(sub_data)
```

Data management in my case means only that I'm going to group my continuous variables to get another overview of the data. The easiest way to get such an overview is simply using `summary()`, as I did before, but I can also group them manually.


```r
# print a data summary, excluding the 'country' variable
summary(sub_data2[, 2:4])
```

```
 breastcancerper100th femaleemployrate internetuserate 
 Min.   :  3.90       Min.   :12.40    Min.   : 0.720  
 1st Qu.: 20.73       1st Qu.:38.90    1st Qu.: 9.637  
 Median : 30.45       Median :47.80    Median :29.440  
 Mean   : 37.90       Mean   :47.73    Mean   :34.082  
 3rd Qu.: 50.38       3rd Qu.:55.88    3rd Qu.:52.769  
 Max.   :101.10       Max.   :83.30    Max.   :95.638  
```

In the Python script, I created five equally sized bins using the `qcut` function. A similar function in R is `cut2()`:


```r
# create five equal-sized groups per variable
library(Hmisc)
sub_data2["breastGroup"] <- cut2(sub_data2$breastcancerper100th, g = 5)
sub_data2["employGroup"] <- cut2(sub_data2$femaleemployrate, g = 5)
sub_data2["internGroup"] <- cut2(sub_data2$internetuserate, g = 5)
```


```r
# print frequency counts for the groups
print("frequency of breast cancer groups:")
cbind(counts = table(sub_data2$breastGroup), percentages = prop.table(table(sub_data2$breastGroup)))

print("frequency of female employment groups:")
cbind(counts = table(sub_data2$employGroup), percentages = prop.table(table(sub_data2$employGroup)))

print("frequency of internet usage groups:")
cbind(counts = table(sub_data2$internGroup), percentages = prop.table(table(sub_data2$internGroup)))
```

```
[1] "frequency of breast cancer groups:"
             counts percentages
[ 3.9, 19.5)     33   0.2037037
[19.5, 26.1)     32   0.1975309
[26.1, 35.1)     33   0.2037037
[35.1, 55.5)     32   0.1975309
[55.5,101.1]     32   0.1975309
[1] "frequency of female employment groups:"
            counts percentages
[12.4,36.8)     33   0.2037037
[36.8,44.8)     32   0.1975309
[44.8,50.9)     33   0.2037037
[50.9,58.3)     32   0.1975309
[58.3,83.3]     32   0.1975309
[1] "frequency of internet usage groups:"
             counts percentages
[ 0.72, 7.0)     33   0.2037037
[ 7.00,16.8)     32   0.1975309
[16.78,39.8)     33   0.2037037
[39.82,65.2)     32   0.1975309
[65.16,95.6]     32   0.1975309
```

The results look slightly different than they did in Python, as R creates slightly different bins. While Python seems to prefer to have the first and last group contain 33 instead of 32 variables, R chooses the first and third bin to be bigger. Additionally, R creates bins with inclusive endpoints, while Python uses inclusive start points - that's the "[...)" and "(...]" notation, respectively. This shows - if nothing else - how easy it is to get slightly different results when grouping continuous data. We can check if this has an influence on the analysis in the next - and last - part of the course.
