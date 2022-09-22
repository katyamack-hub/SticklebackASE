#!/bin/bash
##GATK HaplotypeCaller on RNAseq reads
##Produces GVCFs

cat chrs.txt | while read chr
do
echo "
gatk HaplotypeCaller -R /scratch/users/katlmack/stickleback_genome/stickleback_v4_assembly.fa -I 18146FL-37-01-04_S77.merge.sort.markdup.rehead.2.${chr}.bam -I 18146FL-37-01-16_S89.merge.sort.markdup.rehead.2.${chr}.bam -ERC GVCF -O /scratch/users/katlmack/stickleback_raw/18146-37mapped_v4/samtools_split/ind8.${chr}.gvcf.vcf.gz
gatk HaplotypeCaller -R /scratch/users/katlmack/stickleback_genome/stickleback_v4_assembly.fa -I 18146FL-37-01-03_S76.merge.sort.markdup.rehead.2.${chr}.bam -I 18146FL-37-01-15_S88.merge.sort.markdup.rehead.2.${chr}.bam -ERC GVCF -O /scratch/users/katlmack/stickleback_raw/18146-37mapped_v4/samtools_split/ind7.${chr}.gvcf.vcf.gz
gatk HaplotypeCaller -R /scratch/users/katlmack/stickleback_genome/stickleback_v4_assembly.fa -I 18146FL-37-01-02_S75.merge.sort.markdup.rehead.2.${chr}.bam -I 18146FL-37-01-08_S81.merge.sort.markdup.rehead.2.${chr}.bam -I 18146FL-37-01-10_S83.merge.sort.markdup.rehead.2.${chr}.bam -I 18146FL-37-01-12_S85.merge.sort.markdup.rehead.2.${chr}.bam -I 18146FL-37-01-20_S93.merge.sort.markdup.rehead.2.${chr}.bam -ERC GVCF -O /scratch/users/katlmack/stickleback_raw/18146-37mapped_v4/samtools_split/ind6.${chr}.gvcf.vcf.gz
gatk HaplotypeCaller -R /scratch/users/katlmack/stickleback_genome/stickleback_v4_assembly.fa -I 18146FL-37-01-01_S74.merge.sort.markdup.rehead.2.${chr}.bam -I 18146FL-37-01-07_S80.merge.sort.markdup.rehead.2.${chr}.bam -I 18146FL-37-01-09_S82.merge.sort.markdup.rehead.2.${chr}.bam -I 18146FL-37-01-11_S84.merge.sort.markdup.rehead.2.${chr}.bam -I 18146FL-37-01-19_S92.merge.sort.markdup.rehead.2.${chr}.bam -ERC GVCF -O /scratch/users/katlmack/stickleback_raw/18146-37mapped_v4/samtools_split/ind5.${chr}.gvcf.vcf.gz
gatk HaplotypeCaller -R /scratch/users/katlmack/stickleback_genome/stickleback_v4_assembly.fa -I 18146FL-37-01-17_S90.merge.sort.markdup.rehead.2.${chr}.bam -ERC GVCF -O /scratch/users/katlmack/stickleback_raw/18146-37mapped_v4/samtools_split/ind4.${chr}.gvcf.vcf.gz
gatk HaplotypeCaller -R /scratch/users/katlmack/stickleback_genome/stickleback_v4_assembly.fa -I 18146FL-37-01-18_S91.merge.sort.markdup.rehead.2.${chr}.bam -ERC GVCF -O /scratch/users/katlmack/stickleback_raw/18146-37mapped_v4/samtools_split/ind3.${chr}.gvcf.vcf.gz
gatk HaplotypeCaller -R /scratch/users/katlmack/stickleback_genome/stickleback_v4_assembly.fa -I 18146FL-37-01-06_S79.merge.sort.markdup.rehead.2.${chr}.bam -I 18146FL-37-01-14_S87.merge.sort.markdup.rehead.2.${chr}.bam -ERC GVCF -O /scratch/users/katlmack/stickleback_raw/18146-37mapped_v4/samtools_split/ind2.${chr}.gvcf.vcf.gz
gatk HaplotypeCaller -R /scratch/users/katlmack/stickleback_genome/stickleback_v4_assembly.fa -I 18146FL-37-01-05_S78.merge.sort.markdup.rehead.2.${chr}.bam -I 18146FL-37-01-13_S86.merge.sort.markdup.rehead.2.${chr}.bam -ERC GVCF -O /scratch/users/katlmack/stickleback_raw/18146-37mapped_v4/samtools_split/ind1.${chr}.gvcf.vcf.gz
" > PrepareHaplotypeCallerCommands.sh
done