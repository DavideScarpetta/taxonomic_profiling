  # Taxonomic Profiling

*Metabarcoding* is the barcoding of DNA/RNA (or eDNA/eRNA) in a manner that allows for the simultaneous identification of many taxa within the same sample. The main difference between barcoding and metabarcoding is that metabarcoding does not focus on one specific organism, but instead aims to determine species composition within a sample.

Here I present a *Bioinformatics* Metabarcoding analysis pipeline, starting from raw PE fastq data, using _DADA2_ and _qiime2_. 
All scripts should be run after a quality control check. I recommend fastqc and multiqc. 

Be sure to replace the variables with your own variables of interest. 

This analysis was run on a Slurm HPC. 

Use of conda and singularity is simply for convenience. 

#### SILVA DB
Silva 138 SSURef NR99 full-length sequences and taxonomy to train the classifier are available here: 

https://docs.qiime2.org/2023.9/data-resources/



#### Docs: 

- _CUTADAPT_ documentation:
https://cutadapt.readthedocs.io/en/stable/

- _DADA2_ documentation:
https://www.bioconductor.org/packages/release/bioc/manuals/dada2/man/dada2.pdf

- _QIIME2_ documentation:
https://docs.qiime2.org/2023.9/

#### Scripts order:

###### - 1) Primer removal
  A bash script in order to remove primer, using cutadapt

###### - 2) Adapter removal
  A bash script in order to remove adapter, using cutadapt

###### - 3) Qiime import
  A bash script in order to import files into a qiime artifact (.qza file), to work easily and faster on fastq files

###### - 4) Denoise DADA2
  A bash script in order to do denoising using DADA2, output are Amplicon Sequence Variants (better than OTUs as it is said in literature)

###### - 5) Extract reads classifier
  A bash script to extract reference reads from SILVA database using PCR primers

###### - 6) Training classifier
  A bash script to train a Naive Bayes classifier. Output is a classifier.qza

###### - 7) Classifier 
  A bash script to test the previously trained classifier on our data

###### - 8) Export Filter
  A bash script to:
  
  - export taxa barplot 
    
  - include only sequence classified at the phylum level 
    
  - filter out chloroplast sequence 
    
  - export taxonomic counts at all level
    
  - collapse groups of features that have the same taxonomic assignment through the specified level
    
  - convert tables to .tsv
