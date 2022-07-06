#!/bin/bash -l

#SBATCH

#SBATCH --job-name=Blastdb
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1

module load blast/2.13.0

makeblastdb -dbtype nucl -in ./reference_genome/GCF_000017985.1_ASM1798v1_genomic.fna

