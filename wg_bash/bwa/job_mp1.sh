#!/bin/bash
export PATH=/home/myucchen/miniconda3/bin:$PATH
mkdir -p /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/
cd /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/
mkdir -p /scratch/${USER}/${SLURM_JOBID}
source activate gatk
gatk --java-options "-Xmx40G -Xms40G -Djava.io.tmpdir=/scratch/${USER}/${SLURM_JOBID}" FastqToSam --FASTQ /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/trim/trim_SRR2961754_1P.fq.gz --FASTQ2 /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/trim/trim_SRR2961754_2P.fq.gz --OUTPUT /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/trim_SRR2961754.fq2sam.bam --READ_GROUP_NAME gb004 --SAMPLE_NAME SRR2961754 --LIBRARY_NAME SRR2961754 --PLATFORM ILLUMINA --PREDICTED_INSERT_SIZE 100 --SORT_ORDER queryname > /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_rg.log 2>&1 
gatk --java-options "-Xmx40G -Xms40G -Djava.io.tmpdir=/scratch/${USER}/${SLURM_JOBID}" MarkIlluminaAdapters --INPUT /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/trim_SRR2961754.fq2sam.bam --OUTPUT /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_nwxt.bam --METRICS /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_nwxt_metrics.txt >> /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_rg.log 2>&1 
gatk --java-options "-Xmx40G -Xms40G -Djava.io.tmpdir=/scratch/${USER}/${SLURM_JOBID}" SamToFastq --INPUT /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_nwxt.bam --FASTQ /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_sam2fq.fastq --CLIPPING_ATTRIBUTE XT --CLIPPING_ACTION 2 --INTERLEAVE true --INCLUDE_NON_PF_READS true >> /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_rg.log 2>&1 
rm /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_nwxt.bam
/work/myucchen/software/bwa-mem2-2.2.1_x64-linux/bwa-mem2.sse41 mem -t 1 -p /work/myucchen/ParusMA/pma.01.03/ref/GCF_001522545.3_Parus_major1.1_genomic.fna /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_sam2fq.fastq -o /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754.sam > /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_bwa.log 2>&1 
rm /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_sam2fq.fastq
source activate samtools
samtools sort -@ 1 -o /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_alned.bam /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754.sam 
rm /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754.sam
source activate gatk
gatk --java-options "-Xmx40G -Xms40G -Djava.io.tmpdir=/scratch/${USER}/${SLURM_JOBID}" MergeBamAlignment --REFERENCE_SEQUENCE /work/myucchen/ParusMA/pma.01.03/ref/GCF_001522545.3_Parus_major1.1_genomic.fna --UNMAPPED_BAM /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/trim_SRR2961754.fq2sam.bam --ALIGNED_BAM /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_alned.bam --OUTPUT /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_merged.bam --CREATE_INDEX false --ADD_MATE_CIGAR true --CLIP_ADAPTERS false --CLIP_OVERLAPPING_READS true --INCLUDE_SECONDARY_ALIGNMENTS true --MAX_INSERTIONS_OR_DELETIONS -1 --PRIMARY_ALIGNMENT_STRATEGY MostDistant --ATTRIBUTES_TO_RETAIN XS > /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_merge.log 2>&1
rm /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/trim_SRR2961754.fq2sam.bam /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_alned.bam
source activate samtools
samtools sort -@ 1 -n /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_merged.bam -o /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_merged_sorted.bam
rm /work/myucchen/ParusMA/pma.01.03/fastq/SRR2961754/SRR2961754_merged.bam
