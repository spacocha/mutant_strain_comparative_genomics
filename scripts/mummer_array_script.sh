#!/bin/bash -l

#SBATCH
#SBATCH --job-name=genomes
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1

#submit as an array with the number of lines of forward or reverse file

module load mummer/4.0.0

#choose the fastq file to work on
OUTPUT=`awk "NR==$SLURM_ARRAY_TASK_ID" ./config_files/output`
REF_DB="./reference_genome/LAS.fixed.fasta"
REF_NAME="LAS"
RES_DIR="./results"

#This assumes they are zipped but you provide the unzipped name

#nucmer -p ${RES_DIR}/${REF_NAME}_${OUTPUT}_fixed_nucmer ${REF_DB} ${RES_DIR}/${OUTPUT}.fixed.fasta
#dnadiff -d ${RES_DIR}/${REF_NAME}_${OUTPUT}_fixed_nucmer.delta -p ${RES_DIR}/${REF_NAME}_${OUTPUT}_fixed_nucmer.dnadiff
perl scripts/pull_out_closest_gene_and_sequence.pl ${RES_DIR}/${OUTPUT}.fixed.final.gff3 ${RES_DIR}/${REF_NAME}_${OUTPUT}_fixed_nucmer.dnadiff.snps > ${RES_DIR}/${REF_NAME}_${OUTPUT}_fixed_nucmer.dnadiff.snps.genes

echo "Complete: bowtie2 task $SLURM_ARRAY_TASK_ID"
date

