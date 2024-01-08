#!/bin/bash
#SBATCH --job-name=BetaDiversity
#SBATCH --ntasks 1 
#SBATCH --mem=48G 
#SBATCH --output=stdout_betaDiversity.Log
#SBATCH --cpus-per-task 8

# Setting the working directory 
cd /home/scarpettad

# Setting the path to the singularity container
sing_container=/home/scarpettad/amplicon_2023.9.sif

# Setting the metadata variable
metadata=/home/scarpettad/metadata_secondrun.tsv

# Run qiime beta group significance analysis
singularity run $sing_container qiime diversity beta-group-significance \
  --i-distance-matrix /home/scarpettad/core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file $metadata \
  --m-metadata-column Trattamento \
  --o-visualization /home/scarpettad/core-metrics-results/unweighted-unifrac-trattamento-significance.qzv \
  --p-pairwise

singularity run $sing_container qiime diversity beta-group-significance \
  --i-distance-matrix /home/scarpettad/core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file $metadata \
  --m-metadata-column Giorno_fullname \
  --o-visualization /home/scarpettad/core-metrics-results/unweighted-unifrac-giorno-group-significance.qzv \
  --p-pairwise

# Plotting PCoA to explore data
singularity run $sing_container qiime emperor plot \
  --i-pcoa /home/scarpettad/core-metrics-results/unweighted_unifrac_pcoa_results.qza \
  --m-metadata-file $metadata \
  --p-custom-axes Giorno \
  --o-visualization /home/scarpettad/core-metrics-results/unweighted-unifrac-emperor-days.qzv

singularity run $sing_container qiime emperor plot \
  --i-pcoa /home/scarpettad/core-metrics-results/bray_curtis_pcoa_results.qza \
  --m-metadata-file $metadata \
  --p-custom-axes Giorno \
  --o-visualization /home/scarpettad/core-metrics-results/bray-curtis-emperor-days.qzv
