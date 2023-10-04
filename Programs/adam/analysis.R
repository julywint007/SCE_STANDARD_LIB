# Load required libraries
library(haven)
library(dplyr)
library(ggplot2)
library(tidyr)  # Needed for drop_na()

# Read in the ADLS file
data <- read_xpt("/mnt/data/ADAM/adsl.xpt")

# Convert to dataframe
df <- as.data.frame(data)

# Remove rows with missing values for AGE and EOSDT
df <- df %>% drop_na(AGE, EOSDT)

# Extract the year from EOSDT
df$Year <- as.numeric(format(as.Date(df$EOSDT, format = "%Y-%m-%d"), "%Y"))

# Summarize the data by Year
summaries <- df %>%
  group_by(Year) %>%
  summarise(mean_age = mean(AGE, na.rm = TRUE),
            sd_age = sd(AGE, na.rm = TRUE),
            n = n())

# Plot the means and standard deviations by year
ggplot(summaries, aes(x = Year, y = mean_age)) +
  geom_point() +
  geom_errorbar(aes(ymin = mean_age - sd_age, ymax = mean_age + sd_age), width = 0.5, color = "red") +
  labs(title = "Average Age over Years",
       x = "Year",
       y = "Average Age")

# Plot the means and standard deviations by year
plot_obj <- ggplot(summaries, aes(x = Year, y = mean_age)) +
  geom_point() +
  geom_errorbar(aes(ymin = mean_age - sd_age, ymax = mean_age + sd_age), width = 0.5, color = "red") +
  labs(title = "Average Age over Years",
       x = "Year",
       y = "Average Age")

# Display the plot
print(plot_obj)

# Save the plot to a PDF
ggsave(filename = "/mnt/artifacts/results/average_age_plot.pdf", plot = plot_obj, device = "pdf")