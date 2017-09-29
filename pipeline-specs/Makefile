check-pachctl:
	if [ -z ${ADDRESS} ]; then \
		echo "Cowardly refusing to upload w port-forwarding"; \
		echo "Please set the ADDRESS variable instead"; \
		exit 1; \
	fi
	pachctl version

create-input-repos: check-pachctl
	pachctl create-repo kallisto_input
	pachctl create-repo reference_genome_indexes

clean-pipelines: check-pachctl
	pachctl delete-pipeline kallisto_stage_2
	pachctl delete-repo kallisto_stage_2
	pachctl delete-pipeline kallisto_stage_1
	pachctl delete-repo kallisto_stage_1

create-pipelines: check-pachctl
	pachctl create-pipeline -f kallisto_stage_1.json
	pachctl create-pipeline -f kallisto_stage_2.json

update-pipelines: check-pachctl
	pachctl update-pipeline -f kallisto_stage_1.json
	pachctl update-pipeline -f kallisto_stage_2.json