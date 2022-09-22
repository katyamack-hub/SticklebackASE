#!/bin/bash
##RNAseq and PAXB parent GVCFs combined and filtered
##Requires GATK and chr file (contains list of chromosomes)

cat chrs.txt | while read chr
do
echo "
gatk CombineGVCFs \
-R /scratch/users/katlmack/stickleback_genome/stickleback_v4_assembly.fa --variant ind1.${chr}.gvcf.vcf.gz --variant ind2.${chr}.gvcf.vcf.gz --variant ind3.${chr}.gvcf.vcf.gz --variant ind4.${chr}.gvcf.vcf.gz --variant ind5.${chr}.gvcf.vcf.gz --variant ind6.${chr}.gvcf.vcf.gz --variant ind7.${chr}.gvcf.vcf.gz --variant ind8.${chr}.gvcf.vcf.gz --variant /scratch/users/katlmack/stickleback_parent/version4/18146D-51-01_S76.sort.readgrps.vcf.gz -O genotypeRNAseq.Parent.${chr}.3.vcf.gz
 
gatk --java-options \"-Xmx4g\" GenotypeGVCFs -R /scratch/users/katlmack/stickleback_genome/stickleback_v4_assembly.fa -V genotypeRNAseq.Parent.${chr}.3.vcf.gz -O genotypeRNAseq.Parent.${chr}.genotyped.3.vcf.gz
 
gatk SelectVariants --reference /scratch/users/katlmack/stickleback_genome/stickleback_v4_assembly.fa  --variant genotypeRNAseq.Parent.${chr}.genotyped.3.vcf.gz --select-type-to-include SNP --output genotypeRNAseq.Parent.${chr}.genotyped.SNP.3.vcf.gz
gatk VariantFiltration --reference /scratch/users/katlmack/stickleback_genome/stickleback_v4_assembly.fa  --variant genotypeRNAseq.Parent.${chr}.genotyped.SNP.3.vcf.gz --filter-expression \"QD < 2.0 || FS > 60.0\" --filter-name \"SNPFilter\" --output genotypeRNAseq.Parent.${chr}.genotyped.SNP.filter.3.vcf.gz
" > GenotypeCaller.${chr}.sh
done

cat chrs.txt | while read chr
do
sh GenotypeCaller.${chr}.sh
done
