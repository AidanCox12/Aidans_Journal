#!/bin/bash
## Job Name
#SBATCH --job-name=maker_pgen074
## Allocation Definition
#SBATCH --account=coenv
#SBATCH --partition=coenv
## Resources
## Nodes
#SBATCH --nodes=2
## Walltime (days-hours:minutes:seconds format)
#SBATCH --time=40-00:00:00
## Memory per node
#SBATCH --mem=120G
##turn on e-mail notification
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samwhite@uw.edu
## Specify the working directory for this job
#SBATCH --workdir=/gscratch/scrubbed/samwhite/outputs/20190805_pgen_maker_v070_annotation

# Exit if any command fails
set -e

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
echo "${PATH}" | tr : \\n >> system_path.log

# Add BLAST to system PATH
export PATH=$PATH:/gscratch/srlab/programs/ncbi-blast-2.6.0+/bin
export BLASTDB=/gscratch/srlab/blastdbs/UniProtKB_20190109/


## Establish variables for more readable code

wd=$(pwd)
maker_dir=/gscratch/srlab/programs/maker-2.31.10/bin
snap_dir=/gscratch/srlab/programs/maker-2.31.10/exe/snap
base_name=20190805_Pgenerosa_v070

### Paths to Maker binaries

maker=${maker_dir}/maker
gff3_merge=${maker_dir}/gff3_merge
maker2zff=${maker_dir}/maker2zff
fathom=${snap_dir}/fathom
forge=${snap_dir}/forge
hmmassembler=${snap_dir}/hmm-assembler.pl
fasta_merge=${maker_dir}/fasta_merge
map_ids=${maker_dir}/maker_map_ids
map_gff_ids=${maker_dir}/map_gff_ids
map_fasta_ids=${maker_dir}/map_fasta_ids
functional_fasta=${maker_dir}/maker_functional_fasta
functional_gff=${maker_dir}/maker_functional_gff
ipr_update_gff=${maker_dir}/ipr_update_gff
iprscan2gff3=${maker_dir}/iprscan2gff3

blastp_dir=${wd}/blastp_annotation
maker_blastp=${wd}/blastp_annotation/blastp.outfmt6
maker_prot_fasta=${wd}/snap02/${base_name}_snap02.all.maker.proteins.fasta
maker_prot_fasta_renamed=${wd}/snap02/${base_name}_snap02.all.maker.proteins.renamed.fasta
maker_transcripts_fasta=${wd}/snap02/${base_name}_snap02.all.maker.transcripts.fasta
maker_transcripts_fasta_renamed=${wd}/snap02/${base_name}_snap02.all.maker.transcripts.renamed.fasta
snap02_gff=${wd}/snap02/${base_name}_snap02.all.gff
snap02_gff_renamed=${wd}/snap02/${base_name}_snap02.all.renamed.gff
put_func_gff=${base_name}_genome_snap02.all.renamed.putative_function.gff
put_func_prot=${base_name}_genome_snap02.all.maker.proteins.renamed.putative_function.fasta
put_func_trans=${base_name}_genome_snap02.all.maker.transcripts.renamed.putative_function.fasta
put_domain_gff=${base_name}_genome_snap02.all.renamed.putative_function.domain_added.gff
ips_dir=${wd}/interproscan_annotation
ips_base=${base_name}_maker_proteins_ips
ips_name=${base_name}_maker_proteins_ips.tsv
id_map=${wd}/snap02/${base_name}_genome.map
ips_domains=${base_name}_genome_snap02.all.renamed.visible_ips_domains.gff

## Path to blastp
blastp=/gscratch/srlab/programs/ncbi-blast-2.6.0+/bin/blastp

## Path to InterProScan5
interproscan=/gscratch/srlab/programs/interproscan-5.31-70.0/interproscan.sh

## Store path to options control file
maker_opts_file=./maker_opts.ctl

### Path to genome FastA file
genome=/gscratch/srlab/sam/data/P_generosa/genomes/Pgenerosa_v070.fa

### Paths to transcriptome FastA files
ctendia_transcriptome=/gscratch/srlab/sam/data/P_generosa/transcriptomes/ctenidia/Trinity.fasta
gonad_transcriptome=/gscratch/srlab/sam/data/P_generosa/transcriptomes/gonad/Trinity.fasta
heart_transcriptome=/gscratch/srlab/sam/data/P_generosa/transcriptomes/heart/Trinity.fasta
EPI99_transcriptome=/gscratch/srlab/sam/data/P_generosa/transcriptomes/larvae/EPI99/Trinity.fasta
EPI115_transcriptome=/gscratch/srlab/sam/data/P_generosa/transcriptomes/juvenile/EPI115/Trinity.fasta
EPI116_transcriptome=/gscratch/srlab/sam/data/P_generosa/transcriptomes/juvenile/EPI116/Trinity.fasta
EPI123_transcriptome=/gscratch/srlab/sam/data/P_generosa/transcriptomes/juvenile/EPI123/Trinity.fasta
EPI124_transcriptome=/gscratch/srlab/sam/data/P_generosa/transcriptomes/juvenile/EPI124/Trinity.fasta

### Path to Crassotrea gigas NCBI protein FastA
gigas_proteome=/gscratch/srlab/sam/data/C_gigas/gigas_ncbi_protein/GCA_000297895.1_oyster_v9_protein.faa

### Path to Crassostrea virginica NCBI protein FastA
virginica_proteome=/gscratch/srlab/sam/data/C_virginica/virginica_ncbi_protein/GCF_002022765.2_C_virginica-3.0_protein.faa

### Path to Panopea generosa TransDecoder protein FastAs
panopea_td_proteome=/gscratch/srlab/sam/data/P_generosa/proteomes/20180827_trinity_geoduck.fasta.transdecoder.pep
pgen_td_ctenidia_proteome=/gscratch/srlab/sam/data/P_generosa/proteomes/ctenidia/Trinity.fasta.transdecoder.pep
pgen_td_larvae_EPI99_proteome=/gscratch/srlab/sam/data/P_generosa/proteomes/larvae/EPI99/Trinity.fasta.transdecoder.pep
pgen_td_juv_EPI115_proteome=/gscratch/srlab/sam/data/P_generosa/proteomes/juvenile/EPI115/Trinity.fasta.transdecoder.pep
pgen_td_juv_EPI116_proteome=/gscratch/srlab/sam/data/P_generosa/proteomes/juvenile/EPI116/Trinity.fasta.transdecoder.pep
pgen_td_juv_EPI123_proteome=/gscratch/srlab/sam/data/P_generosa/proteomes/juvenile/EPI123/Trinity.fasta.transdecoder.pep
pgen_td_juv_EPI124_proteome=/gscratch/srlab/sam/data/P_generosa/proteomes/juvenile/EPI124/Trinity.fasta.transdecoder.pep
pgen_td_gonad_proteome=/gscratch/srlab/sam/data/P_generosa/proteomes/gonad/Trinity.fasta.transdecoder.pep
pgen_td_heart_proteome=/gscratch/srlab/sam/data/P_generosa/proteomes/heart/Trinity.fasta.transdecoder.pep


### Path to P.generosa-specific RepeatModeler library
repeat_library=/gscratch/srlab/sam/data/P_generosa/repeats/Pgenerosa_v070-families.fa

### Path to P.generosa-specific RepeatMasker GFF
rm_gff=/gscratch/srlab/sam/data/P_generosa/repeats/Pgenerosa_v070.fa.out.gff

### Path to SwissProt database for BLASTp
sp_db_blastp=/gscratch/srlab/blastdbs/UniProtKB_20190109/uniprot_sprot.fasta


## Make directories
mkdir blastp_annotation
mkdir interproscan_annotation
mkdir snap01
mkdir snap02


## Create Maker control files needed for running Maker, only if it doesn't already exist and then edit it.
### Edit options file
### Set paths to P.generosa genome and transcriptome.
### Set path to combined C. gigas, C.virginica, P.generosa proteomes.
### The use of the % symbol sets the delimiter sed uses for arguments.
### Normally, the delimiter that most examples use is a slash "/".
### But, we need to expand the variables into a full path with slashes, which screws up sed.
### Thus, the use of % symbol instead (it could be any character that is NOT present in the expanded variable; doesn't have to be "%").
if [ ! -e maker_opts.ctl ]; then
  $maker -CTL
  sed -i "/^genome=/ s% %$genome %" "$maker_opts_file"

  # Set transcriptomes to use
  sed -i "/^est=/ s% %\
  ${ctendia_transcriptome},\
  ${gonad_transcriptome},\
  ${heart_transcriptome},\
  ${EPI99_transcriptome},\
  ${EPI115_transcriptome},\
  ${EPI116_transcriptome},\
  ${EPI123_transcriptome},\
  ${EPI124_transcriptome} %" \
  "$maker_opts_file"

  # Set proteomes to use
  sed -i "/^protein=/ s% %\
  ${gigas_proteome},\
  ${panopea_td_proteome},\
  ${pgen_td_ctenidia_proteome},\
  ${pgen_td_gonad_proteome},\
  ${pgen_td_heart_proteome},\
  ${pgen_td_juv_EPI115_proteome},\
  ${pgen_td_juv_EPI116_proteome},\
  ${pgen_td_juv_EPI123_proteome},\
  ${pgen_td_juv_EPI124_proteome},\
  ${pgen_td_larvae_EPI99_proteome},\
  ${virginica_proteome} \
  %" \
  "$maker_opts_file"

  # Set RepeatModeler library to use
  sed -i "/^rmlib=/ s% %$repeat_library %" "$maker_opts_file"

  # Set RepeatMasker GFF to use
  sed -i "/^rm_gff=/ s% %${rm_gff} %" "$maker_opts_file"

  # Set est2ggenome to 1 - tells MAKER to use transcriptome FastAs
  sed -i "/^est2genome=0/ s/est2genome=0/est2genome=1/" "$maker_opts_file"

  # Set protein2genome to 1 - tells MAKER to use protein FastAs
  sed -i "/^protein2genome=0/ s/protein2genome=0/protein2genome=1/" "$maker_opts_file"
fi


## Run Maker
### Specify number of nodes to use.
mpiexec -n 56 $maker

## Merge gffs
${gff3_merge} -d ${base_name}.maker.output/${base_name}_master_datastore_index.log

## GFF with no FastA in footer
${gff3_merge} -n -s -d ${base_name}.maker.output/${base_name}_master_datastore_index.log > ${base_name}.maker.all.noseqs.gff

## Merge all FastAs
${fasta_merge} -d ${base_name}.maker.output/${base_name}_master_datastore_index.log

## Extract GFF alignments for use in subsequent MAKER rounds
### Transcript alignments
awk '{ if ($2 == "est2genome") print $0 }' ${base_name}.maker.all.noseqs.gff > ${base_name}.maker.all.noseqs.est2genome.gff
### Protein alignments
awk '{ if ($2 == "protein2genome") print $0 }' ${base_name}.maker.all.noseqs.gff > ${base_name}.maker.all.noseqs.protein2genome.gff
### Repeat alignments
awk '{ if ($2 ~ "repeat") print $0 }' ${base_name}.maker.all.noseqs.gff > ${base_name}.maker.all.noseqs.repeats.gff

## Run SNAP training, round 1
cd "${wd}"
cd snap01
${maker2zff} ../${base_name}.all.gff
${fathom} -categorize 1000 genome.ann genome.dna
${fathom} -export 1000 -plus uni.ann uni.dna
${forge} export.ann export.dna
${hmmassembler} genome . > ${base_name}_snap01.hmm

## Initiate second Maker run.
### Copy initial maker control files and
### Default gene prediction settings are 0 (i.e. don't generate Maker gene predictions)
### - use GFF subsets generated in first round of MAKER
### - set location of snaphmm file to use for gene prediction
### Percent symbols used below are the sed delimiters, instead of the default "/",
### due to the need to use file paths.
if [ ! -e maker_opts.ctl ]; then
  $maker -CTL
  sed -i "/^genome=/ s% %$genome %" maker_opts.ctl

  # Set transcriptomes to use
  sed -i "/^est=/ s% %\
  ${ctendia_transcriptome},\
  ${gonad_transcriptome},\
  ${heart_transcriptome},\
  ${EPI99_transcriptome},\
  ${EPI115_transcriptome},\
  ${EPI116_transcriptome},\
  ${EPI123_transcriptome},\
  ${EPI124_transcriptome} %" \
  "$maker_opts_file"

  # Set proteomes to use
  sed -i "/^protein=/ s% %\
  ${gigas_proteome},\
  ${panopea_td_proteome},\
  ${pgen_td_ctenidia_proteome},\
  ${pgen_td_gonad_proteome},\
  ${pgen_td_heart_proteome},\
  ${pgen_td_juv_EPI115_proteome},\
  ${pgen_td_juv_EPI116_proteome},\
  ${pgen_td_juv_EPI123_proteome},\
  ${pgen_td_juv_EPI124_proteome},\
  ${pgen_td_larvae_EPI99_proteome},\
  ${virginica_proteome} \
  %" \
  "$maker_opts_file"

  # Set RepeatModeler library to use
  sed -i "/^rmlib=/ s% %$repeat_library %" "$maker_opts_file"

  sed -i "/^est_gff=/ s% %../${base_name}.maker.all.noseqs.est2genome.gff %" maker_opts.ctl
  sed -i "/^protein_gff=/ s% %../${base_name}.maker.all.noseqs.protein2genome.gff %" maker_opts.ctl
  sed -i "/^rm_gff=/ s% %../${base_name}.maker.all.noseqs.repeats.gff %" maker_opts.ctl
  sed -i "/^snaphmm=/ s% %${base_name}_snap01.hmm %" maker_opts.ctl
fi

## Run Maker
### Set basename of files and specify number of CPUs to use
mpiexec -n 56 $maker \
-base ${base_name}_snap01

## Merge gffs
${gff3_merge} -d ${base_name}_snap01.maker.output/${base_name}_snap01_master_datastore_index.log

## GFF with no FastA in footer
${gff3_merge} -n -s -d ${base_name}_snap01.maker.output/${base_name}_snap01_master_datastore_index.log > ${base_name}_snap01.maker.all.noseqs.gff

## Run SNAP training, round 2
cd "${wd}"
cd snap02
${maker2zff} ../snap01/${base_name}_snap01.all.gff
${fathom} -categorize 1000 genome.ann genome.dna
${fathom} -export 1000 -plus uni.ann uni.dna
${forge} export.ann export.dna
${hmmassembler} genome . > ${base_name}_snap02.hmm

## Initiate third and final Maker run.

if [ ! -e maker_opts.ctl ]; then
  $maker -CTL
  sed -i "/^genome=/ s% %$genome %" maker_opts.ctl

  # Set transcriptomes to use
  sed -i "/^est=/ s% %\
  ${ctendia_transcriptome},\
  ${gonad_transcriptome},\
  ${heart_transcriptome},\
  ${EPI99_transcriptome},\
  ${EPI115_transcriptome},\
  ${EPI116_transcriptome},\
  ${EPI123_transcriptome},\
  ${EPI124_transcriptome} %" \
  "$maker_opts_file"

  # Set proteomes to use
  sed -i "/^protein=/ s% %\
  ${gigas_proteome},\
  ${panopea_td_proteome},\
  ${pgen_td_ctenidia_proteome},\
  ${pgen_td_gonad_proteome},\
  ${pgen_td_heart_proteome},\
  ${pgen_td_juv_EPI115_proteome},\
  ${pgen_td_juv_EPI116_proteome},\
  ${pgen_td_juv_EPI123_proteome},\
  ${pgen_td_juv_EPI124_proteome},\
  ${pgen_td_larvae_EPI99_proteome},\
  ${virginica_proteome} \
  %" \
  "$maker_opts_file"

  # Set RepeatModeler library to use
  sed -i "/^rmlib=/ s% %$repeat_library %" "$maker_opts_file"

  sed -i "/^est_gff=/ s% %../${base_name}.maker.all.noseqs.est2genome.gff %" maker_opts.ctl
  sed -i "/^protein_gff=/ s% %../${base_name}.maker.all.noseqs.protein2genome.gff %" maker_opts.ctl
  sed -i "/^rm_gff=/ s% %../${base_name}.maker.all.noseqs.repeats.gff %" maker_opts.ctl
  sed -i "/^snaphmm=/ s% %${base_name}_snap02.hmm %" maker_opts.ctl
fi

## Run Maker
### Set basename of files and specify number of CPUs to use
mpiexec -n 56 $maker \
-base ${base_name}_snap02

## Merge gffs
${gff3_merge} \
-d ${base_name}_snap02.maker.output/${base_name}_snap02_master_datastore_index.log

## GFF with no FastA in footer
${gff3_merge} -n -s -d ${base_name}_snap02.maker.output/${base_name}_snap02_master_datastore_index.log > ${base_name}_snap02.maker.all.noseqs.gff

## Merge FastAs
${fasta_merge} \
-d ${base_name}_snap02.maker.output/${base_name}_snap02_master_datastore_index.log

# Create copies of files for mapping
cp "${maker_prot_fasta}" "${maker_prot_fasta_renamed}"
cp "${maker_transcripts_fasta}" "${maker_transcripts_fasta_renamed}"
cp "${snap02_gff}" "${snap02_gff_renamed}"

# Map IDs
## Change gene names
${map_ids} \
--prefix PGEN_ \
--justify 8 \
"${snap02_gff}" \
> "${id_map}"

## Map GFF IDs
${map_gff_ids} \
"${id_map}" \
"${snap02_gff_renamed}"

## Map FastAs
### Proteins
${map_fasta_ids} \
"${id_map}" \
"${maker_prot_fasta_renamed}"

### Transcripts
${map_fasta_ids} \
"${id_map}" \
"${maker_transcripts_fasta_renamed}"

# Run InterProScan 5
## disable-precalc since this requires external database access (which Mox does not allow)
cd "${ips_dir}"

${interproscan} \
--input "${maker_prot_fasta_renamed}" \
--goterms \
--output-file-base ${ips_base} \
--disable-precalc

# Run BLASTp
cd "${blastp_dir}"

${blastp} \
-query "${maker_prot_fasta_renamed}" \
-db ${sp_db_blastp} \
-out "${maker_blastp}" \
-max_target_seqs 1 \
-evalue 1e-6 \
-outfmt 6 \
-num_threads 28


# Functional annotations

cd "${wd}"

## Add putative gene functions
### GFF
${functional_gff} \
${sp_db_blastp} \
"${maker_blastp}" \
"${snap02_gff_renamed}" \
> ${put_func_gff}

### Proteins
${functional_fasta} \
${sp_db_blastp} \
"${maker_blastp}" \
"${maker_prot_fasta_renamed}" \
> ${put_func_prot}

### Transcripts
${functional_fasta} \
${sp_db_blastp} \
"${maker_blastp}" \
"${maker_transcripts_fasta_renamed}" \
> ${put_func_trans}

## Add InterProScan domain info
### Add searchable tags
${ipr_update_gff} \
${put_func_gff} \
"${ips_dir}"/${ips_name} \
> ${put_domain_gff}

### Add viewable features for genome browsers (JBrowse, Gbrowse, Web Apollo)
${iprscan2gff3} \
"${ips_dir}"/${ips_name} \
"${snap02_gff_renamed}" \
> ${ips_domains}
