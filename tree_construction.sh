#!/bin/bash
#SBATCH --job-name=RootedTreeConstruction
#SBATCH --ntasks 1 
#SBATCH --mem=32G 
#SBATCH --output=stdout_treeConstrunct.Log
#SBATCH --cpus-per-task 8

# Setting the working directory 
cd /home/scarpettad

# Setting the path to the singularity container
sing_container=/home/scarpettad/amplicon_2023.9.sif

# Setting the output directory 
output_dir=/home/scarpettad/second_run/tree

# Setting the path to QIIME 2 artifact with previously filtered representative sequences
rep_seqs=/home/scarpettad/second_run/qiime2_taxonomy_output/filtered-rep-seqs.qza

# Perform multiple sequence alignment with MAFFT
singularity run $sing_container qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences $rep_seqs \
  --o-alignment $output_dir/aligned-rep-seqs.qza \
  --o-masked-alignment $output_dir/masked-aligned-rep-seqs.qza \
  --o-tree $output_dir/unrooted-tree.qza \
  --o-rooted-tree $output_dir/rooted-tree.qza
