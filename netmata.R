#Author: Cong Zhu
#Purpose: an example code of network meta-analysis using package "netmeta"
library(dplyr)
library(boot)
library(survival)
library(ggplot2)
library(survminer)
library(flextable)
library(officer)
library(readxl)
library(netmeta)
help("netmeta-package")


data('Baker2009')



df_meta = Baker2009 %>%
  filter(study %in% c('Carverley-ERJ 2003','Boyd 1997'))

#Get pairwise treatment comparison
#For review purpose
pw_comp = pairwise(treat = treatment,
               n = total ,
               event = exac,
               studlab = study,
               data = df_meta,
               sm = "OR") %>%
  select(studlab,TE, seTE,treat1, event1, n1, treat2, event2, n2)

#For the purpose of serving as input data in the next step
meta_input = pw_comp %>%
  select(TE,seTE, treat1,treat2, studlab)
  

#Random effects network meta-analysis

settings.meta(digits=2)
net_result = netmeta(TE,
               seTE,
               treat1,
               treat2,
               studlab,
               meta_input, 
               common = F,ref = "plac", small.values = "desirable")

net_result

forest(net_result)

netgraph(net_result, 
         seq = 'optimal',
         number.of.studies = T)
