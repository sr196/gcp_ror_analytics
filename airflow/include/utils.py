from google.cloud import storage
import json


def is_ndjson(bucket_name, file_path):
    """
    Checks if the first non-empty line of a file in a GCS bucket is valid NDJSON.

    Args:
        bucket_name (str): Name of the GCS bucket.
        file_path (str): Path to the file in the bucket.

    Returns:
        bool: True if the first non-empty line is valid NDJSON, False otherwise.
    """
    try:
        storage_client = storage.Client()
        # Access the bucket and blob
        bucket = storage_client.bucket(bucket_name)
        blob = bucket.blob(file_path)
        
        # Open a readable stream for the blob
        with blob.open("r") as file_stream:
            for line in file_stream:
                line = line.strip()
                if line:  # Process only non-empty lines
                    try:
                        json.loads(line)  # Validate as JSON
                        return True  # Valid NDJSON format for the first line
                    except json.JSONDecodeError:
                        return False  # Invalid JSON format
        return False  # No non-empty lines found
    except Exception as e:
        print(f"Error: {e}")
        return False


