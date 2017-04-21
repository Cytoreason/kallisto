check-pachctl:
	if [ -z ${ADDRESS} ]; then \
		echo "Cowardly refusing to upload w port-forwarding"; \
		echo "Please set the ADDRESS variable instead"; \
		exit 1; \
	fi
	pachctl version

clean-pipelines: check-pachctl
	pachctl delete-pipeline kallisto_stage1
	pachctl delete-repo kallisto_stage1

create-pipelines: check-pachctl
	pachctl create-pipeline -f kallisto_stage1.json

update-pipelines: check-pachctl
	pachctl update-pipeline -f kallisto_stage1.json
