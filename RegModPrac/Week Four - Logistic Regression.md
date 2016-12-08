
I finally made it to week four of [Regression Modelling in Practice](https://www.coursera.org/learn/regression-modeling-practice/home/welcome)! This is the last step in the regression analyses of my **Breast Cancer Causes Internet Usage!** (BCCIU) [project](http://lilithelina.tumblr.com/post/128347327089/choice-of-data), and once more I am forced to bin my quantitative response variable (I'm [again](http://lilithelina.tumblr.com/post/147984528439/multiple-linear-regression-python) only using internet usage) into two categories. This way, I'll be able to test a logistic regression, which works with binary (0/1) response variables. In the assignment, we're also tasked to check for confounding, so I will use logistic multiple regression as well, with the same variables I used for my [multiple linear regression analysis](http://lilithelina.tumblr.com/post/147984528439/multiple-linear-regression-python).

The output will look better on [GitHub](https://github.com/LilithElina/Data-Analysis-and-Interpretation/blob/master/RegModPrac/Week%20Four%20-%20Logistic%20Regression.ipynb) than on tumblr.

First up comes the code to prepare the raw data, filtering for
* internet usage (internet users per 100 people in 2010), my response variable, as well as
* breast cancer (new breast cancer cases per 100k females in 2002),
* income (Gross Domestic Product per capita in 2010), and
* urbanisation (urban population as percent of total population in 2008) as explanatory variables.


```python
# activate inline plotting, should be first statement
%matplotlib inline

# load packages
import warnings                     # ignore warnings (e.g. from future, deprecation, etc.)
warnings.filterwarnings('ignore')   # for layout reasons, after I read and acknowledged them all!

import pandas
import numpy
import seaborn
import matplotlib.pyplot as plt
import statsmodels.api as sm
import statsmodels.formula.api as smf

# read in data
data = pandas.read_csv("../gapminder.csv", low_memory=False)

# use country names as row names/indices
data.index = data["country"]
data.drop("country", axis=1)

# subset the data and make a copy to avoid error messages later on
sub = data[["breastcancerper100th", "incomeperperson", "internetuserate", "urbanrate"]]
sub_data = sub.copy()

# change data types to numeric
sub_data["breastcancerper100th"] = pandas.to_numeric(sub_data["breastcancerper100th"], errors="coerce")
sub_data["incomeperperson"] = pandas.to_numeric(sub_data["incomeperperson"], errors="coerce")
sub_data["internetuserate"] = pandas.to_numeric(sub_data["internetuserate"], errors="coerce")
sub_data["urbanrate"] = pandas.to_numeric(sub_data["urbanrate"], errors="coerce")

# remove rows with missing values (copy again)
sub2 = sub_data.dropna()
sub_data2 = sub2.copy()
```

As I stated before, my response variable needs to be in a "presence/absence" format this time, which will be coded as "1" for presence and "0" for absence of internet usage. But where should I set the cut-off?


```python
# have a look at the data
print(sub_data2.describe())
```

           breastcancerper100th  incomeperperson  internetuserate   urbanrate
    count            163.000000       163.000000       163.000000  163.000000
    mean              37.781595      7312.376683        33.747359   56.245767
    std               23.122332     10467.625388        27.868070   22.943194
    min                3.900000       103.775857         0.720009   10.400000
    25%               20.600000       691.093623         9.102256   36.840000
    50%               30.300000      2425.471293        28.731883   59.460000
    75%               50.350000      8880.432040        52.513403   73.490000
    max              101.100000     52301.587179        95.638113  100.000000
    

I think I'll use the first quartile this time. That way, in countries with less than 9.1% internet usage, "internet usage will be absent".


```python
# bin internet usage
sub_data2["internetBin"] = numpy.where(sub_data2["internetuserate"] > 9.1, 1, 0)

# examine data summary
print("data with binned response variable")
print(sub_data2.describe())
```

    data with binned response variable
           breastcancerper100th  incomeperperson  internetuserate   urbanrate  \
    count            163.000000       163.000000       163.000000  163.000000   
    mean              37.781595      7312.376683        33.747359   56.245767   
    std               23.122332     10467.625388        27.868070   22.943194   
    min                3.900000       103.775857         0.720009   10.400000   
    25%               20.600000       691.093623         9.102256   36.840000   
    50%               30.300000      2425.471293        28.731883   59.460000   
    75%               50.350000      8880.432040        52.513403   73.490000   
    max              101.100000     52301.587179        95.638113  100.000000   
    
           internetBin  
    count   163.000000  
    mean      0.748466  
    std       0.435231  
    min       0.000000  
    25%       0.500000  
    50%       1.000000  
    75%       1.000000  
    max       1.000000  
    

The `where()` function from `numpy` is really neat here. It returns either one value ($1$, in this case) or the other ($0$), depending on a given condition, which in this case is the test whether or not a value in the internetuserate column is higher or lower than the cut-off I defined. The data summary nicely shows that most of the internet usage values are now coded as $1$. Note that these binary values are nevertheless numeric.

Now I can run my logistic regression. For this, I need a different function than before, when we used `ols()`. This time, `logit()`, also from the `statsmodels.formula.api` package, will be used.


```python
# logistic regression model for breast cancer and internet usage
print("logistic regression model for the association between breast cancer cases and internet use rate")
reg1 = smf.logit("internetBin ~ breastcancerper100th", data=sub_data2).fit()
print(reg1.summary())
```

    logistic regression model for the association between breast cancer cases and internet use rate
    Optimization terminated successfully.
             Current function value: 0.416506
             Iterations 8
                               Logit Regression Results                           
    ==============================================================================
    Dep. Variable:            internetBin   No. Observations:                  163
    Model:                          Logit   Df Residuals:                      161
    Method:                           MLE   Df Model:                            1
    Date:                Thu, 08 Dec 2016   Pseudo R-squ.:                  0.2615
    Time:                        11:01:34   Log-Likelihood:                -67.890
    converged:                       True   LL-Null:                       -91.934
                                            LLR p-value:                 4.076e-12
    ========================================================================================
                               coef    std err          z      P>|z|      [95.0% Conf. Int.]
    ----------------------------------------------------------------------------------------
    Intercept               -1.8950      0.577     -3.284      0.001        -3.026    -0.764
    breastcancerper100th     0.1058      0.023      4.629      0.000         0.061     0.151
    ========================================================================================
    

The logistic regression function returns a model not unlike that of a linear regression, including a (significant) *p*-value and a positive coefficient - indicating a positive correlation between internet usage and breast cancer.  
Since internet usage only has two outcomes now, though, generating a linear equation wouldn't make sense. Instead, we should look at probabilities, or - better yet - odds ratios (OR). The [advantage of odds ratios over probabilities](http://www.theanalysisfactor.com/why-use-odds-ratios/) here is that an odds ratio is a constant number, while the probability of $y$ being $0$ or $1$ changes with the value of $x$ (which is still a quantitative variable).  
The odds ratio can be calculated directly from the coefficient returned by the regression model: it is the natural exponentiation of that coefficient (or parameter estimate). This can be easily calculated with `numpy`'s `exp()` function:


```python
print("odds ratio")
print(numpy.exp(reg1.params))
```

    odds ratio
    Intercept               0.150325
    breastcancerper100th    1.111579
    dtype: float64
    

The same function can also be used to include the confidence intervals returned by the model:


```python
params = reg1.params
conf = reg1.conf_int()
conf["OR"] = params
conf.columns = ["Lower CI", "Upper CI", "OR"]

print("odds ratio with confidence intervals")
print(numpy.exp(conf))
```

    odds ratio with confidence intervals
                          Lower CI  Upper CI        OR
    Intercept             0.048522  0.465722  0.150325
    breastcancerper100th  1.062896  1.162493  1.111579
    

The odds ratio of $OR > 1$ indicates that an increase in breast cancer prevalence leads to a "presence" of internet usage - something which I already described much better with [linear regression](http://lilithelina.tumblr.com/post/147441369709/basic-linear-regression-python). Since an odds ratio can take any value from zero to (positive) infinity, and a value of $1$ means that there is an equal probability for either outcome, my $OR = 1.1$ is not even very impressive. How will the addition of other explanatory variables change that?


```python
# logistic regression model for breast cancer and income with internet usage
print("logistic regression model for the association between breast cancer cases and income with internet use rate")
reg2 = smf.logit("internetBin ~ breastcancerper100th + incomeperperson", data=sub_data2).fit()
print(reg2.summary())
```

    logistic regression model for the association between breast cancer cases and income with internet use rate
    Optimization terminated successfully.
             Current function value: 0.368648
             Iterations 10
                               Logit Regression Results                           
    ==============================================================================
    Dep. Variable:            internetBin   No. Observations:                  163
    Model:                          Logit   Df Residuals:                      160
    Method:                           MLE   Df Model:                            2
    Date:                Thu, 08 Dec 2016   Pseudo R-squ.:                  0.3464
    Time:                        11:15:20   Log-Likelihood:                -60.090
    converged:                       True   LL-Null:                       -91.934
                                            LLR p-value:                 1.479e-14
    ========================================================================================
                               coef    std err          z      P>|z|      [95.0% Conf. Int.]
    ----------------------------------------------------------------------------------------
    Intercept               -2.0101      0.622     -3.232      0.001        -3.229    -0.791
    breastcancerper100th     0.0762      0.026      2.974      0.003         0.026     0.126
    incomeperperson          0.0004      0.000      2.602      0.009         0.000     0.001
    ========================================================================================
    
    Possibly complete quasi-separation: A fraction 0.15 of observations can be
    perfectly predicted. This might indicate that there is complete
    quasi-separation. In this case some parameters will not be identified.
    


```python
params2 = reg2.params
conf2 = reg2.conf_int()
conf2["OR"] = params2
conf2.columns = ["Lower CI", "Upper CI", "OR"]

print("odds ratio with confidence intervals")
print(numpy.exp(conf2))
```

    odds ratio with confidence intervals
                          Lower CI  Upper CI        OR
    Intercept             0.039603  0.453280  0.133982
    breastcancerper100th  1.026306  1.134709  1.079147
    incomeperperson       1.000109  1.000777  1.000443
    

The addition of income per person to the model had two consequences: first, the odds ratio for the association between breast cancer and internet usage is a little bit lower now, and second, a warning message is included in the model results. It warns about complete quasi-separation, or quasi-complete separation. This means that one of the predictors (which would have to be income, since the warning didn't occur before) almost completely separated the two internet usage categories. Apparently, there is a threshold in income per person below which almost all internet usage values are either $0$ or $1$, while almost all values above that threshold are the opposite. The problem with this is that the maximum likelihood estimates, which are used in logistic regression, cannot work with data in which the two distributions to compare don't - or barely - overlap, resulting in unreliable parameter estimates.  
*In short*: I shouldn't use income per person as explanatory variable here.

I'll test if the urbanisation rate is confounding the relationship between internet usage and breast cancer, then. Internet usage could easily be associated with urbanisation, but probably won't be separated as well by it.


```python
# logistic regression model for breast cancer, income and urbanisation with internet usage
print("logistic regression model for the association between breast cancer cases and urbanisation with internet use rate")
reg3 = smf.logit("internetBin ~ breastcancerper100th + urbanrate", data=sub_data2).fit()
print(reg3.summary())
```

    logistic regression model for the association between breast cancer cases and urbanisation with internet use rate
    Optimization terminated successfully.
             Current function value: 0.363538
             Iterations 8
                               Logit Regression Results                           
    ==============================================================================
    Dep. Variable:            internetBin   No. Observations:                  163
    Model:                          Logit   Df Residuals:                      160
    Method:                           MLE   Df Model:                            2
    Date:                Thu, 08 Dec 2016   Pseudo R-squ.:                  0.3554
    Time:                        11:31:15   Log-Likelihood:                -59.257
    converged:                       True   LL-Null:                       -91.934
                                            LLR p-value:                 6.432e-15
    ========================================================================================
                               coef    std err          z      P>|z|      [95.0% Conf. Int.]
    ----------------------------------------------------------------------------------------
    Intercept               -3.3883      0.727     -4.662      0.000        -4.813    -1.964
    breastcancerper100th     0.0781      0.023      3.370      0.001         0.033     0.124
    urbanrate                0.0476      0.012      3.808      0.000         0.023     0.072
    ========================================================================================
    


```python
params3 = reg3.params
conf3 = reg3.conf_int()
conf3['OR'] = params3
conf3.columns = ['Lower CI', 'Upper CI', 'OR']

print("odds ratio with confidence intervals")
print(numpy.exp(conf3))
```

    odds ratio with confidence intervals
                          Lower CI  Upper CI        OR
    Intercept             0.008125  0.140320  0.033766
    breastcancerper100th  1.033227  1.131535  1.081264
    urbanrate             1.023359  1.074744  1.048737
    

Similar to what I've seen in the [multiple linear regression](http://lilithelina.tumblr.com/post/147984528439/multiple-linear-regression-python), the urbanisation rate is not truly confounding the association between internet usage and breast cancer. The *p*-values for both explanatory variables are still very low, and the odds ratios fall into very small confidence intervals. Nevertheless, the odds ratio for breast cancer is even lower than before - closer to $1$ and an equal probability for "presence" or "absence" of internet usage.

While logistic regression is an important and valuable tool to analyse categorical data, forcing my data into the right format for analysis did - not surprisingly - not lead to very convincing results.
