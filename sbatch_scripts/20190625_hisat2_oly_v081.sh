#!/bin/bash
## Job Name
#SBATCH --job-name=oly_hisat2
## Allocation Definition
#SBATCH --account=srlab
#SBATCH --partition=srlab
## Resources
## Nodes
#SBATCH --nodes=1
## Walltime (days-hours:minutes:seconds format)
#SBATCH --time=25-00:00:00
## Memory per node
#SBATCH --mem=500G
##turn on e-mail notification
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samwhite@uw.edu
## Specify the working directory for this job
#SBATCH --workdir=/gscratch/scrubbed/samwhite/outputs/20190625_stringtie_oly_v081

# Exit script if any command fails
set -e

# Load Python Mox module for Python module availability

module load intel-python3_2017

# Document programs in PATH (primarily for program version ID)

date >> system_path.log
echo "" >> system_path.log
echo "System PATH for $SLURM_JOB_ID" >> system_path.log
echo "" >> system_path.log
printf "%0.s-" {1..10} >> system_path.log
echo "${PATH}" | tr : \\n >> system_path.log


threads=27
genome_index_name="Olurida_v081"

# Paths to programs
gffread="/gscratch/srlab/programs/gffread-0.11.4.Linux_x86_64/gffread"
hisat2_dir="/gscratch/srlab/programs/hisat2-2.1.0"
hisat2="${hisat2_dir}/hisat2"
hisat2_build="${hisat2_dir}/hisat2-build"
hisat2_exons="${hisat2_dir}/hisat2_extract_exons.py"
hisat2_splice_sites="${hisat2_dir}/hisat2_extract_splice_sites.py"
samtools="/gscratch/srlab/programs/samtools-1.9/samtools"
stringtie="/gscratch/srlab/programs/stringtie-1.3.6.Linux_x86_64/stringtie"

# Input/output files
genome_gff="/gscratch/srlab/sam/data/O_lurida/genomes/Olurida_v081/20181127_oly_genome_snap02.all.renamed.putative_function.domain_added.gff"
exons="hisat2_exons.tab"
fastq_dir="/gscratch/srlab/sam/data/O_lurida/RNAseq/"
genome_fasta="/gscratch/srlab/sam/data/O_lurida/genomes/Olurida_v081/Olurida_v081.fa"
splice_sites="hisat2_splice_sites.tab"
transcripts_gtf="20190620_oly_genome_snap02.all.renamed.putative_function.domain_added.transcripts.gtf"
gtf_list=""

## Inititalize arrays
fastq_array_R1=()
fastq_array_R2=()
gtf_array=()

# Create array of fastq R1 files
for fastq in ${fastq_dir}/*R1*.gz
do
  fastq_array_R1+=(${fastq})
done

# Create array of fastq R2 files
for fastq in ${fastq_dir}/*R2*.gz
do
  fastq_array_R2+=(${fastq})
done

# Create array of sample names
## Uses parameter substitution to strip leading path from filename
## Uses awk to parse out sample name from filename
for R1_fastq in ${fastq_dir}/*R1*.gz
do
  names_array+=($(echo ${R1_fastq#${fastq_dir}} | awk -F"[_.]" '{print $1 "_" $5}'))
done

# Create list of fastq files used in analysis
## Uses parameter substitution to strip leading path from filename
for fastq in ${fastq_dir}*.gz
do
  echo "${fastq#${fastq_dir}}" >> fastq.list.txt
done

# Create transcipts GTF from genome FastA
"${gffread}" -T \
"${genome_gff}" \
-o "${transcripts_gtf}"

# Create Hisat2 exons tab file
"${hisat2_exons}" \
"${transcripts_gtf}" \
> "${exons}"
# Create Hisate2 splice sites tab file
"${hisat2_splice_sites}" \
"${transcripts_gtf}" \
> "${splice_sites}"

# Build Hisat2 reference index using splice sites and exons
"${hisat2_build}" \
"${genome_fasta}" \
"${genome_index_name}" \
--exon "${exons}" \
--ss "${splice_sites}" \
-p "${threads}" \
2> hisat2_build.err
