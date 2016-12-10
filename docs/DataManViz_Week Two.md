
In week two of the [Data Management and Visualisation course](https://www.coursera.org/learn/data-management-visualization/home/welcome) we're having a first look at the actual data we chose last week ([I'm working with](http://lilithelina.tumblr.com/post/128347327089/choice-of-data) the [Gapminder](http://www.gapminder.org/) data set). As a reminder, my topic is **"Breast Cancer Causes Internet Usage!"**, or BCCIU for short. The long version (the real hypothesis) is that in countries with higher new breast cancer cases per 100,000 female residents, the internet usage per 100 people is also higher.

I am programming in [Python](http://lilithelina.tumblr.com/post/128638794919/choice-of-language), and because there's this awesome thing called [IPython Notebook](http://ipython.org/notebook.html), I can create this blog post interspersed with code and results all in one go. This makes it easy to add explanations outside of regular comments, and since these notebooks can be converted to HTML or Markdown documents, posting everything on tumblr is a breeze as well. The output will look lots better in the [nbviewer](http://nbviewer.ipython.org/github/LilithElina/Data-Management-and-Visualization/blob/master/Week%20Two.ipynb), though, so feel free to hop over there to read on!

In the program, we will first need some packages.


    # load packages
    import pandas
    import numpy

Next is, of course, the data - we'll load it and have a first look.


    # read in data
    data = pandas.read_csv("gapminder.csv", low_memory=False)
    
    # print some information
    print("number of rows:\t\t", len(data))
    print("number of columns:\t", len(data.columns))
    
    print("\ntypes of data:\n", data.dtypes, sep="")

    number of rows:		 213
    number of columns:	 16
    
    types of data:
    country                 object
    incomeperperson         object
    alcconsumption          object
    armedforcesrate         object
    breastcancerper100th    object
    co2emissions            object
    femaleemployrate        object
    hivrate                 object
    internetuserate         object
    lifeexpectancy          object
    oilperperson            object
    polityscore             object
    relectricperperson      object
    suicideper100th         object
    employrate              object
    urbanrate               object
    dtype: object
    

The variables I'm interested in are "breastcancerper100th" and "internetuserate", so I could remove all others. However, I would like to add a third variable to the analysis - "femaleemployrate". This could also be correlated to breast cancer, which was also only measured in females. The new breast cancer cases (per 100,000 females) were counted in 2002, the female employees (percentage of whole popuation aged 15+) were assessed in 2007. Will conutries with a higher breast cancer rate have a lower female employment rate?  
Additionally, I will keep the country as unique identifier for the different observations.


    # subset the data and make a copy to avoid errors later on
    sub = data[["country", "breastcancerper100th", "femaleemployrate", "internetuserate"]]
    sub_data = sub.copy()
    
    print("\ntypes of data:\n", sub_data.dtypes, sep="")

    
    types of data:
    country                 object
    breastcancerper100th    object
    femaleemployrate        object
    internetuserate         object
    dtype: object
    

Now that I have selected the right columns, I have to work on their data types. All values except the country names are numeric, but Python has saved everything as objects. This can easily be changed:


    # change data types to numeric
    sub_data["breastcancerper100th"] = sub_data["breastcancerper100th"].convert_objects(convert_numeric=True)
    sub_data["femaleemployrate"] = sub_data["femaleemployrate"].convert_objects(convert_numeric=True)
    sub_data["internetuserate"] = sub_data["internetuserate"].convert_objects(convert_numeric=True)
    
    print("types of data:\n", sub_data.dtypes, sep="")
    
    print("\nFirst five rows of my subsetted data:\n", sub_data.head(5))

    types of data:
    country                  object
    breastcancerper100th    float64
    femaleemployrate        float64
    internetuserate         float64
    dtype: object
    
    First five rows of my subsetted data:
            country  breastcancerper100th  femaleemployrate  internetuserate
    0  Afghanistan                  26.8         25.600000         3.654122
    1      Albania                  57.4         42.099998        44.989947
    2      Algeria                  23.5         31.700001        12.500073
    3      Andorra                   NaN               NaN        81.000000
    4       Angola                  23.1         69.400002         9.999954
    

Finally, I can have a first look at the numbers using frequency tables (as requested in the course). This doesn't make much sense, since I am working with continuous variables, but it will at least show me if there are missing values (NaN) in my data.


    ## calculate frequencies and concatenate the results in dataframes for nicer output
    # breast cancer rate
    breast_freq = pandas.concat(dict(counts = sub_data["breastcancerper100th"].value_counts(sort=False, dropna=False),
                                     percentages = sub_data["breastcancerper100th"].value_counts(sort=False, dropna=False,
                                                                                                 normalize=True)),
                                axis=1)
    print("first five values for breast cancer cases:\n", breast_freq.head(5))
    
    # female employment rate
    employ_freq = pandas.concat(dict(counts = sub_data["femaleemployrate"].value_counts(sort=False, dropna=False),
                                     percentages = sub_data["femaleemployrate"].value_counts(sort=False, dropna=False,
                                                                                             normalize=True)),
                                axis=1)
    print("\nfirst five values for female employment rate:\n", employ_freq.head(5))
    
    # internet use rate
    internet_freq = pandas.concat(dict(counts = sub_data["internetuserate"].value_counts(sort=False, dropna=False),
                                       percentages = sub_data["internetuserate"].value_counts(sort=False, dropna=False,
                                                                                            normalize=True)),
                                axis=1)
    print("\nfirst five values for internet usage:\n", internet_freq.head(5))

    first five values for breast cancer cases:
            counts  percentages
    NaN        40     0.187793
     91.9       2     0.009390
     46.6       1     0.004695
     3.9        1     0.004695
     30.6       1     0.004695
    
    first five values for female employment rate:
                 counts  percentages
    NaN             35     0.164319
     46.000000       1     0.004695
     30.200001       1     0.004695
     37.900002       1     0.004695
     45.599998       1     0.004695
    
    first five values for internet usage:
                counts  percentages
    NaN            21     0.098592
     0.720009       1     0.004695
     1.400061       1     0.004695
     2.100213       1     0.004695
     3.654122       1     0.004695
    

There are different numbers of missing values in all three of my variables. We have seen above, for example, that breast cancer and female employment rates are not available for Andorra, and now we know that more cases like this are hidden in the data set. Since we can't guess these values, for Andorra or any other country, countries with missing values in any of the variables have to be removed, since calculating with missing values is impossible.


    # remove rows with missing values
    sub_data2 = sub_data.dropna()
    
    print("\nFirst five rows of my further subsetted data:\n", sub_data2.head(5))

    
    First five rows of my further subsetted data:
            country  breastcancerper100th  femaleemployrate  internetuserate
    0  Afghanistan                  26.8         25.600000         3.654122
    1      Albania                  57.4         42.099998        44.989947
    2      Algeria                  23.5         31.700001        12.500073
    4       Angola                  23.1         69.400002         9.999954
    6    Argentina                  73.9         45.900002        36.000335
    

The code above seems to have been successful, as Andorra is no longer on the list. We can again calculate frequencies to make sure:


    ## calculate frequencies once more
    # breast cancer rate
    breast_freq2 = pandas.concat(dict(counts = sub_data2["breastcancerper100th"].value_counts(sort=False, dropna=False),
                                      percentages = sub_data2["breastcancerper100th"].value_counts(sort=False, dropna=False,
                                                                                                 normalize=True)),
                                axis=1)
    print("first five values for breast cancer cases:\n", breast_freq2.head(5))
    
    # female employment rate
    employ_freq2 = pandas.concat(dict(counts = sub_data2["femaleemployrate"].value_counts(sort=False, dropna=False),
                                      percentages = sub_data2["femaleemployrate"].value_counts(sort=False, dropna=False,
                                                                                             normalize=True)),
                                axis=1)
    print("\nfirst five values for female employment rate:\n", employ_freq2.head(5))
    
    # internet use rate
    internet_freq2 = pandas.concat(dict(counts = sub_data2["internetuserate"].value_counts(sort=False, dropna=False),
                                        percentages = sub_data2["internetuserate"].value_counts(sort=False, dropna=False,
                                                                                            normalize=True)),
                                axis=1)
    print("\nfirst five values for internet usage:\n", internet_freq2.head(5))

    first five values for breast cancer cases:
           counts  percentages
    91.9       2     0.012346
    46.6       1     0.006173
    3.9        1     0.006173
    30.6       1     0.006173
    6.4        1     0.006173
    
    first five values for female employment rate:
                counts  percentages
    46.000000       1     0.006173
    30.200001       1     0.006173
    45.599998       1     0.006173
    60.900002       1     0.006173
    12.400000       1     0.006173
    
    first five values for internet usage:
               counts  percentages
    0.720009       1     0.006173
    1.400061       1     0.006173
    2.100213       1     0.006173
    3.654122       1     0.006173
    4.999875       1     0.006173
    

Perfect! All rows with missing values were removed. Now the data set is ready for the next part of the course, or the next step of the analysis.
