#!/usr/bin/env bash

for file in *.faa; do out=$(basename $file .faa);
       sed '/^>/ s/ .*//' $file > $out.renamed.faa ;
       seqkit seq $out.renamed.faa -n > $out.ids ; 
       gawk -i inplace '{print $0,"," FILENAME}' $out.ids ;
       gawk -i inplace '{print $0,"," "genbank"}' $out.ids ;
       gsed -i 's/.ids//g' $out.ids ;
       gsed -i 's/ //g' $out.ids ;
done

cat *.ids > kb_genomes_g2g.csv ;
gsed -i '1i protein_id,contig_id,keywords' kb_genomes_g2g.csv ;
cat *.renamed.faa > kb_genomes.faa ;
rm *.ids *.renamed.faa ;

vcontact2 --raw-proteins kb_genomes.faa --rel-mode 'Diamond' --proteins-fp kb_genomes_g2g.csv --db 'ProkaryoticViralRefSeq211-Merged' --pcs-mode MCL --vcs-mode ClusterONE --c1-bin cluster_one-1.0.jar --output-dir .
