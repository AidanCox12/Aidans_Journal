#!/bin/bash
## Job Name
#SBATCH --job-name=mgm
## Allocation Definition
#SBATCH --account=coenv
#SBATCH --partition=coenv
## Resources
## Nodes
#SBATCH --nodes=1
## Walltime (days-hours:minutes:seconds format)
#SBATCH --time=20-00:00:00
## Memory per node
#SBATCH --mem=120G
##turn on e-mail notification
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samwhite@uw.edu
## Specify the working directory for this job
#SBATCH --workdir=/gscratch/scrubbed/samwhite/outputs/20190416_metagenomics_pgen_metagenemark

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

# Programs
gmhmmp="/gscratch/srlab/programs/MetaGeneMark_linux_64_3.38/mgm/gmhmmp"
mgm_mod="/gscratch/srlab/programs/MetaGeneMark_linux_64_3.38/mgm/MetaGeneMark_v1.mod"
samtools="/gscratch/srlab/programs/samtools-1.9/samtools"

# Variables
assemblies_dir=/gscratch/scrubbed/samwhite/outputs/20190415_metagenomics_pgen_megahit

## Initialize array
assemblies_array=()

# Populate array with MegaHit FastAs
assemblies_array=$(find ${assemblies_dir} -maxdepth 3 -name "*.contigs.fa")

# List of files in array
printf "%s\n" "${assemblies_array[@]}" >> fastas.list.txt

# Loop through array and run MetaGeneMark
# Parse out sample name by removing .contigs.fa from filename
# and remove path
for sample in ${assemblies_array[@]}
do
  no_ext=${sample%%.*}
  sample_name=$(echo ${no_ext##*/})
  # Run MetaGeneMark
  ## Specifying the following:
  ### -a : output predicted proteins
  ### -A : write predicted proteins to designated file
  ### -d : output predicted nucleotides
  ### -D : write predicted nucleotides to designated file
  ### -f 3 : Output format in GFF3
  ### -m : Model file (supplied with software)
  ### -o : write GFF3 to designated file
  ${gmhmmp} \
  -a \
  -A ${sample_name}.mgm-proteins.fasta \
  -d \
  -D ${sample_name}.mgm-nucleotides.fasta \
  -f 3 \
  -m ${mgm_mod} \
  ${sample} \
  -o ${sample_name}.mgm.gff
done

# Index FastAs
for fasta in *.fasta
do
  ${samtools} faidx ${fasta}
done
