#!/bin/bash
## Job Name
#SBATCH --job-name=trin_cbai
## Allocation Definition
#SBATCH --account=srlab
#SBATCH --partition=srlab
## Resources
## Nodes
#SBATCH --nodes=1
## Walltime (days-hours:minutes:seconds format)
#SBATCH --time=30-00:00:00
## Memory per node
#SBATCH --mem=500G
##turn on e-mail notification
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samwhite@uw.edu
## Specify the working directory for this job
#SBATCH --workdir=gscratch/scrubbed/samwhite/outputs/20191218_cbai_trinity_RNAseq

# Exit script if a command fails
set -e

# Load Python Mox module for Python module availability
module load intel-python3_2017

# Document programs in PATH (primarily for program version ID)
{
date
echo ""
echo "System PATH for $SLURM_JOB_ID"
echo ""
printf "%0.s-" {1..10}
echo "${PATH}" | tr : \\n
} >> system_path.log

# User-defined variables
reads_dir=/gscratch/scrubbed/samwhite/outputs/20191218_cbai_fastp_RNAseq_trimming
threads=27
assembly_stats=assembly_stats.txt

# Paths to programs
trinity_dir="/gscratch/srlab/programs/trinityrnaseq-v2.9.0"
samtools="/gscratch/srlab/programs/samtools-1.10/samtools"


## Inititalize arrays
R1_array=()
R2_array=()

# Variables for R1/R2 lists
R1_list=""
R2_list=""

# Create array of fastq R1 files
R1_array=(${reads_dir}/*_R1_*.gz)

# Create array of fastq R2 files
R2_array=(${reads_dir}/*_R2_*.gz)

# Create list of fastq files used in analysis
## Uses parameter substitution to strip leading path from filename
for fastq in ${reads_dir}/*.gz
do
  echo "${fastq##*/}" >> fastq.list.txt
done

# Create comma-separated lists of FastQ reads
R1_list=$(echo "${R1_array[@]}" | tr " " ",")
R2_list=$(echo "${R2_array[@]}" | tr " " ",")


# Run Trinity
${trinity_dir}/Trinity \
--trimmomatic \
--seqType fq \
--max_memory 500G \
--CPU ${threads} \
--left \
"${R1_list}" \
--right \
"${R2_list}"

# Assembly stats
${trinity_dir}/util/TrinityStats.pl trinity_out_dir/Trinity.fasta \
> ${assembly_stats}

# Create gene map files
${trinity_dir}/util/support_scripts/get_Trinity_gene_to_trans_map.pl \
trinity_out_dir/Trinity.fasta \
> trinity_out_dir/Trinity.fasta.gene_trans_map

# Create FastA index
${samtools} faidx \
trinity_out_dir/Trinity.fasta
