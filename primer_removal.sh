#!/bin/bash
#SBATCH --job-name=Primer_Trimming
#SBATCH --ntasks 1 
#SBATCH --mem=24G 
#SBATCH --output=stdout_primertrimming.Log

# Activate conda environment with cutadapt
source activate /home/scarpettad/.conda/envs/metagen

# Directory containing olives FASTQ files
cd /home/ngs/231005_M04028_0161_000000000-L359T
input_dir="/home/ngs/231005_M04028_0161_000000000-L359T"

# Output directory 
output_dir="/home/scarpettad/second_run/cutadapt_primer"

# Chek if the output directory exist, if not thanks to the -p flag mkdir not return any error in case that directory exists
mkdir -p "${output_dir}"

# Primer sequences
forward_primer="CCTACGGGNGGCWGCAG"
reverse_primer="GACTACHVGGGTATCTAATCC"

# We have PE files, so a loop in order to select R1 and R2 for each sample 
for R1 in "${input_dir}"/[0-9]*_R1_001.fastq.gz; do
    # Extract the sample number from the file name
    sample_number=$(basename "${R1}" | grep -o '^[0-9]\+')

    # Olive files are in the range from 32 to 71, so:
    if ((sample_number >= 32 && sample_number <= 71)); then
        SAMPLE=$(echo "${R1}" | sed "s/_R1_001\.fastq\.gz//")
        R2="${SAMPLE}_R2_001.fastq.gz"
        
      
    # Define output file names
    output_R1="${output_dir}/$(basename "${R1}" _001.fastq.gz)_primer_trimmed.fastq.gz"
    output_R2="${output_dir}/$(basename "${R2}" _001.fastq.gz)_primer_trimmed.fastq.gz"

    # Run cutadapt
    cutadapt -g "${forward_primer}" -G "${reverse_primer}" -o "${output_R1}" -p "${output_R2}" "${R1}" "${R2}"

    echo "Primers removed for: $(basename "${R1}") and $(basename "${R2}")"
    fi
done

echo "Primers removed from all files."

# Dectivate conda environment 
conda deactivate
