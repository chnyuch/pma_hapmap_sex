### Calculate
### hapmap_Fst.07.py
### v7 2024/12/10
### Fst betweem different sex in  6 focal populations 
### v6 2024/11/25
### Fst with different gender ratios betweem different populationss
### v5 2024/11/22
### Fst between genders for different populations, but the gender ratio changes
### v4 2024/11/19
### clean the pipeline for comaparing Fst of type 1 and type 2 populations
### v3 2024/07/02
### per country
### v2 2024/07/01
### add Fst between genders for different populations
### v1 2024/06/13
### check gender in hapmap dataset and compare with heterozygosity
### @author:Chen Yu Chi

import os,sys
import re
import pandas as pd
import numpy as np
from itertools import combinations
import random
import glob

dir_in = '/work/myucchen/hapmap/hm.01.02/'
dir_work = '/work/myucchen/hapmap/hm.01.10/'
dir_loc = dir_work + 'loc/'
dir_fst1 = dir_work + 'fst1/'
#dir_fst2 = dir_work + 'fst2/'
header_hm = 'HapMapMajor' # hapmap b file header

os.system('mkdir -p ' + dir_loc)
os.system('mkdir -p ' + dir_fst1)
#os.system('mkdir -p ' + dir_fst2)
os.system('ln -snf ' + dir_in + header_hm + '.* ' + dir_work)
os.chdir(dir_work)
df_fam = pd.read_csv(header_hm + '.fam', sep = r'\s+', names = ['FID', 'IID', 'FIid', 'MIid', 'sex', 'pheno'])
df_fam['id_ind'] = df_fam['FID'] + '_' + df_fam['IID'] 
# prepare geneder list
# snpsex is used here
df_fam_m = df_fam[df_fam['sex'] == 2].reset_index(drop = True) # reverse to mammal
df_fam_f = df_fam[df_fam['sex'] == 1].reset_index(drop = True)

# df_fam_m[['FID', 'IID']].to_csv('maleID.txt', sep = ' ', index = None, header = None)
# df_fam_f[['FID', 'IID']].to_csv('femaleID.txt', sep = ' ', index = None, header = None)

# generate vcf files
os.system('plink --bfile ' + header_hm + ' --recode vcf --maf 0.01 --geno 0.8 --not-chr 35 --rel-cutoff 0.25 --chr-set 36 --must-have-sex --out ' + header_hm)
# only 568 individials in the dataset, need to check which are kept from the original fam file
# check the individuals left
with open(dir_work + header_hm + '.vcf') as inVcf:
    for i, line in enumerate(inVcf):
        if not line.startswith('##'):
            line = line.rstrip()
            vcf_ind = re.split(r'\t+', line)
            break

vcf_ind = vcf_ind[9:]
df_vcf = df_fam[df_fam.id_ind.isin(vcf_ind)]
df_vcf_m = df_fam_m[df_fam_m.id_ind.isin(vcf_ind)]
df_vcf_f = df_fam_f[df_fam_f.id_ind.isin(vcf_ind)]

df_vcf.to_csv(dir_work + 'vcf_sample.txt', sep = ' ', index = None, header = True)

# Prepare pop list
# type1: Czech, Hungary, Montpellier
# type2: Seewiesen, Wytham, Harjavata
pop = df_vcf['FID'].tolist()
pop = list(set(pop))
#lst_fam = ['df_vcf', 'df_vcf_m', 'df_vcf_f']
pop_focal = ['Velky_Kosir_Czech_Republic', 'Pilis_Mountains_Hungary', 'Montpellier_France', 'Seewisen_Germany', 'Wytham_UK', 'Harjavalta_Finland']


for key, value in df_vcf[['FID', 'id_ind']].groupby('FID'):
    print(value['id_ind'])
    if key in pop_focal:
        value['id_ind'].to_csv(dir_loc + '{}.lst'.format(key), index = None, header = None)


def filter_by_loc(df, focal):
    filtered_groups = []
    for key, value in df[['FID', 'id_ind']].groupby('FID'):
        #print(value['id_ind']) 
        if key in focal:
            filtered_groups.append(value)
    return pd.concat(filtered_groups, axis=0).reset_index(drop=True)

df_male = filter_by_loc(df_vcf_m, pop_focal)
df_female = filter_by_loc(df_vcf_f, pop_focal)

df_male['sex'] = 'm'
df_female['sex'] = 'f'
df_focal = pd.concat([df_male, df_female], axis=0, ignore_index=True)


for loc in pop_focal:
    temp_m = df_focal[(df_focal['FID'] == loc) & (df_focal['sex'] == 'm')]
    temp_f = df_focal[(df_focal['FID'] == loc) & (df_focal['sex'] == 'f')]
    df_sub9m = temp_m.sample(n = 9)
    df_sub9m['id_ind'].to_csv(dir_loc + 'male.txt', index = None, header = None, mode = 'a')
    df_sub9f = temp_f.sample(n = 9)
    df_sub9f['id_ind'].to_csv(dir_loc + 'female.txt', index = None, header = None, mode = 'a')


# Fst
os.system('vcftools --vcf HapMapMajor.vcf --out ' + dir_fst1 + 'male-female --fst-window-size 50000 --fst-window-step 10000 --weir-fst-pop ' + dir_loc + 'male.txt --weir-fst-pop ' + dir_loc + 'female.txt')


