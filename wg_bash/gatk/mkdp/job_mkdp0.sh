#!/bin/bash
export PATH=/home/myucchen/miniconda3/bin:$PATH
source activate gatk
cd /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753
mkdir -p /scratch/${USER}/${SLURM_JOBID}
gatk --java-options "-Xmx32G -Xms32G -Djava.io.tmpdir=/scratch/${USER}/${SLURM_JOBID}" MarkDuplicatesSpark -I /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/SRR2961753_merged_sorted.bam -I /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961754/SRR2961754_merged_sorted.bam  -M /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/SRR2961753_dedup_metrics.txt -O /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/SRR2961753_sorted_dedup.bam --tmp-dir /scratch/${USER}/${SLURM_JOBID} > /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/SRR2961753_mrkdup.log 2>&1
picard CollectAlignmentSummaryMetrics -R /work/myucchen/nanoBird/nano.02.01/ref/ONT-DarkMatterPrelim.merged-sort.contigs.fasta -I /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/SRR2961753_sorted_dedup.bam -O /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/SRR2961753_alignment_metrics.txt > /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/SRR2961753_colmx.log 2>&1
picard CollectInsertSizeMetrics -INPUT /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/SRR2961753_sorted_dedup.bam -OUTPUT /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/SRR2961753_insert_metrics.txt --Histogram_FILE /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/SRR2961753_insert_size_histogram.pdf >> /work/myucchen/ParusMA/pma.01.03/ready_reads/SRR2961753/SRR2961753_colmx.log 2>&1
source activate samtools
