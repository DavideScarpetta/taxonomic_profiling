#!/bin/bash
#SBATCH --job-name=AlphaDiversity
#SBATCH --ntasks 1 
#SBATCH --mem=48G 
#SBATCH --output=stdout_alphaDiversity.Log
#SBATCH --cpus-per-task 8

# Setting the working directory 
cd /home/scarpettad

# Activating qiime2 conda environment
source activate /home/scarpettad/.conda/envs/qiime2-dev

# Setting the metadata variable
metadata=/home/scarpettad/metadata_secondrun.tsv

# Qiime alpha group significance
qiime diversity alpha-group-significance \
  --i-alpha-diversity /home/scarpettad/core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file $metadata \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity /home/scarpettad/core-metrics-results/evenness_vector.qza \
  --m-metadata-file $metadata \
  --o-visualization /home/scarpettad/core-metrics-results/evenness-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity /home/scarpettad/core-metrics-results/chao1.qza \
  --m-metadata-file $metadata \
  --o-visualization core-metrics-results/chao1-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity /home/scarpettad/core-metrics-results/simpson.qza \
  --m-metadata-file $metadata \
  --o-visualization core-metrics-results/simpson-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity /home/scarpettad/core-metrics-results/gini_index.qza \
  --m-metadata-file $metadata \
  --o-visualization core-metrics-results/gini_index-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity /home/scarpettad/core-metrics-results/ace.qza \
  --m-metadata-file $metadata \
  --o-visualization core-metrics-results/ace-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity /home/scarpettad/core-metrics-results/goods_coverage.qza \
  --m-metadata-file $metadata \
  --o-visualization core-metrics-results/goods_coverage-group-significance.qzv

# Deactivating conda environment
source deactivate
