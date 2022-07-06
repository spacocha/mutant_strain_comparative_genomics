#!/bin/bash -l

#SBATCH

#SBATCH --job-name=clustalw2
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8


echo "Starting clustalw"
../lib/clustalw-2.1-linux-x86_64-libcppstatic/clustalw2 -INFILE=CIA_LAS_Clustal_test.fa -ALIGN >  clustalw_output.txt

echo "done
