#!/bin/bash
#SBATCH --job-name=TableExport_Filtering
#SBATCH --ntasks 1 
#SBATCH --mem=48G 
#SBATCH --output=stdout_tableexportFiltering.Log
#SBATCH --cpus-per-task 8

# Setting the working directory 
cd /home/scarpettad

# Setting the path to the singularity container
sing_container=/home/scarpettad/amplicon_2023.9.sif

# Activate conda environment with biom
source activate /home/scarpettad/.conda/envs/metagen

# Setting metadata path
metadata=/home/scarpettad/metadata_secondrun.tsv

# Setting ASV table path
asv=/home/scarpettad/second_run/denoise_dada2/table-dada2.qza

# Setting the rep seqs path
rep_seqs=/home/scarpettad/second_run/denoise_dada2/rep-seqs-dada2.qza

# Setting classified seqs path 
classified_seqs=/home/scarpettad/second_run/training_feature_classifier/classified-rep-seqs.qza

# Setting output dir
output_dir=/home/scarpettad/second_run/qiime2_taxonomy_output

# Export taxa bar plots without filterings:
singularity run $sing_container qiime taxa barplot \
  --i-table $asv \
  --i-taxonomy $classified_seqs  \
  --m-metadata-file $metadata \
  --o-visualization $output_dir/taxa-barplots-classified-SILVA138-99.qzv
 

# Keep all sequences with classification at least at phylum level (other are left visible only in qiime2 taxa bar plot for QC purposes)

# Include only sequences classified at phylum level and remove chloroplast sequences from the table artifact
singularity run $sing_container qiime taxa filter-table \
  --i-table $asv \
  --i-taxonomy $classified_seqs \
  --p-include p__ \
  --p-exclude chloroplast \
  --o-filtered-table $output_dir/filtered-table.qza
 
 
# Include only sequences classified at phylum level and remove chloroplast sequences from the rep-seqs artifact
singularity run $sing_container qiime taxa filter-seqs \
  --i-sequences $rep_seqs \
  --i-taxonomy $classified_seqs \
  --p-include p__ \
  --p-exclude chloroplast \
  --o-filtered-sequences $output_dir/filtered-rep-seqs.qza


filtered_table=filtered-table.qza
filtered_sequences=filtered-rep-seqs.qza
 
# Export as .qzv to assess sequencing depth of beta diversity analysis 
singularity run $sing_container qiime feature-table summarize \
  --i-table $output_dir/$filtered_table \
  --o-visualization $output_dir/filtered_table.qzv \
  --m-sample-metadata-file $metadata
 
# Export filtered taxa bar plot: 
singularity run $sing_container qiime taxa barplot \
  --i-table $output_dir/$filtered_table \
  --i-taxonomy $classified_seqs \
  --m-metadata-file $metadata \
  --o-visualization $output_dir/taxa-barplots-classified-SILVA138-99-filtered.qzv


##### Only filtered table and sequences are used for all the analysis
 
## Export taxonomic counts at all levels
 
# Export taxonomy as .tsv file 
singularity run $sing_container qiime tools export \
  --input-path $classified_seqs \
  --output-path $output_dir/taxonomy
 
# Change header to taxonomy.tsv file
sed -i 's/Feature ID\tTaxon\tConfidence/#OTUID\ttaxonomy\tconfidence/' $output_dir/taxonomy/taxonomy.tsv
 
 
##### Export feature table at ASV level
##### Export filtered table in .biom format
 
singularity run $sing_container qiime tools export \
  --input-path $output_dir/$filtered_table \
  --output-path $output_dir/taxonomy
 
# Add taxonomy to FILTERED feature tables:
biom add-metadata \
  -i $output_dir/taxonomy/feature-table.biom \
  -o $output_dir/taxonomy/filtered-feature-table-with-taxonomy.biom \
  --observation-metadata-fp $output_dir/taxonomy/taxonomy.tsv \
  --sc-separated taxonomy
 

# Convert feature table with taxonomy (.biom to .tsv)
biom convert \
  -i $output_dir/taxonomy/filtered-feature-table-with-taxonomy.biom \
  -o $output_dir/taxonomy/filtered-feature-table-with-taxonomy.tsv \
  --to-tsv \
  --header-key taxonomy
 
# Delete first line of each feature table file
sed -i '1d' $output_dir/taxonomy/filtered-feature-table-with-taxonomy.tsv
 
##### Collapse feature-tables

# Collapse groups of features that have the same taxonomic assignment through the specified level. The frequencies of all features will be summed when they are collapsed.
 
for i in {1..7};
        do singularity run $sing_container qiime taxa collapse \
                --i-table $output_dir/$filtered_table \
                --i-taxonomy $classified_seqs \
                --p-level $i \
                --o-collapsed-table $output_dir/taxonomy/table-level-$i.qza;
        done
 
 
# Convert collapsed table (.qza to biom)
for i in {1..7};
        do singularity run $sing_container qiime tools export \
                --input-path $output_dir/taxonomy/table-level-$i.qza \
                --output-path $output_dir/taxonomy/level-$i;
        done
 
 
# Copy and change names to .biom tables adding the level of the collapse:
for i in {1..7};
        do cp $output_dir/taxonomy/level-$i/feature-table.biom $output_dir/taxonomy/feature-table-$i.biom;
        done
 
# Add taxonomy to feature tables
for i in {1..7};
        do biom add-metadata \
                -i $output_dir/taxonomy/feature-table-$i.biom \
                -o $output_dir/taxonomy/feature-table-$i-with-taxonomy.biom \
                --observation-metadata-fp $output_dir/taxonomy/taxonomy.tsv \
                --sc-separated taxonomy;
        done
 
 
# Convert feature table with taxonomy (.biom to .tsv)
for i in {1..7};
        do biom convert \
                -i $output_dir/taxonomy/feature-table-$i-with-taxonomy.biom \
                -o $output_dir/taxonomy/feature-table-$i.tsv \
                --to-tsv \
                --header-key taxonomy;
        done
 
# Delete first line of each feature table file
for i in {1..7};
        do sed -i '1d' $output_dir/taxonomy/feature-table-$i.tsv;
        done

# Remove taxonomy analysis intermediate files 
rm $output_dir/taxonomy/*.biom
rm $output_dir/taxonomy/*.qza

# Deactivate conda environment 
conda deactivate 
