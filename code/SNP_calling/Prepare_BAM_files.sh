#!/bin/bash
##Takes a list of bam file names (output of mapping) and prepares for SNP calling

cat bamfilenames.txt | while read -r line line2 
do
echo "
samtools sort -o ${line}_merge.sort.bam ${line}_merge.bam

picard MarkDuplicates INPUT=${line}_merge.sort.bam OUTPUT=${line}_markdups.bam METRICS_FILE=${line}_metrics.txt

picard BuildBamIndex INPUT=${line}_markdups.bam

picard AddOrReplaceReadGroups I=${line}_markdups.bam O=${line}_markdups.rehead.bam RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=${line2}

#Line below is for calls on RNAseq reads specifically, remove for genomic reads
gatk SplitNCigarReads -R stickleback_v4_assembly.fa -I ${line}_markdups.rehead.bam -O ${line}_.merge.sort.markdup.rehead.2.split.bam
" > preparebamefiles.sh
done

sh preparebamefiles.sh