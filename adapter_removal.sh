#!/bin/bash
#SBATCH --job-name=Adapter_Trimming
#SBATCH --ntasks 1 
#SBATCH --mem=24G 
#SBATCH --output=stdout_adaptertrimming.Log

# Activate conda environment with cutadapt
source activate /home/scarpettad/.conda/envs/metagen

# Directory containing FASTQ files without primers
cd /home/scarpettad/second_run/cutadapt_primer
input_dir="/home/scarpettad/second_run/cutadapt_primer"

# Output directory 
output_dir="/home/scarpettad/second_run/cutadapt_adapter"

# Chek if the output directory exist, if not thanks to the -p flag mkdir not return any error in case that directory exists
mkdir -p "${output_dir}"

# Adapter sequences
forward_adapter="TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG"
reverse_adapter="GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG"

# We have PE files, so a loop in order to select R1 and R2 for each sample 
for R1 in "${input_dir}"/*_R1_primer_trimmed.fastq.gz; do
    SAMPLE=$(echo "${R1}" | sed "s/_R1_primer_trimmed\.fastq\.gz//")
    R2="${SAMPLE}_R2_primer_trimmed.fastq.gz"
        
      
    # Define output file names
    output_R1="${output_dir}/$(basename "${R1}" _primer_trimmed.fastq.gz)_trimmed.fastq.gz"
    output_R2="${output_dir}/$(basename "${R2}" _primer_trimmed.fastq.gz)_trimmed.fastq.gz"
    # Run cutadapt
    cutadapt -a "${forward_adapter}" -A "${reverse_adapter}" -o "${output_R1}" -p "${output_R2}" "${R1}" "${R2}"

echo "Adapter removed for: $(basename "${R1}") and $(basename "${R2}")"
done

echo "Adapter removed from all files."

# Deactivate conda environment
conda deactivate

