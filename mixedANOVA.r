# A scaffolding for a mixed ANOVA in R

library(reshape2)
library(car)
library(dplyr)
library(ez)
library(knitr)

# Read in the data
data = read.csv2('YOUR_FILE', sep=',', encoding='1250')

# Slice the original frame if needed
data <- data %>% select(YOUR_COLUMNS)

# Convert some data into factors if needed
data$COL <- factor(data$COL, levels=c(0, 1), labels=c('Female', 'Male'))

# Rename your subject ID column if needed
colnames(data)[1] <- 'subject'

# Melt the dataframe (`id` takes your BETWEEN-SUBJECT vars, `measured` takes your WITHIN-SUBJECT vars)
data_long <- melt(data, id=c('subject', 'grp', 'fdbk', 'sex'), measured=c('compet', 'cooper'))

# Rename melted (WITHIN) cols if needed:
colnames(data_long)[5] <- 'Choice'
colnames(data_long)[6] <- 'Rank'

# Perform Levene's Test
leveneTest(Rank ~ grp*fdbk*sex, data=data_long, center=mean)


# Perform ANOVA (Maulchy's test included):
output <- ezANOVA(data=data_long, 
                  dv=Rank,
                  wid=subject,
                  within=Choice,
                  between=c(fdbk, grp),
                  detailed=TRUE,
                  type=3)

# Print results in a nice-formatted table
knitr::kable(output, digits = 2, caption = 'Anova results')
