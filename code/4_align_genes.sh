#!/usr/bin/env bash

for tsv in *.tsv ; do out=$(basename $tsv .tsv);
	# Extract genome names
	awk 'NR>1 {print $1}' $tsv > $out.genomes.txt ;
	gsed -i s/$/.ffn/ $out.genomes.txt ;
	# Extarct locus tags
	awk 'NR>1 {print $2}' $tsv > $out.locus_tags.txt ;
	# Find and copy ffn files
	find prokka_results/ -type f -print0 | grep -zFf $out.genomes.txt | xargs -0 -I {} cat {} > $out.genomes.ffn ;
	# Extract only needed genes
	seqtk subseq $out.genomes.ffn $out.locus_tags.txt > $out.ffn ;
	# align
	mafft --thread 10 --auto --reorder $out.ffn > $out.aln 2> $out.mafft.log ;
done
