#!/usr/bin/env bash

ACCS=$1 # File with accession numbers one per line
API_key=$2 # NCBI api key

echo "Downloading genomes"
# Download *.fasta's
cat $1 | xargs -n 1 -P 8 -I {} ncbi-acc-download --format fasta --api-key $2 {} && \
	mkdir -p genomes_fna && mv *.fa genomes_fna ;

echo "Annotating genomes"
# Annotate with prokka
mkdir -p logs && \
	find genomes_fna/*.fa | \
	sed -e 's/.fa$//' -e 's/genomes_fna\///' | \
	parallel -j 5 'prokka --cpus 2 --outdir prokka_results/{} \
	--compliant --usegenus --genus Caudovirales --prefix {} \
	--locustag {} genomes_fna/{}.fa 2> logs/{}.prokka.log' ;

# Copy *.gff's
mkdir -p genomes_gff && find prokka_results -type f -name "*.gff" -exec cp {} genomes_gff \;

echo "Constructing pangenome"
# Create pangenome with PIRATE
PIRATE -i genomes_gff -o pirate_results -s "30,40,50,60,70,80,90,95" \
	-k "--hsp-len 0.5" --para-off -a -r -t 10 2> logs/pirate.log;

# Create 'gene_presence_absence.csv' and 'PIRATE.gene_families.ordered.renamed.tsv'
cd pirate_results && \
	PIRATE_to_roary.pl -i *.tsv -o gene_presence_absence.csv && \
	subsample_outputs.pl -i PIRATE.gene_families.tsv -g modified_gffs \
	-o PIRATE.gene_families.ordered.renamed.tsv --field "prev_locus" && \
	cd ../
