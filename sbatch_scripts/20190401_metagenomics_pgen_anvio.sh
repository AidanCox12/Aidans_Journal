#!/bin/bash
## Job Name
#SBATCH --job-name=megahit
## Allocation Definition
#SBATCH --account=coenv
#SBATCH --partition=coenv
## Resources
## Nodes
#SBATCH --nodes=1
## Walltime (days-hours:minutes:seconds format)
#SBATCH --time=25-00:00:00
## Memory per node
#SBATCH --mem=120G
##turn on e-mail notification
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samwhite@uw.edu
## Specify the working directory for this job
#SBATCH --workdir=/gscratch/scrubbed/samwhite/outputs/20190401_metagenomics_pgen_anvio

# Load Python Mox module for Python module availability

module load intel-python3_2017

# Load Open MPI module for parallel, multi-node processing

module load icc_19-ompi_3.1.2

# SegFault fix?
export THREADS_DAEMON_MODEL=1

# Document programs in PATH (primarily for program version ID)

date >> system_path.log
echo "" >> system_path.log
echo "System PATH for $SLURM_JOB_ID" >> system_path.log
echo "" >> system_path.log
printf "%0.s-" {1..10} >> system_path.log
echo ${PATH} | tr : \\n >> system_path.log


# variables
wd=$(pwd)
cpus=28
megahit_out_dir=/gscratch/scrubbed/samwhite/outputs/20190327_metagenomics_pgen_megahit

## Inititalize arrays
samples_array=(MG1 MG2 MG3 MG5 MG6 MG7)
fastq_array_R1=()
fastq_array_R2=()

## Programs
bbmap_dir=/gscratch/srlab/programs/bbmap_38.34
anvi_dir=/gscratch/srlab/programs/anaconda3/bin
samtools=/gscratch/srlab/programs/samtools-1.9/samtools



# Re-label FastAs
for sample in ${samples_array}
do
  #
  ${anvi_dir}/anvi-script-reformat-fasta \
  -o ${sample}.renamed.fa \
  --simplify-names \
  -l 0 \
  --report-file
  # Create FastA index
  ${samtools} faidx ${sample}.renamed.fa
  # Map reads to FastAs
  ${bbmap_dir}/bbwrap.sh \
  ref=${sample}.renamed.fa \
  in1=${fastq_array_R1[sample]} \
  in2=${fastq_array_R2[sample]} \
  out=${sample_name}.aln.sam.gz
