#!/bin/bash
## Job Name
#SBATCH --job-name=bismark
## Allocation Definition
#SBATCH --account=coenv
#SBATCH --partition=coenv
## Resources
## Nodes
#SBATCH --nodes=1
## Walltime (days-hours:minutes:seconds format)
#SBATCH --time=10-00:00:00
## Memory per node
#SBATCH --mem=120G
##turn on e-mail notification
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samwhite@uw.edu
## Specify the working directory for this job
#SBATCH --workdir=/gscratch/scrubbed/samwhite/outputs/20190222_cgigas_se_bismark

# Load Python Mox module for Python module availability

module load intel-python3_2017

# Document programs in PATH (primarily for program version ID)

date >> system_path.log
echo "" >> system_path.log
echo "System PATH for $SLURM_JOB_ID" >> system_path.log
echo "" >> system_path.log
printf "%0.s-" {1..10} >> system_path.log
echo ${PATH} | tr : \\n >> system_path.log


# Directories and programs
wd=$(pwd)
bismark_dir="/gscratch/srlab/programs/Bismark-0.19.0"
bowtie2_dir="/gscratch/srlab/programs/bowtie2-2.3.4.1-linux-x86_64/"
samtools="/gscratch/srlab/programs/samtools-1.9/samtools"
reads_dir="/gscratch/scrubbed/samwhite/data/C_gigas/BSseq/"

## genomes

genome="/gscratch/srlab/sam/data/C_gigas/genomes/"

## An array of subsets of reads to use in bismark:
## 100k, 500k, 1M, 2M, 5M, 10M
subset_array=(100000 500000 1000000 2000000 5000000 10000000)

## FastQ Files
se_reads="/gscratch/scrubbed/samwhite/data/C_gigas/BSseq/cgig_bsseq_all_R1.fastq.gz"

## FastQ files lists
R1_list="/gscratch/scrubbed/samwhite/data/C_gigas/BSseq/cgig_bsseq_all_R1.list"

# Check for existence of previous concatenation
# If they exist, delete them

for file in ${se_reads} ${R1_list}
do
  if [ -e ${file} ]; then
    rm ${file}
  fi
done

# Concatenate R1 reads and generate lists of FastQs
for fastq in ${reads_dir}*R1*.gz
do
  echo ${fastq} >> ${R1_list}
  cat ${fastq} >> ${se_reads}
done

# Run bismark using bisulftie-converted genome

for subset in ${subset_array[@]}
do
    mkdir subset_${subset}
    cd subset_${subset}
    ${bismark_dir}/bismark \
    --path_to_bowtie ${bowtie2_dir} \
    --genome ${genome} \
    --score_min L,0,-0.6 \
    -u ${subset} \
    -p 28 \
    ${se_reads} \
    2> subset_${subset}_summary.txt

    # Deduplicate bam files
    ${bismark_dir}/deduplicate_bismark \
    --bam \
    --single \
    *.bam

    # Methylation extraction

    ${bismark_dir}/bismark_methylation_extractor \
    --bedgraph \
    --counts \
    --scaffolds \
    --remove_spaces \
    --multicore 28 \
    --buffer_size 75% \
    *deduplicated.bam

    # Bismark processing report

    ${bismark_dir}/bismark2report

    #Bismark summary report

    ${bismark_dir}/bismark2summary

    # Sort files for methylkit and IGV

    find *deduplicated.bam \
    | xargs basename -s .bam \
    | xargs -I{} ${samtools} \
    sort \
    --threads 28 \
    {}.bam \
    -o {}.sorted.bam

    # Index sorted files for IGV
    # The "-@ 56" below specifies number of CPU threads to use.

    find *.sorted.bam \
    | xargs basename -s .sorted.bam \
    | xargs -I{} ${samtools} \
    index -@ 28 \
    {}.sorted.bam
    cd ${wd}
done
