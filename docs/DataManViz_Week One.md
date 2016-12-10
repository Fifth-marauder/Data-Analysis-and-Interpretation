## Choice of Data

This is my first blog post for the [Data Management and Visualisation coursera course](https://www.coursera.org/learn/data-management-visualization/home/welcome) in which I am currently participating. There will probably be no certificate (it's getting harder to get Statements of Accomplishment for coursera courses these days, there's a tendency to offer only paid certificates), so this is really just for fun.

In the course, the students are asked to choose one of five pre-selected data sets (or their own) and create a data analysis project out of whatever takes their fancy. Three of the five data sets contain only data from the U.S., which is a phenomenon I am well used to from online courses. Nevertheless, I'm European and for once I would like to have something not U.S. based. The remaining two data sets are either about craters on Mars or numerous country-level indicators of health, wealth and development. Now, I really enjoyed reading "The Martian" and will most likely go see the movie once it comes out, but I wouldn't know what to do with the crater measurements provided. Therefore, I went with the [Gapminder](http://www.gapminder.org) data set.

The first thing to notice about the codebook provided in the course is the pre-selection of data: there are only sixteen variables - all numeric except for the country name as identifier. And these variables were collected in different years - one in 2002, one in 2011, and all the others in between. This will make comparisons and correlation finding difficult - should you correlate the employment rate in 2007 with the Gross Domestic Product of 2010? Probably not.

I couldn't decide on an interesting topic to explore just by looking at the codebook, so I downloaded the data, read the CSV into R and created basic scatterplots to compare each variable with all others. A few showed nice correlations - especially total employment rate versus female employment rate (same year), but that sounded boring. Instead, I decided to explore a different topic: how everything can be correlated, whether it makes sense or not. Or, to say it with the words of many others: "Statistical significance is not the same thing as scientific importance or economic sense" [1].

![](https://67.media.tumblr.com/91b47e65d680d7a617588776aa8d8fd6/tumblr_nu74qnt3Zn1ufa1d3o1_500.png)

The above scatterplot shows a possible correlation between the two variables plotted - a small x mostly has a small y associated with it, and a large x also has a large y. The variables plotted here are new breast cancer cases per 100,000 female residents, and internet users per 100 people. Wouldn't it be awesome if I could call my project "Internet usage causes breast cancer!" - what a headline! I won't go that far, though, because the breast cancer data is from 2002 and the internet usage rates are from 2010. So, instead of proposing that internet usage causes breast cancer, I will explore the possibility that breast cancer causes internet usage! I can even back up my claim with publications:

In 2000, Jose L. Pereira et al. conducted an exploratory study on internet usage among women with breast cancer. They found, in a survey, that 43% of participating breast cancer patients had used the internet to look for cancer-related information [2]. Two years later, Joshua Fogel et al. also studied the internet usage of breast cancer patients and found 42% of the surveyed women were using the internet for medical information. They also found that "internet use for breast health issues was associated with greater social support and less loneliness than internet use for other purposes or nonuse" [3]. Therefore, it seems that breast cancer could be a reason for people to use the internet more often. Additionally, since there are studies available showing a positive effect of internet usage, it could even be suggested to patients by physicians, other health care related experts or self-help groups.

In conclusion, I will - in this blog and the Data Management and Visualisation course on coursera - explore and test the hypothesis that breast cancer causes internet usage, or - to be exact - that a higher prevalence of breast cancer is correlated with more internet use in certain countries.

<small>[1] Stephen T. Ziliak and Deirdre N. McCloskey, The Cult of Statistical Significance. 2009. http://www.deirdremccloskey.com/docs/jsm.pdf</small>

<small>[2] Jose L. Pereira et al., Internet Usage Among Women with Breast Cancer: An Exploratory Study. 2000. [http://www.clinical-breast-cancer.com/article/S1526-8209(11)70112-4/abstract](http://www.clinical-breast-cancer.com/article/S1526-8209(11)70112-4/abstract)</small>

<small>[3] Joshua Fogel et al., Internet use and social support in women with breast cancer. 2002. http://psycnet.apa.org/journals/hea/21/4/398/
</small>


## Choice of Language

What I find very interesting about the [Data Management and Visualisation course](https://www.coursera.org/learn/data-management-visualization/home/welcome) is that they offer a choice of two programming languages to use: [Python](https://www.python.org/) or [SAS](http://www.sas.com/). Personally, I would have used R for this topic.

Since I already know Python, I briefly considered trying out SAS. In the end, though, I decided to stick to Python, since the course uses version 3.4 (I've only worked with 2.7 so far), and teaches things I haven't done in Python before. Additionally, while SAS might be an important language in the industry, it is also a paid software package, while Python (and R) are both free and open. Of course, there's pros and cons for this (e.g. the wealth of packages out there is not very well curated), but I come from a background where it's not easy to obtain money for software licenses and I believe in open source.

So far, at work, I mostly used Python for conversion between file types and generally reading and extracting data from various files. R, on the other hand, is my go-to tool for statistical analysis and anything to do with math or visualisation. It will be interesting to see how this is done in Python - and I will also follow along in R and compare the languages and the results I can obtain using them for data management and visualisation in my correlation project.