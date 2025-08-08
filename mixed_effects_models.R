
library(rstudioapi)
library(readr)
library(dplyr)
library(lme4)
library(tidyr)
library(lmerTest)
library(emmeans)

library(glmmTMB)
library(brms)


setwd(dirname(getActiveDocumentContext()$path))

# random seed
set.seed(123456)


# read the regression results & Meta data and merge them together
Meta_summary <- read_csv("Meta_summary.csv")
regression_summary <- read_csv("regression_summary.csv")

merged_summary <- left_join(regression_summary, Meta_summary, by = "SubjectCode") %>%
  filter(Condition %in% c("A", "B", "C")) %>%   # 只保留 ABC
  mutate(
     IAF_Pre = replace_na(IAF_Pre, 10),             
    dir_delta_IAF = 10 - IAF_Pre,
    abs_delta_IAF = abs(10 - IAF_Pre),
    Condition = factor(Condition, levels = c("A", "B", "C")),
    SubjectCode = as.factor(SubjectCode),  
    Condition_seq = factor(Condition_seq, levels = c("S1", "S2", "S3")),
    abs_average_delta_IAF = abs(10 - (IAF_Pre+IAF_Post)/2),
    dir_average_delta_IAF = 10 - (IAF_Pre+IAF_Post)/2)

#Multivariable regression was used to analyze the regression coefficients, as the mixed-effects models failed to converge.

# for hits
rmodel_hit_amplitude <- lm(amplitude_hit ~ Condition * abs_delta_IAF, data = merged_summary)
rmodel_rt_amplitude <- lm(amplitude_RT ~ Condition * abs_delta_IAF, data = merged_summary)

# for RT

rmodel_hit_intercept <- lm(intercept_hit ~ Condition * dir_delta_IAF, data = merged_summary)
rmodel_rt_intercept <- lm(intercept_RT ~ Condition * dir_delta_IAF, data = merged_summary)


#-----but we can still try the mixed-effects model--------------------------------------------------------------------------------------------------------------

m_model_hit_amplitude <- lmer(amplitude_hit ~ Condition*abs_delta_IAF + (1 | SubjectCode),
                                             data = merged_summary)

m_model_rt_amplitude <- lmer(amplitude_RT ~ Condition*abs_delta_IAF + (1 | SubjectCode),
                               data = merged_summary)

m_model_hit_intercept <- lmer(intercept_hit ~ Condition*dir_delta_IAF + (1 | SubjectCode),
                              data = merged_summary)

m_model_rt_intercept <- lmer(intercept_RT ~ Condition*dir_delta_IAF + (1 | SubjectCode),
                             data = merged_summary)




# read trial-wise information and merge it with Metadata----------------------------------------------------------------------------------------------
trial_summary <- read_csv("trial_summary.csv")

merged_trial_summary_nosham <- left_join(trial_summary, Meta_summary, by = "SubjectCode") %>%
  filter(Condition %in% c("A", "B", "C")) %>% 
  mutate(
    IAF_Pre = replace_na(IAF_Pre, 10),             
    dir_delta_IAF = 10 - IAF_Pre,
    abs_delta_IAF = abs(10 - IAF_Pre),
    Condition = factor(Condition, levels = c("A", "B", "C")),
    SubjectCode = as.factor(SubjectCode),  
    Condition_seq = factor(Condition_seq, levels = c("S1", "S2", "S3"))
  )

# further analysis for the relationship between performance and directional IAF

# hits+general performance (no sham); 

rmodel_hit_baseline_no_sham <- glmer(Hit ~  Condition*dir_delta_IAF + (1 | SubjectCode),
                                         data = merged_trial_summary_nosham,
                                         family = binomial)

summary(rmodel_hit_baseline_no_sham)

# RT+general performance (no sham)

hit_trials <- subset(merged_trial_summary_nosham, Hit == 1)

rmodel_rt_baseline <- lmer(RT ~  Condition*dir_delta_IAF +(1 | SubjectCode),
                                    data = hit_trials)
summary(rmodel_rt_baseline)


# --analysis of generial performance------------------------------------------------------------------------------------

merged_trial_summary <- left_join(trial_summary, Meta_summary, by = "SubjectCode") %>%
  mutate(
    IAF_Pre = replace_na(IAF_Pre, 10),             
    dir_delta_IAF = 10 - IAF_Pre,
    abs_delta_IAF = abs(10 - IAF_Pre),
    Condition = factor(Condition, levels = c("A", "B", "C", "Sh")),
    SubjectCode = as.factor(SubjectCode),  
    Condition_seq = factor(Condition_seq, levels = c("S1", "S2", "S3"))
  )



model_hit_general_performance <- glmer(Hit ~  Condition*dir_delta_IAF+ (1 | SubjectCode),
                                      data = merged_trial_summary,
                                      family = binomial)

summary(model_hit_general_performance)

## 只选取hit =1 的 
hit_trials <- subset(merged_trial_summary, Hit == 1)

# 在 Hit == 1 的试次中建模 RT
model_rt_hit_only <- lmer(RT ~ Condition * dir_delta_IAF + (1 | SubjectCode),
                          data = hit_trials)

summary(model_rt_hit_only)

# analysis of aftereffects

merged_trial_summary_sham <- merged_trial_summary %>%
                             filter(sham_seq %in% c('pre_stim','post_A','post_B','post_C')) %>%
                                     mutate(
                                         sham_seq= factor(sham_seq, levels = c('pre_stim','post_A','post_B','post_C'))
                                          )
# hit + aftereffects

model_hit_aftereffect <- glmer(Hit ~ sham_seq*dir_delta_IAF  + (1 | SubjectCode),
                             data = merged_trial_summary_sham,
                             family = binomial)

summary(model_hit_aftereffect)

                          

# RT + aftereffects---------------------------------


hit_trials <- subset(merged_trial_summary_sham, Hit == 1)


model_rt_aftereffect <- lmer(RT ~ sham_seq*dir_delta_IAF  + (1 | SubjectCode),
                                     data = hit_trials)

summary(model_rt_aftereffect)
