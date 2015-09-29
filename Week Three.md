
In week three of the [Data Management and Visualisation course](https://www.coursera.org/learn/data-management-visualization/home/welcome) we're managing our data ([I'm working with](http://lilithelina.tumblr.com/post/128347327089/choice-of-data) the [Gapminder](http://www.gapminder.org/) data set) - which means making decisions about coding in (or out) missing values, creating new variables, and grouping old ones.  
As a reminder, my topic is **"Breast Cancer Causes Internet Usage!"**, or BCCIU for short. The hypothesis is that in countries with more breast cancer cases, the internet use rate is also higher. Additionally, I'm looking at an association between breast cancer and female employment rates (are less women working in a country with more breast cancer cases?).  
As before, the output will look lots better in the [nbviewer](http://nbviewer.ipython.org/github/LilithElina/Data-Management-and-Visualization/blob/master/Week%20Three.ipynb) than on tumblr, so you might want to read it over there (but you don't have to).

First up comes all the code I created in the [data preparation script](http://lilithelina.tumblr.com/post/129435011659/data-preparation-python) minus the output.


    # load packages
    import pandas
    import numpy
    
    # read in data
    data = pandas.read_csv("gapminder.csv", low_memory=False)
    
    # subset the data and make a copy to avoid error messages later on
    sub = data[["country", "breastcancerper100th", "femaleemployrate", "internetuserate"]]
    sub_data = sub.copy()
    
    # change data types to numeric
    sub_data["breastcancerper100th"] = sub_data["breastcancerper100th"].convert_objects(convert_numeric=True)
    sub_data["femaleemployrate"] = sub_data["femaleemployrate"].convert_objects(convert_numeric=True)
    sub_data["internetuserate"] = sub_data["internetuserate"].convert_objects(convert_numeric=True)
    
    # remove rows with missing values
    sub2 = sub_data.dropna()
    sub_data2 = sub2.copy()

In that script, I read in the Gapminder data, reduced it to contain only the variables I wanted to work with, and converted these to numeric. I also removed observations - that is, countries - with missing values in any of the variables from my data subset.

To get a better overview of the data set I have created now, I'm going to bin my continuous variables into groups to create meaningful frequency tables. In order to decide on the size or number of my bins, I'll have a look at data summaries - just as I did in the [last R script](http://lilithelina.tumblr.com/post/129719413934/data-preparation-r).


    # print data summary (of numeric variables)
    print(sub_data2.describe())

           breastcancerper100th  femaleemployrate  internetuserate
    count            162.000000        162.000000       162.000000
    mean              37.896914         47.730864        34.081991
    std               23.142723         14.735980        27.819118
    min                3.900000         12.400000         0.720009
    25%               20.725000         38.900000         9.637458
    50%               30.450000         47.799999        29.439699
    75%               50.375000         55.875000        52.769074
    max              101.100000         83.300003        95.638113
    

The result is, of course, the same as in R. In 2002, between 3.9 and 101.1 per 100,000 women were diagnosed with breast cancer; in 2007, between 12.4 and 83.3% of the female population aged over 15 had been employed all over the world; and in 2010, between 0.72 and 95.6% of the different country populations had access to the internet.

The problem is, I still don't know how many groups I would like to create, or where the cuts should be made. This is one of the [problems with binning continuous variables](http://biostat.mc.vanderbilt.edu/wiki/Main/CatContinuous) - and together with all the others, this is why I don't see me using the new groups I'm about to create for the actual analysis. Nevertheless, I'll split the variables into five bins each for this course.


    # create five equal-sized groups per variable
    sub_data2['breastGroup'] = pandas.qcut(sub_data2.breastcancerper100th, 5)
    sub_data2['employGroup'] = pandas.qcut(sub_data2.femaleemployrate, 5)
    sub_data2['internGroup'] = pandas.qcut(sub_data2.internetuserate, 5)


    ## calculate frequencies in bins
    # breast cancer rate
    breastGr_freq = pandas.concat(dict(counts = sub_data2["breastGroup"].value_counts(sort=False, dropna=False),
                                       percentages = sub_data2["breastGroup"].value_counts(sort=False, dropna=False,
                                                                                           normalize=True)),
                                axis=1)
    print("frequency of breast cancer groups:\n", breastGr_freq)
    
    # female employment rate
    employGr_freq = pandas.concat(dict(counts = sub_data2["employGroup"].value_counts(sort=False, dropna=False),
                                       percentages = sub_data2["employGroup"].value_counts(sort=False, dropna=False,
                                                                                           normalize=True)),
                                axis=1)
    print("\nfrequency of female employment groups:\n", employGr_freq)
    
    # internet use rate
    internetGr_freq = pandas.concat(dict(counts = sub_data2["internGroup"].value_counts(sort=False, dropna=False),
                                         percentages = sub_data2["internGroup"].value_counts(sort=False, dropna=False,
                                                                                             normalize=True)),
                                axis=1)
    print("\nfrequency of internet usage groups:\n", internetGr_freq)

    frequency of breast cancer groups:
                     counts  percentages
    [3.9, 19.18]        33     0.203704
    (19.18, 26.04]      32     0.197531
    (26.04, 34.76]      32     0.197531
    (34.76, 54.02]      32     0.197531
    (54.02, 101.1]      33     0.203704
    
    frequency of female employment groups:
                     counts  percentages
    [12.4, 36.56]       33     0.203704
    (36.56, 44.38]      32     0.197531
    (44.38, 50.66]      32     0.197531
    (50.66, 58.2]       33     0.203704
    (58.2, 83.3]        32     0.197531
    
    frequency of internet usage groups:
                        counts  percentages
    [0.72, 7]              33     0.203704
    (7, 16.312]            32     0.197531
    (16.312, 39.271]       32     0.197531
    (39.271, 63.0248]      32     0.197531
    (63.0248, 95.638]      33     0.203704
    

As we can see above, the values were grouped into five almost same-sized groups for each variable. While the groups contain a similar number of observations each, the intervals into which the actual values were grouped vary immensely in all three variables.  
For breast cancer, most values seem to lie between 19.18 and 34.76 (new cases per 100,000), because these two small groups are already enough to "collect" 32 observations each. Female employment rates seem to be mostly between 36.56 and 58.2%, so the middle segment. The internet usage frequency appears to be low more often than high.  
All of this is also reflected in the differences between mean and median (50%) shown in the summary farther above. For the female employment rate, they are almost identical, while both breast cancer cases and internet usage show a lower median than mean. This hints at a right skewed distribution of these variables, which we will visualise in the next analysis step.
