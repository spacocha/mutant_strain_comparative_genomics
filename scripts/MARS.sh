#!/bin/bash -l

#SBATCH

#SBATCH --job-name=MARS
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH -A sprehei1_bigmem
#SBATCH -q qos_bigmem
#SBATCH --partition=bigmem


module load MARS

free -mh
getconf _NPROCESSORS_ONLN
mars -i mars_input_test.txt -o mars_output_test.txt -a DNA


