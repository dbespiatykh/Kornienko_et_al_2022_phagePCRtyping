#!/usr/bin/env bash

# Concatenate genomes
cat genomes_fna/*.fa > all_genomes.fa

# Build the tree
ViPTreeGen --ncpus 10 all_genomes.fa all_tree
