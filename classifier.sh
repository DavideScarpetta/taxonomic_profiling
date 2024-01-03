#!/bin/bash
#SBATCH --job-name=apply_classifier
#SBATCH --ntasks 1 
#SBATCH --mem=48G 
#SBATCH --output=stdout_applyClassifier.Log
#SBATCH --cpus-per-task 8

# Setting the working directory 
cd /home/scarpettad

# Setting the path to the singularity container
sing_container=/home/scarpettad/amplicon_2023.9.sif

# Setting our input (the rep seqs extracted using DADA2)
rep_seqs=/home/scarpettad/second_run/denoise_dada2/rep-seqs-dada2.qza

# Setting the output directory
output_dir=/home/scarpettad/second_run/training_feature_classifier

# Apply the model trained in train_classifier.sh script and visualize taxonomic assignments:

singularity run $sing_container qiime feature-classifier classify-sklearn \
  --i-classifier $output_dir/classifier.qza \
  --i-reads $rep_seqs \
  --p-n-jobs 4 \
  --o-classification $output_dir/classified-rep-seqs.qza


singularity run $sing_container qiime metadata tabulate \
  --m-input-file $output_dir/classified-rep-seqs.qza \
  --o-visualization $output_dir/classified-rep-seqs.qzv
