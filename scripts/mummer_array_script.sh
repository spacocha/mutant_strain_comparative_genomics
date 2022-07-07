#!/bin/bash -l

#SBATCH
#SBATCH --job-name=genomes
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1

#submit as an array with the number of lines of forward or reverse file

module load mummer/4.0.0

#choose the fastq file to work on
OUTPUT=`awk "NR==$SLURM_ARRAY_TASK_ID" output`
REF_DB="./reference/LAS.fasta"

#This assumes they are zipped but you provide the unzipped name

nucmer -p LAS_${OUTPUT}_fixed_nucmer ${REF_DB} ${OUTPUT}.fixed.fasta
dnadiff -d LAS_${OUTPUT}_fixed_nucmer.delta -p LAS_${OUTPUT}_fixed_nucmer.dnadiff

echo "Complete: bowtie2 task $SLURM_ARRAY_TASK_ID"
date

