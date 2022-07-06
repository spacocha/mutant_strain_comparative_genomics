#!/bin/bash -l

#SBATCH
#SBATCH --job-name=genomes
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4

#submit as an array with the number of lines of forward or reverse file

module load samtools/1.15.1
module load blast/2.13.0

#choose the fastq file to work on
FWD_FQ=`awk "NR==$SLURM_ARRAY_TASK_ID" ./config_files/fasta_list`
OUTPUT=`awk "NR==$SLURM_ARRAY_TASK_ID" ./config_files/output`
REF_DB="./reference_genome/GCF_000017985.1_ASM1798v1_genomic.fna"
CONTIG=`awk "NR==$SLURM_ARRAY_TASK_ID" ./config_files/contig_list`
GLEN=`awk "NR==$SLURM_ARRAY_TASK_ID" ./config_files/glen_list`
GFF=`awk "NR==$SLURM_ARRAY_TASK_ID" ./config_files/gff_list`

FADIR="./fasta_files"
RESDIR="./results"
GFFDIR="./gff_files"

#This assumes they are zipped but you provide the unzipped name

echo "BLAST against reference"
date

#forward blast
blastn -query ${FADIR}/${FWD_FQ} -db $REF_DB -out ${RESDIR}/${OUTPUT}.blast.txt -outfmt 6

echo "Reverse complement and blast ref"
samtools faidx ${FADIR}/$FWD_FQ -i -o ${RESDIR}/${OUTPUT}.RC.fasta $CONTIG
blastn -query ${RESDIR}/${OUTPUT}.RC.fasta -db $REF_DB -out ${RESDIR}/${OUTPUT}.RC.blast.txt -outfmt 6

echo "Fix orientation with perl script"
perl ./scripts/fix_circular_fasta_wblast.pl ${FADIR}/${FWD_FQ} ${RESDIR}/${OUTPUT}.RC.fasta ${RESDIR}/${OUTPUT}.blast.txt ${RESDIR}/${OUTPUT}.RC.blast.txt ${GFFDIR}/$GFF $GLEN ${RESDIR}/${OUTPUT}.fixed

echo "Final blast"
blastn -query ${RESDIR}/${OUTPUT}.fixed.fasta -db $REF_DB -out ${RESDIR}/${OUTPUT}.fixed.blast.txt -outfmt 6

echo "Complete: bowtie2 task $SLURM_ARRAY_TASK_ID"
date

