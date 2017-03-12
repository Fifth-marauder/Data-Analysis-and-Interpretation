# Logistic Regression
Sarah Pohl  

As mostly [mentioned first](http://lilithelina.tumblr.com/post/128638794919/choice-of-language), I want to compare `Python` and `R` analysis steps in the [DataManViz](http://lilithelina.tumblr.com/tagged/DataManViz), [DataAnaT](http://lilithelina.tumblr.com/tagged/DataAnaT), and [RegModPrac](http://lilithelina.tumblr.com/RegModPrac) projects.
Therefore, this is the `R` version of the [Logistic Regression](http://lilithelina.tumblr.com/post/154204468274/logistic-regression-python) `Python` script I posted before. Here, I'll use logistic regression to test the association between internet use rate (my response variable, this time binned into two categories) and multiple explanatory variables - but first and foremost new breast cancer cases.  
Again, the whole thing will look better over [here](http://htmlpreview.github.io/?https://github.com/LilithElina/Data-Analysis-and-Interpretation/blob/master/RegModPrac/Week_Four_LogisticRegression.html). I had to switch back to using RMarkdown, since Jupyter had some problems I do not yet understand.

I will first run some of my previous code to remove variables I don't need and observations for which important data is missing.




```r
# load data
gapminder <- read.table("../gapminder.csv", sep = ",", header = TRUE, quote = "\"")
# set row names
rownames(gapminder) <- gapminder$country

# subset data
sub_data <- subset(gapminder, select = c("breastcancerper100th", "urbanrate", 
    "internetuserate", "incomeperperson"))

# remove rows with NAs
sub_data2 <- na.omit(sub_data)
```

Internet usage, my response variable, has to be in a binary format for logistic regression to work. In my `Python` script, I decided to use the 25% quartile (`9.1`) as cut-off, so I'll do the same here.


```r
# bin response variable
sub_data2$internetBin <- as.numeric(sub_data2$internetuserate > 9.1)
summary(sub_data2)
```

```
 breastcancerper100th   urbanrate      internetuserate  incomeperperson  
 Min.   :  3.90       Min.   : 10.40   Min.   : 0.720   Min.   :  103.8  
 1st Qu.: 20.60       1st Qu.: 36.84   1st Qu.: 9.102   1st Qu.:  691.1  
 Median : 30.30       Median : 59.46   Median :28.732   Median : 2425.5  
 Mean   : 37.78       Mean   : 56.25   Mean   :33.747   Mean   : 7312.4  
 3rd Qu.: 50.35       3rd Qu.: 73.49   3rd Qu.:52.513   3rd Qu.: 8880.4  
 Max.   :101.10       Max.   :100.00   Max.   :95.638   Max.   :52301.6  
  internetBin    
 Min.   :0.0000  
 1st Qu.:0.5000  
 Median :1.0000  
 Mean   :0.7485  
 3rd Qu.:1.0000  
 Max.   :1.0000  
```

For the binning, I'm using a simple test whether the internet usage in a country is above my threshold or not. The `as.numeric()` will automatically convert every returned `TRUE` to a `1`, and every `FALSE` to a `0` -- and done is my conversion.

Let's go ahead with the logistic regression!


```r
fit1 <- glm(internetBin ~ breastcancerper100th, data = sub_data2, family = "binomial")
summary(fit1)
```

```

Call:
glm(formula = internetBin ~ breastcancerper100th, family = "binomial", 
    data = sub_data2)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-1.9427  -0.3112   0.2517   0.7259   1.7188  

Coefficients:
                     Estimate Std. Error z value Pr(>|z|)    
(Intercept)          -1.89496    0.57693  -3.285  0.00102 ** 
breastcancerper100th  0.10578    0.02285   4.630 3.66e-06 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 183.87  on 162  degrees of freedom
Residual deviance: 135.78  on 161  degrees of freedom
AIC: 139.78

Number of Fisher Scoring iterations: 6
```

The model results look quite different from those returned by `Python`. Already familiar are the coefficients shown in the middle of the results, which say that there is a significant, positive association between internet usage and breast cancer. From the parameter estimate, the [odds ratio](http://www.theanalysisfactor.com/why-use-odds-ratios/) can again be calculated, but for that it might be nice to have the confidence intervals as well. Luckily, these are relatively easy to obtain:


```r
conf1 <- confint(fit1)
```

```
Waiting for profiling to be done...
```

```r
conf1 <- cbind(conf1, OR = coef(fit1))

print("odds ratio with confidence intervals")
exp(conf1)
```

```
[1] "odds ratio with confidence intervals"
                          2.5 %   97.5 %        OR
(Intercept)          0.04444601 0.432423 0.1503249
breastcancerper100th 1.06804211 1.168457 1.1115793
```

The values are the same as in `Python`, so the `OR > 1` again signifies that internet usage will be higher in countries with higher breast cancer prevalence.

Below the coefficients, the `R` function lists deviance values. I am not really sure what they signify in the context of logistic regression, but apparently the goal of the model is to reduce them as much as possible. How successful the model is at that task can be analysed with an a deviance table using the [Chi square](http://lilithelina.tumblr.com/post/134387869079/data-analysis-chi-square-r) test to calculate test statistics:


```r
anova(fit1, test = "Chisq")
```

```
Analysis of Deviance Table

Model: binomial, link: logit

Response: internetBin

Terms added sequentially (first to last)

                     Df Deviance Resid. Df Resid. Dev  Pr(>Chi)    
NULL                                   162     183.87              
breastcancerper100th  1   48.088       161     135.78 4.076e-12 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The null model uses only the intercept and no explanatory variable, resulting in a high deviance. With breast cancer as explanatory variable, a significant reduction of deviance takes place. If the model would contain more explanatory variables, the test would add them one at a time and determine their effect on the deviance.  
Time to add another explanatory variable!


```r
fit2 <- glm(internetBin ~ breastcancerper100th + incomeperperson, data = sub_data2, 
    family = "binomial")
summary(fit2)
```

```

Call:
glm(formula = internetBin ~ breastcancerper100th + incomeperperson, 
    family = "binomial", data = sub_data2)

Deviance Residuals: 
     Min        1Q    Median        3Q       Max  
-2.50062  -0.31160   0.08903   0.58516   1.78481  

Coefficients:
                       Estimate Std. Error z value Pr(>|z|)   
(Intercept)          -2.0100509  0.6218483  -3.232  0.00123 **
breastcancerper100th  0.0761711  0.0256152   2.974  0.00294 **
incomeperperson       0.0004431  0.0001703   2.602  0.00927 **
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 183.87  on 162  degrees of freedom
Residual deviance: 120.18  on 160  degrees of freedom
AIC: 126.18

Number of Fisher Scoring iterations: 8
```

In [Python](http://lilithelina.tumblr.com/post/154204468274/logistic-regression-python), using both breast cancer and income as explanatory variables resulted in a warning about quasi complete separation of the two internet usage groups. This is not the case here, I wonder why...

Let's have a look at the odds ratios and deviance again...


```r
conf2 <- confint(fit2)
```

```
Waiting for profiling to be done...
```

```
Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
```

```r
conf2 <- cbind(conf2, OR = coef(fit2))

print("odds ratio with confidence intervals")
exp(conf2)
```

```
[1] "odds ratio with confidence intervals"
                          2.5 %    97.5 %        OR
(Intercept)          0.03603527 0.4218608 0.1339819
breastcancerper100th 1.03010585 1.1398341 1.0791472
incomeperperson      1.00016777 1.0008310 1.0004432
```

Ah, here we go! This warning indicates that there is (quasi) complete separation happening, so I'll just move on to my third model, using breast cancer and urbanisation as explanatory variables.


```r
fit3 <- glm(internetBin ~ breastcancerper100th + urbanrate, data = sub_data2, 
    family = "binomial")
summary(fit3)
```

```

Call:
glm(formula = internetBin ~ breastcancerper100th + urbanrate, 
    family = "binomial", data = sub_data2)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-2.1845  -0.2828   0.2272   0.5919   1.9885  

Coefficients:
                     Estimate Std. Error z value Pr(>|z|)    
(Intercept)          -3.38831    0.72676  -4.662 3.13e-06 ***
breastcancerper100th  0.07813    0.02318   3.370 0.000752 ***
urbanrate             0.04759    0.01250   3.808 0.000140 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 183.87  on 162  degrees of freedom
Residual deviance: 118.51  on 160  degrees of freedom
AIC: 124.51

Number of Fisher Scoring iterations: 6
```

All right, what do the additional tests say this time?


```r
conf3 <- confint(fit3)
```

```
Waiting for profiling to be done...
```

```r
conf3 <- cbind(conf3, OR = coef(fit3))

print("odds ratio with confidence intervals")
exp(conf3)
```

```
[1] "odds ratio with confidence intervals"
                           2.5 %    97.5 %         OR
(Intercept)          0.007270543 0.1280973 0.03376562
breastcancerper100th 1.037775543 1.1373111 1.08126415
urbanrate            1.024544428 1.0763632 1.04873683
```


```r
print("Chi-squared test of deviance")
```

```
[1] "Chi-squared test of deviance"
```

```r
anova(fit3, test = "Chisq")
```

```
Analysis of Deviance Table

Model: binomial, link: logit

Response: internetBin

Terms added sequentially (first to last)

                     Df Deviance Resid. Df Resid. Dev  Pr(>Chi)    
NULL                                   162     183.87              
breastcancerper100th  1   48.088       161     135.78 4.076e-12 ***
urbanrate             1   17.267       160     118.51 3.247e-05 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The odds ratio for an association between breast cancer and internet usage decreased a bit when urbanisation was added to the model -- as before. On the other hand, the residual deviance also decreases significantly upon addition of that second explanatory variable, so it definitely improves the model, while not being a confounder (since breast cancer is still significantly associated with internet usage).

We can also subtract the null deviance from the other residual deviances calculated here, to have a simple view of the effect of the different explanatory variables. A high deviance is problematic, and since usually the null deviance (with the model using only the intercept) is higher than the deviance when explanatory variables are included, the differences shows just how much the model improved upon the addition of the variable.


```r
print("difference in residual deviance using only breast cancer")
with(fit1, null.deviance - deviance)

print("difference in residual deviance using breast cancer and internet usage")
with(fit2, null.deviance - deviance)

print("difference in residual deviance using breast cancer and urbanisation")
with(fit3, null.deviance - deviance)
```

```
[1] "difference in residual deviance using only breast cancer"
[1] 48.08763
[1] "difference in residual deviance using breast cancer and internet usage"
[1] 63.68923
[1] "difference in residual deviance using breast cancer and urbanisation"
[1] 65.35506
```

The addition of other explanatory variables definitely improved my logistic model, but overall I think it's nowhere near the multiple linear regression which can directly work with my continuous data.
