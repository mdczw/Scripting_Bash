#!/bin/bash
#This script creates VPC, Subnet, Firewall rules, public IP address for VM, Artifacts Registry and VM.
#Pushes a java spring-petlinic container image built earlier to Artifacts Registry
#Runs container on the VM.
#
#Usage: 
#Run <source ./gcp_script.sh; start> to create resources and run container.
#Run <source ./gcp_script.sh; remove> to remove all resources.


PROJECT_ID="gd-gcp-internship-devops"
REGION="us-central1"
ZONE="us-central1-a"
DOCKERFILE_PATH="/Users/margaritadyczewska/Documents/DevOps_Course/spring-petclinic"
DOCKER_IMAGE="$REGION-docker.pkg.dev/$PROJECT_ID/md-internship-sp-ar/cloud-spring-petclinic"
ALLOWED_IP="89.64.40.117"


createEnvironment() {

	#Create VPC
	gcloud compute networks create md-internship-sp-vpc \
	    --project="$PROJECT_ID" \
	    --subnet-mode=custom 

	#Create subnet
	gcloud compute networks subnets create md-internship-sp-subnet \
	    --project="$PROJECT_ID" \
	    --range=10.0.2.0/24 \
	    --network=md-internship-sp-vpc \
	    --region="$REGION"

	#Create firewall rules
	gcloud compute --project="$PROJECT_ID" firewall-rules create md-internship-sp-firewall-rules \
	    --network=md-internship-sp-vpc \
	    --allow=tcp:80,tcp:22 \
	    --target-tags=sp \
		--source-ranges="$ALLOWED_IP"

	#Reserve static IP address 
	gcloud compute addresses create md-internship-sp-static-ip \
	    --project="$PROJECT_ID" \
	    --region="$REGION"
}

pushImage() {

	#Create artifacts repository
	gcloud artifacts repositories create md-internship-sp-ar \
	    --repository-format=docker \
	    --location="$REGION"

	docker build -t cloud-spring-petclinic $DOCKERFILE_PATH

	docker tag cloud-spring-petclinic $DOCKER_IMAGE

	gcloud auth configure-docker "$REGION"-docker.pkg.dev

	docker push $DOCKER_IMAGE	
}

runContainer() {

	#Get static IP address
	STATIC_IP_SP=$(gcloud compute addresses describe md-internship-sp-static-ip \
	    --project="$PROJECT_ID" \
	    --region="$REGION" \
	    --format='value(address)')

	#Create instances with container
	gcloud compute instances create-with-container md-internship-sp-vm \
	    --project="$PROJECT_ID" \
	    --zone="$ZONE" \
	    --machine-type=e2-small \
	    --subnet=md-internship-sp-subnet \
	    --tags=sp \
	    --image=projects/cos-cloud/global/images/cos-101-17162-336-28 \
	    --address="$STATIC_IP_SP" \
	    --container-image="$DOCKER_IMAGE":latest \
	    --container-arg="--server.port=80"
}


deleteImage() {
	
	#Delete Docker image
	gcloud artifacts docker images delete "$DOCKER_IMAGE" --quiet

	#Delete artifacts repository
	gcloud artifacts repositories delete md-internship-sp-ar \
	    --project="$PROJECT_ID" \
	    --location="$REGION" \
	    --quiet
}

deleteInstances() {

	#Delete instances
	gcloud compute instances delete md-internship-sp-vm \
	    --project="$PROJECT_ID" \
	    --zone="$ZONE" \
	    --quiet
}

deleteEnvironment() {

	#Delete static IP address
	gcloud compute addresses delete md-internship-sp-static-ip \
	    --project="$PROJECT_ID" \
	    --region="$REGION" \
	    --quiet

	#Delete firewall rules
	gcloud compute firewall-rules delete md-internship-sp-firewall-rules \
	    --project="$PROJECT_ID" \
	    --quiet

	#Delete subnet
	gcloud compute networks subnets delete md-internship-sp-subnet \
	    --project="$PROJECT_ID" \
	    --region="$REGION" \
	    --quiet

	#Delete VPC
	gcloud compute networks delete md-internship-sp-vpc \
	    --project="$PROJECT_ID" \
	    --quiet
}

start() {

	createEnvironment
	pushImage
	runContainer
}

remove() {

	deleteInstances
	deleteImage
	deleteEnvironment
}