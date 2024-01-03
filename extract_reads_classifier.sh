#!/bin/bash
#SBATCH --job-name=extract_reads_silva
#SBATCH --ntasks 1 
#SBATCH --mem=16G 
#SBATCH --output=stdout_extractReadsSilva.Log
#SBATCH --cpus-per-task 8

# Setting the working directory 
cd /home/scarpettad

# Setting the path to the singularity container
sing_container=/home/scarpettad/amplicon_2023.9.sif

# Specify silva 138 SSURefNR99 taxonomy data
silva_seqs=/home/scarpettad/second_run/training_feature_classifier/silva-138-99-seqs.qza
silva_tax=/home/scarpettad/second_run/training_feature_classifier/silva-138-99-tax.qza

# Setting our input (the rep seqs extracted using DADA2)
rep_seqs=/home/scarpettad/second_run/denoise_dada2/rep-seqs-dada2.qza

# Setting the output directory
output_dir=/home/scarpettad/second_run/training_feature_classifier

# Extract the reference reads selecting the regions with primers: parameters will be adjusted based on reads characteristics. 
# IT IS SUGGESTED HERE: https://github.com/qiime2/docs/blob/master/source/tutorials/feature-classifier.rst

singularity run $sing_container qiime feature-classifier extract-reads \
  --i-sequences $silva_seqs \
  --p-f-primer "CCTACGGGNGGCWGCAG" \
  --p-r-primer "GACTACHVGGGTATCTAATCC" \
  --o-reads $output_dir/ref-seqs.qza

