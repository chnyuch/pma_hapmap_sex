#!/bin/bash
export PATH=/home/myucchen/miniconda3/bin:$PATH
source activate gatk
mkdir -p /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/qc1/
cd /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/qc1/
fastqc -o /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/qc1/ -f fastq /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961753_1.fq.gz /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961753_2.fq.gz > /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/qc1/SRR2961753.log 2>&1 
mkdir -p /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/trim/
cd /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/trim/
trimmomatic PE -threads 5 -phred33 -trimlog /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/trim/SRR2961753.txt /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961753_1.fq.gz /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961753_2.fq.gz -baseout /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/trim/trim_SRR2961753.fq.gz ILLUMINACLIP:/work/myucchen/software/Trimmomatic/adapters/TruSeq3-PE-2.fa:2:30:10:2:true LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 > /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/trim/trim_SRR2961753.log 2>&1 
rm /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961753_* /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/trim/trim_SRR2961753.txt
mkdir -p /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/qc2/
cd /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/qc2/
fastqc -o /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/qc2/ -f fastq /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/trim/trim_SRR2961753_1P.fq.gz /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/trim/trim_SRR2961753_2P.fq.gz > /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/qc2/SRR2961753.log 2>&1 
