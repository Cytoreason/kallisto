set -euo pipefail

# Setting up input and output directories.
INPUT_DIR='/'
OUTPUT_DIR='/'
INDEX_DIR='/'

# Getting input and output directories from arguements
if [ $# -ne 4 ]; then
	INPUT_DIR=$(readlink -f $1)
	OUTPUT_DIR=$(readlink -f $2)
	INDEX_DIR=$(readlink -f $3)
	echo "Using $INPUT_DIR as input directory, $OUTPUT_DIR as output directory, and $INDEX_DIR as index directory"
else
	echo "Usage: atac_pipeline.sh /directory/to/analyze /directory/to/output /directory/with/indices"
	exit 1
fi

cd $INPUT_DIR

# Iterating through all of the experiments in the input directory.
for dir in */
do
	DIR=${dir%*/}

	# Set up output directory
	CUR_OUTPUT_DIR="${OUTPUT_DIR}/${DIR}"
	mkdir $CUR_OUTPUT_DIR

	cd $DIR
	CUR_INPUT_DIR="${INPUT_DIR}/${DIR}"
	cd $CUR_INPUT_DIR
	echo "Analyzing files in ${CUR_INPUT_DIR}"

	for i in `ls *1.fastq.gz`;
	do
	 	sampleID="${i%1.*.*}"
	 	SAMPLE_OUTPUT_DIR="${CUR_OUTPUT_DIR}/${sampleID}" 
	 	mkdir $SAMPLE_OUTPUT_DIR
	  	echo "Analyzing sample ${sampleID}"
		/root/kallisto_linux-v0.43.1/kallisto quant -i ${INDEX_DIR}/Homo_sapiens.GRCh38.87.cdna.all.idx -o $SAMPLE_OUTPUT_DIR -b 100 -t 8 ${sampleID}1.fastq.gz ${sampleID}2.fastq.gz
	done

	echo $?
done