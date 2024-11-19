
# title: "Therapeutic_Area_Assigner"
# author: "Lada Sycheva"
# date: "12/13/2023"

#### This script harmonizes Therapeutic Area column in the Excel file and outputs a file with corrected Therapeutic Area values.

# Load necessary libraries
library(readxl)
library(dplyr)  # for 'flatten_chr'
library(stringr)
library(tidyverse)

# Set the paths to the files

xlsx_file_path <- file.path(r"(C:\Projects\Project_1\Therapeutic_Areas_CV.xlsx)")

cleaned_csv_file_path <- file.path(r"(C:\Projects\Project_1\Therapeutic_Areas_CV_clean.csv)")


# Read in the Excel file
raw_data_df <- read_excel(xlsx_file_path,
                          sheet = "raw", col_types = "text")

# Clean up
cleaned_raw_data_df <- raw_data_df %>%
  select(- Company) %>%
  filter(!grepl("\\|", Conditions)) %>%
  rename(`TherapeuticArea` = `Therapeutic Area`) %>%
  filter(!grepl("Unclear", TherapeuticArea)) %>%
  filter(!grepl("Various", TherapeuticArea)) %>%
  filter(!grepl("Other", TherapeuticArea)) %>%
  unique()

# Harmonization
harmonized_raw_data_df <- cleaned_raw_data_df %>%
  group_by(Conditions)

condition_occur <- as.data.frame(table(harmonized_raw_data_df$Conditions))

duplicate_cond <- harmonized_raw_data_df %>%
  filter(Conditions %in%
           condition_occur[condition_occur$Freq > 1, ]$Var1) %>%
  arrange(Conditions)

harmonized_raw_data_df <- cleaned_raw_data_df %>%
  ungroup()

harmonized_raw_data_df <- harmonized_raw_data_df %>%
  filter(!grepl("Healthy", Conditions)) %>%
  mutate(TherapeuticArea = 
           case_when(grepl("AL Amyloidosis", Conditions) ~
                       "Metabolic Diseases|Rare disease",
                     grepl("Acquired Immunodeficiency", Conditions) ~
                       "Immunology",
                     grepl("Allergic Bronchopulmonary Aspergillosis", Conditions) ~
                       "Infectious Diseases|Pulmonology",
                     grepl("Allergic Fungal Rhinosinusitis", Conditions) ~
                       "Infectious Diseases|Otolaryngology",
                     grepl("Alopecia Areata", Conditions) ~ "Autoimmunity|Dermatology", 
                     grepl("Alzheimer Disease", Conditions) ~
                       "Neurology",
                     grepl("Asthma", Conditions) ~
                       "Pulmonology",
                     grepl("Atopic Dermatitis", Conditions) ~
                       "Immunology|Dermatology",
                     grepl("Atypical Hemolytic Uremic Syndrome", Conditions) ~
                       "Rare disease|Cardiovascular",
                     grepl("COVID-19 Pneumonia", Conditions) ~
                       "Infectious Diseases|Pulmonology",
                     grepl("Celiac Disease", Conditions) ~
                       "Gastroenterology|Immunology",
                     grepl("Chickenpox", Conditions) ~
                       "Infectious Diseases|Dermatology",
                     grepl("Chronic Kidney Disease", Conditions) ~
                       "Nephrology",
                     grepl("Pulmonary Disease", Conditions) ~
                       "Pulmonology",
                     grepl("Chronic Spontaneous Urticaria", Conditions) ~
                       "Autoimmunity|Dermatology",
                     grepl("Crohn Disease", Conditions) ~
                       "Immunology|Gastroenterology",
                     grepl("Crohn's Disease", Conditions) ~
                       "Immunology|Gastroenterology",
                     grepl("Dermatitis, Atopic", Conditions) ~
                       "Immunology|Dermatology",
                     grepl("Diabetes", Conditions) ~
                       "Metabolic diseases",
                     grepl("Diabetic Foot Ulcer", Conditions) ~
                       "Metabolic diseases|Dermatology",
                     grepl("Diabetic Macular Edema", Conditions) ~
                       "Metabolic diseases|Ophthalmology",
                     grepl("Giant Cell Arteritis", Conditions) ~
                       "Immunology",
                     grepl("Growth Hormone Deficiency in Children", Conditions) ~
                       "Endocrinology|Pediatrics",
                     grepl("Diabetic Retinopathy", Conditions) ~
                       "Metabolic diseases|Ophthalmology",
                     grepl("Hematological Malignancies", Conditions) ~
                       "Hematology|Oncology",
                     grepl("Hepatic Impairment", Conditions) ~
                       "Hepatology",
                     grepl("Hidradenitis Suppurativa", Conditions) ~
                       "Dermatology|Immunology",
                     grepl("Kidney Transplant", Conditions) ~
                       "Nephrology|Immunology",
                     grepl("Children With Suspected or Confirmed Nosocomial Pneumonia", Conditions) ~
                       "Infectious Diseases|Pulmonology|Pediatrics",
                     grepl("Human Papillomavirus Vaccination", Conditions) ~
                       "Infectious Diseases",
                     grepl("Idiopathic Pulmonary Fibrosis", Conditions) ~
                       "Pulmonology",
                     grepl("Immune Thrombocytopenia", Conditions) ~
                       "Autoimmunity|Hematology",
                     grepl("Infections, Meningococcal", Conditions) ~
                       "Infectious Diseases|Neurology",
                     grepl("Interstitial Lung Disease", Conditions) ~
                       "Pulmonology",
                     grepl("Juvenile Idiopathic Arthritis", Conditions) ~
                       "Autoimmunity|Rheumatology|Pediatrics",
                     grepl("Liver Cirrhosis", Conditions) ~
                       "Hepatology",
                     grepl("Macular Edema", Conditions) ~
                       "Ophtalmology",
                     grepl("Measles; Mumps; Rubella; Chickenpox", Conditions) ~
                       "Infectious diseases",
                     grepl("Meningococcal Vaccine", Conditions) ~
                       "Infectious diseases",
                     grepl("Multiple Sclerosis", Conditions) ~
                       "Autoimmunity|Neurology",
                     grepl("Muscular Atrophy, Spinal", Conditions) ~
                       "Neurology",
                     grepl("Myasthenia Gravis", Conditions) ~
                       "Autoimmunity|Neurology",
                     grepl("Macular Degeneration", Conditions) ~
                       "Ophthalmology",
                     grepl("Neurodermatitis", Conditions) ~
                       "Dermatology|Neurology",
                     grepl("Steatohepatitis", Conditions) ~
                       "Hepatology",
                     grepl("Papillomavirus Infections", Conditions) ~
                       "Infectious diseases",
                     grepl("Parkinson Disease", Conditions) ~
                       "Neurology",
                     grepl("Paroxysmal Nocturnal Hemoglobinuria", Conditions) ~
                       "Hematology|Rare diseases",
                     grepl("Pneumococcal Disease", Conditions) ~
                       "Infectious Diseases|Pulmonology",
                     grepl("Pneumonia", Conditions) ~
                       "Pulmonology",
                     grepl("Polycythemia Vera", Conditions) ~
                       "Oncology",
                     grepl("Presbyopia", Conditions) ~
                       "Ophthalmology",
                     grepl("Pyoderma Gangrenosum", Conditions) ~
                       "Immunology|Dermatology",
                     grepl("Renal Impairment", Conditions) ~
                       "Nephrology",
                     grepl("Renal Insufficiency", Conditions) ~
                       "Nephrology",
                     grepl("Respiratory Syncytial Virus", Conditions) ~
                       "Infectious Diseases|Pulmonology",
                     grepl("Respiratory Syndrome", Conditions) ~
                       "Infectious Diseases|Pulmonology",
                     grepl("Severe Aplastic Anemia", Conditions) ~
                       "Hematology",
                     grepl("Sickle Cell Disease", Conditions) ~
                       "Hematology",
                     grepl("Spinal Muscular Atrophy", Conditions) ~
                       "Neurology",
                     grepl("Sunscreening Agents", Conditions) ~
                       "Dermatology",
                     grepl("Systemic Lupus Erythematosus", Conditions) ~
                       "Autoimmunity",
                     grepl("Thromboembolism", Conditions) ~
                       "Cardiovascular",
                     grepl("Thyroid Eye Disease", Conditions) ~
                       "Ophthalmology",
                     grepl("Tuberculosis", Conditions) ~
                       "Infectious Diseases|Pulmonology",
                     grepl("Myelodysplastic Syndrome", Conditions) ~
                       "Oncology|Hematology",
                     grepl("Autoimmune Hemolytic Anemia", Conditions) ~
                       "Autoimmunity|Hematology",
                     TRUE ~ TherapeuticArea)) %>%
  unique()

TAs <- harmonized_raw_data_df %>%
  select(TherapeuticArea) %>%
  arrange() %>%
  unique()

#### Harmonize more
# "diseses" -> "Diseases"
# "disease" -> "Diseases"
# 
harmonized_raw_data_df <- harmonized_raw_data_df %>%
  mutate(TherapeuticArea = 
           case_when(grepl("Infectious Diseses", TherapeuticArea) ~ 
                       str_replace(TherapeuticArea,
                                   "Infectious Diseses",
                                   "Infectious Diseases"),
                     grepl("Infectious diseases", TherapeuticArea) ~ 
                       str_replace(TherapeuticArea,
                                   "Infectious diseases",
                                   "Infectious Diseases"),
                     grepl("Liver diseases", TherapeuticArea) ~ 
                       str_replace(TherapeuticArea,
                                   "Liver diseases",
                                   "Hepatology"),
                     grepl("disease$|disease\\|", TherapeuticArea) ~ 
                       str_replace(TherapeuticArea,
                                   "disease",
                                   "Diseases"),
                     grepl("Osteopathy", TherapeuticArea) ~ 
                       str_replace(TherapeuticArea,
                                   "Osteopathy",
                                   "Orthopedics"),
                     grepl("Metabolic diseases", TherapeuticArea) ~
                       str_replace(TherapeuticArea,
                                   "Metabolic diseases",
                                   "Metabolic Diseases"),
                     grepl("Metabolism", TherapeuticArea) ~
                       str_replace(TherapeuticArea,
                                   "Metabolism",
                                   "Metabolic Diseases"),
                     grepl("Autoimmune",  TherapeuticArea) ~
                       str_replace(TherapeuticArea,
                                   "Autoimmune",
                                   "Autoimmunity"),
                     grepl("Rare diseases", TherapeuticArea) ~
                       str_replace(TherapeuticArea,
                                   "Rare diseases",
                                   "Rare Diseases"),
                     grepl("Endocrine", TherapeuticArea) ~
                       str_replace(TherapeuticArea,
                                   "Endocrine",
                                   "Endocrinology"),
                     grepl("Opthalmology", TherapeuticArea) ~
                       str_replace(TherapeuticArea,
                                   "Opthalmology",
                                   "Ophthalmology"),
                     grepl("Ophtalmology", TherapeuticArea) ~
                       str_replace(TherapeuticArea,
                                   "Ophtalmology",
                                   "Ophthalmology"),
                     grepl("Vaccine$", TherapeuticArea) ~
                       str_replace(TherapeuticArea,
                                   "Vaccine",
                                   "Vaccines"),
                     grepl("Neuromuscular diseases", TherapeuticArea) ~
                       str_replace(TherapeuticArea,
                                   "diseases",
                                   "Diseases"),
                     TRUE ~ TherapeuticArea))

TAs <- harmonized_raw_data_df %>%
  select(TherapeuticArea) %>%
  unique() %>%
  arrange(TherapeuticArea)


write_csv(harmonized_raw_data_df, cleaned_csv_file_path)
