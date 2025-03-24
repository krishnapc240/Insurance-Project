library(dplyr)
library(ggplot2)
insurance <- read.csv("C:/Users/pckri/OneDrive/Documents/insurance sql edited.csv")
insurance
View(insurance)

base_cost <- 2000
age_factor <- 50
bmi_factor <- 30
smoker_surcharge <- 5000

insurance <- insurance %>%
  mutate(
    premium = base_cost + (age_factor * age) + (bmi_factor * bmi) + 
      (smoker_surcharge*(smoker == "yes"))
  )
head(insurance)

#Premiums for Smokers vs. Non-Smokers
# Premiums for Smokers vs. Non-Smokers
smoker_premium <- insurance %>%
  group_by(smoker) %>%
  summarise(avg_premium = mean(premium))

# Visualization: Premiums for Smokers vs. Non-Smokers
ggplot(smoker_premium, aes(x = smoker, y = avg_premium, fill = smoker)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Premiums: Smokers vs Non-Smokers", x = "Smoker Status", y = "Average Premium") +
  theme_minimal()

# Premiums Across Age Categories
age_premium <- insurance %>%
  group_by(age_category) %>%
  summarise(avg_premium = mean(premium))

# Visualization: Premiums Across Age Categories
ggplot(age_premium, aes(x = age_category, y = avg_premium, fill = age_category)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Premiums Across Age Categories", x = "Age Category", y = "Average Premium") +
  theme_minimal()

# Premiums Across BMI Categories
bmi_premium <- insurance %>%
  group_by(bmi_category) %>%
  summarise(avg_premium = mean(premium))

# Visualization: Premiums Across BMI Categories
ggplot(bmi_premium, aes(x = bmi_category, y = avg_premium, fill = bmi_category)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Premiums Across BMI Categories", x = "BMI Category", y = "Average Premium") +
  theme_minimal()

