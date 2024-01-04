#!/bin/bash
#SBATCH --job-name=CoreMetrics
#SBATCH --ntasks 1 
#SBATCH --mem=48G 
#SBATCH --output=stdout_coreMetrics.Log
#SBATCH --cpus-per-task 8

# Setting the working directory 
cd /home/scarpettad

# Setting the path to the singularity container
sing_container=/home/scarpettad/amplicon_2023.9.sif

# Setting the output directory
output_dir=/home/scarpettad/second_run/diversity_analysis/core_metrics_results

# Setting the rooted tree variable
rooted_tree=/home/scarpettad/second_run/tree/rooted-tree.qza

# Setting the feature table 
table_qza=/home/scarpettad/second_run/qiime2_taxonomy_output/filtered-table.qza

# Setting the metadata file
metadata=/home/scarpettad/metadata_secondrun.tsv

# Run qiime diversity core metrics, sampling depth choose at the minimum number of reads in my samples
singularity run $sing_container qiime diversity core-metrics-phylogenetic \
  --i-phylogeny $rooted_tree \
  --i-table $table_qza \
  --p-sampling-depth 9151 \
  --m-metadata-file $metadata \
  --output-dir core-metrics-results

