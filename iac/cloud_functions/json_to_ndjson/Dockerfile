# Use a minimal base image with bash and gsutil
FROM google/cloud-sdk:latest

# Set working directory inside the container
WORKDIR /workspace

# Install jq CLI tool
RUN apt-get update ; apt-get install jq -y

# Copy the Bash script into the container
COPY json_to_ndjson.sh .

# Make the script executable
RUN chmod +x ./json_to_ndjson.sh

# Set default command to run the script with an argument passed at runtime
CMD ["bash", "-c", "./json_to_ndjson.sh $GCS_FILE_PATH"]

