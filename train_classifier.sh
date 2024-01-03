#!/bin/bash
#SBATCH --job-name=Train_classifier
#SBATCH --ntasks 1 
#SBATCH --mem=48G 
#SBATCH --output=stdout_trainingClassifier.Log
#SBATCH --cpus-per-task 8

# Setting the working directory 
cd /home/scarpettad

# Setting the path to the singularity container
sing_container=/home/scarpettad/amplicon_2023.9.sif

# Specify silva 138 SSURefNR99 taxonomy data
silva_seqs=/home/scarpettad/second_run/training_feature_classifier/silva-138-99-seqs.qza
silva_tax=/home/scarpettad/second_run/training_feature_classifier/silva-138-99-tax.qza

# Setting the output directory
output_dir=/home/scarpettad/second_run/training_feature_classifier

# Train the classifier:

singularity run $sing_container qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads $output_dir/ref-seqs.qza \
  --i-reference-taxonomy $silva_tax \
  --o-classifier $output_dir/classifier.qza
