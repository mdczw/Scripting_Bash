#!/bin/bash
#This script creates VPC, Subnet, Firewall rules, public IP address for VM, Artifacts Registry and VM.
#Pushes a java spring-petlinic container image built earlier to Artifacts Registry
#Runs container on the VM.
#
#Usage:
#Run <./gcp_create.sh [OPTIONS...]> to create resources and run container.
#Example: ./gcp_create.sh -d <Dockerfile> -I <Allowed_IPs>

PROJECT_ID="gd-gcp-internship-devops"
REGION="us-central1"
ZONE="${REGION}-a"
BASE_RESOURS_NAME="md-internship-sp-"

SUBNET_RANGE="10.0.2.0/24"

ALLOWED_IP="0.0.0.0/0"
ALLOWED_PORTS="tcp:80,tcp:22"

DOCKERFILE_PATH_DEF="/Users/margaritadyczewska/Documents/DevOps_Course/spring-petclinic"
DOCKERFILE_PATH=""
CONTAINER_NAME="cloud-spring-petclinic"
DOCKER_IMAGE="$REGION-docker.pkg.dev/$PROJECT_ID/${BASE_RESOURS_NAME}ar/${CONTAINER_NAME}"

createEnvironment() {

	gcloud compute networks create "$BASE_RESOURS_NAME"vpc \
		--project="$PROJECT_ID" \
		--subnet-mode=custom

	gcloud compute networks subnets create "$BASE_RESOURS_NAME"subnet \
		--project="$PROJECT_ID" \
		--range="$SUBNET_RANGE" \
		--network="$BASE_RESOURS_NAME"vpc \
		--region="$REGION"

	gcloud compute --project="$PROJECT_ID" firewall-rules create "$BASE_RESOURS_NAME"firewall-rules \
		--network="$BASE_RESOURS_NAME"vpc \
		--allow="$ALLOWED_PORTS" \
		--target-tags=sp \
		--source-ranges="$ALLOWED_IP"

	gcloud compute addresses create "$BASE_RESOURS_NAME"static-ip \
		--project="$PROJECT_ID" \
		--region="$REGION"
}

pushImage() {

	gcloud artifacts repositories create "$BASE_RESOURS_NAME"ar \
		--repository-format=docker \
		--location="$REGION"

	docker build -t "$CONTAINER_NAME" "$DOCKERFILE_PATH"

	docker tag "$CONTAINER_NAME" "$DOCKER_IMAGE"

	gcloud auth configure-docker "$REGION"-docker.pkg.dev

	docker push "$DOCKER_IMAGE"
}

runContainer() {

	STATIC_IP_SP=$(gcloud compute addresses describe "$BASE_RESOURS_NAME"static-ip \
		--project="$PROJECT_ID" \
		--region="$REGION" \
		--format='value(address)')

	gcloud compute instances create-with-container "$BASE_RESOURS_NAME"vm \
		--project="$PROJECT_ID" \
		--zone="$ZONE" \
		--machine-type=e2-small \
		--subnet="$BASE_RESOURS_NAME"subnet \
		--tags=sp \
		--image=projects/cos-cloud/global/images/cos-101-17162-336-28 \
		--address="$STATIC_IP_SP" \
		--container-image="$DOCKER_IMAGE":latest \
		--container-arg="--server.port=80"
}

main() {

	if [[ -z $DOCKERFILE_PATH ]]; then
		echo ""
		echo "Specify path to Docker file"
		echo ""
		echo "Usage example:"
		echo "$0 -d <Dockerfile> -I <Allowed_IPs>"
		echo "Run $0 -h for more information"
		exit 1
	fi
	createEnvironment
	#pushImage
	#runContainer
}

while getopts "r:b:s:I:P:d:c:h" flag; do
	case $flag in
	r)
		REGION=$OPTARG
		;;
	b)
		BASE_RESOURS_NAME=$OPTARG
		;;
	s)
		SUBNET_RANGE=$OPTARG
		;;
	I)
		ALLOWED_IP=$OPTARG
		;;
	P)
		ALLOWED_PORTS=$OPTARG
		;;
	d)
		DOCKERFILE_PATH=$OPTARG
		if [[ ! -e $DOCKERFILE_PATH ]]; then
			echo "Specify path to Docker file"
			exit 1
		fi
		;;
	c)
		CONTAINER_NAME=$OPTARG
		;;
	h)
		echo ""
		echo "[-r] to set up REGION (default us-central1)"
		echo "[-b] to set up BASE_RESOURS_NAME (default md-internship-sp-)"
		echo "[-s] to set up SUBNET_RANGE (default 10.0.2.0/24)"
		echo "[-I] to set up ALLOWED_IP (default 0.0.0.0/0)"
		echo "[-P] to set up ALLOWED_PORTS (default tcp:80,tcp:22)"
		echo "[-d] to set up DOCKERFILE_PATH"
		echo "[-c] to set up CONTAINER_NAME (default cloud-spring-petclinic)"
		echo ""
		exit 0
		;;
	*)
		echo ""
		echo "Please use the correct syntax! Usage example:"
		echo "$0 -d <Dockerfile> -I <Allowed_IPs>"
		echo "Run $0 -h for more information"
		echo ""
		exit 1
		;;
	esac
done

main
