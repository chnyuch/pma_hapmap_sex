# pma_hapmap_sex

## sex check
script: hapmap_sex.01.py

plot: hapmap_sex.01.R

## Female and male comparison in the same population
script: hapmap_Fst.04.py

plot: hapmap_Fst.07.R

## Testing different sex ration in uk and fn population
script: hapmap_Fst.06.py

plot: hapmap_Fst.08.R

## Female and male comparison for 6 focal population
script: hapmap_Fst.07.py

plot: hapmap_Fst.09.R

## Whole genome analysis scripts
SRR2fastq QC: wg_bash/qc_trim

bwa mapping: wg_bash/bwa/mkdp

markduplicate: wg_bash/gatk/
