### GETTING STARTED

First, set your working directory. 

**setwd("*FILE PATH*")**

Or you can use the drop-down menu: **Session -> Set Working Directory -> Choose Directory**

We'll be using these libraries. 
```
library(dplyr)
library(ggplot2)
library(janitor)
library(psych)
library(readxl)
library(stringr)
library(tidyr)
library(tidyverse)
```
We'll work with this data set, which has information on four-year colleges in the US:
- colleges.csv -- Select data from College Scorecard. Full files here: https://collegescorecard.ed.gov/data/

**Getting started**

Read the .csv file into R. In R-speak, we're creating a data frame named *colleges*.
It contains field names, so we include this: col_names = TRUE

```
colleges <- read_csv("colleges.csv", col_names = TRUE) 

```
View the data
```
view(colleges)
```

What if your file has millions of records and you want to see only the first few? Use head to call up the first rows.

```
head(colleges, 15)
```
We see the first several fields in the Console window (lower left of RStudio) but not all. So let's view all columns in first 15 rows.
```
view(head(colleges, 15))
```
This way also works.
```
head(colleges, 15) %>% view()
```
```
# A tibble: 15 × 17
   unitid instnm         city    state control ugrads accept_rate act_mid sat_avg
    <dbl> <chr>          <chr>   <chr> <chr>    <dbl>       <dbl>   <dbl>   <dbl>
 1 100654 Alabama A & M… Normal  AL    Public    5271       0.918      17     939
 2 100663 University of… Birmin… AL    Public   13328       0.737      26    1234
 3 100706 University of… Huntsv… AL    Public    7785       0.826      28    1319
 4 100724 Alabama State… Montgo… AL    Public    3750       0.969      17     946
 5 100751 The Universit… Tuscal… AL    Public   31900       0.827      27    1261
 6 100812 Athens State … Athens  AL    Public    2677      NA          NA      NA
 7 100830 Auburn Univer… Montgo… AL    Public    4407       0.904      21    1082
 8 100858 Auburn Univer… Auburn  AL    Public   24209       0.807      28    1300
 9 100937 Birmingham-So… Birmin… AL    Private   1205       0.538      26    1230
10 101116 South Univers… Montgo… AL    For-pr…    251      NA          NA      NA
11 101189 Faulkner Univ… Montgo… AL    Private   1928       0.783      21    1066
12 101435 Huntingdon Co… Montgo… AL    Private   1007       0.593      21    1076
13 101453 Heritage Chri… Floren… AL    Private     59       0.235      11      NA
14 101480 Jacksonville … Jackso… AL    Public    6743       0.548      21    1084
15 101541 Judson College Marion  AL    Private    245       0.372      19    1020
# … with 8 more variables: total_cost <dbl>, net_price <dbl>, ft_faculty <dbl>,
#   pell_grant <dbl>, first_gen <dbl>, default_3yr <dbl>, grad_rate <dbl>,
#   grad_debt <dbl>


 ```
 
Check out the structure of our data - which fields are numeric, character, etc.
```
str(colleges)
```

**Descriptive statistics**

We can get basic statistics for our variables using summary.
```
summary(colleges)
```

Note that this works only for numeric fields, not character.
We can also look at a single variable.
```
summary(colleges$total_cost)
```

Or a single statistic for a single variable.
```
mean(colleges$total_cost) 
```

Wait, it returns NA. That's because some colleges have missing values.
You have to exclude the null fields with na.rm = TRUE
That's Rspeak for Remove NAs? Yes

```
mean(colleges$total_cost, na.rm = T) 
```

Other handy stats
```
median(colleges$total_cost, na.rm = T) # median = middle value
sd(colleges$total_cost, na.rm = T) # standard deviation
min(colleges$total_cost, na.rm = T) # minimum value, i.e. cheapest college
max(colleges$total_cost, na.rm = T) # maximum value, i.e. priciest college
```
Which gives us
```
> median(colleges$total_cost, na.rm = T) # median = middle value
[1] 32016
> sd(colleges$total_cost, na.rm = T) # standard deviation
[1] 16482.91
> min(colleges$total_cost, na.rm = T) # minimum value, i.e. cheapest college
[1] 9007
> max(colleges$total_cost, na.rm = T) # maximum value, i.e. priciest college
[1] 78555
```


Whoa, which college has the highest sticker price of $78,555?
```
which.max(colleges$total_cost)

[1] 340
```
It returns 340, which is the row number. Which college is that?
This returns the data in that row.

```
colleges[340,]
```
Which gives us
```
> colleges[340,]
# A tibble: 1 × 17
  unitid instnm city  state control ugrads accept_rate act_mid sat_avg total_cost
   <dbl> <chr>  <chr> <chr> <chr>    <dbl>       <dbl>   <dbl>   <dbl>      <dbl>
1 144050 Unive… Chic… IL    Private   6801      0.0617      34    1528      78555
# … with 7 more variables: net_price <dbl>, ft_faculty <dbl>, pell_grant <dbl>,
#   first_gen <dbl>, default_3yr <dbl>, grad_rate <dbl>, grad_debt <dbl>
```

We can also return just the college name (column 2) in that row.
```
colleges[340,2]
```
Same result but we use the column name instead of number.
```
colleges[340,"instnm"]
```
*Bonus tip: Put those commands together*
```
colleges[which.max(colleges$total_cost),]
```
Try getting the same info for the cheapest college on your own.

**Frequency counts and group statistics**

What if you want to know how many colleges there are by control (public, private, for-profit)
```
colleges %>%
  group_by(control) %>%
  count() 
  
# A tibble: 3 × 2
# Groups:   control [3]
  control        n
  <chr>      <int>
1 For-profit   167
2 Private     1264
3 Public       580
```
Instead of count, we can use summarize. This is helpful if we want to build on this & add statistics like average, median, etc.
```
colleges %>%
  group_by(control) %>%
  summarize(freq = n()) 
```
Note that I called it "freq" but you can call it anything, like count or N

We can also look at the average total cost by type.
```
colleges %>%
  group_by(control) %>%
  summarize(freq = n(), avg = mean(total_cost, na.rm = T))
  
# A tibble: 3 × 3
  control     freq    avg
  <chr>      <int>  <dbl>
1 For-profit   167 30242.
2 Private     1264 43256.
3 Public       580 22327.
```
Look only at colleges in Georgia
```
colleges %>%
  group_by(control) %>%
  filter(state == "GA") %>%
  summarize(freq = n(), avg = mean(total_cost, na.rm = T))
  
# A tibble: 3 × 3
  control     freq    avg
  <chr>      <int>  <dbl>
1 For-profit     8 29366.
2 Private       29 39922.
3 Public        18 20624.
```
Compare the average sticker price (total_cost) to net price, 
which is what students actually pay after grants & scholarships
We'll also give our new fields more detailed names
```
colleges %>%
  group_by(control) %>%
  filter(state == "GA") %>%
  summarize(freq = n(),
            avg_net = mean(net_price, na.rm = T), 
            avg_total = mean(total_cost, na.rm = T),
            avg_default = mean(default_3yr, na.rm = T))
            
# A tibble: 3 × 5
  control     freq avg_net avg_total avg_default
  <chr>      <int>   <dbl>     <dbl>       <dbl>
1 For-profit     8  22631.    29366.      0.124 
2 Private       29  22543.    39922.      0.0953
3 Public        18  12965.    20624.      0.0882
```

**Correlations - how much two variables are related to each other**

For that we use *cor*
```
cor(colleges$total_cost, colleges$net_price)
```
There's that NA again - we need to specify only complete pairs, i.e. both fields have values
```
cor(colleges$total_cost, colleges$net_price, use = "complete.obs")


[1] 0.7830763

```
The correlation is **0.78**. What does that mean?
Correlations range from -1 to 1.
- A value of -1 means perfect negative correlation. As one variable goes up, the other goes down.
- A value of 1 means perfect positive correlation. The two variables go up together.
- A value of 0 means no correlation - there's no relationship between the two variables.
So 0.78 shows a strong correlation between sticker price and net price.
Note: This correlation is also known as Pearson's R. It's the default kind with cor()

We can also look at correlations across multiple variables

```
colnames(colleges)
cor(colleges[7:16], use = "complete.obs")
cor(colleges[7:16], use = "pairwise.complete.obs")

```

*pairwise.complete.obs = Goes pair by pair and excludes missing variables. N will vary.
complete.obs = Includes only cases with no missing values at all. N will be consistent.*

Let's say we want to see what measures are most strongly correlated with grad_rate.
Here's an excerpt from using complete.obs

```
             ft_faculty pell_grant  first_gen default_3yr  grad_rate
accept_rate -0.04393138  0.1460390  0.2248305  0.16469773 -0.3516391
act_mid      0.17450810 -0.7278785 -0.6772431 -0.67363509  0.8348351
sat_avg      0.18830115 -0.7324468 -0.6709702 -0.67957407  0.8325304
total_cost  -0.03964591 -0.4291535 -0.5164789 -0.41105102  0.5848145
net_price   -0.09809404 -0.4429567 -0.5323789 -0.33552365  0.4594331
ft_faculty   1.00000000 -0.1441360 -0.1880841 -0.04161433  0.1145687
pell_grant  -0.14413599  1.0000000  0.6806644  0.68847561 -0.6889457
first_gen   -0.18808414  0.6806644  1.0000000  0.51159820 -0.6656683
default_3yr -0.04161433  0.6884756  0.5115982  1.00000000 -0.7465700
grad_rate    0.11456872 -0.6889457 -0.6656683 -0.74657005  1.0000000
```
That would be the median ACT (act_mid) and average SAT scores of incoming students, at 0.83.

The weakest correlation with grad rates is the percent of full-time faculty, at 0.11.


We also want to know if the correlations are significant - did they happen by pure chance?
The corr.test function from the psych package shows this. Again, it works only on numeric fields.
```
corr.test(colleges[11:16], use = "complete.obs")
```
Generally if you have a lot of cases, it will be statistically significant.
What about a smaller slice of the data? Let's create a dataframe with just Georgia colleges.

```
ga_colleges <- filter(colleges, state == "GA")
corr.test(ga_colleges[11:16], use = "complete.obs")
```

We see the correlations again, followed by probability values, also known as p-values.
Anything less than 0.05 means it's statistically significant.
That means there's less than 5 percent probability that we got these results by pure chance.
Take the mild correlation of 0.30 between grad rates and net price. It has a p-value of 0.17.
That means there's a 17 percent chance we got those results by dumb luck.

**VISUALIZE YOUR DATA: Histograms and scatter plots**
It helps to visualize your data, too. For one variable, draw a histogram.

```
hist(colleges$total_cost)
```

For two variables, make a scatter plot.
```
plot(colleges$total_cost, colleges$net_price)
```
You can also use *pairs*. This shows a matrix of columns 12 through 15.
```
pairs(colleges[12:15])
```
Or you can select the variables by name.
```
pairs(~ total_cost + net_price + grad_rate, data = colleges)
```


