library(dplyr)
library(ggplot2)
library(readr)

# Load the demo data
load("/mnt/data/ADAM/demo_ae_data.RData")

# Descriptive analysis
total_AEs <- sum(ae_data$AE, na.rm = TRUE)
total_severe_AEs <- sum(ae_data$AESeverity == "Severe", na.rm = TRUE)
total_serious_AEs <- sum(ae_data$AESerious == 1, na.rm = TRUE)

cat("Total AEs:", total_AEs, "\n")
cat("Total Severe AEs:", total_severe_AEs, "\n")
cat("Total Serious AEs:", total_serious_AEs, "\n")

# AE count by treatment group
ae_by_treatment <- ae_data %>% 
  group_by(Treatment) %>% 
  summarise(
    Total_AEs = sum(AE, na.rm = TRUE),
    Severe_AEs = sum(AESeverity == "Severe", na.rm = TRUE),
    Serious_AEs = sum(AESerious == 1, na.rm = TRUE)
  )

print(ae_by_treatment)

# Bar plot of AEs by treatment group
ggplot(ae_by_treatment, aes(x = Treatment)) +
  geom_bar(aes(y = Total_AEs), stat = "identity", position = "dodge", fill = "blue") +
  geom_bar(aes(y = Severe_AEs), stat = "identity", position = "dodge", fill = "red") +
  geom_bar(aes(y = Serious_AEs), stat = "identity", position = "dodge", fill = "green") +
  labs(title = "Adverse Events by Treatment Group",
       y = "Number of AEs",
       x = "Treatment Group") +
  scale_fill_manual(values = c("blue", "red", "green"), 
                    name = "AE Type", 
                    breaks = c("blue", "red", "green"),
                    labels = c("Total AEs", "Severe AEs", "Serious AEs")) +
  theme_minimal()

# Save the output to /mnt/artifacts/results
output_dir <- "/mnt/artifacts/results"
write_csv(ae_by_treatment, file.path(output_dir, "AE_by_treatment.csv"))
ggsave(filename = file.path(output_dir, "AE_by_treatment_plot.png"), plot = last_plot())
