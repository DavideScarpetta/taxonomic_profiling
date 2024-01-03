# taxonomic_profiling
Metabarcoding analysis pipeline, using DADA2 and qiime2.

## Primer removal
A bash script in order to remove primer, using cutadapt

## Adapter removal
A bash script in order to remove adapter, using cutadapt

## Qiime import
A bash scritp in order to import files into a qiime artifact (.qza file), to work easily and faster on fastq files

## Denoise DADA2
A bash script in order to do denoising using DADA2, output are Amplicon Sequence Variants (better than OTUs as it is said in literature)

## Extract reads classifier
A bash script to extract reference reads from SILVA database using PCR primers

## Training classifier
A bash script to train a Naive Bayes classifier. Output is a classifier.qza

## Classifier 
A bash script to test the previously trained classifier on our data


