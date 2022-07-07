#!/bin/bash -l

#SBATCH

#SBATCH --job-name=Blastdb
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1

module load blast/2.13.0
module load samtools/1.15.1

makeblastdb -dbtype nucl -in ./reference_genome/GCF_000017985.1_ASM1798v1_genomic.fna

blastn -query ./reference_genome/LAS.fasta -db ./reference_genome/GCF_000017985.1_ASM1798v1_genomic.fna -out ./reference_genome/LAS.blast.txt -outfmt 6

samtools faidx ./reference_genome/LAS.fasta -i -o ./reference_genome/LAS.RC.fasta ctg.s1.000000F\|arrow
blastn -query ./reference_genome/LAS.RC.fasta -db ./reference_genome/GCF_000017985.1_ASM1798v1_genomic.fna -out ./reference_genome/LAS.RC.blast.txt -outfmt 6

perl ./scripts/fix_circular_fasta_wblast.pl ./reference_genome/LAS.fasta ./reference_genome/LAS.RC.fasta ./reference_genome/LAS.blast.txt ./reference_genome/LAS.RC.blast.txt ./gff_files/LAS_with_locustags.gff3 4611842 ./reference_genome/LAS.fixed

blastn -query ./reference_genome/LAS.fixed.fasta -db ./reference_genome/GCF_000017985.1_ASM1798v1_genomic.fna -out ./reference_genome/LAS.fixed.blast.txt -outfmt 6

makeblastdb -dbtype nucl -in ./reference_genome/LAS.fixed.fasta
