### Calculate
### hapmap_Fst.04.py
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

dir_in = '/work/myucchen/hapmap/hm.01.02/'
dir_work = '/work/myucchen/hapmap/hm.01.07/'
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

df_fam_m[['FID', 'IID']].to_csv('maleID.txt', sep = ' ', index = None, header = None)
df_fam_f[['FID', 'IID']].to_csv('femaleID.txt', sep = ' ', index = None, header = None)

# generate vcf files
os.system('plink --bfile ' + header_hm + ' --recode vcf --maf 0.01 --geno 0.8 --not-chr 1,2,3,4,6,7,8,9,10,11,12,13,14,15,17,18,19,20,21,22,23,24,26,27,28,30,31,32,33,34,35,36 --rel-cutoff 0.25 --chr-set 36 --must-have-sex --out ' + header_hm)

# Prepare pop list
pop = df_fam['FID'].tolist()
pop = list(set(pop))
lst_fam = ['df_fam', 'df_fam_m', 'df_fam_f']

for key, value in df_fam[['FID', 'id_ind']].groupby('FID'):
    print(value['id_ind'])
    value['id_ind'].to_csv(dir_loc + '{}.txt'.format(key), index = None, header = None)

for key, value in df_fam_m[['FID', 'id_ind']].groupby('FID'):
    print(value['id_ind'])
    value['id_ind'].to_csv(dir_loc + '{}_m.txt'.format(key), index = None, header = None)

for key, value in df_fam_f[['FID', 'id_ind']].groupby('FID'):
    print(value['id_ind'])
    value['id_ind'].to_csv(dir_loc + '{}_f.txt'.format(key), index = None, header = None)

# calculate Fst
# type1: Czech, Hungary, Montpellier
# type2: Seewiesen, Wytham, Harjavata
type1 = ['Velky_Kosir_Czech_Republic', 'Pilis_Mountains_Hungary', 'Montpellier_France']
type2 = ['Seewisen_Germany', 'Wytham_UK', 'Harjavalta_Finland']
popType = {'type1':type1, 'type2':type2}

os.system('mkdir ' + dir_fst1 + 'type1')
os.system('mkdir ' + dir_fst1 + 'type2')

# compare with different locations
for pop, poplist in popType.items():
    pairwise = [list(pair) for pair in combinations(poplist, 2)]
    #print(pairwise)
    if pop == 'type1':
        dir_out = dir_fst1 + 'type1/'
    else:
        dir_out = dir_fst1 + 'type2/'
    for pair in pairwise:
        #print(pair[0])
        # whole group comparison
        os.system('vcftools --vcf HapMapMajor.vcf --out ' + dir_out + pair[0] + '.' + pair[1] + ' --fst-window-size 50000 --fst-window-step 10000 --weir-fst-pop ' + dir_loc + pair[0] + '.txt --weir-fst-pop ' + dir_loc + pair[1] + '.txt')
        # female comparison
        os.system('vcftools --vcf HapMapMajor.vcf --out ' + dir_out + pair[0] + '_f.' + pair[1] + '_f --fst-window-size 50000 --fst-window-step 10000 --weir-fst-pop ' + dir_loc + pair[0] + '_f.txt --weir-fst-pop ' + dir_loc + pair[1] + '_f.txt')
        # female vs whole comparison
        os.system('vcftools --vcf HapMapMajor.vcf --out ' + dir_out + pair[0] + '_f.' + pair[1] + ' --fst-window-size 50000 --fst-window-step 10000 --weir-fst-pop ' + dir_loc + pair[0] + '_f.txt --weir-fst-pop ' + dir_loc + pair[1] + '.txt')
        # whole vs female comparison
        os.system('vcftools --vcf HapMapMajor.vcf --out ' + dir_out + pair[0] + '.' + pair[1] + '_f --fst-window-size 50000 --fst-window-step 10000 --weir-fst-pop ' + dir_loc + pair[0] + '.txt --weir-fst-pop ' + dir_loc + pair[1] + '_f.txt')


# compare with same locations
pops = [item for sublist in popType.values() for item in sublist]
for pop in pops:
    if pop in type1:
        dir_out = dir_fst1 + 'type1/'
    else:
        dir_out = dir_fst1 + 'type2/'
    print('vcftools --vcf HapMapMajor.vcf --out ' + dir_out + pop + '.' + pop + '_f --fst-window-size 50000 --fst-window-step 10000 --weir-fst-pop ' + dir_loc + pop + '.txt --weir-fst-pop ' + dir_loc + pop + '_f.txt')
    os.system('vcftools --vcf HapMapMajor.vcf --out ' + dir_out + pop + '.' + pop + '_f --fst-window-size 50000 --fst-window-step 10000 --weir-fst-pop ' + dir_loc + pop + '.txt --weir-fst-pop ' + dir_loc + pop + '_f.txt')


# Different gender ratios


