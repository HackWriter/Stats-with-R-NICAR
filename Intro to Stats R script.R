# This file comes from the College Scorecard file. 
# Focus: Four-year, bachelor's degree-granting schools.

# your working directory will be different - this is mine
setwd("~/Documents/NICAR/college_scorecard/")


library(dplyr)
library(ggplot2)
library(janitor)
library(psych)
library(readxl)
library(stringr)
library(tidyr)
library(tidyverse)

# Read colleges.csv into R, create data frame with same name
  

colleges <- read_csv("colleges.csv", col_names = TRUE) 

# View the data

view(colleges)


# What if your file has millions of records and you want to see only 
# the first few? Use head to call up the first rows.

head(colleges, 15)

# We see the first several fields in the Console window (lower left of RStudio) but not all. So let's view all columns in first 15 rows.

view(head(colleges, 15))

# This way also works.
head(colleges, 15) %>% view()

# Check out the structure of our data - which fields are numeric, character, etc.
str(colleges)

#####  
# DESCRIPTIVES - get basic statistics for our variables using summary
#####
summary(colleges)

# Note that this works only for numeric fields, not character.
# We can also look at a single variable.
summary(colleges$total_cost)

# Or a single statistic for a single variable.
mean(colleges$total_cost) 

# Wait, it returns NA. That's because some colleges have missing values.
# You have to exclude the null fields with na.rm = TRUE
# That's Rspeak for Remove NAs? Yes

mean(colleges$total_cost, na.rm = T) 

# Other Handy Stats
median(colleges$total_cost, na.rm = T) # median = middle value
sd(colleges$total_cost, na.rm = T) # standard deviation
min(colleges$total_cost, na.rm = T) # minimum value, i.e. cheapest college
max(colleges$total_cost, na.rm = T) # maximum value, i.e. priciest college

# Which college has the highest sticker price of $78,555?
which.max(colleges$total_cost)

# It returns 340, which is the row number. Which college is that?
#   This returns the data in that row.

colleges[340,]

# We can also return just the college name (column 2) in that row.
colleges[340,2]

# Same result but we use the column name instead of number.
colleges[340,"instnm"]

# Bonus tip: Put those commands together
colleges[which.max(colleges$total_cost),]

# Try getting the same info for the cheapest college on your own.

#####
## FREQUENCY COUNTS & GROUP STATISTICS
#####

# What if you want to know how many colleges there are by control
# (public, private, for-profit)

colleges %>%
  group_by(control) %>%
  count() 

# Instead of count, we can use summarize. This is helpful if we want to build on this & add statistics like average, median, etc.

colleges %>%
  group_by(control) %>%
  summarize(freq = n()) 

# I called it "freq" but you can call it anything, like count or N

# We can also look at the average total cost by type.
colleges %>%
  group_by(control) %>%
  summarize(freq = n(), avg = mean(total_cost, na.rm = T))

# Look only at colleges in Tennessee
colleges %>%
  group_by(control) %>%
  filter(state == "TN") %>%
  summarize(freq = n(), avg = mean(total_cost, na.rm = T))


# Compare the average sticker price (total_cost) to net price, 
# which is what students actually pay after grants & scholarships
# We'll also give our new fields more detailed names

colleges %>%
  group_by(control) %>%
  filter(state == "TN") %>%
  summarize(freq = n(),
            avg_net = mean(net_price, na.rm = T), 
            avg_total = mean(total_cost, na.rm = T),
            avg_default = mean(default_3yr, na.rm = T))
            
# A tibble: 3 × 5

#####
# CORRELATIONS - how much two variables are related to each other
#####
# For that we use *cor*
cor(colleges$total_cost, colleges$net_price)

# We get NA again, so we need to specify only complete pairs,
# i.e. both fields have values

cor(colleges$total_cost, colleges$net_price, use = "complete.obs")

# The correlation is **0.78**. What does that mean?
#  Correlations range from -1 to 1.
# A value of -1 means perfect negative correlation. As one variable goes up, the other goes down.
# A value of 1 means perfect positive correlation. The two variables go up together.
# A value of 0 means no correlation - there's no relationship between the two variables.
# So 0.78 shows a strong correlation between sticker price and net price.
# Note: This correlation is also known as Pearson's R. It's the default kind with cor()

# We can also look at correlations across multiple variables
colnames(colleges)
cor(colleges[7:16], use = "complete.obs")
cor(colleges[7:16], use = "pairwise.complete.obs")

# pairwise.complete.obs = Goes pair by pair and excludes missing variables. N will vary.
# complete.obs = Includes only cases with no missing values at all. N will be consistent.*

# Say we want to see what measures are most strongly correlated with grad_rate.

# That would be the median ACT (act_mid) and average SAT scores of incoming students, at 0.83.

# The weakest correlation with grad rates is the percent of full-time faculty, at 0.11.


# We also want to know if the correlations are significant - 
# did they happen by pure chance?
# The corr.test function from the psych package shows this. 
# Again, it works only on numeric fields.
corr.test(colleges[11:16], use = "complete.obs")

# Generally if you have a lot of cases, it will be statistically significant.
# What about a smaller slice of the data? 
# Let's create a dataframe with just Tennessee colleges.

tn_colleges <- filter(colleges, state == "TN")
corr.test(tn_colleges[11:16], use = "complete.obs")

# We see the correlations again, followed by probability values, 
# also known as p-values.
# Anything less than 0.05 means it's statistically significant.
# That means there's less than 5 percent probability that we got these results by pure chance.
# Take the moderate correlation of 0.39 between grad rates and net price. It has a p-value of 0.07.
# That means there's a 7 percent chance we got those results by dumb luck.

###########
# VISUALIZE YOUR DATA: Histograms and scatter plots
###########
# It helps to visualize your data, too. For one variable, draw a histogram.

hist(colleges$total_cost)

# For two variables, make a scatter plot.
plot(colleges$total_cost, colleges$net_price)

# You can also use *pairs*. This shows a matrix of columns 12 through 15.
pairs(colleges[12:15])

# Or you can select the variables by name.
pairs(~ total_cost + net_price + grad_rate, data = colleges)

# Make more powerful charts with the ggplot2 library

# Basic scatter plot
ggplot(colleges, aes(x=total_cost, y=net_price)) + geom_point()
# R gives you a warning message about missing values that are removed

# Change the point size
ggplot(colleges, aes(x=total_cost, y=net_price)) + 
  geom_point(size = 1)

# Color by college type
ggplot(colleges, aes(x=total_cost, y=net_price, color = control)) + 
  geom_point(size = 1)

# Do the same with TN colleges only
# Color by college type
ggplot(tn_colleges, aes(x=total_cost, y=net_price, color = control)) + 
  geom_point(size = 1)

# Label points with school ID. hjust & vjust reposition the label
ggplot(tn_colleges, aes(x=total_cost, y=net_price, color = control, 
                        label=unitid)) + 
  geom_point(size = 1) +
  geom_text(size = 2, hjust=0, vjust=0)

#####
# HISTOGRAMS
#####
ggplot(colleges, aes(x=total_cost)) +
  geom_histogram()

# Change the bin width (based on total dollars)
ggplot(colleges, aes(x=total_cost)) +
  geom_histogram(binwidth=1000)

# Change the colors
ggplot(colleges, aes(x=total_cost)) +
  geom_histogram(binwidth=1000, color="blue", fill="white")

# Color by group
ggplot(colleges, aes(x=total_cost, color=control)) +
  geom_histogram(binwidth=1000, fill="white")
