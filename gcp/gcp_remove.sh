#!/bin/bash
#
#This script removes VPC, Subnet, Firewall rules, static IP address, Artifacts Registry and VM.
#Usage:
#Run <./gcp_remove.sh [OPTIONS]> to create resources and run container.
#Example: ./gcp_remove.sh -b <Base resourse name> -r <Region>

PROJECT_ID="gd-gcp-internship-devops"
REGION="us-central1"
ZONE="${REGION}-a"
BASE_RESOURS_NAME="md-internship-sp"

deleteRepository() {

	gcloud artifacts repositories delete "$BASE_RESOURS_NAME"-ar \
		--project="$PROJECT_ID" \
		--location="$REGION" \
		--quiet
}

deleteInstances() {

	gcloud compute instances delete "$BASE_RESOURS_NAME"-vm \
		--project="$PROJECT_ID" \
		--zone="$ZONE" \
		--quiet
}

deleteEnvironment() {

	gcloud compute addresses delete "$BASE_RESOURS_NAME"-static-ip \
		--project="$PROJECT_ID" \
		--region="$REGION" \
		--quiet

	gcloud compute firewall-rules delete "$BASE_RESOURS_NAME"-firewall-rules \
		--project="$PROJECT_ID" \
		--quiet

	gcloud compute networks subnets delete "$BASE_RESOURS_NAME"-subnet \
		--project="$PROJECT_ID" \
		--region="$REGION" \
		--quiet

	gcloud compute networks delete "$BASE_RESOURS_NAME"-vpc \
		--project="$PROJECT_ID" \
		--quiet
}

main() {
	deleteRepository
	deleteInstances
	deleteEnvironment
}

while getopts "r:b:h" flag; do
	case $flag in
	r)
		REGION=$OPTARG
		;;
	b)
		BASE_RESOURS_NAME=$OPTARG
		;;
	h)
		echo ""
		echo "[-r] to specify REGION (default us-central1)"
		echo "[-b] to specify BASE_RESOURS_NAME (default md-internship-sp)"
		echo ""
		exit 0
		;;
	*)
		echo ""
		echo "Please use the correct syntax! Usage example:"
		echo "$0 -r \"us-central1\" -b \"new-\" "
		echo ""
		exit 1
		;;
	esac
done

main
