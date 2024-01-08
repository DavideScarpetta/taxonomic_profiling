#!/bin/bash
#SBATCH --job-name=AlphaMetrics
#SBATCH --ntasks 1 
#SBATCH --mem=48G 
#SBATCH --output=stdout_alphaMetrics.Log
#SBATCH --cpus-per-task 8

# Setting the working directory 
cd /home/scarpettad

# Activating qiime2 conda environment
source activate /home/scarpettad/.conda/envs/qiime2-dev

# Setting the metadata variable
metadata=/home/scarpettad/metadata_secondrun.tsv

# Setting the table variable
table_qza=/home/scarpettad/second_run/qiime2_taxonomy_output/filtered-table.qza

# Additional alpha diversity metrics not contained in core-metrics

# Export of chao1
qiime diversity alpha \
  --i-table $table_qza \
  --p-metric chao1 \
  --o-alpha-diversity core-metrics-results/chao1.qza

# Export of Simpson
qiime diversity alpha \
  --i-table $table_qza \
  --p-metric simpson \
  --o-alpha-diversity core-metrics-results/simpson.qza

# Export of Gini index
qiime diversity alpha \
  --i-table $table_qza \
  --p-metric gini_index \
  --o-alpha-diversity core-metrics-results/gini_index.qza

# Export of ACE
qiime diversity alpha \
  --i-table $table_qza \
  --p-metric ace \
  --o-alpha-diversity core-metrics-results/ace.qza

# Export of Goods coverage
qiime diversity alpha \
  --i-table $table_qza \
  --p-metric goods_coverage \
  --o-alpha-diversity core-metrics-results/goods_coverage.qza

# Deactivate conda environment
source deactivate 

