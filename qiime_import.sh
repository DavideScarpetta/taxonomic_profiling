#!/bin/bash
#SBATCH --job-name=Qiime_Import
#SBATCH --ntasks 1 
#SBATCH --mem=16G 
#SBATCH --output=stdout_qiiimeimport.Log

# Setting the working directory 
cd /home/scarpettad

# Setting the path to the singularity container
sing_container=/home/scarpettad/amplicon_2023.9.sif

# Setting the output directory to store qiime2 artifacts
output_dir=/home/scarpettad/second_run/qiime_artifacts/

# Setting the name for qiime2 artifact
artifact_name=paired_end.qza

# Setting the type of data
data_type=SampleData[PairedEndSequencesWithQuality]

# Setting the path to the manifest file
manifest_file=/home/scarpettad/pe-33p-manifest

# Import the paired-end fastq files into QIIME 2
singularity run ${sing_container} qiime tools import \
  --type $data_type \
  --input-path $manifest_file \
  --output-path $output_dir/$artifact_name \
  --input-format PairedEndFastqManifestPhred33V2

# Seq quality control
singularity run ${sing_container} qiime demux summarize \
  --i-data $output_dir/$artifact_name \
  --o-visualization $output_dir/paired_end.qzv
