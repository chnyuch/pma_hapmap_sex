### Check gender in hapmap dataset
### hapmap_sex.01.py
### v1 2024/06/13
### check gender in hapmap dataset and compare with heterozygosity
### @author:Chen Yu Chi

import os,sys
import re
import pandas as pd
import numpy as np

dir_work = '/work/myucchen/hapmap/hm.01.02/'
header_hm = 'HapMapMajor' # hapmap b file header
header_out = 'chr_z' # output file header

# calculate z chromosome heterozygosity
os.chdir(dir_work)
os.system('plink --bfile ' + header_hm + ' --chr-set 36 --not-chr 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18,19,20,21,22,23,24,26,27,28,30,31,32,33,34,35 --geno 0.8 --maf 0.01 --out ' + header_out  + ' --het')
    # --het: observed and expected homozygous/heterozygous genotype counts for each sample, and reports method-of-moments F coefficient estimates (i.e. (1 - (<observed het. count> / <expected het. count>)))
    # --geno: Filter out variants with many missing calls.
    # --maf: Filter out all variants with minor allele frequency below the provided threshold (default 0.01),
    # --rel-cutoff: excludes one member of each pair of samples with observed genomic relatedness greater than the given cutoff value (default 0.025) from the analysis
df_het = pd.read_csv(header_out + '.het', sep = '\s+', header = 0, dtype = str)

# geneder record
df_fam = pd.read_csv(header_hm + '.fam', sep = r'\s+', names = ['FID', 'IID', 'FIid', 'MIid', 'sex', 'pheno'])
    # https://www.cog-genomics.org/plink/1.9/formats 
    # Family ID ('FID')
    # Within-family ID ('IID'; cannot be '0')
    # Within-family ID of father ('0' if father isn't in dataset)
    # Within-family ID of mother ('0' if mother isn't in dataset)
    # Sex code ('1' = male, '2' = female, '0' = unknown)
    # Phenotype value ('1' = control, '2' = case, '-9'/'0'/non-numeric = missing data if case/control)

df_sex = pd.merge(df_het, df_fam, on = ["FID", "IID"], how = "outer")
df_sex = df_sex.drop(['FIid', 'MIid', 'pheno'], axis=1)

df_sex.to_csv(dir_work + 'sexChk.lst', sep = '\t', index = None) # save intermediate file

# assigned new gender info based on z chromosome heterozygosity
df_sex['F'] = pd.to_numeric(df_sex['F'], errors='coerce')
df_sex['sex_het'] = np.where(df_sex['F'] <= 0.2, 1, np.where(df_sex['F'] >= 0.8, 2, 0))
# df_sex.to_csv(dir_work + 'sexChk.1.lst', sep = '\t', index = None) # save intermediate file

df_fam = pd.merge(df_fam, df_sex[["FID", "IID", "sex_het"]], on = ["FID", "IID"], how = "left")
df_fam['sex'] = df_fam['sex_het']
df_fam = df_fam.drop('sex_het', axis=1)
df_fam.to_csv(header_hm + '.fam', sep = ' ', index = None, header = None)

## methods from plink
"""
file_sexChk = 'z.pruned.sexcheck'
#header_hm = 'HapMapMajor'
header_hm = 'HapMapMajorPruned'

df_fam = pd.read_csv(header_hm + '.fam', sep = r'\s+', names = ['FID', 'IID', 'FIid', 'MIid', 'sex', 'pheno'], dtype = str)
df_sexChk = pd.read_csv(file_sexChk, sep = r'\s+', header = 0, dtype = str)
df_fam = pd.merge(df_fam, df_sexChk[["FID", "IID", "SNPSEX"]], on = ["FID", "IID"], how = "outer")
df_fam['sex'] = df_fam['SNPSEX']
df_fam = df_fam.drop('SNPSEX', axis=1)
df_fam.to_csv(header_hm + '.fam', sep = ' ', index = None, header = None)
"""