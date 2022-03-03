### GETTING STARTED

First, set your working directory. 

**setwd("*FILE PATH*")**

```setwd("~/IRE_NICAR/NOLA_2020")```
Or you can use the drop-down menu: **Session -> Set Working Directory -> Choose Directory**
Make sure these four packages are installed and loaded: dplyr, tidyverse, ggplot2 and psych
**install.packages("*package_name*")**.  # note the quotes here
**library(*package_name*)**. # but no quotes here
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

**STEP 1: Getting started**
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

head(colleges, 15)

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
### DESCRIPTIVES: MIN, MAX, AVERAGE, ETC.
Let's get some basic statistics from our data - averages, standard deviations, etc. 
The 'psych' package we loaded has a handy function called 'describe'. 
**describe(*filename*)**
```
describe(nba)
```
The first two fields are strings, so R can't run statistics on them.
```        vars   n   mean    sd median trimmed   mad min   max range  skew kurtosis   se
player*    1 509    NaN    NA     NA     NaN    NA Inf  -Inf  -Inf    NA       NA   NA
team*      2 507    NaN    NA     NA     NaN    NA Inf  -Inf  -Inf    NA       NA   NA
age        3 507  25.54  4.05   25.0   25.21  4.45  19  43.0  24.0  0.76     0.30 0.18
height     4 509  78.34  3.53   78.0   78.33  2.97  63  89.0  26.0 -0.03     0.27 0.16
weight     5 507 217.26 24.16  215.0  216.43 25.20 160 311.0 151.0  0.39     0.01 1.07
points     6 505   8.66  6.58    7.1    7.88  5.78   0  35.2  35.2  1.08     0.86 0.29
```
But check out the last four. The average age of NBA players, for instance, is 25-1/2. They range from 19 to 43 years old.
The sd (standard deviation) of 4 means about two-thirds of players fall within 4 years of the average age.
That is, about two-third of players range from 21-1/2 to 29-1/2 years old.

You can also get a single statistic for a single variable.

**measure(*filename$fieldname*)**
```
mean(nba$height)
```
The average height for players is 78.3 inches. What about the heaviest player?
```
max(nba$weight)
```
Uh oh, we get "NA" because a couple of players have missing values. In that case, we tell R to remove the NAs by adding 'na.rm = TRUE'
```
max(nba$weight, na.rm = TRUE)
```
The heaviest player weights 311 pounds.

### MAKE COMPARISONS: Z-scores

Sometimes we want to compare things on the same scale. 
For instance, Tacko Fall is the tallest AND heaviest player in our data.
But is he taller than he is heavy? 

That's where Z-scores come in. Z-scores tell you how far from the average a certain data point - or NBA player - is.
It's expressed as a standard deviation.

Calculate the Z-score for one variable

**scale(*filename$fieldname*)**
```
scale(nba$height)
```
Tacko Fall is row 445 in our data. His Z-score, or standardized score, is 3.02. 
That means his height is 3.02 standard deviations above the average height of 78.3 inches. 
```
[443,] -1.51370374
[444,]  0.46986611
[445,]  3.02017021
[446,]  0.75323323
[447,] -0.66360238
```

Now get his standardized weight.
```
scale(nba$weight)
```
Tacko's weight is 3.88 standard deviations above the average weight of 217.3 pounds.
So he's heavier (3.88) than he is tall (3.02)
```
[443,] -1.12820207
[444,]  0.11347329
[445,]  3.87988856
[446,]  0.61014344
[447,]  0.69292179
```
What if you want Z-scores for all variables? scale() works only on numeric data.

In our files, that's columns 3 through 6. Put that range in brackets, like so:
```
scale(nba[3:6])
```
This time we don't see all cases. Let's save this as a new file (or dataframe in R speak)
```
znba <- scale(nba[3:6])
```
Let's combine those Z-scores with our original file so we have everything together.
Use a function called cbind, for column bind.

***newfile* <- cbind(*file1, file2*)**
```
nba_joined <- cbind(nba, znba)
View(nba_joined)
```
<img src="https://github.com/HackWriter/Stats-with-R/blob/pictures/view_nbajoined.png" width="600">
### FIND RELATIONSHIPS: Correlations
Let's switch to the NFL file and run some correlations.
```
View(nfl)
```
Look at the relationship between the number of points scored and games won all season.
**cor(*filename$fieldname1, filename$fieldname2*)**
```
cor(nfl$pts_scored, nfl$games_won)
```
The correlation is 0.71. What does that mean?
Correlations range from -1 to 1.
- A value of -1 means perfect negative correlation. As one variable goes up, the other goes down.
- A value of 1 means perfect positive correlation. The two variables go up together.
- A value of 0 means no correlation - there's no relationship between the two variables.
So 0.71 shows a strong correlation between points scored and games won.
Note: This correlation is also known as Pearson's R. It's the default kind with cor()
What if we want to see correlations for all pairs of variables?
Remember to select only numeric fields, in this case colums 2 through 9.
```
cor(nfl[2:9])
```
The strongest correlation is between points scored and yards gained, at 0.84.
The weakest is between takeaways and yards gained, at 0.03.
We also want to know if the correlations are significant - did they happen by pure chance?
The corr.test function from the psych package shows this. Again, it works only on numeric fields.
```
corr.test(nfl[2:9])
```
We see the correlations again, followed by probability values, also known as p-values.
Anything less than 0.05 means it's statistically significant.
That means there's less than 5 percent probability that we got these results by pure chance.
Take the mild correlation of 0.37 between takeaways and points scored. It has a p-value of 0.62.
That means there's a 62 percent chance we got those results by dumb luck.
### VISUALIZE YOUR DATA: Histograms and scatter plots
It helps to visualize your data, too. For one variable, draw a histogram.
**hist(*filename$fieldname*)**
```
hist(nfl$games_won)
```
<img src="https://github.com/HackWriter/Stats-with-R/blob/pictures/histogram_nfl_games.png" width="400">
For two variables, make a scatter plot.
**plot(*filename$fieldname1, filename$fieldname2*)**
```
plot(nfl$games_won, nfl$pts_scored)
```
<img src="https://github.com/HackWriter/Stats-with-R/blob/pictures/scatterplot_nfl_games_points.png" width="400">
You can also draw plots of all pairs of variables. Once again, R takes only numeric variables.
For the NFL data, that's columns 2 through 9.
```
pairs(nfl[2:9])
```
<img src="https://github.com/HackWriter/Stats-with-R/blob/pictures/matrix_nfl_allpairs.png" width="400">
What if you want to show three pairs of variables that aren't in order? Here's the syntax.
pairs(~ fieldname2 + fieldname4 + fieldname6, data = filename )
```
pairs(~ pts_scored + giveaways + yds_allowed, data = nfl)
```
<img src="https://github.com/HackWriter/Stats-with-R/blob/pictures/matrix_nfl_3pairs.png" width="400">
