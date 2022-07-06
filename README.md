# mutant_strain_comparative_genomics
Scripts to compare PacBio draft genomes of antibiotic and antiviral resistant mutant E coli strains

This pipeline was used to process draft genomes associated with the publication:
Wallace VJ, Sakowski EG, Preheim SP, Prasse C. Bacteria exposed to antiviral drugs develop antibiotic cross-resistance and unique resistance profiles.

This works on Rockfish, the JHU computing cluster using SLURM job scheduler

CONFIG FILE CREATION
Create config files for multi-process array job submission

Files in the config_files folder should guide the input and output processes for each job.
Each line of all the files should correspond to the data for the same isolate.
The job number then corresponds to the information on the line of the job number.

./config_files/fasta_list 
This file should contain the path to the fasta files associated with the draft genomes from PacBio sequencing. All are single contigs, but oriented at random different start points within the circular genome.

./config_files/contig_list
This file should contain the header name for each draft genome file. The order should correspond with the fasta_list and will be used to reverse complement fasta file with samtools.

./config_files/gff_files
This should contain the path to the gff files provided by the automated genome assignment program. The order should correspond with fasta_list and will be used to transform the gff files according to the rearranged (start shifted and potentially reverse complemented) genome order.

./config_files/glen_list
This should contain the genome length of each draft genome. The order should correspond with the fasta_list file and will be used to transform gff files that are reverse complemented.

./config_files/output
This should contain the output prefix to be used for each analysis. The order should correspond with the fasta_list and will be the path to the output files.

DATA SETUP
./fasta_files 
This folder should contain all of the fasta files to be processed. They will not be altered during processing.

./gff_files
This folder should contain all of the gff files that need to be processed. With the shift in genome position, all of the gff file coordinates need to be shifted and potentially reversed.

./results
This folder will contain any results from the analysis. It should be made before and indicated in the output file.

./scripts
This folder contains all of the scripts used to process the samples.

./reference_genome
This folder contains the reference genome

CREATE REFERENCE GENOME BLAST DATABASE

Run the following command to create blast reference database for the WT strain.
./scripts/blast_reference_setup.sh

This should result in files in reference_genome for the BLAST index.

RUN ANALYSIS ARRAY
Foreach genome in fasta_files that is listed in config_files/fasta_files, run the array for each one

sbatch -o slurm-%A_%a.out --array=1-13 ./scripts/overall_array_script.sh

UNDERSTANDING RESULTS
The results will be listed as ${OUTPUT}.fixed.fasta, ${OUTPUT}.fixed.blast.txt and ${OUTPUT}.fixed.gff3, using output names assigned in ./config_files/output

Fasta file will contain the fixed fasta files, shifted and potentially reverse complemented to align best with the reference genome.

