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
	echo "Usage: run_kallisto.sh /directory/to/analyze /directory/to/output /directory/with/indices"
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

	# Expects the input files to be of the format *R1*.fastq.gz with an identically named R2 pair.
	for i in `ls | egrep '.*[R]1.*\.fastq\.gz'`;
	do
		read SAMPLE_PREFIX SAMPLE_SUFFIX <<< $(echo $i | awk -F'R1' '{print $1,$2}')
		SAMPLE_OUTPUT_DIR="${CUR_OUTPUT_DIR}/${SAMPLE_PREFIX}"
		mkdir $SAMPLE_OUTPUT_DIR
		echo "Analyzing sample ${SAMPLE_PREFIX}"
		/root/kallisto_linux-v0.43.1/kallisto quant -i ${INDEX_DIR}/Homo_sapiens.GRCh38.87.cdna.all.idx -o $SAMPLE_OUTPUT_DIR -b 100 -t 8 ${SAMPLE_PREFIX}R1${SAMPLE_SUFFIX} ${SAMPLE_PREFIX}R2${SAMPLE_SUFFIX}
	done

	echo $?
done