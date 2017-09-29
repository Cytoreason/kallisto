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
	echo "Usage: kallisto_pipeline_2.sh /directory/to/analyze /directory/to/output /directory/with/indices"
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

	CUR_INPUT_DIR="${INPUT_DIR}/${DIR}"
	cd $CUR_INPUT_DIR
	echo "Analyzing files in ${CUR_INPUT_DIR}"

	# Iterates through the Experiment folders output by Stage 1
	for exp in */
	do
		EXP=${exp%*/}
		EXP_INPUT_DIR="${CUR_INPUT_DIR}/${EXP}"
		echo "Analyzing sample ${exp}"
		RScript /code/postprocess.R -i ${EXP_INPUT_DIR}/abundance.tsv -r ${INDEX_DIR}/ENSG_to_Hugo.tsv -o ${CUR_OUTPUT_DIR}/${EXP}postprocessed.tsv
	done

	echo $?
done