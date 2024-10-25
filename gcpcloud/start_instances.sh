#!/bin/bash

# Define an array of instance names and their corresponding zones
instances=(
  "vuecalc1:europe-central2-a"
  "expressed1:europe-central2-a"
  "expressed2:europe-central2-a"
  "happy1:europe-central2-a"
  "happy2:europe-central2-a"
  "balancer:europe-central2-a"
  "bootstorage-1:europe-central2-a"
  "bootstorage-2:europe-west1-d"
  "mongodb:europe-central2-a"
  "prometheus:europe-west1-d"
)

# Loop through each instance and start it
for instance in "${instances[@]}"; do
  name=$(echo "$instance" | cut -d: -f1)
  zone=$(echo "$instance" | cut -d: -f2)

  echo "Starting instance $name in zone $zone"
  gcloud compute instances start "$name" --zone="$zone"

  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Instance $name started successfully."
  else
    echo "Failed to start instance $name."
  fi
done
