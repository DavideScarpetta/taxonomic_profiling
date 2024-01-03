#!/bin/bash
#SBATCH --job-name=DADA2_denoise
#SBATCH --ntasks 1 
#SBATCH --mem=16G 
#SBATCH --output=stdout_denoiseDADA2.Log
#SBATCH --cpus-per-task 8

# Setting the working directory 
cd /home/scarpettad

# Setting the path to the singularity container
sing_container=/home/scarpettad/amplicon_2023.9.sif

# Setting the qiime2 artifact to work on 
qiime_artifact=/home/scarpettad/second_run/qiime_artifacts/paired_end.qza

# Setting the output directory to store denoised artifacts
output_dir=/home/scarpettad/second_run/denoise_dada2

# Run DADA2 denoising
singularity run ${sing_container} qiime dada2 denoise-paired --i-demultiplexed-seqs ${qiime_artifact} --p-n-threads 8 --p-trim-left-f 0 --p-trim-left-r 0 --p-trunc-len-f 0 --p-trunc-len-r 0 --p-max-ee-f 2.0 --p-max-ee-r 2.0 --o-representative-sequences ${output_dir}/rep-seqs-dada2.qza --o-table ${output_dir}/table-dada2.qza --o-denoising-stats ${output_dir}/denoising-stats-dada2.qza
