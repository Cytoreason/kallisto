# kallisto
Contains a Dockerfile that defines an image with [Kallisto](https://pachterlab.github.io/kallisto/) alongside a shell script for automating the analysis of multiple files with it. It's built so that it can be used with [Pachyderm](https://www.pachyderm.io/) or as a stand-alone Docker image.

## Input data
This pipeline expects one level of folders within the input directory (e.g. kallisto_input/experiment_one, kallisto_input/experiment_two).
Within these folders the pipeline expects paired .fastq or .fastq.gz files. The top level folders have no impact on how the file are analyzed.

## Output data
This script outputs the result of running the following command on every pair of files:

`kallisto quant -i Homo_sapiens.GRCh38.87.cdna.all.idx -o [output_dir] -b 100 -t 8 [R1.fastq.gz] [R2.fastq.gz]`

## Using the pipeline with Pachyderm
This assumes that you're familiar with Pachyderm and have a Pachyderm cluster up and running. The pipeline specifications we use at PICI are included in the pipeline-specs folder. Right now all of the specs point to an image hosted on our private Google Container Registry. You'll want to either ask for permission to the registry or to build the image yourself and point the pipeline specs to the location of the image that you've built. Once this is done, all you need to do is run `cd pipeline-specs && make create-input-repos && make create-pipelines`. The makefile assumes you're connecting to Pachyderm directly. To do this you'll want to run `export ADDRESS=xxx.xxx.xxx.xxx:30650` in the shell session that you're working in, where the IP address in question belongs to one of the machines in your Pachyderm cluster. Once you've done this, you'll need to add reference data to your reference repositories. You can use the following commands to accomplish this:

```
pachctl start-commit reference_genome_indexes master && \
pachctl put-file reference_genome_indexes master / -r -f gs://pici-pachyderm-reference/reference_genome_indexes/kallisto && \
pachctl finish-commit reference_genome_indexes master
```

Once the reference data has been loaded, you can kick off a run of the pipeline by commiting data to the input repository:

```
pachctl start-commit kallisto_input_full master && \
pachctl put-file kallisto_input_full master / -r -f gs://PATH/TO/YOUR/DATA && \
pachctl finish-commit kallisto_input_full master
```

You can check the status of the jobs with `pachctl list-job`. Once complete, the results will be in the kallisto_stage1 data repository.

## Using the pipeline as a stand-alone Docker image
You'll need to have the Docker image built or pulled locally. You'll also need to create a folder to hold your input, reference, and output data to mount in the Docker image. It should have the following structure:

```
./input_data
./input_data/kallisto_indexes
./input_data/kallisto_input
./input_data/output
```

Contact us to get access to our reference repository, or use reference data of your own. Once the reference files and your input data is in place, you can run the pipeline with the following command:

```
sudo docker run -t -i -P -v ./input_data/:/input_data kallisto:latest && \
/code/kallisto_pipeline_1.sh /input_data/kallisto_input /input_data/output /input_data/kallisto_indexes
```

The final output of the pipeline will be in ./input_data/output
