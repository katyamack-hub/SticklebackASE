#!/bin/bash
##Prepare files that map RNAseq reads with WASP for allele-specific expression
##Requires STAR, samtools, HTseq-count, GATK
##Requires phased VCF file

cat filenames.txt | while read -r line
do
echo "
##Map RNAseq reads with STAR and WASP filter
##Include list of variant positions phased for WASP filtering
STAR --runMode alignReads --runThreadN 16 --genomeDir genome_index_STAR --readFilesIn ${line}_R1.trim.fastq ${line}_R2.trim.fastq --outSAMtype BAM SortedByCoordinate --waspOutputMode SAMtag --outSAMattributes NH HI AS nM NM MD vA vG vW --varVCFfile stickleback_filteredhetcalls.vcf --outFilterMultimapNmax 1 --outFilterMismatchNmax 3 --outFileNamePrefix ${line}.STAR_ASE
samtools view -h -o ${line}.STAR_ASEAligned.sortedByCoord.out.sam  ${line}.STAR_ASEAligned.sortedByCoord.out.bam 

#pull out reads based of WASP flags
grep \"vW:i:1\" ${line}.STAR_ASEAligned.sortedByCoord.out.sam > ${line}.STAR_ASEAligned.sortedByCoord.out.filter.sam
grep \"vW:i:1\" ${line}.STAR_ASEAligned.sortedByCoord.out.sam | grep \"vA:B:c,1\"  |awk -F' ' '{if(\$18 ~ /2/){}else{print}}' > ${line}.geno1.sam
grep \"vW:i:1\" ${line}.STAR_ASEAligned.sortedByCoord.out.sam | grep \"vA:B:c,2\"  | awk -F' ' '{if(\$18 ~ /1/){}else{print}}' > ${line}.geno2.sam

grep \"@\" ${line}.geno2.sam > ${line}.head.sam

cat ${line}.head.sam ${line}.geno1.sam > ${line}.geno1.withhead.sam
cat ${line}.head.sam ${line}.geno2.sam > ${line}.geno2.withhead.sam
cat ${line}.head.sam ${line}.STAR_ASEAligned.sortedByCoord.out.filter.sam > ${line}.bothwhead.sam

samtools view -S -b ${line}.geno1.withhead.sam > ${line}.geno1.withhead.bam
samtools view -S -b ${line}.geno2.withhead.sam > ${line}.geno2.withhead.bam
samtools view -S -b ${line}.bothwhead.sam > ${line}.bothwhead.bam

samtools sort ${line}.geno1.withhead.bam -o ${line}.geno1.withhead.sorted.bam
samtools sort ${line}.geno2.withhead.bam -o ${line}.geno2.withhead.sorted.bam
samtools sort ${line}.bothwhead.bam -o ${line}.bothwhead.sorted.bam

##Produce count files (HTseq)
python -m HTSeq.scripts.count -f bam -s no -r pos ${line}.geno1.withhead.sorted.bam stickleback_v4_ensembl_lifted.gtf >  ${line}.geno1.withhead.sorted.counts
python -m HTSeq.scripts.count -f bam -s no -r pos ${line}.geno2.withhead.sorted.bam stickleback_v4_ensembl_lifted.gtf >  ${line}.geno2.withhead.sorted.counts


java -jar picard-2.20.7/picard.jar AddOrReplaceReadGroups I=${line}.geno1.withhead.sorted.bam O=${line}.geno1.withhead.plusreads.sorted.withgroup.bam RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=${line}_geno1

java -jar picard-2.20.7/picard.jar AddOrReplaceReadGroups I=${line}.geno2.withhead.sorted.bam O=${line}.geno2.withhead.plusreads.sorted.withgroup.bam RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=${line}_geno2

java -jar picard-2.20.7/picard.jar AddOrReplaceReadGroups I=${line}.bothwhead.sorted.bam O=${line}.bothwhead.withgroup.bam RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=${line}_both

##Produce count tables per SNP (GATK)
gatk ASEReadCounter -I ${line}.bothwhead.sorted.bam O=${line}.bothwhead.withgroup.bam -R stickleback_v4_assembly.fa -V stickleback_filteredhetcalls.vcf.gz -O ${line}.bothgeno.table

gatk ASEReadCounter -I ${line}.geno1.withhead.plusreads.sorted.withgroup.bam -R stickleback_v4_assembly.fa -V stickleback_filteredhetcalls.vcf.gz -O ${line}.geno1.table

gatk ASEReadCounter -I ${line}.geno1.withhead.plusreads.sorted.withgroup.bam -R stickleback_v4_assembly.fa -V stickleback_filteredhetcalls.vcf.gz -O ${line}.geno2.table

gatk ASEReadCounter -I ${line}.bothwhead.sorted.bam -R stickleback_v4_assembly.fa -V stickleback_filteredhetcalls.vcf.gz -O ${line}.both_alleles.table

"
done
