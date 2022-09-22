#!/bin/bash
##Implements method in Pirinen et al. 2014 to partition ASE genes into groups
##Requires code from Pirinen et al. 2014: https://www.mv.helsinki.fi/home/mjxpirin/download.html

echo "source(\"stickleback_bayestest/ASE_29Dec2014.R\")
df <- data.frame(matrix(ncol = 6, nrow = 0))
##datafile, low tissues removed and set to zero
j <- read.csv(\"all_tissues_merged.txt\",header=FALSE,sep=\" \")

pr.beta=c(2000,2000,80,36,80,7)
" > ASEhet_run.R

#List of genes to be analyzed
cat ${list} | while read gene
do
echo "
g <- j[j\$V1 == '${gene}',]
y=matrix(as.double(g[,c(2:15)]),ncol=2,byrow=TRUE)
res_${gene}=gtm(y=y,pr.beta,niter=2000,burnin=10,two.sided=TRUE,independent=TRUE,model.strong.ase=TRUE,pr.dist=NULL)
t2<-t(res_${gene}\$top.het.model)

write.csv(res_${gene}\$state.posteriors,\"TIME2_only/${gene}.statepos.out\")
write.csv(res_${gene}\$indiv.posteriors,\"TIME2_only/${gene}.ind.postiors.out\")
write.csv(t2,\"TIME2_only/${gene}.hetmodels.out\")
" >> ASEhet_run.R
done


R CMD BATCH ASEhet_run.R
