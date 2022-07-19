#!/usr/bin/env bash

seqkit fx2tab --length --name -i all_genomes.fa > lengths.txt ;
gsed -i '1i id\tlength' lengths.txt
